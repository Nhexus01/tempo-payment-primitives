# Tempo Network Smart Contracts Deployment

**Date:** February 8, 2026  
**Network:** Tempo Testnet (Moderato)  
**Chain ID:** 42431  
**RPC URL:** https://rpc.moderato.tempo.xyz  
**Block Explorer:** https://explore.tempo.xyz

---

## Wallet Information

- **Address:** `0x89B492505ec9785B45413EAA0D612749665e2Df0`
- **Total Transactions Executed:** 43+

---

## Deployed Contracts

### 1. TempoPaymentSplitter (TIP-20 Version)

A contract for splitting TIP-20 token payments to multiple recipients in a single transaction. Supports adding/removing payees, setting split percentages, and batch distribution with memos.

| Property | Value |
|----------|-------|
| **Contract Address** | `0xB0c73Af547dB09F817202e4B2d30Dae6478C7D26` |
| **Deployment TX** | `0x8e14d9ad2071e7dc255451a5bdeecfb671f171be03888724e7e155da53006d7d` |
| **Explorer Link** | [View on Explorer](https://explore.tempo.xyz/address/0xB0c73Af547dB09F817202e4B2d30Dae6478C7D26) |

**Features:**
- Create payment splits with multiple payees and custom share percentages
- Add/remove payees dynamically
- Update payee share allocations
- Distribute TIP-20 tokens proportionally to all payees
- Batch payments to multiple recipients
- Send payments with Tempo-style memos for reconciliation

### 2. TempoStreamingPayments (TIP-20 Version)

A contract for continuous TIP-20 payment streams (Sablier-style). Supports creating, withdrawing from, and canceling payment streams.

| Property | Value |
|----------|-------|
| **Contract Address** | `0xd616458d15c9BDf2972A59b79E8168023c5f77ad` |
| **Deployment TX** | `0xa54b1d5d9f6846b0b56ffe3d2245f8caa884a967bca28cb8d232e4c43bf57c0a` |
| **Explorer Link** | [View on Explorer](https://explore.tempo.xyz/address/0xd616458d15c9BDf2972A59b79E8168023c5f77ad) |

**Features:**
- Create continuous payment streams with custom duration
- Batch stream creation for multiple recipients
- Real-time balance calculation
- Withdraw accumulated funds at any time
- Cancel streams with proportional refunds
- Top up existing streams to extend duration
- Tempo-style memos for payment tracking

---

## Token Information

| Property | Value |
|----------|-------|
| **Token Name** | PathUSD |
| **Token Symbol** | PathUSD |
| **Token Address** | `0x20C0000000000000000000000000000000000000` |
| **Decimals** | 6 |

---

## Faucet Transactions

Initial funding via `cast rpc tempo_fundAddress`:

| TX Hash |
|---------|
| `0x55a8171411a93d38ddb54361e232d0c29109237e00115adbd734ecfbd0a259b4` |
| `0xfe324e223347756720ded97a1b511f9e40f0ee1c5f1149ba31e1be3aea24fb9d` |
| `0x431c321c87c0f8b517219d3dfa11664144edd188168fe05d5b1290b9414e3f73` |
| `0xc780b7ac36b2bc8d94e42ce8cc74fa989e64d07d1f8a1fd3f4b3b27e59a01876` |

---

## Contract Interactions (13+ Transactions)

### Token Approvals

| # | Action | TX Hash |
|---|--------|---------|
| 1 | Approve Splitter | `0x5a0c684e6be4209a134f201a0bf620bc16c6eb75208426d34641970a6676a32b` |
| 2 | Approve Streaming | `0x09a90b16e35b9ad5be3d59765256fa0a3db4ec4da537d5b31a8b919f85335bff` |

### Payment Splitter Interactions

| # | Action | Description | TX Hash |
|---|--------|-------------|---------|
| 1 | Create Split | Created split with 3 payees (50/30/20 shares) | `0x9ea0eaf21f2acfbda842eabd3ba526cf29eb694dc0b4d165f048ccee0f442511` |
| 2 | Add Payee | Added 4th payee with 25 shares | `0x735232073a60536eb976a79a4aa7b1412e884e5bfd211a54a45d8bb5c051a037` |
| 3 | Distribute | Q1 2026 Revenue Distribution (100 PathUSD) | `0x6c8327c1a7e6ddfd0a62e8eaea430d214c569bea17f41e4694d553de56ae4c1c` |
| 4 | Send With Memo | Invoice #INV-2026-001 - Consulting Services | `0x151c5a96013e04feebdb218442cb4efdf861bbdef43da8542fd83974183ba4e7` |
| 5 | Create Split #2 | Created split with 2 payees (60/40 shares) | `0xd8b7fcdfbc1b7832c7d88b65dbdb64251fca92ca62464edb595ecfda1c9a4fef` |
| 6 | Batch Payment | February 2026 - Multi-vendor settlement | `0xf0c02acc5c47c8638f251779615efe9115c0033100af680ab16a8c0337d03c19` |
| 7 | Update Shares | Updated payee 1 shares from 50 to 75 | `0x66379f2cff497bb3cb65e1435da1e908dda01e99bea9cab9333623eb685a5e35` |
| 8 | Distribute #2 | Q1 2026 - Bonus Distribution (75 PathUSD) | `0x77f33c83f3c7a6106081599df18db493b89369b8347d37faf038e7f44648cce9` |
| 9 | Distribute #3 | Split 2 - Partner Distribution Feb 2026 | `0xd511835f99cc16433dd65923990505de12acf0a371145a0be6d8b15f55e3aed8` |

### Streaming Payments Interactions

| # | Action | Description | TX Hash |
|---|--------|-------------|---------|
| 1 | Create Stream #1 | Employee Salary Stream - Feb 2026 - Employee #001 | `0xeaddce47ec802143441e40d0a73503ed4e9f95306243aea928891e77b0ca25b3` |
| 2 | Create Stream #2 | Contractor Payment - Project Alpha Q1 | `0x4fbefc895e4df0381865c5bbea3feef0c2a6550acbc7823c26fc9f57cd465602` |
| 3 | Top Up Stream | Extended Stream #1 with additional funds | `0xe01e2b4d06cacd5c0837522b878deb4f674dc57e6bb88ba08ede455189df0cca` |
| 4 | Create Stream #3 | Vesting Stream - Token Grant Feb 2026 | `0x415682a6543a7493bdde7252804db2ddc191d4d5997897041ebd7a552c4138aa` |

---

## Contract Statistics

### TempoPaymentSplitter
- **Total Splits Created:** 2
- **Total Distributions:** 3
- **Total Batch Payments:** 1
- **Individual Payments with Memo:** 1

### TempoStreamingPayments
- **Total Streams Created:** 3
- **Streams Topped Up:** 1

---

## Important Notes

### Tempo Network Specifics
- Tempo Network is optimized for stablecoin payments and **does not support native token transfers**
- All value transfers must use TIP-20 tokens (like PathUSD)
- Gas fees are paid in stablecoins (PathUSD on testnet)
- The network supports memos for payment reconciliation (Tempo Transaction feature)

### Contract Design
Both contracts were designed to leverage Tempo's unique features:
- **Memo Support:** All payment functions include memo parameters for invoice/reference tracking
- **TIP-20 Integration:** Uses standard ERC20/TIP-20 interface for maximum compatibility
- **Batch Operations:** Optimized for Tempo's batch transaction capabilities
- **Gas Efficiency:** Designed with Tempo's payment-optimized gas model in mind

---

## Verification Commands

```bash
# Check contract deployment
cast code 0xB0c73Af547dB09F817202e4B2d30Dae6478C7D26 --rpc-url https://rpc.moderato.tempo.xyz

# Check split counter
cast call 0xB0c73Af547dB09F817202e4B2d30Dae6478C7D26 "splitCounter()" --rpc-url https://rpc.moderato.tempo.xyz

# Check stream counter
cast call 0xd616458d15c9BDf2972A59b79E8168023c5f77ad "streamCounter()" --rpc-url https://rpc.moderato.tempo.xyz

# Get faucet tokens
cast rpc tempo_fundAddress 0x89B492505ec9785B45413EAA0D612749665e2Df0 --rpc-url https://rpc.moderato.tempo.xyz
```

---

## Explorer Links

- **Wallet:** https://explore.tempo.xyz/address/0x89B492505ec9785B45413EAA0D612749665e2Df0
- **PaymentSplitter:** https://explore.tempo.xyz/address/0xB0c73Af547dB09F817202e4B2d30Dae6478C7D26
- **StreamingPayments:** https://explore.tempo.xyz/address/0xd616458d15c9BDf2972A59b79E8168023c5f77ad

---

*Generated for Tempo Network Airdrop Eligibility Campaign - February 2026*
