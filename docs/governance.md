# Governance

## Overview

LaborCoin governance is conducted through **LABR Solidarity Proposals (LSP)**.

This system enables participants to collectively decide how resources are allocated and how the system evolves.

---

## Voting Power

Voting is based on the LABRV token.

* Each participant holds **1 LABRV**
* LABRV is **non-transferable**
* Voting follows a **one person, one vote** model

---

## Proposal Requirements

For a proposal to pass, it must meet both conditions:

* **75% participation**
* **75% approval**

This ensures that decisions reflect broad consensus, not narrow majorities.

---

## Proposal Flow

1. A proposal is submitted through LSP
2. Voting begins and remains open for a fixed period
3. Participants vote using LABRV
4. If thresholds are met, the proposal passes
5. The DAO executes the approved action

---

## Execution Model

All approved proposals are executed through **executor contracts**.

The DAO does not directly interact with core contracts.

Instead:

```text
DAO → Executor → Action
```

This ensures that governance actions are limited to predefined, controlled operations.

---

## Types of Proposals

Governance is primarily focused on:

* Funding requests from the treasury
* Allocation of resources to workers or initiatives
* System-level operational decisions (within defined constraints)

---

## Security Model

The system is designed to prevent abuse and reduce risk:

* Voting power cannot be transferred or accumulated
* Execution is restricted to executor contracts
* Arbitrary contract calls will be removed after bootstrap phase

---

## Current Phase

The system is currently in a **bootstrap phase**:

* Governance is active and functional
* Execution is temporarily unrestricted for setup purposes

---

## Planned Transition

The following changes will be implemented:

* Removal of unrestricted execution ("Any Action")
* Restriction to executor-only actions
* Introduction of a registration system for participant onboarding

---

## Participation

Participants are encouraged to:

* Review proposals carefully
* Verify funding requests when applicable
* Engage in discussion before voting

---

## Disclaimer

Governance decisions are executed on-chain and are irreversible. Participants should understand the implications of proposals before voting.
