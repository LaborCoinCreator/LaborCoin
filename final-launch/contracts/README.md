# LaborCoin Smart Contracts

**Network:** Polygon Mainnet
**Chain ID:** 137
**Release:** Final Launch
**Status:** Production Deployment Complete

This directory contains the custom production smart contracts used by the LaborCoin protocol.

LaborCoin combines a deterministic bonding curve exchange, a transferable economic token, Sybil-resistant participant registration, a non-transferable governance token, constrained treasury governance, and DAO-controlled treasury execution into a unified system for transparent collective resource allocation.

The final custom contracts have been deployed to Polygon Mainnet, publicly source verified on Polygonscan, and archived with their constructor arguments, compiler settings, deployment records, artifacts, metadata, and source hashes.

The production architecture is designed to minimize privileged authority while preserving transparent governance over treasury distributions.

---

## Contents

The final custom contract set consists of:

| Source File                     | Production Contract | Role                                                      |
| ------------------------------- | ------------------- | --------------------------------------------------------- |
| `LaborVoteV7.sol`               | LaborVote V7        | Non-transferable LABRV governance token                   |
| `LaborCoinRegistrationV4.sol`   | Registration V4     | Governance eligibility and LABRV issuance                 |
| `LaborCoinTreasuryModuleV1.sol` | Treasury Module V1  | DAO-authorized POL distribution                           |
| `LaborCoinGovernanceV13.sol`    | Governance V13      | Proposals, voting, and execution authorization            |
| `LaborCoinExchangeV4.sol`       | Exchange V4         | LABR distribution, purchases, sales, and treasury funding |

The LABR token is a separately deployed production dependency. It was generated through the 20LABS Token Generator before the custom final-launch contract sequence and uses a different compiler environment.

---

# Architecture

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
                         LaborVote V7 (LABRV)
                                   │
                                   ▼
                          Governance V13
                                   │
                          Approved Action
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

The architecture separates five responsibilities:

| Layer                 | Components                              | Responsibility                                                     |
| --------------------- | --------------------------------------- | ------------------------------------------------------------------ |
| Economic              | LABR and Exchange V4                    | Distribution, pricing, liquidity, and treasury funding             |
| Eligibility           | Passport, verifier, and Registration V4 | Governance eligibility and duplicate-participation resistance      |
| Governance Credential | LaborVote V7                            | Equal, non-transferable governance weight                          |
| Governance            | Governance V13                          | Proposal creation, voting, validation, and execution authorization |
| Treasury              | Aragon DAO and Treasury Module V1       | Asset custody and approved POL distribution                        |

This division limits authority concentration and makes each component easier to inspect independently.

---

# Production Contract Registry

| Contract           | Address                                                                                                                    |    Block | Deployment Date (UTC)        | Verification | Final Authority State                           |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------- | -------: | ---------------------------- | ------------ | ----------------------------------------------- |
| LABR Token         | [`0x460DD873A1D2a41e77410B125cD3027C5FEd2f78`](https://polygonscan.com/address/0x460DD873A1D2a41e77410B125cD3027C5FEd2f78) | 69797383 | Apr-02-2025 07:56:25 AM +UTC | Verified     | DAO Controlled                                  |
| LaborVote V7       | [`0x833242E933c675846D8f8982048FecA95B8e435A`](https://polygonscan.com/address/0x833242E933c675846D8f8982048FecA95B8e435A) | 88595455 | Jun-16-2026 08:22:48 AM +UTC | Verified     | Ownership Renounced / Minter Permanently Locked |
| Registration V4    | [`0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C`](https://polygonscan.com/address/0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C) | 88997813 | Jun-22-2026                  | Verified     | Autonomous                                      |
| Treasury Module V1 | [`0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C`](https://polygonscan.com/address/0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C) | 89052358 | Jun-24-2026                  | Verified     | Autonomous / Fixed DAO Only                     |
| Governance V13     | [`0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c`](https://polygonscan.com/address/0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c) | 89084762 | Jun-24-2026 08:15:38 PM +UTC | Verified     | Autonomous                                      |
| Exchange V4        | [`0x4Cf18cB39203B678f5C26f2338a10a79f9684749`](https://polygonscan.com/address/0x4Cf18cB39203B678f5C26f2338a10a79f9684749) | 89115657 | Jun-25-2026 09:08:01 AM +UTC | Verified     | Autonomous                                      |

Exchange V4 was the final custom contract deployed after a required exchange redeployment. It is the authoritative production exchange and replaces Exchange V2.

Historical exchange addresses must not be used for current integrations.

---

# External System References

The following addresses are part of the deployed architecture but are not custom contracts contained in this directory.

| Reference              | Address                                                                                                                    | Purpose                                              |
| ---------------------- | -------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| Aragon DAO Treasury    | [`0x0C2e5679153593b82a84eAB5CA90895BB291Cec4`](https://polygonscan.com/address/0x0C2e5679153593b82a84eAB5CA90895BB291Cec4) | Treasury custody and DAO action execution            |
| Verifier Address       | [`0x475d519631d2406753aCA29F305f19b83E97513e`](https://polygonscan.com/address/0x475d519631d2406753aCA29F305f19b83E97513e) | Registration and governance authorization signatures |
| Chainlink POL/USD Feed | [`0xAB594600376Ec9fD91F8e885dADF0CE036862dE0`](https://polygonscan.com/address/0xAB594600376Ec9fD91F8e885dADF0CE036862dE0) | USD-to-POL bonding curve price conversion            |

The verifier is an externally controlled signing address, not a smart contract.

The Chainlink feed is external infrastructure and is not deployed, owned, or controlled by LaborCoin.

---

# Build Environments

The LABR token and the custom LaborCoin contracts use separate production build profiles.

These environments must not be treated as interchangeable when reproducing or verifying deployed bytecode.

## LABR Token

LABR was generated and deployed through the 20LABS Token Generator.

| Setting             | Value                        |
| ------------------- | ---------------------------- |
| Solidity Compiler   | `0.8.25`                     |
| EVM Version         | `Paris`                      |
| Optimizer           | Enabled                      |
| Optimizer Runs      | `200`                        |
| Generator           | 20LABS Token Generator       |
| Verification Method | Solidity Standard JSON Input |
| Polygonscan Result  | Exact Match                  |
| License Recorded    | No License                   |

LABR should not be recompiled with the custom-contract Solidity 0.8.30 and Prague profile when attempting to reproduce its deployed bytecode.

## Custom Final-Launch Contracts

The five custom contracts in this directory use the following production build environment:

| Setting                 | Value                     |
| ----------------------- | ------------------------- |
| Solidity Compiler       | `0.8.30`                  |
| Compiler Build          | `v0.8.30+commit.73712a01` |
| EVM Version             | `Prague`                  |
| Optimizer               | Enabled                   |
| Optimizer Runs          | `200`                     |
| Via IR                  | `False`                   |
| Development Environment | Remix IDE `2.4.1`         |
| License                 | MIT                       |
| OpenZeppelin Version    | `5.6.1` where imported    |

### Dependency Summary

| Contract           | OpenZeppelin |
| ------------------ | ------------ |
| LaborVote V7       | `5.6.1`      |
| Registration V4    | `5.6.1`      |
| Governance V13     | `5.6.1`      |
| Exchange V4        | `5.6.1`      |
| Treasury Module V1 | None         |

Any change to source code, compiler version, dependency version, optimizer settings, EVM target, Via IR setting, metadata, or constructor arguments may produce different bytecode.

---

# Contract Components

## Economic Layer

### LABR Token

LABR is the transferable economic token of the LaborCoin ecosystem.

It supports:

* Economic participation
* Exchange purchases and sales
* Governance registration eligibility
* Treasury funding through token-level taxation
* POL dividend distribution
* Transfers subject to token-level controls

LABR ownership does not directly confer governance rights.

Holding additional LABR does not produce additional LABRV and does not increase governance voting weight.

### LABR Configuration

| Parameter                 |              Value |
| ------------------------- | -----------------: |
| Total Supply              | 1,000,000,000 LABR |
| Maximum Token Wallet      |     1,000,000 LABR |
| Maximum Token Transaction |       500,000 LABR |
| Sell Treasury Tax         |                 5% |
| Sell Dividend Tax         |                 5% |
| Burn Tax                  |                 0% |
| Total Sell Tax            |                10% |

The 12-hour exchange cooldown is enforced by Exchange V4. Token-level transfer and trading controls are separately implemented in LABR.

---

### LaborCoin Exchange V4

Exchange V4 is the protocol-native LABR distribution and liquidity contract.

It supports:

* LABR purchases using POL
* LABR sales for POL
* Deterministic bonding curve pricing
* Chainlink POL/USD conversion
* Automatic supply tranche unlocking
* Automatic DAO treasury funding
* Exchange liquidity retention
* Contract-enforced wallet limits
* Contract-enforced transaction limits
* Buy and sell slippage protection

#### Economic Parameters

| Parameter                      |               Value |
| ------------------------------ | ------------------: |
| Maximum Curve Supply           |  1,000,000,000 LABR |
| Initial Unlocked Supply        |    100,000,000 LABR |
| Additional Tranche             |     50,000,000 LABR |
| Minimum Target Price           |                  $1 |
| Maximum Target Price           |                 $15 |
| Buy Treasury Allocation        | 10% of incoming POL |
| Exchange Wallet Limit          |         10,000 LABR |
| Exchange Transaction Limit     |          5,000 LABR |
| Cooldown                       |            12 Hours |
| Oracle Freshness Window        |          30 Minutes |
| Maximum Oracle-Protected Price |    100 POL per LABR |

#### Bonding Curve

The target USD price is calculated as:

```text
P(x) = 1 + 14x²
```

where:

```text
x = total LABR distributed through the exchange / 1,000,000,000
```

The USD target price is converted into POL using the Chainlink POL/USD feed.

#### Purchase Flow

A purchase:

1. Reads the current curve price.
2. Converts that price into POL.
3. Calculates expected LABR output.
4. Enforces the exchange transaction limit.
5. Enforces the resulting exchange wallet limit.
6. Confirms sufficient unlocked supply.
7. Confirms sufficient LABR inventory.
8. Transfers LABR to the buyer.
9. Enforces `minTokensOut`.
10. Updates total distributed supply.
11. Evaluates tranche unlocking.
12. Sends 10% of incoming POL to the DAO treasury.
13. Retains the remaining POL as exchange liquidity.

#### Sale Flow

A sale:

1. Confirms the seller does not exceed the exchange wallet limit.
2. Enforces the exchange transaction limit.
3. Reads the current curve price.
4. Transfers LABR from the seller.
5. Measures the amount actually received after token-level behavior.
6. Calculates the POL payout.
7. Enforces `minPOL`.
8. Confirms sufficient exchange POL liquidity.
9. Reduces distributed-supply accounting.
10. Sends POL to the seller.

Exchange liquidity is finite. Sales remain subject to the exchange's available POL balance and all other contract conditions.

#### Exchange Security

Exchange V4 includes:

* OpenZeppelin `ReentrancyGuard`
* Safe low-level token transfer wrappers
* Positive oracle-value validation
* Oracle freshness enforcement
* Oracle anomaly protection
* Buy slippage protection
* Sell slippage protection
* Supply availability checks
* Liquidity availability checks
* Wallet and transaction limits
* A 12-hour cooldown

Exchange V4 contains:

* No owner
* No administrator
* No pause function
* No upgrade mechanism
* No administrative withdrawal function
* No ownership transfer function
* No post-deployment parameter setters

POL held by Exchange V4 is permanently dedicated to exchange operations and eligible seller payouts.

---

# Registration Layer

## LaborCoin Registration V4

Registration V4 is the on-chain gateway to governance participation.

The Passport score is evaluated through the external verifier workflow. Registration V4 does not independently query or calculate a Passport score.

Instead, the contract validates a signed authorization produced after the external eligibility check.

Registration V4:

* Verifies that the participant holds at least 1 LABR
* Validates the designated verifier signature
* Rejects expired authorizations
* Prevents repeat registration
* Rejects participants who already hold LABRV
* Records registration timestamps
* Assigns sequential member numbers
* Increments `totalMembers`
* Mints one LABRV to an eligible participant

### Registration Requirements

| Requirement                  | Value      |
| ---------------------------- | ---------- |
| Minimum LABR Balance         | 1 LABR     |
| Gitcoin Passport Threshold   | 15         |
| Valid Verifier Authorization | Required   |
| Unexpired Authorization      | Required   |
| Existing LABRV               | Prohibited |
| Repeat Registration          | Prohibited |
| LABRV Issued                 | 1          |

The Passport threshold is enforced operationally through the verifier service. The deployed registration contract enforces the signed authorization, expiration, LABR balance, and duplicate-participation conditions.

### Registration Dependencies

Registration V4 is permanently connected to:

| Dependency | Address                                      |
| ---------- | -------------------------------------------- |
| LABR       | `0x460DD873A1D2a41e77410B125cD3027C5FEd2f78` |
| LABRV      | `0x833242E933c675846D8f8982048FecA95B8e435A` |
| Verifier   | `0x475d519631d2406753aCA29F305f19b83E97513e` |

---

# Governance Layer

## LaborVote V7

LaborVote V7 is the non-transferable LABRV governance token.

LABRV serves only as a governance credential.

It is:

* Non-transferable
* Non-tradable
* Not available for purchase
* Issued only through Registration V4
* Limited to one per eligible registered participant
* Compatible with ERC20Votes governance accounting

The final LABRV authority state includes:

* Registration V4 assigned as the minter
* Minter configuration permanently locked
* Contract ownership renounced
* No ability to appoint another minter

This supports the protocol model of:

```text
one verified participant per LABRV
```

Additional LABR ownership does not create additional voting power.

---

## LaborCoin Governance V13

Governance V13 manages proposal creation, voting, proposal validation, and treasury execution authorization.

It is permanently connected to:

| Dependency         | Address                                      |
| ------------------ | -------------------------------------------- |
| Aragon DAO         | `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` |
| LABRV              | `0x833242E933c675846D8f8982048FecA95B8e435A` |
| Verifier           | `0x475d519631d2406753aCA29F305f19b83E97513e` |
| Treasury Module V1 | `0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C` |
| Registration V4    | `0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C` |

### Governance Parameters

| Parameter                                        |                                   Value |
| ------------------------------------------------ | --------------------------------------: |
| Minimum Registered Participants Before Execution |                                      50 |
| Voting Duration                                  |                                 14 Days |
| Participation Requirement                        |                                     25% |
| Approval Requirement                             |                                     67% |
| Execution Window                                 |                                  7 Days |
| Maximum Treasury Distribution                    | 5% of DAO treasury balance at execution |

### Governance Responsibilities

Governance V13:

* Creates treasury proposals
* Records votes
* Prevents duplicate voting
* Calculates participation
* Calculates approval support
* Enforces the minimum membership requirement
* Enforces the treasury distribution cap
* Enforces the execution window
* Prevents repeat execution
* Validates verifier-authorized actions
* Tracks per-wallet nonces
* Rejects expired signatures
* Constructs execution through the Aragon DAO action framework

### Constrained Authority

Governance may authorize treasury distributions.

Governance cannot change:

* LABR supply
* Token tax configuration
* Bonding curve pricing
* Exchange limits
* Exchange cooldown
* Tranche sizes
* Oracle address
* Registration minimum
* LABRV transferability
* Governance participation requirement
* Governance approval requirement
* Voting duration
* Execution window
* Treasury distribution cap

Governance V13 contains:

* No owner
* No upgrade mechanism
* No emergency override
* No administrative bypass
* No post-deployment parameter modification functions

---

## Aragon DAO Treasury

The Aragon DAO is the treasury custody and execution layer.

It is not an unrestricted administrator of the LaborCoin protocol.

The DAO:

* Holds protocol treasury assets
* Receives the Exchange V4 buy allocation
* Receives applicable LABR treasury taxes
* May receive voluntary contributions
* Enforces DAO permissions
* Executes authorized actions through `execute(Action[])`

Governance V13 authorizes eligible treasury actions. The DAO then executes the approved action through its permission framework.

The DAO does not control:

* Exchange pricing
* Exchange limits
* Registration rules
* LABRV issuance rules
* Governance thresholds
* Treasury proposal caps
* Other fixed custom-contract parameters

---

# Treasury Layer

## LaborCoin Treasury Module V1

Treasury Module V1 is a narrowly scoped POL transfer module.

The module does not independently custody the DAO treasury.

It:

* Accepts calls only from the configured Aragon DAO
* Receives POL supplied with an authorized DAO call
* Transfers that POL to the designated recipient
* Updates cumulative distributed POL
* Emits `TransferExecuted` events

### Fixed DAO

The DAO address was established during deployment:

```text
0x0C2e5679153593b82a84eAB5CA90895BB291Cec4
```

The address is immutable and cannot be replaced.

### Authority Restrictions

Treasury Module V1 contains:

* No owner
* No administrator
* No upgrade mechanism
* No administrative withdrawal function
* No arbitrary external execution function
* No mechanism to change the DAO address

Only the fixed DAO may call `executeTransfer()`.

The transfer amount is determined by the POL value supplied with the DAO call.

---

# Governance and Treasury Flow

```text
Registered Participant
          │
          ▼
   Create Proposal
          │
          ▼
  14-Day Voting Period
          │
          ├── Participation below 25% ──► Rejected
          │
          └── Participation at least 25%
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
                              ▼
                 Governance V13 Validation
                              │
                              ▼
                    Aragon DAO Execute
                              │
                              ▼
                  Treasury Module V1
                              │
                              ▼
                    Approved Recipient
```

Before execution, the proposal must also satisfy:

* At least 50 registered members
* The 5% treasury distribution cap
* Signature validity
* Nonce validity
* Execution-window validity
* Non-executed status
* DAO permission requirements

---

# Security Architecture

LaborCoin uses multiple independent controls rather than relying on a single protection.

## Economic Controls

* Fixed total LABR supply
* Progressive tranche availability
* Deterministic bonding curve
* Token-level wallet and transaction limits
* Exchange-level wallet and transaction limits
* Twelve-hour exchange cooldown
* Slippage protections
* Exchange liquidity checks

## Oracle Controls

* Chainlink POL/USD feed
* Positive price requirement
* Thirty-minute freshness requirement
* Maximum oracle-derived price protection

## Registration Controls

* Minimum LABR requirement
* Passport-assisted eligibility workflow
* Designated verifier signatures
* Signature expiration
* Duplicate-registration prevention
* Existing-LABRV prevention

## Governance Controls

* Non-transferable LABRV
* One LABRV per eligible participant
* Verifier-authorized proposal and voting actions
* Per-wallet nonces
* Signature expiration
* Minimum membership activation
* Participation requirement
* Supermajority approval
* Treasury distribution cap
* Execution window
* Repeat-execution prevention

## Treasury Controls

* Custody in the Aragon DAO
* DAO permission enforcement
* Fixed DAO address in Treasury Module V1
* DAO-only transfer execution
* No module owner
* No module upgrade path
* Public execution events
* Cumulative distribution tracking

## Administrative Controls

* LABRV ownership renounced
* LABRV minter permanently locked
* No owner in Exchange V4
* No owner in Governance V13
* No owner in Treasury Module V1
* No upgrade framework in the custom production contracts
* No unrestricted governance authority over protocol parameters

---

# Authority Summary

| Component          | Authority Model                                        |
| ------------------ | ------------------------------------------------------ |
| LABR               | Ownership held through the DAO-controlled structure    |
| Exchange V4        | No owner or administrative control path                |
| Registration V4    | Fixed production logic and dependencies                |
| LaborVote V7       | Ownership renounced; minter locked to Registration V4  |
| Governance V13     | No owner, upgrade path, override, or parameter setters |
| Aragon DAO         | Treasury custody and authorized action execution       |
| Treasury Module V1 | Fixed DAO-only POL transfer execution                  |

The production model does not replace creator control with unlimited governance control.

Governance remains limited to treasury allocation, while the custom contracts enforce the fixed operating rules.

---

# Verification and Source Integrity

Every production contract listed in this README is publicly source verified.

The final-launch records preserve:

* Exact source files
* Source SHA-256 hashes
* Compiler settings
* Dependency versions
* Constructor arguments
* Encoded constructor arguments
* Deployment transactions
* Deployment blocks
* Verification methods
* Verification links
* Compiler artifacts
* Metadata files
* Artifact and metadata hashes
* LABRV minter configuration transactions
* Ownership-renouncement records
* Historical exchange retirement records

Public source verification improves transparency and enables independent review. It should not be represented as a substitute for a separately published professional security audit.

---

# Historical Exchange Note

The final production exchange is:

```text
LaborCoinExchangeV4
0x4Cf18cB39203B678f5C26f2338a10a79f9684749
```

Exchange V4 was deployed last on June 25, 2026, following a required exchange redeployment.

It replaces the retired Exchange V2 deployment:

```text
0xD0692ec758bb852421B702B187b6439f74f8Bf3b
```

Historical exchange addresses are retained only for transparency and must not be used by the current frontend, documentation, or integrations.

---

# Documentation

## Protocol Documentation

* [`/docs/whitepaper.md`](../docs/whitepaper.md)
  Full technical specification, tokenomics, governance, security model, and risk analysis.

* [`/docs/redpaper.md`](../docs/redpaper.md)
  Project mission, philosophy, and long-term objective.

* [`/docs/architecture.md`](../docs/architecture.md)
  Component relationships and system architecture.

* [`/docs/governance.md`](../docs/governance.md)
  Proposal, voting, approval, and execution rules.

## Contract Documentation

* [`/contracts-docs`](../contracts-docs/)
  Individual contract descriptions and technical references.

## Final Launch Records

* [`/final-launch/deployment-records`](../deployment-records/)
  Deployment, verification, constructor, compiler, and release records.

* [`/final-launch/artifacts`](../artifacts/)
  Exported compiler artifacts and metadata.

* [`contract-map.md`](contract-map.md)
  Production contract dependency and authority map.

Paths may be adjusted where this README is stored at a different repository depth.

---

# Working With These Contracts

The source files in this directory correspond to the deployed final production contracts.

They should be treated as archival production source.

Modifying a local source file:

* Does not alter the deployed contract
* Does not upgrade the protocol
* Does not change the production bytecode
* May prevent exact-match reproduction
* Should not be represented as a modification to the existing production system

To reproduce a custom contract build, use the exact source, dependencies, compiler profile, and constructor arguments preserved in the final-launch records.

---

# Risks and Limitations

The production contracts remain subject to risks including:

* Undiscovered smart contract defects
* Immutable implementation errors
* Polygon network disruption
* Chainlink feed failure or unavailability
* Verifier compromise or unavailability
* Passport workflow changes
* Governance coordination failure
* Low participation
* Treasury misallocation
* Exchange liquidity constraints
* Regulatory uncertainty

The protocol provides transparent infrastructure. It cannot guarantee participation, liquidity, treasury growth, effective governance, or successful real-world outcomes.

---

# License

The custom production contracts are released under the MIT License.

The externally generated LABR source and third-party dependencies may contain their own license declarations or explorer metadata.

See the repository-level `LICENSE` file and the individual source headers for applicable terms.
