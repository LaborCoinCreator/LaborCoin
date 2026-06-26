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

| Contract Name | Contract Address | Deployment Block | Deployment Date (UTC) | Verified Source | Ownership Status |
|--------------|------------------|-----------------:|-----------------------|----------------|------------------|
| LABR Token | [0x460DD873A1D2a41e77410B125cD3027C5FEd2f78](https://polygonscan.com/address/0x460DD873A1D2a41e77410B125cD3027C5FEd2f78) | 69797383 | Apr-02-2025 07:56:25 AM +UTC | Yes | DAO Controlled |
| LaborVote (LABRV) V7 | [0x833242E933c675846D8f8982048FecA95B8e435A](https://polygonscan.com/address/0x833242E933c675846D8f8982048FecA95B8e435A) | 88595455 | Jun-16-2026 08:22:48 AM +UTC | Yes | Ownership Renounced / Minter Permanently Locked |
| LaborCoin Registration V4 | [0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C](https://polygonscan.com/address/0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C) | 88997813 | Jun-22-2026 | Yes | Autonomous |
| LaborCoin Treasury Module V1 | [0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C](https://polygonscan.com/address/0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C) | 89052358 | Jun-24-2026 | Yes | Autonomous (DAO Only) |
| LaborCoin Governance V13 | [0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c](https://polygonscan.com/address/0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c) | 89084762 | Jun-24-2026 08:15:38 PM +UTC | Yes | Autonomous |
| LaborCoin Exchange V4 | [0x4Cf18cB39203B678f5C26f2338a10a79f9684749](https://polygonscan.com/address/0x4Cf18cB39203B678f5C26f2338a10a79f9684749) | 89115657 | Jun-25-2026 09:08:01 AM +UTC | Yes | Autonomous |

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
