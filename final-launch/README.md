# LaborCoin Final Launch Package

**Network:** Polygon Mainnet
**Chain ID:** 137
**Release:** Final Launch
**Status:** Production Deployment Complete

This directory contains the authoritative source, build, deployment, verification, configuration, and release records for the final production deployment of the LaborCoin protocol.

The package preserves the exact information required to identify, verify, review, and historically reproduce the deployed system.

It is intended to support:

* Independent source and bytecode verification
* Security review and auditing
* Deployment reproducibility
* Constructor-argument verification
* Historical preservation
* Contract relationship review
* Ownership and authority verification
* Long-term protocol transparency

The records in this directory should be treated as the canonical reference for the final Polygon Mainnet deployment.

---

## Final Production System

The final LaborCoin deployment consists of:

| Component          | Production Version           |
| ------------------ | ---------------------------- |
| Economic Token     | LABR Token                   |
| Governance Token   | LaborVote V7                 |
| Registration       | LaborCoin Registration V4    |
| Treasury Execution | LaborCoin Treasury Module V1 |
| Governance         | LaborCoin Governance V13     |
| Exchange           | LaborCoin Exchange V4        |
| Treasury Custody   | Aragon DAO Treasury          |

The custom production contracts were deployed as immutable or autonomous infrastructure with narrowly defined authority boundaries.

The LABR token was deployed separately before the final custom-contract deployment sequence and uses a different compiler environment.

---

# Build Environments

LaborCoin uses two distinct production build profiles:

1. The externally generated LABR token build
2. The custom LaborCoin final-launch contract build

These profiles must not be treated as interchangeable.

---

## LABR Token Build Profile

LABR was generated and deployed through the 20LABS Token Generator before the custom final-launch contracts.

| Setting                         | Value                                        |
| ------------------------------- | -------------------------------------------- |
| Contract                        | LABR Token                                   |
| Address                         | `0x460DD873A1D2a41e77410B125cD3027C5FEd2f78` |
| Deployment Source               | 20LABS Token Generator                       |
| Solidity Compiler               | `0.8.25`                                     |
| EVM Version                     | `Paris`                                      |
| Optimizer                       | Enabled                                      |
| Optimizer Runs                  | `200`                                        |
| Verification Method             | Solidity Standard JSON Input                 |
| Verification Result             | Exact Match                                  |
| License Recorded on Polygonscan | No License                                   |

The LABR build environment differs from the build environment used for the custom LaborCoin contracts.

The LABR token should not be recompiled using Solidity 0.8.30 or the Prague EVM configuration when attempting to reproduce or verify its deployed bytecode.

---

## Custom Final-Launch Contract Build Profile

The following contracts were compiled using the final custom-contract build environment:

* LaborVoteV7
* LaborCoinRegistrationV4
* LaborCoinTreasuryModuleV1
* LaborCoinGovernanceV13
* LaborCoinExchangeV4

| Setting                 | Value                     |
| ----------------------- | ------------------------- |
| Solidity Compiler       | `0.8.30`                  |
| Compiler Build          | `v0.8.30+commit.73712a01` |
| EVM Version             | `Prague`                  |
| Optimizer               | Enabled                   |
| Optimizer Runs          | `200`                     |
| Via IR                  | `False`                   |
| Development Environment | Remix IDE `2.4.1`         |
| Network                 | Polygon Mainnet           |
| Chain ID                | `137`                     |
| License                 | MIT                       |

### OpenZeppelin Dependencies

| Contract                  | OpenZeppelin Version |
| ------------------------- | -------------------- |
| LaborVoteV7               | `5.6.1`              |
| LaborCoinRegistrationV4   | `5.6.1`              |
| LaborCoinGovernanceV13    | `5.6.1`              |
| LaborCoinExchangeV4       | `5.6.1`              |
| LaborCoinTreasuryModuleV1 | None                 |

LaborCoinTreasuryModuleV1 does not import OpenZeppelin contracts.

Any change to compiler version, EVM target, optimizer settings, optimizer runs, Via IR setting, source code, imports, or constructor arguments may produce different deployed bytecode.

---

# Directory Structure

```text
final-launch/
├── README.md
│
├── contracts/
│   ├── LaborVoteV7.sol
│   ├── LaborCoinRegistrationV4.sol
│   ├── LaborCoinTreasuryModuleV1.sol
│   ├── LaborCoinGovernanceV13.sol
│   ├── LaborCoinExchangeV4.sol
│   └── contract-map.md
│
├── deployment-records/
│   ├── README.md
│   ├── deployment-manifest.md
│   ├── build-environment.md
│   ├── constructor-args.md
│   ├── deployments.md
│   ├── verification.md
│   └── release-record.md
│
├── artifacts/
│   ├── LaborVoteV7/
│   ├── LaborCoinRegistrationV4/
│   ├── LaborCoinTreasuryModuleV1/
│   ├── LaborCoinGovernanceV13/
│   └── LaborCoinExchangeV4/
│
└── test-results/
    └── Final deployment and functional validation records
```

Directory names should be adjusted only where the repository structure differs from this documented layout.

---

# Directory Contents

## `contracts/`

Contains the exact custom source files associated with the final Polygon Mainnet deployment.

These files represent archival production source.

They are not upgrade modules and should not be modified in place when documenting the final release.

The LABR token was generated externally through 20LABS and is documented as an external pre-existing production contract rather than as one of the custom final-launch source deployments.

---

## `deployment-records/`

Contains the records required to identify and independently review the final deployment.

### `deployment-manifest.md`

Records the release identity, deployment environment, deployment sequence, network, operator, and system-level deployment information.

### `build-environment.md`

Records the exact compiler, EVM, optimizer, dependency, Remix, and network configuration used for the custom final-launch contracts.

It also distinguishes the LABR token build from the custom contract build.

### `constructor-args.md`

Records:

* Constructor signatures
* Raw constructor values
* Encoded constructor arguments
* Deployment transactions
* Contract addresses
* Verification status

### `deployments.md`

Records:

* Contract addresses
* Deployment transactions
* Deployment blocks
* Deployment timestamps
* Deployment wallet
* Verification status
* Post-deployment configuration
* Functional validation results
* Historical exchange retirement information

### `verification.md`

Records:

* Verification status
* Verification date
* Compiler settings
* EVM settings
* Optimizer settings
* OpenZeppelin versions
* Constructor arguments
* Polygonscan verification links
* Verification methods

### `release-record.md`

Records:

* Final source hashes
* File sizes
* Artifact hashes
* Metadata hashes
* Release integrity information
* Final production contract references

---

## `artifacts/`

Contains exported compiler artifacts and metadata associated with the final deployment.

Archived files may include:

* Contract ABIs
* Bytecode
* Deployed bytecode
* Compiler input
* Compiler output
* Metadata JSON
* Remix artifacts
* Verification artifacts

Artifact and metadata hashes are recorded in `release-record.md`.

---

## `test-results/`

Contains final validation records where maintained separately from the deployment record.

Validation may include:

* Registration testing
* Signature-expiration testing
* Replay-protection testing
* LABRV mint testing
* Exchange buy testing
* Exchange sell testing
* Governance proposal testing
* Governance voting testing
* Treasury execution testing
* Access-control testing
* Multi-wallet testing

The authoritative status of each completed validation should be taken from the final deployment and validation records rather than inferred from the existence of a test-results directory.

---

# Final Deployed Contracts

| Contract           | Address                                                                                                                    |    Block | Deployment Date (UTC)        | Verification |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------- | -------: | ---------------------------- | ------------ |
| LABR Token         | [`0x460DD873A1D2a41e77410B125cD3027C5FEd2f78`](https://polygonscan.com/address/0x460DD873A1D2a41e77410B125cD3027C5FEd2f78) | 69797383 | Apr-02-2025 07:56:25 AM +UTC | Verified     |
| LaborVote V7       | [`0x833242E933c675846D8f8982048FecA95B8e435A`](https://polygonscan.com/address/0x833242E933c675846D8f8982048FecA95B8e435A) | 88595455 | Jun-16-2026 08:22:48 AM +UTC | Verified     |
| Registration V4    | [`0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C`](https://polygonscan.com/address/0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C) | 88997813 | Jun-22-2026                  | Verified     |
| Treasury Module V1 | [`0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C`](https://polygonscan.com/address/0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C) | 89052358 | Jun-24-2026                  | Verified     |
| Governance V13     | [`0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c`](https://polygonscan.com/address/0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c) | 89084762 | Jun-24-2026 08:15:38 PM +UTC | Verified     |
| Exchange V4        | [`0x4Cf18cB39203B678f5C26f2338a10a79f9684749`](https://polygonscan.com/address/0x4Cf18cB39203B678f5C26f2338a10a79f9684749) | 89115657 | Jun-25-2026 09:08:01 AM +UTC | Verified     |

---

# External System References

## Aragon DAO Treasury

```text
0x0C2e5679153593b82a84eAB5CA90895BB291Cec4
```

Purpose:

* Treasury custody
* DAO permission enforcement
* Approved action execution

---

## Verifier Address

```text
0x475d519631d2406753aCA29F305f19b83E97513e
```

Purpose:

* Passport eligibility verification
* Registration authorization signatures
* Governance authorization signatures

The verifier is an externally controlled signing address and is not a smart contract.

---

## Chainlink POL/USD Feed

```text
0xAB594600376Ec9fD91F8e885dADF0CE036862dE0
```

Purpose:

* POL/USD price discovery
* Conversion of USD-denominated bonding curve prices into POL
* Exchange pricing

This feed is external Chainlink infrastructure and is not deployed or controlled by LaborCoin.

---

# Actual Final Deployment Sequence

The final production sequence should be understood from the actual completed deployments rather than from an earlier planned deployment order.

## 1. Deploy and Verify LaborVoteV7

* Deploy LaborVoteV7
* Verify source code
* Confirm compiler and EVM settings
* Archive deployment transaction and block

## 2. Deploy and Verify LaborCoinRegistrationV4

* Deploy Registration V4 with LABR, LABRV, and verifier addresses
* Verify source code and constructor arguments
* Test registration behavior

## 3. Configure and Permanently Lock LABRV

* Assign Registration V4 as LABRV minter
* Validate LABRV minting through registration
* Permanently lock the minter
* Renounce LABRV ownership
* Archive configuration transactions

## 4. Deploy and Verify LaborCoinTreasuryModuleV1

* Deploy the module with the Aragon DAO address
* Verify the immutable DAO constructor value
* Confirm DAO-only execution behavior
* Archive source and metadata

## 5. Deploy and Verify LaborCoinGovernanceV13

* Deploy Governance V13 with the final DAO, LABRV, verifier, Treasury Module, and Registration addresses
* Verify constructor arguments
* Confirm governance and treasury execution behavior
* Archive artifacts and metadata

## 6. Deploy and Verify LaborCoinExchangeV4

Exchange V4 was deployed last.

The exchange followed the other final-launch contracts because a final exchange redeployment was required.

* Deploy Exchange V4 with the LABR and DAO treasury addresses
* Verify source and constructor arguments
* Confirm Chainlink POL/USD integration
* Test purchases and sales
* Confirm treasury routing
* Update the frontend to the final Exchange V4 address
* Retire the superseded exchange deployment

## 7. Complete Final Integration

* Update all frontend contract addresses
* Update documentation and contract registries
* Validate production integrations
* Archive final deployment records
* Archive artifacts and source hashes
* Publish the final deployment package

---

# Exchange Redeployment Note

The final production exchange is:

```text
LaborCoinExchangeV4
0x4Cf18cB39203B678f5C26f2338a10a79f9684749
```

It was deployed on June 25, 2026, after the Treasury Module and Governance V13 deployments.

Earlier exchange deployments are historical and must not be used as production addresses.

The retirement record for the superseded Exchange V2 address is preserved in the deployment and verification documentation.

Any documentation, frontend integration, audit, or historical review should identify Exchange V4 as the final production exchange.

---

# Verification Policy

Every production contract is expected to have the following information archived:

* Source file
* Contract address
* Deployment transaction
* Deployment block
* Deployment timestamp
* Compiler version
* EVM version
* Optimizer setting
* Optimizer runs
* OpenZeppelin version, where applicable
* Constructor arguments
* Encoded constructor arguments
* Verification method
* Verification result
* Explorer link

The verification record should clearly distinguish between:

### LABR Token

* Solidity `0.8.25`
* EVM `Paris`
* 20LABS-generated source
* No License recorded
* Separate build profile

### Custom LaborCoin Contracts

* Solidity `0.8.30`
* EVM `Prague`
* Optimizer enabled with 200 runs
* Via IR disabled
* MIT license
* OpenZeppelin `5.6.1` where imported
* Remix IDE `2.4.1`

---

# Reproduction Requirements

To reproduce a custom final-launch contract build accurately, use:

```text
Compiler: Solidity 0.8.30
Compiler Build: v0.8.30+commit.73712a01
EVM Version: Prague
Optimizer: Enabled
Optimizer Runs: 200
Via IR: False
OpenZeppelin: 5.6.1 where imported
```

Then use the exact source files and constructor arguments archived in this package.

Do not use the custom contract build profile when attempting to reproduce LABR.

To reproduce the LABR deployment build, use its separately documented 20LABS source and compiler profile:

```text
Compiler: Solidity 0.8.25
EVM Version: Paris
Optimizer: Enabled
Optimizer Runs: 200
```

Even minor changes to source formatting, dependency versions, metadata, compiler settings, or constructor arguments may produce different bytecode or prevent exact-match verification.

---

# Final Launch Objectives

The final deployment package exists to preserve evidence that the production protocol was deployed according to its documented architecture.

The package supports the following objectives:

* Publicly verifiable contract identities
* Transparent authority relationships
* Exact build-environment preservation
* Reproducible source verification
* Immutable deployment history
* Archived ownership and minter configuration
* Independent security review
* Long-term historical integrity

---

# Authority and Immutability Summary

| Component           | Final Status                                    |
| ------------------- | ----------------------------------------------- |
| LABR Token          | DAO Controlled                                  |
| LaborVote V7        | Ownership Renounced / Minter Permanently Locked |
| Registration V4     | Autonomous                                      |
| Treasury Module V1  | Autonomous / Fixed DAO Only                     |
| Governance V13      | Autonomous                                      |
| Exchange V4         | Autonomous                                      |
| Aragon DAO Treasury | Governed through DAO permissions                |

The custom production contracts contain no upgrade framework.

Governance remains limited to treasury allocation and does not possess authority to rewrite the fixed protocol rules.

---

# Source of Truth

The following records collectively constitute the authoritative final-launch record:

* `deployment-manifest.md`
* `build-environment.md`
* `constructor-args.md`
* `deployments.md`
* `verification.md`
* `release-record.md`
* Final production contract source files
* Exported artifacts and metadata
* Polygonscan deployment and verification records

Where an older planning document conflicts with a completed deployment record, the final on-chain deployment data and completed verification records take precedence.

The authoritative production exchange is Exchange V4, deployed last on June 25, 2026.

---

# Preservation Policy

These records should not be rewritten to reflect hypothetical future deployments.

Corrections may be made to:

* Typographical errors
* Missing links
* Incorrect formatting
* Incomplete archival metadata
* Demonstrably inaccurate historical statements

Corrections should not obscure:

* Superseded deployments
* Redeployment history
* Deployment chronology
* Compiler differences
* Verification methods
* Ownership transitions
* Final production addresses

Historical transparency is part of the purpose of this package.

---

# Final Status

The LaborCoin final-launch package records a completed Polygon Mainnet production deployment.

The package documents:

* Final custom contract source
* Separate LABR and custom-contract build environments
* Final contract addresses
* Actual deployment chronology
* Exchange V4 redeployment
* Constructor arguments
* Source verification
* Ownership and minter configuration
* Release hashes
* Exported artifacts
* Functional validation records

Any future audit, verification effort, historical review, or independent reproduction attempt should begin with this directory and the associated on-chain records.
