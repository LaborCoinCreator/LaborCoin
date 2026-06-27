# LaborCoin Smart Contracts

**Network:** Polygon Mainnet

This directory contains the production smart contracts that power the LaborCoin ecosystem.

LaborCoin combines a deterministic bonding curve economy, decentralized governance, participant registration, and DAO-managed treasury infrastructure into a unified on-chain system designed to support collective funding and democratic resource allocation.

All production contracts have been deployed to Polygon Mainnet, publicly verified on Polygonscan, and finalized according to the project's immutable launch architecture.

---

# Contract Categories

## Economic Layer

### LABR Token

The primary economic token of the LaborCoin ecosystem.

Responsibilities:

* Economic participation
* Bonding curve exchange integration
* Treasury funding through protocol taxes
* Dividend funding
* Wallet and transaction protections

---

### LaborCoin Exchange V4

The protocol's native bonding curve exchange.

Responsibilities:

* LABR purchases
* LABR sales
* Deterministic on-chain pricing
* Automatic treasury funding
* Supply tranche unlocking
* Exchange liquidity management

Features:

* Chainlink POL/USD oracle
* Oracle freshness validation
* Oracle anomaly protection
* 12-hour cooldown
* Exchange wallet limits
* Exchange transaction limits
* Buy and sell slippage protection
* OpenZeppelin ReentrancyGuard

---

# Governance Layer

### LaborVote (LABRV) V7

Non-transferable governance token.

Responsibilities:

* Governance participation
* Voting power representation
* Proposal voting

Properties:

* One governance token per eligible registered participant
* Non-transferable
* Cannot be bought or sold
* Minter permanently locked
* Ownership permanently renounced

---

### LaborCoin Governance V13

The protocol governance contract responsible for proposal creation, voting, and treasury authorization.

Responsibilities:

* Proposal management
* Vote tracking
* Proposal validation
* Treasury execution authorization
* Governance rule enforcement

Governance Parameters:

* Proposal Duration: 14 Days
* Execution Window: 7 Days
* Minimum Participation: 25%
* Approval Threshold: 67%
* Treasury Distribution Cap: 5%
* Minimum Registered Participants: 50

---

### LaborCoin DAO

The Aragon DAO serves as the protocol treasury authority.

Responsibilities:

* Treasury custody
* Proposal execution
* Governance oversight
* Treasury ownership

The DAO authorizes approved treasury actions through the Treasury Module.

---

# Registration Layer

### LaborCoin Registration V4

Participant onboarding and governance eligibility system.

Responsibilities:

* Identity verification
* Registration tracking
* LABRV issuance
* Governance onboarding
* Duplicate registration prevention

Registration Requirements:

* Minimum 1 LABR
* Gitcoin Passport score meeting the required threshold
* Valid verifier signature
* One registration per wallet

---

# Treasury Layer

### LaborCoin Treasury Module V1

Immutable treasury transfer module.

Responsibilities:

* Governance-authorized distributions
* Treasury accounting
* Distribution execution
* Transparent transfer records

The Treasury Module has:

* No owner
* No upgrade mechanism
* No administrative withdrawal function
* DAO-only execution authority

---

# Deployed Contracts

All LaborCoin contracts are deployed on Polygon Mainnet and publicly verifiable.

| Contract Name                | Contract Address                                                                                                         | Deployment Block | Deployment Date (UTC)        | Verified Source | Ownership Status                                |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ---------------: | ---------------------------- | --------------- | ----------------------------------------------- |
| LABR Token                   | [0x460DD873A1D2a41e77410B125cD3027C5FEd2f78](https://polygonscan.com/address/0x460DD873A1D2a41e77410B125cD3027C5FEd2f78) |         69797383 | Apr-02-2025 07:56:25 AM +UTC | Yes             | DAO Controlled                                  |
| LaborVote (LABRV) V7         | [0x833242E933c675846D8f8982048FecA95B8e435A](https://polygonscan.com/address/0x833242E933c675846D8f8982048FecA95B8e435A) |         88595455 | Jun-16-2026 08:22:48 AM +UTC | Yes             | Ownership Renounced / Minter Permanently Locked |
| LaborCoin Registration V4    | [0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C](https://polygonscan.com/address/0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C) |         88997813 | Jun-22-2026                  | Yes             | Autonomous                                      |
| LaborCoin Treasury Module V1 | [0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C](https://polygonscan.com/address/0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C) |         89052358 | Jun-24-2026                  | Yes             | Autonomous (DAO Only)                           |
| LaborCoin Governance V13     | [0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c](https://polygonscan.com/address/0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c) |         89084762 | Jun-24-2026 08:15:38 PM +UTC | Yes             | Autonomous                                      |
| LaborCoin Exchange V4        | [0x4Cf18cB39203B678f5C26f2338a10a79f9684749](https://polygonscan.com/address/0x4Cf18cB39203B678f5C26f2338a10a79f9684749) |         89115657 | Jun-25-2026 09:08:01 AM +UTC | Yes             | Autonomous                                      |

Detailed documentation for each contract can be found in the `/contracts-docs` directory.

---

# System Architecture

```text
Users
  │
  ├──────────────► Exchange V4
  │                   │
  │                   ▼
  │                 LABR
  │
  └──────────────► Registration V4
                      │
                      ▼
                 LABRV V7
                      │
                      ▼
             Governance V13
                      │
                      ▼
             Aragon DAO Treasury
                      │
                      ▼
          Treasury Module V1
                      │
                      ▼
          Approved Distributions
```

The architecture separates:

* Economic participation
* Governance participation
* Identity verification
* Treasury management
* Treasury execution

This separation minimizes protocol complexity while preserving transparent, auditable governance.

---

# Protocol Summary

## LABR

The primary economic token used throughout the ecosystem.

Current configuration:

* Fixed supply of 1,000,000,000 LABR
* Bonding curve distribution
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

## LaborVote (LABRV)

Governance token issued through Registration V4.

Properties:

* Non-transferable
* Cannot be bought or sold
* One governance token per eligible registered participant
* Permanently issued through Registration V4
* Used exclusively for governance participation

---

## Registration V4

Registration grants governance eligibility.

Requirements:

* Hold at least 1 LABR
* Meet the required Gitcoin Passport score
* Provide a valid verifier signature
* Complete registration once per wallet

Successful registration permanently mints one LABRV governance token.

---

## Exchange V4

Deterministic bonding curve exchange using protocol-owned liquidity.

Features:

* Continuous protocol liquidity
* Deterministic pricing
* Automatic tranche unlocking
* Oracle pricing through Chainlink
* Automatic DAO funding
* Slippage protection
* Oracle anomaly protection

Current Limits:

| Parameter                  | Value            |
| -------------------------- | ---------------- |
| Exchange Wallet Limit      | 10,000 LABR      |
| Exchange Transaction Limit | 5,000 LABR       |
| Cooldown                   | 12 Hours         |
| Initial Tranche            | 100,000,000 LABR |
| Tranche Unlock             | 50,000,000 LABR  |
| Buy Treasury Allocation    | 10% of POL       |

---

## Governance V13

Governance is conducted through LABRV.

Protocol Parameters:

* Minimum Registered Participants: 50
* Participation Requirement: 25%
* Approval Threshold: 67%
* Voting Duration: 14 Days
* Execution Window: 7 Days
* Treasury Distribution Cap: 5% of DAO Treasury

Governance authorizes treasury distributions while preserving immutable protocol rules.

---

# Security Principles

LaborCoin is designed around immutable, transparent smart contract infrastructure.

Core principles include:

* Immutable production contracts
* Transparent governance
* Equal voting power for eligible participants
* Separation of governance and economic ownership
* Publicly auditable treasury activity
* Deterministic protocol behavior
* Public source verification
* Oracle anomaly protection
* Replay protection
* Open-source development

---

# Documentation

Additional documentation is available throughout the repository.

## System Documentation

* `/docs` – Architecture, governance, protocol overview, and user documentation

## Contract Documentation

* `/contracts-docs` – Individual contract documentation

## Final Launch Records

* `/final-launch/contracts` – Final production contracts
* `/final-launch/deployment-records` – Deployment manifests, verification records, constructor arguments, release records, and build environment
* `/final-launch/artifacts` – Deployment artifacts and metadata

---

# License

MIT
