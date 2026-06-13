# LaborCoin

A decentralized governance and funding system designed to support worker solidarity through collective resource allocation, democratic decision-making, and transparent on-chain coordination.

LaborCoin combines a bonding curve economy, a non-transferable governance token, and a DAO-managed treasury to enable participants to collectively direct resources toward worker support initiatives, strike assistance, educational projects, and other community-approved purposes.

---

# Mission

LaborCoin was created to explore how blockchain technology can be used to strengthen collective action and economic solidarity.

The project is built around a simple idea:

Workers often face significant economic pressure when organizing, negotiating, or taking collective action. LaborCoin seeks to provide a transparent and democratic funding infrastructure that can be governed directly by its participants.

---

# What LaborCoin Is

LaborCoin is a governance and treasury system.

Participants may:

* Acquire LABR through the protocol exchange
* Register for governance participation
* Receive LABRV governance rights
* Submit and vote on proposals
* Direct treasury resources through collective decision-making

LaborCoin is not intended to function as a traditional investment product.

---

# How It Works

1. Connect a wallet on Polygon
2. Acquire LABR using POL through the LaborCoin Exchange
3. Complete registration requirements
4. Receive LABRV governance rights
5. Participate in proposals and voting
6. Help direct treasury resources through governance

---

# Governance Model

LaborCoin separates economic participation from governance participation.

### LABR

LABR is the ecosystem's primary economic token.

It is used for:

* Participation in the bonding curve economy
* Treasury funding through protocol taxes
* Dividend participation
* Ecosystem engagement

### LABRV

LABRV is the governance token.

Properties:

* Non-transferable
* Cannot be bought or sold
* Issued through the registration system
* Used exclusively for governance

Governance rights are distributed through registration rather than token accumulation.

This helps maintain equal voting power for eligible registered participants.

---

# Core Components

## Exchange V2

The LaborCoin Exchange provides the primary mechanism for acquiring and selling LABR.

Features include:

* Deterministic bonding curve pricing
* On-chain liquidity
* Treasury funding
* Dividend funding
* Transaction cooldowns
* Wallet limits
* Slippage protection

### Current Exchange Parameters

| Parameter         | Value       |
| ----------------- | ----------- |
| Transaction Limit | 5,000 LABR  |
| Wallet Limit      | 10,000 LABR |
| Cooldown          | 12 Hours    |

---

## Treasury System

The Treasury collects protocol revenue and distributes resources through governance-approved proposals.

Treasury allocations may support:

* Strike assistance
* Worker support initiatives
* Educational projects
* Community infrastructure
* Other governance-approved activities

---

## Registration System

The Registration contract manages governance eligibility and LABRV issuance.

Participants who satisfy registration requirements may receive governance rights and participate in DAO voting.

---

## Governance

Governance proposals are voted on using LABRV.

A proposal passes only when both requirements are met:

* 75% participation
* 75% approval

These thresholds are designed to encourage broad consensus before treasury resources are allocated.

---

# Protocol Architecture

```text
Users
  │
  ▼
Exchange V2
  │
  ▼
LABR
  │
  ▼
Registration
  │
  ▼
LABRV
  │
  ▼
Governance
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

Additional architectural documentation can be found in the `/docs` directory.

---

# Deployed Contracts

All LaborCoin contracts are deployed on Polygon and publicly verifiable.

| Component       | Address                                      |
| --------------- | -------------------------------------------- |
| LABR Token      | `0x460DD873A1D2a41e77410B125cD3027C5FEd2f78` |
| LaborCoin DAO   | `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` |
| Exchange V2     | `0xD0692ec758bb852421B702B187b6439f74f8Bf3b` |
| Governance V12  | `0x499b32e9E5a8b9865a9D69480d590252a56FA78F` |
| Registration V3 | `0xa7D0C092C2391379046cACDc56BEbDe5A0CBD113` |
| LABRV V6        | `0x113579220515cd59b884Ea2379b4C369025246e2` |
| Treasury Module | `0x0B018E45E4cB71E222C345a5341BdbaeE519c623` |

Detailed documentation for each contract is available in the `/contracts-docs` directory.

---

# Current Status

### Deployed

* LABR Token
* Exchange V2
* Registration V3
* LABRV V6
* Governance V12
* LaborCoin DAO
* Treasury Module

### Operational

* Bonding curve exchange
* Governance system
* Registration system
* Treasury management
* On-chain proposal voting

---

# Design Principles

* Transparent governance
* Equal voting power for eligible registered participants
* Separation of governance and economic ownership
* Publicly auditable treasury activity
* Deterministic protocol rules
* Open-source development
* Long-term community stewardship

---

# Documentation

Additional documentation is available in this repository:

* `/docs` – System documentation and architecture
* `/contracts-docs` – Contract-level documentation
* `/contracts` – Solidity source code
* `/deployments` – Deployment records and artifacts

---

# Disclaimer

LaborCoin is experimental software.

Participation involves interacting with smart contracts, decentralized governance systems, and blockchain networks. Users should review the source code, documentation, and deployed contracts before participating.

Nothing in this repository constitutes legal, financial, or investment advice.

---

# License

MIT
