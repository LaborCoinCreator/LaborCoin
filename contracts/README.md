# LaborCoin Smart Contracts

**Network:** Polygon

This directory contains the core smart contracts that power the LaborCoin ecosystem.

LaborCoin combines a bonding curve economy, decentralized governance, treasury management, and participant registration into a unified on-chain system designed to support collective funding and democratic resource allocation.

---

# Contract Categories

## Economic Layer

### LABR Token

The primary economic token of the LaborCoin ecosystem.

Responsibilities:

* Economic participation
* Treasury funding
* Dividend funding
* Exchange integration

### Exchange V2

The protocol's bonding curve exchange.

Responsibilities:

* LABR purchases
* LABR sales
* Automated pricing
* Treasury funding
* Dividend funding

---

## Governance Layer

### LABRV V6

Non-transferable governance token.

Responsibilities:

* Governance participation
* Voting power representation
* Proposal voting

### Governance V12

Governance contract responsible for proposal creation, voting, and execution.

Responsibilities:

* Proposal management
* Vote tracking
* Governance execution
* Treasury authorization

### LaborCoin DAO

Primary governance authority.

Responsibilities:

* Treasury oversight
* Proposal execution
* Administrative governance functions

---

## Registration Layer

### Registration V3

Participant onboarding and governance eligibility system.

Responsibilities:

* Eligibility verification
* Registration tracking
* LABRV issuance
* Governance onboarding

---

## Treasury Layer

### Treasury Module

Treasury custody and distribution system.

Responsibilities:

* Treasury management
* Governance-approved distributions
* Fund accounting
* Distribution execution

---

# Deployed Contracts

All LaborCoin contracts are deployed on Polygon and publicly verifiable.

| Component | Address |
|------------|------------|
| LABR Token | [0x460DD873A1D2a41e77410B125cD3027C5FEd2f78](https://polygonscan.com/address/0x460DD873A1D2a41e77410B125cD3027C5FEd2f78) |
| LaborCoin DAO | [0x0C2e5679153593b82a84eAB5CA90895BB291Cec4](https://polygonscan.com/address/0x0C2e5679153593b82a84eAB5CA90895BB291Cec4) |
| Exchange V2 | [0xD0692ec758bb852421B702B187b6439f74f8Bf3b](https://polygonscan.com/address/0xD0692ec758bb852421B702B187b6439f74f8Bf3b) |
| Governance V12 | [0x499b32e9E5a8b9865a9D69480d590252a56FA78F](https://polygonscan.com/address/0x499b32e9E5a8b9865a9D69480d590252a56FA78F) |
| Registration V3 | [0xa7D0C092C2391379046cACDc56BEbDe5A0CBD113](https://polygonscan.com/address/0xa7D0C092C2391379046cACDc56BEbDe5A0CBD113) |
| LABRV V6 | [0x113579220515cd59b884Ea2379b4C369025246e2](https://polygonscan.com/address/0x113579220515cd59b884Ea2379b4C369025246e2) |
| Treasury Module | [0x0B018E45E4cB71E222C345a5341BdbaeE519c623](https://polygonscan.com/address/0x0B018E45E4cB71E222C345a5341BdbaeE519c623) |

Detailed documentation for each contract can be found in the `/contracts-docs` directory.

---

# System Architecture

```text
Participant
    │
    ▼
Exchange V2
    │
    ▼
LABR
    │
    ▼
Registration V3
    │
    ▼
LABRV V6
    │
    ▼
Governance V12
    │
    ▼
LaborCoin DAO
    │
    ▼
Treasury Module
    │
    ▼
Approved Distributions
```

The architecture separates:

* Economic participation
* Governance participation
* Registration and eligibility
* Treasury management
* Governance execution

This separation reduces complexity while maintaining transparent governance and treasury oversight.

---

# Protocol Summary

## LABR

Economic token used throughout the ecosystem.

Current configuration:

* Fixed supply
* Wallet limits
* Transaction limits
* Cooldown protections
* 5% treasury sell tax
* 5% dividend sell tax
* 0% burn tax

Total sell tax:

```text
10%
```

---

## LABRV

Governance token issued through registration.

Properties:

* Non-transferable
* Cannot be bought or sold
* One governance token per eligible registered wallet
* Used exclusively for governance participation

---

## Registration V3

Participants must satisfy registration requirements before receiving governance rights.

Registration is a one-time process that grants eligibility for governance participation.

---

## Exchange V2

Bonding curve exchange using protocol-owned liquidity.

Features:

* Deterministic pricing
* Continuous liquidity
* Wallet protections
* Transaction protections
* Treasury funding
* Dividend funding

Current limits:

| Parameter         | Value       |
| ----------------- | ----------- |
| Transaction Limit | 5,000 LABR  |
| Wallet Limit      | 10,000 LABR |
| Cooldown          | 12 Hours    |

---

## Governance

Governance is conducted through LABRV.

Proposal requirements:

* 75% participation
* 75% approval

Governance determines how treasury resources are allocated and how the ecosystem evolves over time.

---

# Security Principles

The system is designed around several core principles:

* Transparent governance
* Equal voting power for eligible registered participants
* Separation of governance and economic ownership
* Publicly auditable treasury activity
* Deterministic protocol behavior
* Open-source verification

---

# Documentation

Additional documentation is available throughout the repository:

* `/docs` – Architecture, governance, and system documentation
* `/contracts-docs` – Contract-level documentation
* `/deployments` – Deployment information and records

---

# License

MIT
