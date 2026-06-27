# LaborCoin

### Public Infrastructure for Democratic Worker Funding

[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)
[![Network](https://img.shields.io/badge/network-Polygon_Mainnet-purple)](https://polygonscan.com/)
[![Status](https://img.shields.io/badge/status-Final_Launch-success)](https://www.laborcoin.tech/)
[![Contracts](https://img.shields.io/badge/contracts-source_verified-brightgreen)](final-launch/deployment-records/verification.md)
[![Solidity](https://img.shields.io/badge/custom_contracts-Solidity_0.8.30-black)](final-launch/deployment-records/build-environment.md)

LaborCoin is an open-source treasury governance protocol designed to help workers and supporters build shared resources and allocate them through transparent, democratic decision-making.

The protocol combines a transferable economic token, a deterministic bonding curve exchange, Sybil-resistant registration, a non-transferable governance token, constrained treasury governance, and an Aragon DAO treasury into a unified system deployed on Polygon Mainnet.

LaborCoin is intended to operate as public infrastructure rather than as a permanently administered organization. Governance determines how treasury resources are distributed, while the core economic, registration, voting, and treasury protection rules remain fixed by deployed smart contracts.

---

## Quick Links

| Resource                                                        | Description                                         |
| --------------------------------------------------------------- | --------------------------------------------------- |
| [LaborCoin Website](https://www.laborcoin.tech/)                | Public web application and protocol interface       |
| [Exchange](https://www.laborcoin.tech/exchange)                 | Buy and sell LABR through Exchange V4               |
| [DAO Registration](https://www.laborcoin.tech/dao)              | Complete governance registration                    |
| [Governance](https://www.laborcoin.tech/governance)             | Create, review, vote on, and execute proposals      |
| [Onboarding](https://www.laborcoin.tech/onboarding)             | Participant and organization onboarding             |
| [Technical Whitepaper](docs/whitepaper.md)                      | Full technical protocol specification               |
| [Redpaper](docs/redpaper.md)                                    | Mission, philosophy, and long-term vision           |
| [Architecture](docs/architecture.md)                            | System components and contract relationships        |
| [Governance](docs/governance.md)                                | Governance rules and proposal lifecycle             |
| [Contract Map](final-launch/contracts/contract-map.md)          | Production contract dependency map                  |
| [Deployment Records](final-launch/deployment-records/README.md) | Final deployment, verification, and release records |

---

## Overview

LaborCoin was created in response to a practical coordination problem.

Workers participating in strikes, organizing campaigns, labor disputes, mutual aid efforts, and other forms of collective action may face immediate economic pressure. Existing unions, strike funds, community organizations, and mutual aid networks provide essential support, but access to durable funding infrastructure remains uneven across workplaces, industries, regions, and organizations.

LaborCoin provides an additional mechanism through which participants can:

1. Build a shared treasury through protocol activity and voluntary contributions.
2. Register for governance through a Sybil-resistant process.
3. Participate under a one-verified-participant-per-LABRV model.
4. Propose and vote on treasury distributions.
5. Execute approved distributions through transparent on-chain infrastructure.

The protocol does not decide which workers, organizations, campaigns, or initiatives should receive funding. Those decisions belong to registered governance participants.

LaborCoin is not intended to replace labor unions, worker organizations, strike funds, mutual aid networks, or other existing institutions. It is designed as complementary infrastructure that such communities may choose to use.

---

## What LaborCoin Is

LaborCoin is:

* A decentralized treasury governance protocol
* A transparent worker-support funding mechanism
* A deterministic LABR distribution system
* A Sybil-resistant governance framework
* A publicly auditable DAO treasury
* An open-source protocol deployed on Polygon Mainnet
* A completed production architecture intended for long-term autonomous operation

LaborCoin is not:

* A traditional investment fund
* A guaranteed strike-support program
* A replacement for unions or worker organizations
* A system that guarantees treasury growth or successful governance outcomes
* A protocol whose core rules can be continually rewritten by token holders
* A promise of financial returns

---

## Design Objectives

LaborCoin combines a social objective with a technical objective.

### Social Objective

Provide infrastructure through which participants may accumulate and democratically allocate resources in support of workers and communities facing economic hardship connected to strikes, lockouts, labor disputes, organizing activity, mutual aid, education, and related collective efforts.

### Technical Objective

Provide a system that is:

* Transparent
* Publicly auditable
* Deterministic
* Resistant to duplicate governance identities
* Constrained against treasury overreach
* Independent of permanent founder administration
* Capable of operating according to fixed smart contract rules

The technology exists to support collective coordination. The project does not treat blockchain use as an end in itself.

---

## Protocol Architecture

```text
Workers and Supporters
          │
          ├────────────────────────────────────┐
          │                                    │
          ▼                                    ▼
  Exchange V4                         Gitcoin Passport
          │                                    │
          ▼                                    ▼
        LABR                            Verifier Signature
          │                                    │
          └──────────────► Registration V4 ◄───┘
                                   │
                                   ▼
                         One LABRV per Participant
                                   │
                                   ▼
                          Governance V13
                                   │
                         Proposal and Voting
                                   │
                                   ▼
                         Aragon DAO Treasury
                                   │
                                   ▼
                       Treasury Module V1
                                   │
                                   ▼
                         Approved Recipient
```

The architecture separates four major functions:

| Layer        | Components                              | Function                                                                    |
| ------------ | --------------------------------------- | --------------------------------------------------------------------------- |
| Economic     | LABR and Exchange V4                    | Token distribution, liquidity, treasury funding, and economic participation |
| Registration | Passport, verifier, and Registration V4 | Governance eligibility and duplicate-participation resistance               |
| Governance   | LABRV V7 and Governance V13             | Proposal creation, voting, approval validation, and execution authorization |
| Treasury     | Aragon DAO and Treasury Module V1       | Asset custody and execution of approved distributions                       |

No single contract performs every function. Responsibilities are divided among narrowly scoped components to reduce authority concentration and improve auditability.

---

## How the Protocol Works

### 1. Acquire POL

LaborCoin operates on Polygon Mainnet. Participants need POL for network transaction fees and for LABR purchases through the exchange.

### 2. Acquire LABR

Participants may purchase LABR through LaborCoin Exchange V4.

The exchange:

* Calculates the LABR price from the deployed quadratic bonding curve
* Converts the USD-denominated curve price into POL through Chainlink
* Transfers LABR from protocol-held exchange inventory
* Sends 10% of incoming POL to the DAO treasury
* Retains the remaining POL as exchange liquidity
* Enforces transaction, wallet, supply, cooldown, oracle, and slippage requirements

Participants may also sell eligible LABR back to the exchange when all contract conditions are satisfied and sufficient POL liquidity is available.

### 3. Complete Governance Registration

Economic participation does not automatically create governance authority.

To register, a participant must:

* Hold at least 1 LABR
* Reach the required Gitcoin Passport score
* Obtain a valid authorization signature from the designated verifier
* Submit the registration transaction before the authorization expires
* Not already possess LABRV

### 4. Receive LABRV

Successful registration causes Registration V4 to mint one LABRV to the participant.

LABRV is:

* Non-transferable
* Non-tradable
* Issued only through Registration V4
* Limited to one per registered participant
* Used exclusively for governance

The LABRV minter is permanently locked to Registration V4, and LABRV ownership has been renounced.

### 5. Participate in Governance

Registered participants may create proposals and vote through Governance V13.

Governance is limited to treasury allocation. It cannot change the bonding curve, supply, exchange limits, registration requirements, governance thresholds, execution window, or treasury cap.

### 6. Execute Approved Distributions

A proposal may execute only after satisfying all protocol requirements.

Approved distributions are authorized through Governance V13, executed by the Aragon DAO, and routed through Treasury Module V1 to the approved recipient.

Every proposal, vote, execution, and treasury transfer remains publicly visible on-chain.

---

## Core Components

### LABR Token

LABR is the transferable economic token of the LaborCoin ecosystem.

LABR supports:

* Economic participation
* Exchange purchases and sales
* Governance registration eligibility
* Treasury funding through protocol taxes
* POL dividend participation
* Transfers subject to token-level rules

LABR ownership does not provide additional voting power. A participant holding more LABR does not receive more LABRV and does not gain greater governance weight.

**Production address:**

[`0x460DD873A1D2a41e77410B125cD3027C5FEd2f78`](https://polygonscan.com/address/0x460DD873A1D2a41e77410B125cD3027C5FEd2f78)

---

### LaborCoin Exchange V4

Exchange V4 is the protocol-native LABR distribution and liquidity contract.

It provides:

* Deterministic quadratic bonding curve pricing
* LABR purchases using POL
* LABR sales for POL
* Chainlink POL/USD conversion
* Automatic supply tranche unlocking
* Automatic DAO treasury funding
* Contract-level wallet and transaction limits
* A 12-hour transaction cooldown
* Buy and sell slippage protection
* Oracle freshness validation
* Oracle anomaly protection
* OpenZeppelin reentrancy protection

Exchange V4 contains:

* No owner
* No administrator
* No upgrade mechanism
* No pause function
* No administrative withdrawal function
* No ownership transfer function
* No post-deployment parameter setter

POL retained by Exchange V4 is permanently dedicated to exchange liquidity and seller payouts.

**Production address:**

[`0x4Cf18cB39203B678f5C26f2338a10a79f9684749`](https://polygonscan.com/address/0x4Cf18cB39203B678f5C26f2338a10a79f9684749)

---

### LaborCoin Registration V4

Registration V4 connects the economic layer to the governance layer.

The contract:

* Verifies minimum LABR ownership
* Validates verifier signatures
* Rejects expired authorizations
* Prevents duplicate registration
* Assigns sequential member numbers
* Records registration timestamps
* Tracks total registered membership
* Mints one LABRV to eligible participants

The Gitcoin Passport score is evaluated through the verifier service before authorization is signed. Registration V4 verifies the resulting cryptographic authorization on-chain.

**Production address:**

[`0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C`](https://polygonscan.com/address/0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C)

---

### LaborVote (LABRV) V7

LABRV is the protocol's non-transferable governance credential.

It implements ERC20Votes-compatible governance accounting while preventing transfers between participants.

Its final production state includes:

* Registration V4 assigned as the sole minter
* Permanent minter lock
* Renounced ownership
* No secondary market
* No purchase mechanism
* One verified participant per LABRV

LABRV separates governance participation from economic ownership and prevents participants from purchasing additional voting power.

**Production address:**

[`0x833242E933c675846D8f8982048FecA95B8e435A`](https://polygonscan.com/address/0x833242E933c675846D8f8982048FecA95B8e435A)

---

### LaborCoin Governance V13

Governance V13 manages the treasury proposal lifecycle.

It is responsible for:

* Proposal creation
* Vote recording
* Participation calculations
* Approval calculations
* Execution-window enforcement
* Treasury-cap enforcement
* Replay-protected signature validation
* Execution authorization through the Aragon DAO architecture

Governance V13 has no owner, upgrade path, administrative override, emergency bypass, or post-deployment parameter modification functions.

Governance authority is deliberately constrained. Governance can authorize treasury distributions, but it cannot administer or rewrite the rest of the protocol.

**Production address:**

[`0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c`](https://polygonscan.com/address/0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c)

---

### Aragon DAO Treasury

The Aragon DAO holds protocol treasury assets.

The DAO:

* Receives 10% of POL used for exchange purchases
* Receives the treasury portion of applicable LABR taxes
* May receive voluntary contributions
* Holds treasury assets pending governance approval
* Executes only properly authorized actions through its permission framework

The DAO does not control the bonding curve, exchange rules, registration rules, governance thresholds, or other fixed protocol parameters.

**DAO treasury address:**

[`0x0C2e5679153593b82a84eAB5CA90895BB291Cec4`](https://polygonscan.com/address/0x0C2e5679153593b82a84eAB5CA90895BB291Cec4)

---

### LaborCoin Treasury Module V1

Treasury Module V1 is a narrowly scoped execution contract.

The module:

* Accepts execution calls only from the configured DAO
* Routes the POL supplied with an approved DAO call to the designated recipient
* Records cumulative POL distributed
* Emits transfer events for public accounting

The module does not independently custody the DAO treasury, evaluate proposals, count votes, or determine recipients.

Its DAO address was fixed at deployment and cannot be changed.

Treasury Module V1 contains:

* No owner
* No upgrade mechanism
* No administrator
* No administrative withdrawal function
* No arbitrary external execution capability

**Production address:**

[`0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C`](https://polygonscan.com/address/0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C)

---

## Economic Model

### Fixed Supply

LABR has a fixed total supply of:

```text
1,000,000,000 LABR
```

The documented distribution model allocates the supply to protocol-controlled exchange distribution. No founder, team, investor, adviser, or private-sale allocation is defined in the protocol tokenomics.

### Progressive Exchange Availability

The exchange does not make its full inventory available at once.

| Distribution Parameter  |              Value |
| ----------------------- | -----------------: |
| Maximum Supply          | 1,000,000,000 LABR |
| Initial Unlocked Supply |   100,000,000 LABR |
| Additional Tranche Size |    50,000,000 LABR |

When distributed supply reaches the current unlocked-supply boundary, the exchange automatically unlocks another 50,000,000 LABR tranche, subject to the maximum supply.

No administrator or governance vote is required to release a tranche.

### Bonding Curve

Exchange V4 uses the following USD-denominated target-price function:

```text
P(x) = 1 + 14x²
```

where:

```text
x = distributed LABR / 1,000,000,000 LABR
```

The theoretical target-price range is:

```text
$1.00 to $15.00 per LABR
```

The current USD-denominated curve price is converted into POL using the configured Chainlink POL/USD feed.

The curve determines protocol pricing from distribution progress. It does not use an order book, external market maker, or third-party liquidity pool.

### Purchase Flow

When a participant purchases LABR:

| Destination        | Allocation                                                                   |
| ------------------ | ---------------------------------------------------------------------------- |
| Buyer              | Full calculated LABR output, subject to transfer behavior and `minTokensOut` |
| DAO Treasury       | 10% of incoming POL                                                          |
| Exchange Liquidity | Remaining 90% of incoming POL                                                |

### Sale Flow

When LABR is transferred to the exchange for sale, the LABR token applies the configured sell-side allocation:

| Allocation       | Rate |
| ---------------- | ---: |
| DAO Treasury     |   5% |
| Holder Dividends |   5% |
| Burn             |   0% |
| Total Sell Tax   |  10% |

Exchange V4 calculates the seller payout from the amount actually received by the exchange after token-level transfer behavior.

### Distribution Controls

LaborCoin uses two separate layers of limits.

#### LABR Token-Level Limits

| Parameter                 |          Value |
| ------------------------- | -------------: |
| Maximum Token Wallet      | 1,000,000 LABR |
| Maximum Token Transaction |   500,000 LABR |

#### Exchange V4 Limits

| Parameter                    |       Value |
| ---------------------------- | ----------: |
| Maximum Exchange Wallet      | 10,000 LABR |
| Maximum Exchange Transaction |  5,000 LABR |
| Exchange Cooldown            |    12 Hours |

The Exchange V4 limits are enforced by the deployed exchange contract and are more restrictive than the underlying token limits.

---

## Registration and Governance Eligibility

Governance participation requires more than LABR ownership.

| Requirement                | Value      |
| -------------------------- | ---------- |
| Minimum LABR Balance       | 1 LABR     |
| Gitcoin Passport Threshold | 15         |
| Verifier Authorization     | Required   |
| Authorization Expiration   | Enforced   |
| Duplicate Registration     | Prohibited |
| LABRV Issued               | 1          |

Gitcoin Passport is used as a practical Sybil-resistance mechanism. It provides signals of participant uniqueness without requiring the protocol to collect government identification or traditional Know Your Customer information.

Passport does not provide absolute proof of identity. The governance model should therefore be understood as pursuing one-verified-participant-per-LABRV rather than claiming perfect identity assurance.

---

## Governance Model

LaborCoin uses equal governance weight among registered participants.

```text
1 LABRV = 1 governance vote
```

Additional LABR ownership does not produce additional LABRV and does not increase governance weight.

### Governance Parameters

| Parameter                                        |                           Value |
| ------------------------------------------------ | ------------------------------: |
| Minimum Registered Participants Before Execution |                              50 |
| Voting Period                                    |                         14 Days |
| Participation Requirement                        |                             25% |
| Approval Requirement                             |                             67% |
| Execution Window                                 |                          7 Days |
| Maximum Treasury Distribution Per Proposal       | 5% of DAO treasury at execution |

### Proposal Lifecycle

```text
Proposal Created
       │
       ▼
14-Day Voting Period
       │
       ├──────────────► Participation below 25% ──► Rejected
       │
       └──────────────► Participation at least 25%
                                      │
                                      ▼
                           Approval below 67% ──► Rejected
                                      │
                                      ▼
                           Approval at least 67%
                                      │
                                      ▼
                         7-Day Execution Window
                                      │
                         ┌────────────┴────────────┐
                         ▼                         ▼
                    Executed                    Expired
```

An approved proposal must still satisfy the treasury cap, execution-window requirement, signature checks, nonce checks, and all other contract conditions at execution time.

### Constrained Governance

Governance may determine:

* Whether a treasury proposal is approved
* Which recipient receives an approved distribution
* How much is distributed within the protocol cap
* Whether a participant supports or opposes a proposal

Governance may not change:

* LABR maximum supply
* Bonding curve formula
* Exchange wallet or transaction limits
* Tranche sizes
* Exchange cooldown
* Oracle address
* Registration minimum
* Passport threshold used by the verifier
* LABRV transferability
* Governance participation threshold
* Governance approval threshold
* Voting duration
* Execution window
* Treasury distribution cap

This separation preserves democratic treasury allocation without creating an unrestricted protocol administrator.

---

## Treasury Architecture

The treasury lifecycle is deliberately separated into decision, custody, and execution layers.

```text
Protocol Activity and Contributions
                │
                ▼
        Aragon DAO Treasury
                │
                ▼
       Governance V13 Approval
                │
                ▼
      Aragon DAO execute(Action[])
                │
                ▼
       Treasury Module V1
                │
                ▼
       Approved Recipient
```

### Treasury Funding Sources

Treasury resources may originate from:

* 10% of POL used in Exchange V4 purchases
* The 5% treasury portion of applicable LABR sell taxation
* Voluntary contributions
* Other assets sent directly to the DAO treasury

### Treasury Protections

Treasury distributions are protected by:

* Registration-based governance eligibility
* Non-transferable LABRV
* Verifier-authorized governance actions
* A minimum governance membership requirement
* A 25% participation requirement
* A 67% approval requirement
* A 5% per-proposal treasury cap
* A 7-day execution window
* Double-execution prevention
* DAO permission enforcement
* A DAO-only Treasury Module

No individual governance vote can bypass these requirements.

---

## Security Model

LaborCoin uses defense in depth. No single control is expected to protect the entire protocol.

### Exchange Protections

* OpenZeppelin `ReentrancyGuard`
* Checks-effects-interactions ordering
* Safe low-level token transfer wrappers
* Positive oracle-price validation
* 30-minute oracle freshness requirement
* Maximum oracle-derived price protection
* Contract-level transaction limits
* Contract-level wallet limits
* Twelve-hour cooldown
* Buy slippage protection through `minTokensOut`
* Sell slippage protection through `minPOL`
* Supply availability checks
* Exchange liquidity checks

### Registration Protections

* Minimum LABR ownership
* Passport-assisted Sybil resistance
* Designated verifier signatures
* Signature expiration
* Duplicate-registration prevention
* Existing-LABRV checks
* Registration-controlled minting

### LABRV Protections

* Non-transferability
* One LABRV per eligible participant
* Registration V4 fixed as minter
* Permanent minter lock
* Ownership renouncement

### Governance Protections

* Membership-based eligibility
* Verifier-authorized actions
* Per-wallet nonce tracking
* Signature expiration
* Vote tracking
* Participation requirement
* Supermajority approval
* Minimum membership activation
* Execution-window enforcement
* Treasury distribution cap
* Reentrancy protection
* No owner or administrative override

### Treasury Protections

* Asset custody in the Aragon DAO
* Permissioned DAO execution
* DAO-only Treasury Module access
* Immutable DAO address in Treasury Module V1
* No module owner
* No module upgrade path
* No administrative withdrawal function
* Public transfer events and cumulative accounting

### Transparency Protections

* Public source verification
* Public contract addresses
* Archived constructor arguments
* Archived compiler settings
* Archived deployment transactions
* Archived artifacts and metadata
* Public treasury activity
* Public governance activity

Public source verification improves auditability, but it is not equivalent to an independent professional security audit. This repository should not be read as claiming an external audit unless a separate audit report is published.

---

## Trust Boundaries and External Dependencies

LaborCoin removes or constrains internal administrative authority, but it still depends on external infrastructure.

### Polygon Mainnet

Polygon provides transaction execution, consensus, account state, and smart contract availability.

A major Polygon outage, consensus failure, or network disruption may affect protocol operation.

### Chainlink POL/USD Feed

Exchange V4 depends on the Chainlink POL/USD feed:

[`0xAB594600376Ec9fD91F8e885dADF0CE036862dE0`](https://polygonscan.com/address/0xAB594600376Ec9fD91F8e885dADF0CE036862dE0)

If the feed becomes stale or invalid, exchange pricing calls revert. The oracle is external infrastructure and is not owned or controlled by LaborCoin.

### Gitcoin Passport

The governance onboarding process uses Gitcoin Passport as a source of Sybil-resistance signals.

Changes to Passport availability, scoring, or supported identity signals may affect the off-chain verification workflow.

### Verifier Address

The designated verifier is:

[`0x475d519631d2406753aCA29F305f19b83E97513e`](https://polygonscan.com/address/0x475d519631d2406753aCA29F305f19b83E97513e)

The verifier is an externally controlled signing address, not a smart contract.

The verifier may authorize eligible registration and governance actions, but it cannot directly:

* Mint LABRV
* Register participants
* Transfer treasury assets
* Execute DAO actions
* Change contract parameters
* Cast votes from participant wallets

The verifier remains a material operational dependency because valid signatures are required by the deployed registration and governance architecture.

### Frontend and Hosting

The LaborCoin website provides a convenient interface to the protocol but is not the protocol itself.

The deployed smart contracts remain accessible through compatible blockchain tools even if the official frontend becomes unavailable.

---

## Immutability and Authority Model

The final production architecture does not assign identical authority status to every component.

| Component           | Final Authority State                                    |
| ------------------- | -------------------------------------------------------- |
| LABR Token          | DAO controlled                                           |
| Exchange V4         | Autonomous; no owner or administrative control path      |
| Registration V4     | Autonomous                                               |
| LABRV V7            | Ownership renounced; minter permanently locked           |
| Governance V13      | Autonomous; no owner, upgrade path, or parameter setters |
| Aragon DAO Treasury | Governed through DAO permissions and Governance V13      |
| Treasury Module V1  | Autonomous; callable only by the fixed DAO               |

The final design does not replace creator control with unlimited DAO control.

Instead:

* Administrative control is removed from the custom production contracts.
* LABR ownership and treasury custody reside with the DAO.
* Governance authority remains limited to treasury allocation.
* Core protocol parameters remain outside governance control.

---

## Deployed Contracts

All listed production contracts are deployed on Polygon Mainnet and publicly source verified.

| Contract Name                | Contract Address                                                                                                         | Deployment Block | Deployment Date (UTC)        | Verified Source | Final Status                                    |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ---------------: | ---------------------------- | --------------- | ----------------------------------------------- |
| LABR Token                   | [0x460DD873A1D2a41e77410B125cD3027C5FEd2f78](https://polygonscan.com/address/0x460DD873A1D2a41e77410B125cD3027C5FEd2f78) |         69797383 | Apr-02-2025 07:56:25 AM +UTC | Yes             | DAO Controlled                                  |
| LaborVote (LABRV) V7         | [0x833242E933c675846D8f8982048FecA95B8e435A](https://polygonscan.com/address/0x833242E933c675846D8f8982048FecA95B8e435A) |         88595455 | Jun-16-2026 08:22:48 AM +UTC | Yes             | Ownership Renounced / Minter Permanently Locked |
| LaborCoin Registration V4    | [0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C](https://polygonscan.com/address/0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C) |         88997813 | Jun-22-2026                  | Yes             | Autonomous                                      |
| LaborCoin Treasury Module V1 | [0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C](https://polygonscan.com/address/0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C) |         89052358 | Jun-24-2026                  | Yes             | Autonomous / DAO Only                           |
| LaborCoin Governance V13     | [0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c](https://polygonscan.com/address/0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c) |         89084762 | Jun-24-2026 08:15:38 PM +UTC | Yes             | Autonomous                                      |
| LaborCoin Exchange V4        | [0x4Cf18cB39203B678f5C26f2338a10a79f9684749](https://polygonscan.com/address/0x4Cf18cB39203B678f5C26f2338a10a79f9684749) |         89115657 | Jun-25-2026 09:08:01 AM +UTC | Yes             | Autonomous                                      |

### System References

| Reference              | Address                                                                                                                  | Purpose                                              |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------- |
| Aragon DAO Treasury    | [0x0C2e5679153593b82a84eAB5CA90895BB291Cec4](https://polygonscan.com/address/0x0C2e5679153593b82a84eAB5CA90895BB291Cec4) | Treasury custody and DAO execution                   |
| Verifier               | [0x475d519631d2406753aCA29F305f19b83E97513e](https://polygonscan.com/address/0x475d519631d2406753aCA29F305f19b83E97513e) | Registration and governance authorization signatures |
| Chainlink POL/USD Feed | [0xAB594600376Ec9fD91F8e885dADF0CE036862dE0](https://polygonscan.com/address/0xAB594600376Ec9fD91F8e885dADF0CE036862dE0) | USD-to-POL exchange price conversion                 |

Historical and retired deployments should not be treated as production contracts. Historical addresses and retirement records are preserved in the final launch deployment documentation.

---

## Build and Verification Environment

### Custom Final-Launch Contracts

| Setting                 | Value                     |
| ----------------------- | ------------------------- |
| Solidity Compiler       | `0.8.30`                  |
| Compiler Build          | `v0.8.30+commit.73712a01` |
| EVM Version             | `Prague`                  |
| Optimizer               | Enabled                   |
| Optimizer Runs          | `200`                     |
| Via IR                  | `False`                   |
| OpenZeppelin            | `5.6.1` where used        |
| Development Environment | Remix IDE `2.4.1`         |
| Network                 | Polygon Mainnet           |
| Chain ID                | `137`                     |
| License                 | MIT                       |

Treasury Module V1 does not import OpenZeppelin.

### LABR Token

LABR was produced through the 20LABS token generator before the custom final-launch deployment sequence.

| Setting           | Value                      |
| ----------------- | -------------------------- |
| Solidity Compiler | `0.8.25`                   |
| EVM Version       | `Paris`                    |
| Optimizer         | Enabled                    |
| Optimizer Runs    | `200`                      |
| Verification      | Exact Match on Polygonscan |

The LABR token build environment is therefore different from the custom final-launch contract environment.

### Verification Records

The repository archives:

* Exact production source files
* Compiler and EVM settings
* Constructor arguments
* Encoded constructor arguments
* Deployment transactions
* Deployment blocks
* Verification methods
* Artifact hashes
* Metadata hashes
* Release records
* Ownership and minter-lock transactions

These records are intended to support future audits, bytecode review, historical research, and reproducibility.

---

## Repository Structure

```text
LaborCoin/
├── README.md
├── LICENSE
│
├── docs/
│   ├── whitepaper.md
│   ├── redpaper.md
│   ├── architecture.md
│   ├── governance.md
│   └── user-journey.md
│
├── contracts-docs/
│   └── Contract-level technical documentation
│
├── final-launch/
│   ├── contracts/
│   │   ├── LaborVoteV7.sol
│   │   ├── LaborCoinRegistrationV4.sol
│   │   ├── LaborCoinExchangeV4.sol
│   │   ├── LaborCoinTreasuryModuleV1.sol
│   │   ├── LaborCoinGovernanceV13.sol
│   │   └── contract-map.md
│   │
│   ├── deployment-records/
│   │   ├── README.md
│   │   ├── constructor-args.md
│   │   ├── deployments.md
│   │   ├── verification.md
│   │   ├── build-environment.md
│   │   └── release-record.md
│   │
│   └── artifacts/
│       └── Exported compiler artifacts and metadata
│
└── frontend/
    └── Public web application files, where maintained in this repository
```

Repository paths should be adjusted only where the actual repository directory name differs. The final-launch records are the authoritative source for production deployments.

---

## Documentation Guide

| Document                                                            | Audience                                           | Purpose                                                                      |
| ------------------------------------------------------------------- | -------------------------------------------------- | ---------------------------------------------------------------------------- |
| [Technical Whitepaper](docs/whitepaper.md)                          | General readers, developers, auditors, researchers | Full protocol specification, economic model, governance, security, and risks |
| [Redpaper](docs/redpaper.md)                                        | General readers and organizers                     | Mission, political philosophy, and long-term social objective                |
| [Architecture](docs/architecture.md)                                | Developers and reviewers                           | Component boundaries and system relationships                                |
| [Governance](docs/governance.md)                                    | Governance participants                            | Proposal, voting, approval, and execution rules                              |
| [User Journey](docs/user-journey.md)                                | Participants                                       | End-to-end onboarding and participation flow                                 |
| [Contract Documentation](contracts-docs/)                           | Developers and auditors                            | Contract-specific behavior and responsibilities                              |
| [Contract Map](final-launch/contracts/contract-map.md)              | Developers and auditors                            | Production contract dependency map                                           |
| [Deployment Records](final-launch/deployment-records/)              | Auditors and researchers                           | Addresses, blocks, transactions, verification, and constructor arguments     |
| [Release Record](final-launch/deployment-records/release-record.md) | Auditors and maintainers                           | Source hashes, artifact hashes, and final release integrity                  |

---

## Working With the Repository

The contracts in `final-launch/contracts/` represent the source associated with the final Polygon Mainnet deployment.

They should be treated as archival production source, not as upgradeable modules awaiting future deployment.

Changes to repository files do not alter the deployed protocol.

### Reproducing the Custom Contract Build

Use the exact settings recorded in:

```text
final-launch/deployment-records/build-environment.md
```

The production custom contracts were compiled using Remix IDE with:

```text
Solidity: 0.8.30
EVM: Prague
Optimizer: Enabled
Runs: 200
Via IR: False
OpenZeppelin: 5.6.1 where imported
```

Constructor arguments must match:

```text
final-launch/deployment-records/constructor-args.md
```

Any change to source code, imports, compiler version, optimizer settings, EVM target, or constructor arguments may produce different bytecode.

### Frontend Development

Frontend contributions should preserve:

* Final production contract addresses
* ABI compatibility
* Polygon Mainnet chain validation
* WalletConnect and injected-wallet compatibility
* User-facing transaction confirmation
* Explicit error reporting
* Mobile and PWA support
* Non-investment framing
* Clear distinction between LABR and LABRV
* Clear presentation of governance and registration requirements

### Documentation Contributions

Documentation corrections and clarity improvements are welcome where they do not misrepresent deployed behavior.

Any technical claim about the production protocol should be checked against:

1. Deployed source code
2. Polygonscan verification
3. Constructor arguments
4. Deployment records
5. Final release artifacts

---

## Contribution Scope

The deployed production protocol is intended to remain fixed.

Contributions may improve:

* Documentation
* Accessibility
* Frontend interfaces
* Read-only analytics
* Educational materials
* Governance discussion tools
* Archival records
* Independent analysis
* Testing utilities

Contributions cannot upgrade or modify the already deployed production contracts.

A proposed replacement deployment should not be represented as the existing LaborCoin production protocol.

---

## Project Status

**Network:** Polygon Mainnet
**Chain ID:** 137
**Release:** Final Launch
**Production Exchange:** LaborCoin Exchange V4
**Production Governance:** LaborCoin Governance V13

### Completed

* Production contracts deployed
* Production source code verified
* Constructor arguments archived
* Build environment archived
* Deployment transactions archived
* Source and artifact hashes archived
* LABRV minter assigned to Registration V4
* LABRV minter permanently locked
* LABRV ownership renounced
* Registration flow validated
* Replay protection validated
* LABRV minting validated
* Governance proposal flow validated
* Governance voting validated
* Treasury execution validated
* Exchange purchasing validated
* Exchange selling validated
* Frontend updated to production addresses

The final launch records remain the authoritative reference for the exact scope and results of validation.

---

## Design Principles

### Transparency

Participants should be able to independently inspect contract code, treasury balances, governance activity, exchange transactions, and distributions.

### Governance Equality

Governance weight is based on registration and LABRV issuance rather than LABR accumulation.

### Separation of Responsibilities

Economic distribution, registration, voting, custody, and execution are handled by separate components.

### Constrained Authority

No participant, administrator, governance vote, or treasury proposal should possess unlimited authority.

### Predictability

Core operating rules are fixed rather than subject to continuous political or administrative modification.

### Public Verifiability

Production source, deployment details, constructor arguments, and verification records are publicly documented.

### Completion

LaborCoin is designed to become completed infrastructure rather than a permanently mutable protocol dependent on continuous founder administration.

---

## Risks and Limitations

LaborCoin cannot guarantee:

* Treasury growth
* Participant adoption
* Governance participation
* Effective proposals
* Wise allocation decisions
* Successful labor actions
* Continuous exchange liquidity
* Continuous availability of external dependencies
* Absence of smart contract vulnerabilities
* Favorable legal or regulatory treatment

Material risks include:

* Immutable smart contract defects
* Polygon network disruption
* Chainlink oracle disruption
* Gitcoin Passport changes or unavailability
* Verifier compromise or unavailability
* Governance coordination failure
* Low participation
* Coordinated voting blocs
* Treasury misallocation
* Exchange liquidity constraints
* Frontend or hosting failure
* Regulatory uncertainty

The protocol provides infrastructure. It cannot create solidarity, participation, trust, good judgment, or successful outcomes on its own.

---

## Security Disclosures

Potential vulnerabilities should be disclosed privately before public publication whenever possible.

A responsible report should include:

* Affected contract or interface
* Production address
* Relevant function or component
* Reproduction steps
* Expected behavior
* Observed behavior
* Potential impact
* Suggested mitigation, when known

Because the custom production contracts are immutable, some contract-level defects may not be correctable after deployment. Responsible disclosure remains valuable for user protection, interface warnings, documentation, and independent analysis.

Use the current project contact information published through the official website or repository for private disclosure.

---

## Disclaimer

LaborCoin is experimental blockchain infrastructure.

Interaction with smart contracts, digital assets, decentralized governance systems, external identity systems, and blockchain networks involves risk.

Nothing in this repository constitutes:

* Investment advice
* Legal advice
* Tax advice
* Financial advice
* A solicitation of securities
* An offer to sell a financial product
* A guarantee of treasury support
* A guarantee of governance outcomes
* A guarantee of economic performance

Participants should independently review the source code, documentation, deployed contracts, external dependencies, and applicable legal requirements before interacting with the protocol.

---

## License

Repository source is released under the MIT License except where a file, dependency, generated contract, or third-party component states otherwise.

See:

```text
LICENSE
```

---

## Additional Resources

* Website: [laborcoin.tech](https://www.laborcoin.tech/)
* Whitepaper: [laborcoin.tech/whitepaper](https://www.laborcoin.tech/whitepaper)
* Repository: [github.com/LaborCoinCreator/LaborCoin](https://github.com/LaborCoinCreator/LaborCoin)
* Polygon Explorer: [polygonscan.com](https://polygonscan.com/)

---

## Closing Statement

LaborCoin is an attempt to provide durable infrastructure for transparent collective economic coordination.

The token supports economic participation. The exchange supports distribution and treasury growth. Registration supports governance legitimacy. LABRV supports equal voting weight. Governance coordinates treasury decisions. The DAO and Treasury Module convert approved decisions into transparent on-chain distributions.

The protocol does not determine what participants should support.

It provides a framework through which participants may decide together.
