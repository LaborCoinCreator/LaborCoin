# constructor-args.md

## Purpose

This document records the exact constructor arguments used during the final LaborCoin deployment.

The objective is complete deployment reproducibility and verification.

All constructor arguments should be documented before deployment and verified after deployment.

---

# Deployment Environment

Repository Commit Hash:

```text
TO BE FILLED
```

Deployment Tag:

```text
v1.0-final-launch
```

Deployment Date:

```text
TO BE FILLED
```

Network:

```text
Polygon Mainnet
```

---

# Contract 1: LaborVoteV7

Contract Name:

```text
LaborVoteV7
```

Source File:

```text
final-launch/contracts/LaborVoteV7.sol
```

Deployment Order:

```text
1
```

Constructor Signature:

```solidity
constructor()
```

Constructor Arguments:

| Parameter | Type | Value |
| --------- | ---- | ----- |
| None      | N/A  | N/A   |

Raw Constructor Arguments:

```text
None
```

Encoded Constructor Arguments:

```text
None
```

Contract Address:

```text
0x833242E933c675846D8f8982048FecA95B8e435A
```

Deployment Transaction:

```text
0x83f241f7c3d3442d9a4a1d56c38d3354fb1803a5bb3bae05c6e22c547a143db7
```

Verification Status:

```text
Verified
```

Notes:

```text
Network: Polygon Mainnet

Verification Method: Solidity Standard JSON Input

Compiler Version: 0.8.30

EVM Version: Prague

Optimizer: Enabled

Optimizer Runs: 200

OpenZeppelin Version: 5.6.1

License: MIT

Contract successfully verified on Polygonscan using Standard JSON Input. No constructor arguments were required. Contract deployed as the initial contract in the final LaborCoin deployment sequence.
```

---

# Contract 2: LaborCoinRegistrationV4

Contract Name:

```text
LaborCoinRegistrationV4
```

Source File:

```text
final-launch/contracts/LaborCoinRegistrationV4.sol
```

Deployment Order:

```text
2
```

Constructor Signature:

```solidity
constructor(
    address _labr,
    address _labrv,
    address _verifier
)
```

Constructor Arguments:

| Parameter | Type    | Value                                      |
| --------- | ------- | ------------------------------------------ |
| _labr     | address | 0x460DD873A1D2a41e77410B125cD3027C5FEd2f78 |
| _labrv    | address | 0x833242E933c675846D8f8982048FecA95B8e435A |
| _verifier | address | 0x475d519631d2406753aCA29F305f19b83E97513e |

Raw Constructor Arguments:

```text
_labr = 0x460DD873A1D2a41e77410B125cD3027C5FEd2f78

_labrv = 0x833242E933c675846D8f8982048FecA95B8e435A

_verifier = 0x475d519631d2406753aCA29F305f19b83E97513e
```

Encoded Constructor Arguments:

```text
000000000000000000000000460dd873a1d2a41e77410b125cd3027c5fed2f78
000000000000000000000000833242e933c675846d8f8982048feca95b8e435a
000000000000000000000000475d519631d2406753aca29f305f19b83e97513e
```

Contract Address:

```text
0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C
```

Deployment Transaction:

```text
0xbe8c2a8cc7f9322a36b9a6a1726d7f830531b601941f17324bffe1b995bc10fe
```

Verification Status:

```text
Verified
```

Notes:

```text
Final production deployment.

Network: Polygon Mainnet

Compiler: Solidity 0.8.30

EVM Version: Prague

Optimizer: Enabled (200 runs)

OpenZeppelin Version: 5.6.1

License: MIT

Verification Method: Solidity Standard JSON Input

Registration requires a valid verifier signature, an unexpired signature timestamp, and a minimum balance of 1 LABR.

The contract records registration timestamps, assigns sequential member numbers, tracks totalMembers, and mints one LABRV governance token to eligible participants who do not already hold LABRV.
```

---

# Contract 3: LaborCoinExchangeV3

Contract Name:

```text
LaborCoinExchangeV3
```

Source File:

```text
final-launch/contracts/LaborCoinExchangeV3.sol
```

Deployment Order:

```text
3
```

Constructor Signature:

```solidity
constructor(
    address _labr,
    address _daoTreasury
)
```

Constructor Arguments:

| Parameter    | Type    | Value                                      |
| ------------ | ------- | ------------------------------------------ |
| _labr        | address | 0x460DD873A1D2a41e77410B125cD3027C5FEd2f78 |
| _daoTreasury | address | 0x0C2e5679153593b82a84eAB5CA90895BB291Cec4 |

Raw Constructor Arguments:

```text
_labr = 0x460DD873A1D2a41e77410B125cD3027C5FEd2f78

_daoTreasury = 0x0C2e5679153593b82a84eAB5CA90895BB291Cec4
```

Encoded Constructor Arguments:

```text
000000000000000000000000460dd873a1d2a41e77410b125cd3027c5fed2f780000000000000000000000000c2e5679153593b82a84eab5ca90895bb291cec4
```

Contract Address:

```text
0xE57ba76AED1B7B4142E3DfaBd6cf3E94970b86eA
```

Deployment Transaction:

```text
0x7eafc77c8e5a0e5f2d2c6f83f2cd1fd4e104f963dca1c0325e2b93d563c9d876
```

Verification Status:

```text
Verified
```

Notes:

```text
Final production deployment.

Successfully verified on Polygonscan as an Exact Match.

Compiler Version: 0.8.30
EVM Version: Prague
Optimizer: Enabled (200 runs)
OpenZeppelin Version: 5.6.1
License: MIT

Chainlink POL/USD Oracle:
0xAB594600376Ec9fD91F8e885dADF0CE036862dE0

Implements the final LaborCoin bonding curve exchange with tranche unlocking, buy and sell functionality, DAO treasury funding, cooldown enforcement, and oracle-based POL pricing.

Verification Method:
Automatic Exact Match Verification (Sourcify / PolygonScan Metadata Match)

Deployment Order: 3
```

---

# Contract 4: LaborCoinTreasuryModuleV1

Contract Name:

```text
LaborCoinTreasuryModuleV1
```

Source File:

```text
final-launch/contracts/LaborCoinTreasuryModuleV1.sol
```

Deployment Order:

```text
4
```

Constructor Signature:

```solidity
constructor(
    address _dao
)
```

Constructor Arguments:

| Parameter | Type    | Value                                      |
| --------- | ------- | ------------------------------------------ |
| _dao      | address | 0x0C2e5679153593b82a84eAB5CA90895BB291Cec4 |

Raw Constructor Arguments:

```text
_dao = 0x0C2e5679153593b82a84eAB5CA90895BB291Cec4
```

Encoded Constructor Arguments:

```text
0000000000000000000000000c2e5679153593b82a84eab5ca90895bb291cec4
```

Contract Address:

```text
0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C
```

Deployment Transaction:

```text
0x6817331673fa3d178b78c9a7d4499a36a28913728767c870ffce5c2bb9a84cb8
```

Verification Status:

```text
Verified
```

Notes:

```text
Final production deployment.

Successfully verified on Polygonscan using Solidity Standard JSON Input.

Compiler Version: 0.8.30
EVM Version: Prague
Optimizer: Enabled (200 runs)
OpenZeppelin Version: None
License: MIT

Constructor Argument:
_dao = 0x0C2e5679153593b82a84eAB5CA90895BB291Cec4

The DAO address is immutable and fixed at deployment.

The contract contains no owner, no upgrade mechanism, no admin withdrawal function, and no arbitrary external execution capability.

Only the configured DAO may execute transfers through executeTransfer(). Transfer amounts are determined by the POL value supplied with the DAO call.

Deployment Order: 4
```
---

# Contract 5: LaborCoinGovernanceV13

Contract Name:

```text
LaborCoinGovernanceV13
```

Source File:

```text
final-launch/contracts/LaborCoinGovernanceV13.sol
```

Deployment Order:

```text
5
```

Constructor Signature:

```solidity
TO BE FILLED
```

Constructor Arguments:

| Parameter    | Type         | Value        |
| ------------ | ------------ | ------------ |
| TO BE FILLED | TO BE FILLED | TO BE FILLED |

Raw Constructor Arguments:

```text
TO BE FILLED
```

Encoded Constructor Arguments:

```text
TO BE FILLED AFTER DEPLOYMENT
```

Contract Address:

```text
TO BE FILLED
```

Deployment Transaction:

```text
TO BE FILLED
```

Verification Status:

```text
TO BE FILLED
```

Notes:

```text
TO BE FILLED
```
---

# External Contract References

## LABR Token

Contract Address:

```text
0x460DD873A1D2a41e77410B125cD3027C5FEd2f78
```

Verification Status:

```text
Verified on Polygonscan
```

---

## Chainlink POL/USD Feed

Contract Address:

```text
0xAB594600376Ec9fD91F8e885dADF0CE036862dE0
```

Network:

```text
Polygon Mainnet
```

Verification Status:

```text
Verified
```

---

# Verification Checklist

For each deployed contract verify:

* Source file matches GitHub repository
* Compiler version matches deployment manifest
* EVM version matches deployment manifest
* Optimizer settings match deployment manifest
* OpenZeppelin version matches deployment manifest
* Constructor arguments match this document
* Verification succeeds without modification

---

# Final Verification Record

LaborVoteV7 Verified:

```text
YES
```

LaborCoinRegistrationV4 Verified:

```text
YES
```

LaborCoinExchangeV3 Verified:

```text
YES
```

LaborCoinTreasuryModuleV1 Verified:

```text
YES
```

LaborCoinGoverneanceV13 Verified:

```text
YES / NO
```

All Constructor Arguments Archived:

```text
YES / NO
```

All Verification Records Archived:

```text
YES / NO
```

Final Deployment Complete:

```text
YES / NO
```

Verified By:

```text
TO BE FILLED
```

Verification Date:

```text
TO BE FILLED
```
