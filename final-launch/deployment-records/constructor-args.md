# constructor-args.md

## Purpose

This document records the exact constructor arguments used during the final LaborCoin deployment.

The objective is complete deployment reproducibility and verification.

All constructor arguments should be documented before deployment and verified after deployment.

---

# Deployment Environment

Repository Commit Hash:

```text
0fa98aa098057689db8479c323dd69ef4a86d880
```

Deployment Tag:

```text
v1.0-final-launch
```

Deployment Date:

```text
Jun-25-2026
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



---

# Contract 3: LaborCoinTreasuryModuleV1

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

Deployment Order: 3
```
---

# Contract 4: LaborCoinGovernanceV13

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
constructor(
    address _dao,
    address _labrv,
    address _verifier,
    address _treasuryModule,
    address _registration
)
```

Constructor Arguments:

| Parameter       | Type    | Value                                      |
| --------------- | ------- | ------------------------------------------ |
| _dao            | address | 0x0C2e5679153593b82a84eAB5CA90895BB291Cec4 |
| _labrv          | address | 0x833242E933c675846D8f8982048FecA95B8e435A |
| _verifier       | address | 0x475d519631d2406753aCA29F305f19b83E97513e |
| _treasuryModule | address | 0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C |
| _registration   | address | 0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C |

Raw Constructor Arguments:

```text
_dao = 0x0C2e5679153593b82a84eAB5CA90895BB291Cec4

_labrv = 0x833242E933c675846D8f8982048FecA95B8e435A

_verifier = 0x475d519631d2406753aCA29F305f19b83E97513e

_treasuryModule = 0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C

_registration = 0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C
```

Encoded Constructor Arguments:

```text
0000000000000000000000000c2e5679153593b82a84eab5ca90895bb291cec4
000000000000000000000000833242e933c675846d8f8982048feca95b8e435a
000000000000000000000000475d519631d2406753aca29f305f19b83e97513e
00000000000000000000000010f2798ef055950b897af4b3a8ae90de34f6c56c
000000000000000000000000d1cd6c0b6f1f709a52908b40c07d3c54649e323c
```

Contract Address:

```text
0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c
```

Deployment Transaction:

```text
0xabd669c27e4bc94471241d433432e8c66375d258a0a6fa5413772d2aef0fbc6e
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

The contract is permanently connected to the deployed Aragon DAO treasury, LABRV governance token, RegistrationV4 contract, TreasuryModuleV1 contract, and verifier address through immutable constructor parameters.

Governance activation requires a minimum of 50 registered participants before proposal execution is permitted.

Proposal duration is fixed at 14 days.

Successful proposals may only be executed during the 7 day execution window following vote completion.

Proposal approval requires at least 25% participation from registered members and at least 67% affirmative voting support.

Treasury distributions are limited to a maximum of 5% of the DAO treasury balance at execution time.

Replay protection is implemented through signature validation, nonce tracking, and signature expiry enforcement.

The contract contains no owner privileges, no upgrade mechanism, no administrative override capability, and no post-deployment parameter modification functions.

Deployment Order: 4
```

---

# Contract 5: LaborCoinExchangeV4

Contract Name:

```text
LaborCoinExchangeV4
```

Source File:

```text
final-launch/contracts/LaborCoinExchangeV4.sol
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
0x4Cf18cB39203B678f5C26f2338a10a79f9684749
```

Deployment Transaction:

```text
0xa5d1b14cd13c6aeaf7408878e4dddde141908dab12e27022ee565f5d207025fc
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

Implements the final LaborCoin bonding curve exchange with tranche unlocking, buy and sell functionality, wallet and transaction limits, DAO treasury funding, cooldown enforcement, and oracle-based POL pricing.

Verification Method:
Solidity Standard JSON Input

Deployment Order: 5
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

LaborCoinExchangeV4 Verified:

```text
YES
```

LaborCoinTreasuryModuleV1 Verified:

```text
YES
```

LaborCoinGoverneanceV13 Verified:

```text
YES
```

All Constructor Arguments Archived:

```text
YES
```

All Verification Records Archived:

```text
YES
```

Final Deployment Complete:

```text
YES
```

Verified By:

```text
The LaborCoin Creator
```

Verification Date:

```text
2026-06-25
```
