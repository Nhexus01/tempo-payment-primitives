#!/bin/bash
###############################################################################
# Tempo Recurring Transaction Scheduler
# 
# Executes a payment stream every 4 days on Tempo Moderato Testnet.
# When PathUSD balance runs low, automatically claims from faucet to continue.
###############################################################################

set -euo pipefail

# ─── Configuration ───────────────────────────────────────────────────────────
TEMPO_RPC="https://rpc.moderato.tempo.xyz"
WALLET="0x89B492505ec9785B45413EAA0D612749665e2Df0"
PRIVATE_KEY="<YOUR_PRIVATE_KEY>"
PATHUSD="0x20C0000000000000000000000000000000000000"
SPLITTER="0xB0c73Af547dB09F817202e4B2d30Dae6478C7D26"
STREAMING="0xd616458d15c9BDf2972A59b79E8168023c5f77ad"

# Payment parameters
PAYMENT_AMOUNT=5000000        # 5 PathUSD (6 decimals)
STREAM_DURATION=86400         # 1 day stream duration
MIN_BALANCE=10000000          # 10 PathUSD minimum before faucet claim
INTERVAL_SECONDS=345600       # 4 days in seconds
RECIPIENT="0x1111111111111111111111111111111111111111"

LOG_FILE="/home/ubuntu/blockchain_research/tempo_recurring.log"
STATE_FILE="/home/ubuntu/blockchain_research/tempo_recurring_state.json"

# ─── Logging ─────────────────────────────────────────────────────────────────
log() {
    local msg="[$(date -u '+%Y-%m-%d %H:%M:%S UTC')] $1"
    echo "$msg" | tee -a "$LOG_FILE"
}

# ─── Get PathUSD Balance ─────────────────────────────────────────────────────
get_balance() {
    local bal
    bal=$(cast call "$PATHUSD" "balanceOf(address)(uint256)" "$WALLET" --rpc-url "$TEMPO_RPC" 2>/dev/null | head -1 | tr -d '[:space:]')
    # Extract just the number (remove bracketed notation)
    echo "$bal" | grep -oP '^\d+'
}

# ─── Claim Faucet Tokens ────────────────────────────────────────────────────
claim_faucet() {
    log "💰 Balance low — claiming tokens from Tempo faucet..."
    local attempts=0
    local max_attempts=5
    
    while [ $attempts -lt $max_attempts ]; do
        local result
        result=$(cast rpc tempo_fundAddress "$WALLET" --rpc-url "$TEMPO_RPC" 2>&1) || true
        
        if echo "$result" | grep -q "0x"; then
            log "✅ Faucet claim successful: $result"
            sleep 5  # Wait for balance to update
            return 0
        else
            attempts=$((attempts + 1))
            log "⚠️  Faucet attempt $attempts/$max_attempts failed: $result"
            sleep 30
        fi
    done
    
    log "❌ All faucet attempts failed. Will retry next cycle."
    return 1
}

# ─── Ensure Sufficient Balance (with faucet loop) ───────────────────────────
ensure_balance() {
    local required=$1
    local current
    current=$(get_balance)
    
    log "📊 Current PathUSD balance: $current (need: $required)"
    
    local loop_count=0
    local max_loops=10
    
    while [ "$current" -lt "$required" ] && [ $loop_count -lt $max_loops ]; do
        log "⚠️  Insufficient balance ($current < $required). Initiating faucet claim loop..."
        
        if claim_faucet; then
            current=$(get_balance)
            log "📊 Updated balance after faucet: $current"
        else
            loop_count=$((loop_count + 1))
            log "🔄 Faucet loop iteration $loop_count/$max_loops"
            sleep 60
        fi
    done
    
    if [ "$current" -lt "$required" ]; then
        log "❌ Could not obtain sufficient balance after $max_loops faucet attempts."
        return 1
    fi
    
    log "✅ Balance sufficient: $current >= $required"
    return 0
}

# ─── Approve Token Spending ──────────────────────────────────────────────────
ensure_approval() {
    local spender=$1
    local amount=$2
    
    local allowance
    allowance=$(cast call "$PATHUSD" "allowance(address,address)(uint256)" "$WALLET" "$spender" --rpc-url "$TEMPO_RPC" 2>/dev/null | head -1 | grep -oP '^\d+')
    
    if [ "$allowance" -lt "$amount" ]; then
        log "🔑 Approving $amount PathUSD for $spender..."
        local tx
        tx=$(cast send --rpc-url "$TEMPO_RPC" --private-key "$PRIVATE_KEY" \
            "$PATHUSD" "approve(address,uint256)" "$spender" "115792089237316195423570985008687907853269984665640564039457584007913129639935" 2>&1)
        log "✅ Approval tx: $(echo "$tx" | grep -oP '0x[a-fA-F0-9]{64}' | head -1)"
        sleep 5
    fi
}

# ─── Execute Recurring Stream Payment ────────────────────────────────────────
execute_stream_payment() {
    local cycle=$1
    local now
    now=$(date +%s)
    local start_time=$((now + 60))    # Start 60 seconds from now to avoid "Start time in past"
    local stop_time=$((start_time + STREAM_DURATION))
    local memo="Recurring Stream Payment - Cycle #${cycle} - $(date -u '+%Y-%m-%d')"
    
    log "🚀 Creating stream payment cycle #$cycle..."
    log "   Amount: $PAYMENT_AMOUNT PathUSD | Duration: ${STREAM_DURATION}s"
    log "   Recipient: $RECIPIENT"
    
    # Ensure balance (with faucet loop if needed)
    if ! ensure_balance "$MIN_BALANCE"; then
        log "❌ Skipping cycle #$cycle — insufficient funds even after faucet claims"
        return 1
    fi
    
    # Ensure approval
    ensure_approval "$STREAMING" "$PAYMENT_AMOUNT"
    
    # Create the stream
    local tx_output
    tx_output=$(cast send --rpc-url "$TEMPO_RPC" --private-key "$PRIVATE_KEY" \
        "$STREAMING" \
        "createStream(address,address,uint256,uint256,uint256,string)" \
        "$PATHUSD" "$RECIPIENT" "$PAYMENT_AMOUNT" "$start_time" "$stop_time" "$memo" \
        2>&1) || {
        log "❌ Stream creation failed: $tx_output"
        return 1
    }
    
    local tx_hash
    tx_hash=$(echo "$tx_output" | grep -oP '0x[a-fA-F0-9]{64}' | head -1)
    log "✅ Stream created! TX: $tx_hash"
    log "   Explorer: https://explore.tempo.xyz/tx/$tx_hash"
    
    # Update state
    echo "{\"last_cycle\": $cycle, \"last_tx\": \"$tx_hash\", \"last_run\": \"$(date -u '+%Y-%m-%dT%H:%M:%SZ')\", \"next_run\": \"$(date -u -d '+4 days' '+%Y-%m-%dT%H:%M:%SZ')\"}" > "$STATE_FILE"
    
    return 0
}

# ─── Also do a splitter distribution every other cycle ───────────────────────
execute_splitter_payment() {
    local cycle=$1
    local memo="Recurring Split Distribution - Cycle #${cycle} - $(date -u '+%Y-%m-%d')"
    
    log "🔀 Executing splitter distribution cycle #$cycle..."
    
    ensure_approval "$SPLITTER" "$PAYMENT_AMOUNT"
    
    local tx_output
    tx_output=$(cast send --rpc-url "$TEMPO_RPC" --private-key "$PRIVATE_KEY" \
        "$SPLITTER" \
        "distribute(address,uint256,uint256,string)" \
        "$PATHUSD" 1 "$PAYMENT_AMOUNT" "$memo" \
        2>&1) || {
        log "⚠️  Splitter distribution failed (non-critical): $tx_output"
        return 1
    }
    
    local tx_hash
    tx_hash=$(echo "$tx_output" | grep -oP '0x[a-fA-F0-9]{64}' | head -1)
    log "✅ Splitter distribution TX: $tx_hash"
    return 0
}

# ─── Main Loop ───────────────────────────────────────────────────────────────
main() {
    log "═══════════════════════════════════════════════════════════════"
    log "🎵 Tempo Recurring Transaction Scheduler Started"
    log "   Interval: Every 4 days ($INTERVAL_SECONDS seconds)"
    log "   Payment: $PAYMENT_AMOUNT PathUSD per cycle"
    log "   Auto-faucet: ENABLED (claims when balance < $MIN_BALANCE)"
    log "═══════════════════════════════════════════════════════════════"
    
    # Load state
    local cycle=1
    if [ -f "$STATE_FILE" ]; then
        cycle=$(python3 -c "import json; d=json.load(open('$STATE_FILE')); print(d.get('last_cycle', 0) + 1)" 2>/dev/null || echo 1)
    fi
    
    # Execute first payment immediately
    log "▶ Executing initial payment (cycle #$cycle)..."
    execute_stream_payment "$cycle"
    
    # Also do a splitter distribution
    execute_splitter_payment "$cycle"
    
    cycle=$((cycle + 1))
    
    # Recurring loop
    while true; do
        log "⏳ Sleeping for 4 days until next cycle (#$cycle)..."
        sleep "$INTERVAL_SECONDS"
        
        log "═══════════════════════════════════════════════════════════════"
        log "🔄 Starting cycle #$cycle"
        
        execute_stream_payment "$cycle"
        
        # Splitter distribution every other cycle
        if [ $((cycle % 2)) -eq 0 ]; then
            execute_splitter_payment "$cycle"
        fi
        
        cycle=$((cycle + 1))
    done
}

main "$@"
