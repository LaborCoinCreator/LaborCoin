# Architecture

## Overview

LaborCoin is a governance-driven ecosystem designed to support worker solidarity through decentralized funding, democratic decision making, and transparent on-chain operations.

The system consists of six primary components:

```text
Users
  │
  ▼
Registration System (V4)
  │
  ▼
LABRV Voting Token (V7)
  │
  ▼
LaborCoin DAO
  │
  ├─────────────► Treasury Module V1
  │
  ├─────────────► LABR Token
  │
  └─────────────► Exchange V4
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

```text
0x460DD873A1D2a41e77410B125cD3027C5FEd2f78
```

Current Fee Structure:

| Action | Treasury | Dividends | Burn |
| ------ | -------- | --------- | ---- |
| Buy    | 0%       | 0%        | 0%   |
| Sell   | 5%       | 5%        | 0%   |

Total Sell Tax:

```text
10%
```

---

## 2. LaborCoin DAO

The DAO serves as the governing authority of the protocol.

Responsibilities:

* Proposal management
* Community voting
* Treasury oversight
* Treasury execution authorization
* Governance coordination

Contract:

```text
0x0C2e5679153593b82a84eAB5CA90895BB291Cec4
```

Governance decisions are executed through on-chain voting using LABRV.

---

## 3. LABRV Voting Token (V7)

LABRV is a non-transferable governance token used exclusively for voting.

Properties:

* One token per registered participant
* Non-transferable
* Cannot be traded
* Represents governance power

Contract:

```text
0x833242E933c675846D8f8982048FecA95B8e435A
```

The purpose of LABRV is to separate governance rights from economic ownership.

This reduces the influence of wealth concentration within governance processes.

---

## 4. Registration System (V4)

The registration system manages governance eligibility.

Responsibilities:

* Identity verification integration
* Eligibility checks
* LABRV issuance
* Prevention of duplicate governance accounts

Contract:

```text
0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C
```

The registration system serves as the gateway into governance participation.

---

## 5. Exchange V4

Exchange V4 is LaborCoin's bonding curve exchange.

Responsibilities:

* LABR purchases
* LABR sales
* Automated pricing
* Treasury funding through protocol taxes

Contract:

```text
0x4Cf18cB39203B678f5C26f2338a10a79f9684749
```

The exchange allows participants to enter and exit the ecosystem directly through the protocol rather than relying on external liquidity providers.

---

## 6. Treasury Module V1

The Treasury Module manages protocol treasury assets.

Responsibilities:

* Treasury custody
* Distribution of approved funds
* Governance-directed expenditures
* Long-term resource management

Contract:

```text
0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C
```

Treasury assets are controlled through governance decisions approved by the DAO.

---

# Governance Flow

## Registration

A participant:

1. Completes registration requirements.
2. Receives one LABRV governance token.
3. Gains governance access.

## Proposal

A participant:

1. Creates a proposal.
2. Proposal enters the voting period.
3. LABRV holders vote.

## Execution

If a proposal passes:

1. Voting concludes.
2. The DAO authorizes execution.
3. The Treasury Module distributes approved funds.
4. Protocol state updates accordingly.

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

All contracts are publicly deployed and source verified.

Protocol actions can be independently audited through blockchain records.

---

# Deployed Contracts

| Component              | Address                                    |
| ---------------------- | ------------------------------------------ |
| LABR Token             | 0x460DD873A1D2a41e77410B125cD3027C5FEd2f78 |
| LaborCoin DAO (Aragon) | 0x0C2e5679153593b82a84eAB5CA90895BB291Cec4 |
| Exchange V4            | 0x4Cf18cB39203B678f5C26f2338a10a79f9684749 |
| Governance V13         | 0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c |
| Registration V4        | 0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C |
| LABRV V7               | 0x833242E933c675846D8f8982048FecA95B8e435A |
| Treasury Module V1     | 0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C |

---

# Summary

LaborCoin combines:

* Democratic governance
* Non-transferable voting rights
* Transparent treasury management
* Automated market infrastructure
* On-chain accountability

The architecture is designed to balance decentralization, security, and long-term governance stability while providing a sustainable mechanism for worker-directed collective funding. The final production deployment consists of immutable, publicly verifiable smart contracts operating on Polygon Mainnet.
