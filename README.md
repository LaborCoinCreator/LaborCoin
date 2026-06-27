[README.md](https://github.com/user-attachments/files/29404708/README.md)
# LaborCoin

A decentralized governance and funding system designed to support worker
solidarity through collective resource allocation, democratic
decision-making, and transparent on-chain coordination.

LaborCoin combines an immutable bonding curve economy, a
non-transferable governance token, and a DAO-managed treasury to enable
participants to collectively direct resources toward worker support
initiatives, strike assistance, educational projects, mutual aid
efforts, and other community-approved purposes.

![License](https://img.shields.io/badge/license-MIT-blue)
![Network](https://img.shields.io/badge/network-Polygon-purple)
![Status](https://img.shields.io/badge/status-Final_Launch-success)

------------------------------------------------------------------------

# Quick Links

## Project Resources

-   🌐 Website: https://www.laborcoin.tech/
-   📖 Whitepaper: docs/whitepaper.md
-   📕 Redpaper: docs/redpaper.md

## Documentation

-   🏗️ docs/architecture.md
-   🗳️ docs/governance.md
-   🧩 final-launch/contracts/contract-map.md
-   🚀 final-launch/deployment-records/README.md

------------------------------------------------------------------------

# Mission

LaborCoin explores how blockchain technology can strengthen collective
action through transparent, democratic and publicly auditable
infrastructure.

The protocol enables participants to collectively build and govern a
treasury that may support worker solidarity, strike assistance,
educational initiatives, mutual aid projects, and other
community-approved purposes.

------------------------------------------------------------------------

# Protocol Overview

LaborCoin separates economic participation from governance
participation.

1.  Acquire LABR through the LaborCoin Exchange V4.
2.  Hold at least 1 LABR.
3.  Complete identity verification requirements (Gitcoin Passport score
    threshold and verifier signature).
4.  Register through LaborCoin Registration V4.
5.  Receive one non-transferable LABRV governance token.
6.  Create proposals and vote through Governance V13.
7.  Approved proposals authorize distributions from the DAO Treasury
    through Treasury Module V1.

------------------------------------------------------------------------

# Core Components

  Component               Purpose
  ----------------------- ----------------------------------------
  LaborCoin Exchange V4   Protocol-native bonding curve exchange
  LABR Token              Economic participation token
  Registration V4         Governance eligibility
  LaborVote (LABRV) V7    Non-transferable governance token
  Governance V13          Proposal and voting logic
  Aragon DAO Treasury     Treasury governance
  Treasury Module V1      Executes approved treasury transfers

------------------------------------------------------------------------

# Protocol Architecture

``` text
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

------------------------------------------------------------------------

# Protocol Parameters

  Parameter                    Value
  ---------------------------- ----------------------------
  Network                      Polygon Mainnet
  Total Supply                 1,000,000,000 LABR
  Initial Tranche              100,000,000 LABR
  Tranche Unlock               50,000,000 LABR
  Buy Treasury Allocation      10% of POL
  Sell Tax                     5% Treasury / 5% Dividends
  Exchange Wallet Limit        10,000 LABR
  Exchange Transaction Limit   5,000 LABR
  Cooldown                     12 Hours
  Governance Quorum            25%
  Governance Approval          67%
  Voting Period                14 Days
  Execution Window             7 Days
  Treasury Distribution Cap    5% of DAO Treasury
  Minimum Registered Members   50

------------------------------------------------------------------------

# Deployed Contracts

  Contract             Address
  -------------------- --------------------------------------------
  LABR                 0x460DD873A1D2a41e77410B125cD3027C5FEd2f78
  Exchange V4          0x4Cf18cB39203B678f5C26f2338a10a79f9684749
  Registration V4      0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C
  LABRV V7             0x833242E933c675846D8f8982048FecA95B8e435A
  Treasury Module V1   0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C
  Governance V13       0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c
  Aragon DAO           0x0C2e5679153593b82a84eAB5CA90895BB291Cec4

------------------------------------------------------------------------

# Project Status

**Network:** Polygon Mainnet

**Status:** Final Launch Complete

All production contracts have been deployed, verified, and transitioned
to their intended immutable governance model.

------------------------------------------------------------------------

# Security

-   Immutable production contracts
-   Publicly verified source code
-   OpenZeppelin ReentrancyGuard
-   Chainlink POL/USD oracle
-   Oracle freshness and anomaly protection
-   Replay protection
-   Wallet and transaction limits
-   Deterministic bonding curve
-   Transparent on-chain treasury

------------------------------------------------------------------------

# Design Principles

-   Transparent governance
-   Equal voting power
-   Separation of governance and economic ownership
-   Immutable protocol rules
-   Public verification
-   Open-source development
-   Long-term community stewardship

------------------------------------------------------------------------

# Disclaimer

LaborCoin is experimental blockchain software. Participation involves
interacting with smart contracts and decentralized governance systems.
Review the documentation and deployed contracts before participating.
Nothing in this repository constitutes legal, financial, or investment
advice.

------------------------------------------------------------------------

# License

MIT
