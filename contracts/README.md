# LaborCoin Smart Contracts

**Network:** Polygon

LaborCoin is a decentralized governance and coordination system designed to enable collective decision-making and resource allocation for the working class.

This repository contains the core smart contracts powering:

- Token economics (LABR)
- Governance (LABRV + DAO)
- Registration (onboarding voters)
- Treasury and execution layer
- Bonding curve exchange

---

# 📦 Deployed Contracts

## Core System

| Component | Address |
|----------|--------|
| **LaborCoin (LABR)** | `0x460DD873A1D2a41e77410B125cD3027C5FEd2f78` |
| **LaborCoin Exchange** | `0xED8C432FdFBa629387eeD06C1DC5cA6087c1C09b` |
| **LaborCoin DAO** | `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` |
| **Registration Contract** | `0x4fD4fC509e83f011A509f0B3406d35652169B8FF` |
| **LaborVote (LABRV v5)** | `0x3586B123191be1944DBDa623079cED5b6c8d03fE` |

---

## Execution Layer

| Executor | Address | Purpose |
|--------|--------|--------|
| **Pause Executor** | `0x5a0C3d5F6A814Dda121Fe174FFD963451E9fCa4f` | Pause / unpause LABR |
| **Treasury Executor** | `0x440A756e16D4b42a015eC61258759037A454Ec79` | Transfer treasury funds |
| **Mint Executor (legacy)** | `0xA361cB84422452BDef5A04a447492ad176B09C0B` | Legacy LABRV minting |

---

# 🧠 System Architecture

User
 ↓
Frontend (UI + optional CAPTCHA)
 ↓
Registration Contract
 ↓
LABRV Mint (1 per wallet)
 ↓
DAO Governance (Aragon)
 ↓
Executor Contracts
 ↓
Treasury / Protocol Actions


---

# 🪙 Token System

## LABR (Primary Token)

- Fixed supply: **1,000,000,000**
- Used for:
  - Economic participation
  - Bonding curve exchange
  - Access to governance (registration requirement)

---

## LABRV (Voting Token)

- Non-transferable (soulbound)
- 1 token per registered wallet
- Represents voting power in DAO

---

# 🧾 Registration System

The **LaborCoinRegistration** contract enables permissionless onboarding.

## Requirements

- Must hold ≥ **1 LABR**
- Can only register once

## Effects

- Marks wallet as registered
- Mints **1 LABRV**
- Enables DAO voting rights

## Properties

- No admin approval required
- Fully on-chain
- One wallet = one vote

---

# 🗳 Governance Model

- DAO built on Aragon
- Voting power derived from LABRV balance
- Proposal requirements:
  - **75% participation**
  - **75% approval**

---

# ⚙️ Execution Layer

DAO proposals do not directly execute actions.

Instead, they route through **executor contracts**:

## Executors

- **TreasuryExecutor**
  - Sends funds to approved addresses

- **PauseExecutor**
  - Controls LABR token pause state

- **MintExecutor (legacy)**
  - Previously used for LABRV minting
  - Now superseded by registration system

---

# 💱 Exchange

The LaborCoin Exchange implements a **bonding curve mechanism**:

- Deterministic pricing (USD-pegged via Chainlink)
- Continuous liquidity
- Treasury accumulation

## Key Properties

- Price increases with supply
- 10% of buy volume routed to DAO treasury
- Sell-side taxes handled at token level

---

# 🔐 Security Design

## Core Protections

- Non-transferable governance token (prevents vote buying)
- One-time registration per wallet
- Reentrancy protection in exchange
- Oracle price validation
- Treasury reserve protection
- Restricted execution via DAO-only executors

---

# ⚠️ Important Notes

## Registration Model

- LABR is only checked at registration
- Voting rights persist even if LABR is later transferred

## Legacy Components

- Mint Executor is no longer required for onboarding
- Registration contract replaces manual DAO-based minting

---

# 🧭 Deployment Philosophy

The system is designed to:

- Minimize trust in individuals
- Eliminate admin intervention after setup
- Transition fully to DAO control
- Support real-world collective action (e.g., strike funding)

---

# 🚀 Current Status

- Core contracts deployed
- Registration system live
- DAO operational
- Exchange deployed (testing phase)

---

# 🔜 Next Steps

- Finalize registration testing
- Lock LABRV minter
- Implement automated proposal execution
- Complete frontend integration
- Fund exchange liquidity

---

# 📜 License

MIT
