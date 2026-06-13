# Architecture

## Overview

LaborCoin is a governance-driven ecosystem designed to support worker solidarity through decentralized funding, democratic decision making, and transparent on-chain operations.

The system consists of six primary components:

```
Users
  │
  ▼
Registration System
  │
  ▼
LABRV Voting Token
  │
  ▼
LaborCoin DAO
  │
  ├─────────────► Treasury Module
  │
  ├─────────────► LABR Token
  │
  └─────────────► Exchange V2
```

The architecture separates:

* Economic participation (LABR)
* Governance participation (LABRV)
* Identity verification (Registration)
* Treasury management (Treasury Module)
* Market operations (Exchange)

This separation minimizes risk while maintaining democratic control over protocol resources.

---

# Core Components

## 1. LABR Token

LABR is the primary economic token of the LaborCoin ecosystem.

Responsibilities:

* Trading and market participation
* Funding solidarity initiatives
* Treasury contributions through protocol taxes
* Dividend participation

Contract:

```
0x460DD873A1D2a41e77410B125cD3027C5FEd2f78
```

Current Fee Structure:

| Action | Treasury | Dividends | Burn |
| ------ | -------- | --------- | ---- |
| Buy    | 0%       | 0%        | 0%   |
| Sell   | 5%       | 5%        | 0%   |

Total Sell Tax:

```
10%
```

---

## 2. LaborCoin DAO

The DAO serves as the governing authority of the protocol.

Responsibilities:

* Proposal management
* Community voting
* Treasury oversight
* Protocol governance
* Contract administration

Contract:

```
0x0C2e5679153593b82a84eAB5CA90895BB291Cec4
```

Governance decisions are executed through on-chain voting using LABRV.

---

## 3. LABRV Voting Token

LABRV is a non-transferable governance token used exclusively for voting.

Properties:

* One token per registered participant
* Non-transferable
* Cannot be traded
* Represents governance power

Contract:

```
0x113579220515cd59b884Ea2379b4C369025246e2
```

The purpose of LABRV is to separate governance rights from economic ownership.

This reduces the influence of wealth concentration within governance processes.

---

## 4. Registration System

The registration system manages governance eligibility.

Responsibilities:

* Identity verification integration
* Eligibility checks
* LABRV issuance
* Prevention of duplicate governance accounts

Contract:

```
0xa7D0C092C2391379046cACDc56BEbDe5A0CBD113
```

The registration system serves as the gateway into governance participation.

---

## 5. Exchange V2

Exchange V2 is LaborCoin's bonding curve exchange.

Responsibilities:

* LABR purchases
* LABR sales
* Automated pricing
* Treasury funding through protocol taxes

Contract:

```
0xD0692ec758bb852421B702B187b6439f74f8Bf3b
```

The exchange allows participants to enter and exit the ecosystem directly through the protocol rather than relying on external liquidity providers.

---

## 6. Treasury Module

The Treasury Module manages protocol treasury assets.

Responsibilities:

* Treasury custody
* Distribution of approved funds
* Governance-directed expenditures
* Long-term resource management

Contract:

```
0x0B018E45E4cB71E222C345a5341BdbaeE519c623
```

Treasury assets are controlled through governance decisions approved by the DAO.

---

# Governance Flow

## Registration

A participant:

1. Completes registration requirements
2. Receives LABRV
3. Gains governance access

## Proposal

A participant:

1. Creates a proposal
2. Proposal enters voting period
3. LABRV holders vote

## Execution

If a proposal passes:

1. Voting concludes
2. DAO executes approved actions
3. Protocol state updates accordingly

---

# Security Model

LaborCoin uses layered governance controls.

### Separation of Roles

LABR and LABRV are intentionally separated.

LABR:

* Economic participation

LABRV:

* Governance participation

### Non-Transferable Governance

LABRV cannot be bought, sold, or transferred.

This prevents direct market acquisition of voting power.

### Transparent Treasury

Treasury resources remain visible on-chain and are subject to governance oversight.

### Open Verification

All contracts are publicly deployed and verifiable.

Protocol actions can be independently audited through blockchain records.

---

# Deployed Contracts

| Component       | Address                                    |
| --------------- | ------------------------------------------ |
| LABR Token      | 0x460DD873A1D2a41e77410B125cD3027C5FEd2f78 |
| LaborCoin DAO   | 0x0C2e5679153593b82a84eAB5CA90895BB291Cec4 |
| Exchange V2     | 0xD0692ec758bb852421B702B187b6439f74f8Bf3b |
| Governance V12  | 0x499b32e9E5a8b9865a9D69480d590252a56FA78F |
| Registration V3 | 0xa7D0C092C2391379046cACDc56BEbDe5A0CBD113 |
| LABRV V6        | 0x113579220515cd59b884Ea2379b4C369025246e2 |
| Treasury Module | 0x0B018E45E4cB71E222C345a5341BdbaeE519c623 |

---

# Summary

LaborCoin combines:

* Democratic governance
* Non-transferable voting rights
* Transparent treasury management
* Automated market infrastructure
* On-chain accountability

The architecture is designed to balance decentralization, security, and long-term governance stability while providing a sustainable mechanism for worker-directed collective funding.
