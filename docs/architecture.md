# Architecture

## Overview

LaborCoin is built as a controlled governance system where decisions are made by a DAO and executed through restricted contract pathways.

The architecture separates decision-making from execution to reduce risk and prevent arbitrary control over the system.

```
DAO (decision layer)
  ↓
Executors (control layer)
  ↓
Contracts (state layer)
```

---

## Core Components

### 1. DAO (Aragon)

The DAO is the central governance authority.

* Manages proposals and voting
* Enforces participation and approval thresholds
* Executes approved actions

**Deployed at:**
0x0C2e5679153593b82a84eAB5CA90895BB291Cec4

---

### 2. LABRV (Voting Token)

LABRV is a non-transferable ERC20Votes token used for governance.

* 1 token per participant
* Non-transferable (soulbound)
* Represents voting power in the DAO

This enforces a one-person, one-vote structure.

---

### 3. Executors (Control Layer)

Executors are purpose-built contracts that act as the only allowed pathways for DAO actions.

They restrict what governance can actually do.

Each executor is responsible for a single type of action.

---

#### PauseExecutor

* Calls `pause()` and `unpause()` on the LABR token
* Used for emergency controls

---

#### TreasuryExecutor

* Sends ETH from the DAO treasury
* Used for funding proposals and resource allocation

---

#### LaborVoteMintExecutor

* Mints LABRV tokens
* Will be controlled by the registration system

---

## Design Principle: Restricted Execution

The DAO does not directly interact with core contracts.

Instead:

```
DAO → Executor → Target Contract
```

This ensures:

* No arbitrary contract calls
* Limited and auditable actions
* Reduced attack surface

---

## Governance Flow

1. A proposal is created through LABR Solidarity Proposals (LSP)
2. Participants vote using LABRV
3. Proposal must meet:

   * 75% participation
   * 75% approval
4. If passed, the DAO executes the action via an executor

---

## Current State

* DAO deployed and operational
* Voting system live and tested
* Executors deployed
* LABRV v5 implemented

---

## Planned Improvements

### Permission Lockdown

The DAO currently has unrestricted execution (bootstrap phase).

This will be replaced with:

* Executor-only permissions
* Removal of arbitrary DAO calls

---

### Registration System

A registration contract will:

* Verify users
* Mint LABRV automatically
* Gate access to governance

This replaces manual minting and enables scalable participation.

---

## Security Model

The system is designed to minimize trust and limit risk:

* DAO cannot directly modify core contracts
* Executors restrict available actions
* Voting is non-transferable and evenly distributed
* Future upgrades are handled through governance, not admin control

---

## Summary

LaborCoin’s architecture ensures that:

* Governance is transparent
* Execution is controlled
* Power is distributed evenly
* Risk is minimized through structural constraints

This design allows the system to scale while maintaining integrity and accountability.
