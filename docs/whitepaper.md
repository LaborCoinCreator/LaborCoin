# LaborCoin Whitepaper

## Abstract

LaborCoin is a decentralized governance system designed to enable collective decision-making and resource allocation for the working class. It combines a non-transferable voting token, DAO-based governance, and controlled execution through dedicated smart contracts to create a transparent, accountable, and scalable coordination mechanism.

The system enforces a one-person, one-vote model and restricts execution to predefined actions, minimizing attack surface while preserving flexibility through governance.

---

## 1. Introduction

Modern economic systems concentrate decision-making power in centralized institutions, limiting the ability of workers to coordinate and act collectively.

LaborCoin provides:

* A governance-first architecture
* Equalized voting power
* Transparent, on-chain execution
* Controlled and auditable action pathways

This is not a speculative asset system. It is a coordination system.

---

## 2. System Overview

LaborCoin consists of four primary components:

* LABR (primary token)
* LABRV (voting token)
* DAO governance (Aragon)
* Executor contracts (controlled execution layer)

The system separates decision-making from execution:

```
DAO → Executors → Contracts
```

---

## 3. Governance Model

### 3.1 LABR Solidarity Proposals (LSP)

Governance actions are executed through LABR Solidarity Proposals.

Participants can:

* Submit proposals
* Vote on proposals
* Approve or reject funding and system actions

---

### 3.2 Voting Mechanism

Voting power is derived from LABRV:

* 1 LABRV per participant
* Non-transferable (soulbound)
* Equal voting weight

This enforces a one-person, one-vote structure.

---

### 3.3 Proposal Requirements

* **75% participation required**
* **75% approval required**

---

### 3.4 Proposal Lifecycle

1. Proposal submission
2. Voting period
3. Threshold validation
4. Execution via DAO

---

## 4. Token Design

### 4.1 LABR

Primary system token.

---

### 4.2 LABRV (v5)

Governance token with the following properties:

* ERC20Votes-based
* Non-transferable
* One token per participant
* Minted upon registration

---

### 4.3 Anti-Concentration Design

* No transfers
* One token per wallet
* Equal voting power

---

## 5. Execution Architecture

### 5.1 Design Principle

The DAO does not directly execute arbitrary actions.

Instead:

```
DAO → Executor → Target Contract
```

---

### 5.2 Executor Contracts

**PauseExecutor**

* Controls pause/unpause of LABR

**TreasuryExecutor**

* Sends funds from treasury

**LaborVoteMintExecutor**

* Mints LABRV

---

### 5.3 Security Model

* No arbitrary contract calls
* Restricted execution pathways
* Predictable behavior

---

## 6. Deployment (Polygon)

### Core

```
LaborCoin (LABR): 0x460DD873A1D2a41e77410B125cD3027C5FEd2f78

LaborCoin DAO:
0x0C2e5679153593b82a84eAB5CA90895BB291Cec4

LABRV (v5):
0x3586B123191be1944DBDa623079cED5b6c8d03fE
```

---

### Executors

```
PauseExecutor:
0x5a0C3d5F6A814Dda121Fe174FFD963451E9fCa4f

TreasuryExecutor:
0x440A756e16D4b42a015eC61258759037A454Ec79

LaborVoteMintExecutor:
0xA361cB84422452BDef5A04a447492ad176B09C0B
```

---

## 7. Current Status

* DAO deployed and operational
* Voting system live
* Executors deployed
* Proposal lifecycle tested

**Current condition:**

* DAO temporarily has unrestricted execution (bootstrap phase)

---

## 8. Planned Upgrades

### Permission Lockdown

* Remove unrestricted execution
* Restrict to executor-only actions

---

### Registration System

* Verify participants
* Mint LABRV automatically
* Gate governance access

---

### Decentralization

* Remove bootstrap privileges
* Full governance control via DAO

---

## 9. Security Considerations

LaborCoin minimizes risk through structure:

* Non-transferable voting power
* High voting thresholds
* Restricted execution
* Transparent on-chain actions

---

## 10. Use Cases

* Strike funding
* Resource allocation
* Collective decision-making
* Worker coordination

---

## 11. Limitations

* Early-stage system
* Registration system pending
* UX dependent on external interfaces

---

## 12. Conclusion

LaborCoin is a governance-first system designed for coordination rather than speculation.

It combines equal voting power, controlled execution, and transparent decision-making to enable scalable collective action.

---

## Disclaimer

LaborCoin is an experimental governance system. Participation involves interacting with smart contracts and decentralized infrastructure, which carry inherent risks.
