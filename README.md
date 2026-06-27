# LaborCoin

### Open Infrastructure for Democratic Worker Funding

![License](https://img.shields.io/badge/license-MIT-blue)
![Network](https://img.shields.io/badge/network-Polygon-purple)
![Status](https://img.shields.io/badge/status-Production-green)
![Solidity](https://img.shields.io/badge/Solidity-0.8.30-black)

---

## Overview

LaborCoin is an open-source blockchain protocol designed to help workers and supporters collectively build shared financial resources through transparent, democratic governance.

The protocol combines an ERC-20 utility token, identity-gated governance, an immutable bonding curve exchange, and an on-chain treasury governed through an Aragon DAO.

LaborCoin is designed as public infrastructure.

The protocol emphasizes:

- democratic participation
- transparent treasury management
- immutable economic rules
- publicly verifiable smart contracts
- open-source development

---

## How the Protocol Works

```

Workers & Supporters
│
▼
Bonding Curve Exchange
│
▼
LABR Token
│
▼
Registration
│
▼
LABRV Governance Token
│
▼
Governance Voting
│
▼
Aragon DAO
│
▼
Treasury Module
│
▼
Approved Treasury Distribution

```

---

## Protocol Flow

1. Participants acquire LABR through the protocol exchange.

2. Participants complete registration.

3. Registration verifies eligibility and mints one non-transferable LABRV governance token.

4. LABRV holders vote on treasury proposals.

5. Approved proposals execute through the Aragon DAO treasury.

---

# Core Components

| Component | Purpose |
|------------|---------|
| LABR | ERC-20 utility token |
| LaborVote (LABRV) | Non-transferable governance token |
| Registration | Identity-gated participant registration |
| Exchange | Bonding curve token exchange |
| Treasury Module | Executes approved treasury transfers |
| Governance | Proposal creation and voting |
| Aragon DAO | Treasury ownership and execution |

---

# Features

- Deterministic bonding curve pricing
- ERC-20 utility token
- ERC20Votes governance
- Soulbound governance participation
- DAO-controlled treasury
- Gitcoin Passport integration
- Signature-based registration
- Replay protection
- Chainlink oracle pricing
- Automated dividend funding
- Immutable production contracts
- Public source verification
- Open-source architecture

---

# Core Design Principles

LaborCoin is built around several protocol-level principles.

## Immutable Production

Production contracts are intended to become immutable following deployment and ownership finalization.

## Democratic Governance

Treasury distributions require on-chain governance approval before execution.

## Public Transparency

Protocol logic, documentation, deployments, and governance activity are publicly accessible.

## Identity-Gated Governance

Each verified participant may receive one governance token through protocol registration.

## Separation of Roles

Economic participation and governance participation are intentionally separated.

---

# Security Model

The protocol incorporates multiple security mechanisms.

## Smart Contract Security

- ReentrancyGuard
- Replay-protected signatures
- Signature expiration
- Ownership renunciation
- Permanent minter locking
- Immutable protocol parameters where applicable

## Oracle Security

- Chainlink POL/USD price feed
- Oracle freshness validation
- Oracle anomaly detection

## Governance Security

- Identity-gated governance
- Treasury execution through DAO authorization
- Governance quorum requirements
- Approval thresholds
- Treasury distribution limits

---

# Protocol Parameters

| Parameter | Value |
|------------|------:|
| Network | Polygon Mainnet |
| Total Supply | 1,000,000,000 LABR |
| Initial Distribution | 100,000,000 |
| Subsequent Distribution | 50,000,000 |
| Buy Treasury Allocation | 10% POL |
| Sell Treasury Tax | 5% |
| Sell Dividend Tax | 5% |
| Burn Tax | 0% |
| Wallet Cooldown | 12 Hours |
| Governance Participation | 25% |
| Governance Approval | 67% |
| Treasury Transfer Cap | 5% |
| Registration Requirement | ≥1 LABR |
| Passport Threshold | 15 |

---

# Repository Layout

```

contracts/
├── Exchange
├── Governance
├── Registration
├── Treasury
└── Token

contracts-docs/

deployments/

docs/

frontend/

assets/

```

---

# Documentation

## Whitepaper

Technical specification of the protocol.

```
docs/whitepaper.md
```

## Redpaper

Project philosophy and long-term vision.

```
docs/redpaper.md
```

## Architecture

System architecture and contract relationships.

```
docs/architecture.md
```

## Governance

Governance rules and proposal lifecycle.

```
docs/governance.md
```

## Contract Map

Relationships between deployed contracts.

```
docs/contract-map.md
```

## Deployments

Deployment records and verified addresses.

```
deployments/
```

---

# Smart Contracts

| Contract | Description |
|-----------|-------------|
| LABR Token | ERC-20 utility token |
| LaborVote | ERC20Votes governance token |
| Registration | Participant registration |
| Exchange | Bonding curve exchange |
| Treasury Module | Treasury execution |
| Governance | Proposal management |

---

# Production Deployment

Network:

```
Polygon Mainnet
```

Compiler:

```
Solidity 0.8.30
```

Optimizer:

```
Enabled
Runs: 200
```

EVM Version

```
Prague
```

License

```
MIT
```

---

# Development

Clone the repository.

```bash
git clone https://github.com/LaborCoinCreator/LaborCoin.git
```

Install dependencies.

```bash
npm install
```

Compile.

```bash
npx hardhat compile
```

Run tests.

```bash
npx hardhat test
```

---

# Verification

All production contracts are intended to be:

- Source verified
- Publicly documented
- Deterministically deployed
- Linked to deployment records
- Referenced within the whitepaper

---

# Contributing

Pull requests are welcome.

For significant protocol changes, please open an issue first to discuss the proposed modification.

Development discussions should prioritize protocol security, determinism, documentation quality, and long-term maintainability.

---

# Security

If you discover a security issue, please do not publicly disclose it immediately.

Instead, responsibly disclose the issue so that it can be investigated before public discussion.

---

# License

Released under the MIT License.

See:

```
LICENSE
```

---

# Additional Resources

Website

https://www.laborcoin.tech

Whitepaper

https://www.laborcoin.tech/whitepaper

GitHub

https://github.com/LaborCoinCreator/LaborCoin

---

# Project Status

Current Status

✅ Production Deployment

✅ Source Verified

✅ Documentation Complete

✅ DAO Controlled Treasury

✅ Open Source

✅ MIT Licensed
