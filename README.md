# LaborCoin

A decentralized governance and funding system designed to support worker solidarity through collective resource allocation, democratic decision-making, and transparent on-chain coordination.

LaborCoin combines a bonding curve economy, a non-transferable governance token, and a DAO-managed treasury to enable participants to collectively direct resources toward worker support initiatives, strike assistance, educational projects, and other community-approved purposes.

![License](https://img.shields.io/badge/license-MIT-blue)
![Network](https://img.shields.io/badge/network-Polygon-purple)
![Status](https://img.shields.io/badge/status-Active-green)

---

## Quick Links

### Project Resources

* 🌐 [Website](https://www.laborcoin.tech/)
* 📖 [Whitepaper](docs/whitepaper.md)
* 📕 [Redpaper](docs/redpaper.md)

### Documentation

* 🏗️ [Architecture](docs/architecture.md)
* 🗳️ [Governance](docs/governance.md)
* 🧩 [Contract Map](docs/contract-map.md)
* 🚀 [Polygon Deployment](deployments/polygon-mainnet.md)

---

## Mission

LaborCoin was created to explore how blockchain technology can be used to strengthen collective action and economic solidarity.

Workers often face significant economic pressure when organizing, negotiating, or taking collective action. LaborCoin seeks to provide a transparent and democratic funding infrastructure that can be governed directly by its participants.

---

## What LaborCoin Is

LaborCoin is a governance and treasury system.

Participants may:

* Acquire LABR through the protocol exchange
* Register for governance participation
* Receive LABRV governance rights
* Submit and vote on proposals
* Direct treasury resources through collective decision-making

LaborCoin is not intended to function as a traditional investment product.

---

## How It Works

1. Connect a wallet on Polygon
2. Acquire LABR using POL through the LaborCoin Exchange
3. Complete registration requirements
4. Receive LABRV governance rights
5. Participate in proposals and voting
6. Help direct treasury resources through governance

---

## Governance Model

LaborCoin separates economic participation from governance participation.

### LABR

The ecosystem's primary economic token.

* Participation in the bonding curve economy
* Treasury funding through protocol taxes
* Dividend participation
* Ecosystem engagement

### LABRV

The governance token.

* Non-transferable
* Cannot be bought or sold
* Issued through the registration system
* Used exclusively for governance

Governance rights are distributed through registration rather than token accumulation.

This helps maintain equal voting power for eligible registered participants.

---

## Core Components

| Component       | Purpose                               |
| --------------- | ------------------------------------- |
| Exchange V2     | Bonding curve market for LABR         |
| LABR            | Economic participation token          |
| Registration V3 | Governance eligibility and onboarding |
| LABRV V6        | Non-transferable governance token     |
| Governance V12  | Proposal and voting system            |
| LaborCoin DAO   | Governance authority                  |
| Treasury Module | Treasury custody and distributions    |

---

## Protocol Architecture

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

## Deployed Contracts

All LaborCoin contracts are deployed on Polygon and publicly verifiable.

| Component       | Address                                                                                                                    |
| --------------- | -------------------------------------------------------------------------------------------------------------------------- |
| LABR Token      | [`0x460DD873A1D2a41e77410B125cD3027C5FEd2f78`](https://polygonscan.com/address/0x460DD873A1D2a41e77410B125cD3027C5FEd2f78) |
| LaborCoin DAO   | [`0x0C2e5679153593b82a84eAB5CA90895BB291Cec4`](https://polygonscan.com/address/0x0C2e5679153593b82a84eAB5CA90895BB291Cec4) |
| Exchange V2     | [`0xD0692ec758bb852421B702B187b6439f74f8Bf3b`](https://polygonscan.com/address/0xD0692ec758bb852421B702B187b6439f74f8Bf3b) |
| Governance V12  | [`0x499b32e9E5a8b9865a9D69480d590252a56FA78F`](https://polygonscan.com/address/0x499b32e9E5a8b9865a9D69480d590252a56FA78F) |
| Registration V3 | [`0xa7D0C092C2391379046cACDc56BEbDe5A0CBD113`](https://polygonscan.com/address/0xa7D0C092C2391379046cACDc56BEbDe5A0CBD113) |
| LABRV V6        | [`0x113579220515cd59b884Ea2379b4C369025246e2`](https://polygonscan.com/address/0x113579220515cd59b884Ea2379b4C369025246e2) |
| Treasury Module | [`0x0B018E45E4cB71E222C345a5341BdbaeE519c623`](https://polygonscan.com/address/0x0B018E45E4cB71E222C345a5341BdbaeE519c623) |

---

## Current Status

### ✅ Deployed

* LABR Token
* Exchange V2
* Registration V3
* LABRV V6
* Governance V12
* LaborCoin DAO
* Treasury Module

### ✅ Operational

* Bonding curve exchange
* Governance system
* Registration system
* Treasury management
* On-chain proposal voting

---

## Documentation

### System Documentation

* 📄 Architecture
* 📄 Governance
* 📄 User Journey
* 📄 Contract Map

### Contract Documentation

* 📜 LABR Token
* 📜 Exchange V2
* 📜 Registration V3
* 📜 LABRV V6
* 📜 Governance V12
* 📜 Treasury Module

### Source Code

* 💻 `/contracts`
* 📦 `/deployments`

---

## Design Principles

* Transparent governance
* Equal voting power for eligible registered participants
* Separation of governance and economic ownership
* Publicly auditable treasury activity
* Deterministic protocol rules
* Open-source development
* Long-term community stewardship

---

## Disclaimer

LaborCoin is experimental software.

Participation involves interacting with smart contracts, decentralized governance systems, and blockchain networks. Users should review the source code, documentation, and deployed contracts before participating.

Nothing in this repository constitutes legal, financial, or investment advice.

---

## License

MIT
