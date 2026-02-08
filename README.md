# Tempo Payment Primitives

Innovative payment primitive smart contracts for the **Tempo Network** (Moderato Testnet), built with Foundry.

## Contracts

### TempoPaymentSplitter
A contract for splitting TIP-20 token payments to multiple recipients in a single transaction.

- **Address:** `0xB0c73Af547dB09F817202e4B2d30Dae6478C7D26`
- **Explorer:** [View on Tempo Explorer](https://explore.tempo.xyz/address/0xB0c73Af547dB09F817202e4B2d30Dae6478C7D26)

**Features:**
- Create payment splits with multiple payees and custom share percentages
- Add/remove payees dynamically
- Distribute TIP-20 tokens proportionally to all payees
- Batch payments to multiple recipients
- Memo support for payment reconciliation

### TempoStreamingPayments
A Sablier-style continuous payment streaming contract for TIP-20 tokens.

- **Address:** `0xd616458d15c9BDf2972A59b79E8168023c5f77ad`
- **Explorer:** [View on Tempo Explorer](https://explore.tempo.xyz/address/0xd616458d15c9BDf2972A59b79E8168023c5f77ad)

**Features:**
- Create continuous payment streams with custom duration
- Batch stream creation for multiple recipients
- Real-time balance calculation
- Withdraw accumulated funds at any time
- Cancel streams with proportional refunds
- Top up existing streams

## Network Info

| Property | Value |
|----------|-------|
| Network | Tempo Testnet (Moderato) |
| Chain ID | 42431 |
| RPC | https://rpc.moderato.tempo.xyz |
| Token | PathUSD (TIP-20) at `0x20C0000000000000000000000000000000000000` |

## Build & Test

```bash
forge build
forge test
```

## Deploy

```bash
forge script script/Deploy.s.sol --rpc-url https://rpc.moderato.tempo.xyz --private-key <KEY> --broadcast
```

## License

MIT
