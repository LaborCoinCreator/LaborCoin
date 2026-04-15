# LaborCoin

LaborCoin is a DAO-driven system designed to support the working class through transparent, on-chain coordination, funding, and governance.

This project combines a token system, decentralized governance, and controlled execution mechanisms to enable collective decision-making and resource allocation.

---

## Overview

LaborCoin consists of two primary tokens and a governance system:

* **LABR** — the primary token
* **LABRV** — a non-transferable voting token (1 per participant)
* **LaborCoin DAO** — governance layer built on Aragon
* **Executor Contracts** — controlled interfaces for all on-chain actions

---

## Governance Model

Governance is conducted through **LABR Solidarity Proposals (LSP)**.

Each proposal must meet the following conditions:

* **75% participation required**
* **75% approval required**

Voting power is determined by LABRV holdings:

* Each registered participant holds **1 LABRV**
* LABRV is **non-transferable**
* Governance is **one person, one vote**

---

## Architecture

The system follows a controlled execution model:

```
DAO (decision layer)
  ↓
Executors (control layer)
  ↓
Contracts (state changes)
```

### Executors

All actions are routed through dedicated executor contracts:

* **PauseExecutor**

  * Pauses / unpauses the LABR token

* **TreasuryExecutor**

  * Sends funds from the DAO treasury

* **LaborVoteMintExecutor**

  * Mints LABRV voting tokens (to be controlled by registration system)

This design prevents arbitrary contract calls and limits governance to predefined, safe actions.

---

## Contracts

### Core

* **LaborVoteV5 (LABRV)**

  * ERC20Votes-based
  * Non-transferable (soulbound)
  * 1 token per registered participant

### Executors

* PauseExecutor
* TreasuryExecutor
* LaborVoteMintExecutor

All executor contracts are restricted to calls from the DAO only.

---

## Deployment (Polygon)

```
DAO: 0x0C2e5679153593b82a84eAB5CA90895BB291Cec4
LABRV (v5): 0x3586B123191be1944DBDa623079cED5b6c8d03fE

PauseExecutor:     0x5a0C3d5F6A814Dda121Fe174FFD963451E9fCa4f
TreasuryExecutor:  0x440A756e16D4b42a015eC61258759037A454Ec79
MintExecutor:      0xA361cB84422452BDef5A04a447492ad176B09C0B
```

---

## Current Status

* DAO deployed and operational
* Voting system live and tested
* Executor architecture implemented
* Governance thresholds enforced

**In progress:**

* Registration system (automated LABRV distribution)
* Permission lockdown (removal of unrestricted execution)

---

## Design Principles

* **One person, one vote**
* **Transparent governance**
* **Controlled execution**
* **Minimal trusted surface**
* **Upgradeable through governance, not admins**

---

## Roadmap

* Finalize registration contract
* Restrict DAO permissions to executor-only actions
* Launch public participation
* Expand treasury governance capabilities

---

## Disclaimer

LaborCoin is an experimental governance system. It is not a traditional investment vehicle. Participation involves interacting with smart contracts and decentralized systems, which carry inherent risks.

---

## License

MIT
