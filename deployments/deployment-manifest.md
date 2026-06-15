# LaborCoin Final Launch Deployment Manifest

## Purpose

This document defines the canonical deployment configuration for the final LaborCoin launch.

The goal is complete reproducibility, transparency, auditability, and long-term verification.

No deployment should occur unless all settings in this document are finalized and committed to the repository.

---

# Repository Commit

Git Commit Hash:

```text
TO BE FILLED AT DEPLOYMENT
```

Deployment Tag:

```text
v1.0-final-launch
```

Deployment Date:

```text
TO BE FILLED AT DEPLOYMENT
```

---

# Network

Network:

```text
Polygon Mainnet
```

Chain ID:

```text
137
```

RPC Provider:

```text
TO BE FILLED
```

---

# Compiler Configuration

Solidity Version:

```text
0.8.20
```

EVM Version:

```text
paris
```

Optimizer Enabled:

```text
true
```

Optimizer Runs:

```text
200
```

Via IR:

```text
false
```

Metadata Hash:

```text
ipfs
```

License Identifier:

```text
MIT
```

---

# OpenZeppelin Dependencies

OpenZeppelin Contracts Version:

```text
TO BE FINALIZED
```

Recommended:

```text
5.0.2
```

All contracts must compile against the exact same OpenZeppelin release.

No mixed OpenZeppelin versions are permitted.

---

# Final Launch Contracts

## Contract 1

Name:

```text
LaborVote
```

Purpose:

```text
Soulbound governance token used for DAO voting.
```

Deployment Order:

```text
1
```

Contract Address:

```text
TO BE FILLED
```

Deployment Transaction:

```text
TO BE FILLED
```

Block Number:

```text
TO BE FILLED
```

Verification Status:

```text
TO BE FILLED
```

Constructor Arguments:

```text
TO BE FILLED
```

---

## Contract 2

Name:

```text
LaborCoinRegistrationV3
```

Purpose:

```text
Membership registration and LABRV mint authorization.
```

Deployment Order:

```text
2
```

Contract Address:

```text
TO BE FILLED
```

Deployment Transaction:

```text
TO BE FILLED
```

Block Number:

```text
TO BE FILLED
```

Verification Status:

```text
TO BE FILLED
```

Constructor Arguments:

```text
TO BE FILLED
```

---

## Contract 3

Name:

```text
LaborCoinExchangeV2
```

Purpose:

```text
Primary LABR exchange and treasury contract.
```

Deployment Order:

```text
3
```

Contract Address:

```text
TO BE FILLED
```

Deployment Transaction:

```text
TO BE FILLED
```

Block Number:

```text
TO BE FILLED
```

Verification Status:

```text
TO BE FILLED
```

Constructor Arguments:

```text
TO BE FILLED
```

---

# External Dependencies

## LABR Token

Contract Address:

```text
TO BE FILLED
```

Verification Status:

```text
TO BE FILLED
```

---

## Chainlink POL/USD Feed

Contract Address:

```text
TO BE FILLED
```

Verification Status:

```text
Verified
```

---

# Verification Procedure

Immediately after deployment:

1. Verify contract source.
2. Verify constructor arguments.
3. Verify compiler version.
4. Verify optimizer settings.
5. Verify OpenZeppelin dependency version.
6. Confirm exact source matches GitHub commit.

Verification must be completed before proceeding to the next deployment step.

---

# Deployment Sequence

1. Freeze source code.
2. Commit source to GitHub.
3. Tag repository release.
4. Archive compiler settings.
5. Deploy LaborVote.
6. Verify LaborVote.
7. Deploy Registration.
8. Verify Registration.
9. Configure Registration permissions.
10. Deploy Exchange.
11. Verify Exchange.
12. Configure Exchange permissions.
13. Update frontend addresses.
14. Conduct final functional testing.
15. Archive deployment records.
16. Prepare ownership transfer process.

---

# Required Archived Records

The following must be committed to GitHub and retained permanently.

## contracts/

```text
LaborVote.sol
LaborCoinRegistrationV3.sol
LaborCoinExchangeV2.sol
```

## artifacts/

```text
ABI files
Compilation artifacts
Metadata files
```

## deployment-records/

```text
deployment-manifest.md
compiler-settings.md
constructor-args.md
deployments.md
verification.md
ownership-transfer.md
```

---

# Required Deployment Metadata

For every deployed contract record:

* Contract Name
* Contract Address
* Deployment Transaction Hash
* Block Number
* Timestamp
* Compiler Version
* EVM Version
* Optimizer Enabled
* Optimizer Runs
* OpenZeppelin Version
* Constructor Arguments
* Verification Status
* Verifier URL
* Source Commit Hash

---

# Launch Integrity Rule

No contract source modifications may occur after deployment begins.

If any contract source changes:

1. Stop deployment.
2. Create a new repository commit.
3. Update deployment manifest.
4. Restart deployment process from the beginning.

This ensures every deployed contract can be reproduced from a single immutable source revision.

---

# Final Launch Objective

LaborCoin final launch should produce:

* Fully verified contracts
* Fully reproducible deployments
* Complete public source availability
* Complete deployment records
* Complete ownership transfer records

Any third party should be able to independently reproduce the deployment environment and verify every deployed contract from the archived records.
