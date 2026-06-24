# Final Release Record

This document records the definitive source code release used for LaborCoin final launch deployment.

---

## Release Information

Project:

LaborCoin

Release Name:

Final Launch

Release Tag:

Git Commit Hash:

Release Date:

Prepared By:

---

## Build Environment

Solidity Compiler:

0.8.30

EVM Version:

Prague

Optimizer:

Enabled

Optimizer Runs:

200

OpenZeppelin Version:

5.6.1

License:

MIT

---

## Source Repository

Repository URL:

Primary Branch:

Release Tag:

Commit Hash:

Commit URL:

---

## Contract Source File Hashes

Record SHA256 hashes of the exact source files deployed.

### LaborCoin.sol

SHA256:

File Size:

Notes:

---

### LaborVoteV7.sol

SHA256:
aa2c75d1a4ecd36cb8544e9890dfc4c4804bfe65359feb693e912eb5630545a1

File Size:
1520 bytes

Notes:
Final production deployment.

Network: Polygon Mainnet
Contract Address: 0x833242E933c675846D8f8982048FecA95B8e435A
Deployment Transaction: 0x83f241f7c3d3442d9a4a1d56c38d3354fb1803a5bb3bae05c6e22c547a143db7
Block Number: 88595455
Deployment Order: 1

Compiler: Solidity 0.8.30
EVM Version: Prague
Optimizer: Enabled (200 runs)
OpenZeppelin: 5.6.1
License: MIT

Verification Status: Verified
Verification Method: Solidity Standard JSON Input
Constructor Arguments: None

Notes:
LaborVoteV7 is the final LABRV governance token contract. It is non-transferable and uses a controlled minter role intended to be assigned to LaborCoinRegistrationV4. After successful registration testing, the minter should be locked and ownership renounced through the LABRV lock process.

---

### LaborCoinRegistrationV4.sol

SHA256:
1350c96ba556beb4804e3d084accc586b9727955681f41133ee4bfd5eaf8df13

File Size:
5706 bytes

Notes:
Final production deployment.

Network: Polygon Mainnet
Contract Address: 0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C
Deployment Transaction: 0xbe8c2a8cc7f9322a36b9a6a1726d7f830531b601941f17324bffe1b995bc10fe
Block Number: 88997813
Deployment Order: 2

Compiler: Solidity 0.8.30
EVM Version: Prague
Optimizer: Enabled (200 runs)
OpenZeppelin: 5.6.1
License: MIT

Verification Status: Verified
Verification Method: Solidity Standard JSON Input

Constructor Arguments:
_labr: 0x460DD873A1D2a41e77410B125cD3027C5FEd2f78
_labrv: 0x833242E933c675846D8f8982048FecA95B8e435A
_verifier: 0x475d519631d2406753aCA29F305f19b83E97513e

Notes:
LaborCoinRegistrationV4 is the final registration contract for verified DAO participation. Registration requires a minimum balance of 1 LABR, a valid verifier signature, and an unexpired signature timestamp. The contract records sequential member numbers, stores registration timestamps, increments totalMembers, and mints one LABRV governance token to eligible participants who do not already hold LABRV.

---

### LaborCoinExchangeV3.sol

SHA256:
82de27c817cf45c4e8a07c87c163aacae7ade1f4a21e76701958aa61ca8a80ff

File Size:
5899 bytes

Notes:
Final production deployment.

Network: Polygon Mainnet

Contract Address:
0xE57ba76AED1B7B4142E3DfaBd6cf3E94970b86eA

Deployment Transaction:
0x7eafc77c8e5a0e5f2d2c6f83f2cd1fd4e104f963dca1c0325e2b93d563c9d876

Block Number:
89043429

Deployment Order:
3

Compiler:
Solidity 0.8.30

EVM Version:
Prague

Optimizer:
Enabled (200 runs)

OpenZeppelin:
5.6.1

License:
MIT

Verification Status:
Verified

Verification Method:
Automatic Exact Match Verification (Sourcify / PolygonScan Metadata Match)

Constructor Arguments:

_labr:
0x460DD873A1D2a41e77410B125cD3027C5FEd2f78

_daoTreasury:
0x0C2e5679153593b82a84eAB5CA90895BB291Cec4

Notes:

LaborCoinExchangeV3 is the final production exchange contract implementing the LaborCoin bonding curve distribution system. The contract uses the Chainlink POL/USD oracle (0xAB594600376Ec9fD91F8e885dADF0CE036862dE0) to calculate POL-denominated prices from the USD bonding curve formula.

The exchange begins with an initial unlocked tranche of 100,000,000 LABR and automatically unlocks additional 50,000,000 LABR tranches as distribution milestones are reached. Pricing follows the quadratic bonding curve defined in the LaborCoin whitepaper.

The contract enforces a 12-hour cooldown between transactions, distributes 10% of buy volume directly to the DAO treasury, and uses OpenZeppelin ReentrancyGuard protections for buy and sell operations.

This deployment replaces LaborCoinExchangeV2.

Exchange V2 Retirement Record:

Retired Exchange:
0xD0692ec758bb852421B702B187b6439f74f8Bf3b

Recovered:
0.50361236 LABR

Remaining Dust:
0.0002534 LABR

Dust Recovery Transaction:
0x45f2e3c0f56b9cd3b66de9817f5643445f7b5e5903e89af2e0882b1b837c8dbf

DAO Treasury Received:
0.6572 POL

No administrative withdrawal function existed on Exchange V2. The remaining dust balance was deemed economically insignificant and retained as a retired contract balance.

---

### LaborCoinTreasuryModuleV1.sol

SHA256:
a6c8ceb4b1b20cc048fc2615ff447f5cc7a274028e835b7c99e1efe6fba35be2

File Size:
2151 bytes

Notes:
Final production deployment.

Network: Polygon Mainnet

Contract Address:
0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C

Deployment Transaction:
0x6817331673fa3d178b78c9a7d4499a36a28913728767c870ffce5c2bb9a84cb8

Block Number:
89052358

Deployment Order:
4

Compiler:
Solidity 0.8.30

EVM Version:
Prague

Optimizer:
Enabled (200 runs)

OpenZeppelin:
None

License:
MIT

Verification Status:
Verified

Verification Method:
Solidity Standard JSON Input

Constructor Arguments:

_dao:
0x0C2e5679153593b82a84eAB5CA90895BB291Cec4

Notes:

LaborCoinTreasuryModuleV1 is the final production treasury transfer module. The contract is controlled only by the configured DAO address and has no owner, no upgrade path, no admin withdrawal function, and no arbitrary external control mechanism.

The DAO address is immutable and fixed at deployment. Only the DAO may call executeTransfer. Transfer amounts are determined by the POL value sent with the DAO call.

The contract records cumulative distributed POL through totalDistributed and emits TransferExecuted events for transparency.

---

### LaborCoinGovernanceV13.sol

SHA256:
8e0feaa4567833d6d3af4ffde6bd00ca19e2aebfad3bee67a1ea1be611b5efc7

File Size:
13241 bytes

Notes:
Final production deployment.

Network: Polygon Mainnet

Contract Address:
0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c

Deployment Transaction:
0xabd669c27e4bc94471241d433432e8c66375d258a0a6fa5413772d2aef0fbc6e

Block Number:
89084762

Deployment Order:
5

Compiler:
Solidity 0.8.30

EVM Version:
Prague

Optimizer:
Enabled (200 runs)

OpenZeppelin:
5.6.1

License:
MIT

Verification Status:
Verified

Verification Method:
Automatic Exact Match Verification (Sourcify / PolygonScan Metadata Match)

Constructor Arguments:

_dao:
0x0C2e5679153593b82a84eAB5CA90895BB291Cec4

_labrv:
0x833242E933c675846D8f8982048FecA95B8e435A

_verifier:
0x475d519631d2406753aCA29F305f19b83E97513e

_treasuryModule:
0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C

_registration:
0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C

Notes:

LaborCoinGovernanceV13 is the final production governance contract responsible for proposal creation, voting, proposal execution authorization, and treasury distribution control.

The contract integrates with the Aragon DAO treasury, LaborVoteV7 governance token, LaborCoinRegistrationV4 membership registry, verifier signature system, and LaborCoinTreasuryModuleV1 distribution module.

Governance activation requires a minimum of 50 registered participants before treasury proposals may be executed. Proposals require a 25% participation quorum and a 67% approval threshold. Voting remains open for 14 days followed by a 7-day execution window.

Treasury distributions are limited to 5% of the DAO treasury balance at execution time. Proposal execution uses the Aragon DAO execute(Action[]) permission framework and routes approved transfers through LaborCoinTreasuryModuleV1.

The contract includes verifier-signed identity validation, proposal eligibility checks, execution-window enforcement, treasury-cap validation, and registration-based governance participation controls.

This deployment represents the final immutable governance implementation for LaborCoin treasury allocation and democratic treasury management.

---

## Deployment Artifacts

Record hashes of exported deployment artifacts if retained.

### LaborCoin

Artifact SHA256:

Metadata SHA256:

---

### LaborVoteV7

Artifact File:
final-launch/artifacts/LaborVoteV7/LaborVoteV7.json

Artifact SHA256:
79e9d402a794cca2a854a9eebadcd81f729723008deac10cee5a8b501114d9f5

Metadata File:
final-launch/artifacts/LaborVoteV7/LaborVoteV7_metadata.json

Metadata SHA256:
569952c8ae4f91093b6efdc16ecc3c80c6f59eaf8d7beabc32587a3e884a8add

---

### LaborCoinRegistrationV4

Artifact File:
final-launch/artifacts/LaborCoinRegistrationV4/LaborCoinRegistrationV4.json

Artifact SHA256:
999b2c57f169c36c51df4513ca9274cde54148829dcd248b015aa690674dc0de

Metadata File:
final-launch/artifacts/LaborCoinRegistrationV4/LaborCoinRegistrationV4_metadata.json

Metadata SHA256:
bf6ecded77da8917df464fffd6d05140744b559d4ca9d98773ad52ff88f47ad6

---

### LaborCoinExchangeV3

Artifact File:
final-launch/artifacts/LaborCoinExchangeV3/LaborCoinExchangeV3.json

Artifact SHA256:
c5a14ec17c224fc1fbede89ec2e76b68b435647df12501ffa11c0efea80dd6e2

Metadata File:
final-launch/artifacts/LaborCoinExchangeV3/LaborCoinExchangeV3_metadata.json

Metadata SHA256:
5efedb64d0bbbd479e1764873729c3bf39a7099a01ab93974ab6ff72b6bde60a

---

### LaborCoinTreasuryModuleV1

Artifact File:
final-launch/artifacts/LaborCoinTreasuryModuleV1/LaborCoinTreasuryModuleV1.json

Artifact SHA256:
58bf825f038b1bcaa6af357d069db7f041e5027783c2028b0fca9d9e350e2f0b

Metadata File:
final-launch/artifacts/LaborCoinTreasuryModuleV1/LaborCoinTreasuryModuleV1_metadata.json

Metadata SHA256:
8ecf1120c38671706264c859bb7d31aaf912ff40a5d149a3b9e2a3053da7f90a

---

### LaborCoinGovernanceV13

Artifact File:
final-launch/artifacts/LaborCoinGovernanceV13/LaborCoinGovernanceV13.json

Artifact SHA256:
64d0db4ed7c277a950501c7cd4bf915b2746376f25ce14fc274ecd95c5ddaf1a

Metadata File:
final-launch/artifacts/LaborCoinGovernanceV13/LaborCoinGovernanceV13_metadata.json

Metadata SHA256:
c54a360099be00947b24f5ade7b186062f0f8d7356052fa32e5c9568816b15c0

---

## Verification Summary

LaborCoin:

Verified:
Yes

Verification URL:
https://polygonscan.com/address/0x460DD873A1D2a41e77410B125cD3027C5FEd2f78#code

---

LaborVoteV7:

Verified:
Yes

Verification URL:
https://polygonscan.com/address/0x833242E933c675846D8f8982048FecA95B8e435A#code

---

LaborCoinRegistrationV4:

Verified:
Yes

Verification URL:
https://polygonscan.com/address/0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C#code

---

LaborCoinExchangeV3:

Verified:
Yes

Verification URL:
https://polygonscan.com/address/0xE57ba76AED1B7B4142E3DfaBd6cf3E94970b86eA#code

---

LaborCoinTreasuryModuleV1:

Verified:
Yes

Verification URL:
https://polygonscan.com/address/0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C#code

---

LaborCoinGovernanceV13:

Verified:
Yes

Verification URL:
https://polygonscan.com/address/0x8238105d31f6bb26897d8ab270a0a521fef03e8c#code

---

## Deployment Summary

Network: Polygon (POL)

Chain ID: 137

Deployment Wallet: 0x015b6D0990E56D908c876474C6A30eBa2b8A0CFB

Deployment Date:
Jun-24-2026

Total Contracts Deployed:
5

All Contracts Verified:
Yes

Frontend Updated:
Yes

Final Testing Completed:
Yes

---

## Final Integrity Statement

The contracts, artifacts, deployment records, constructor arguments, verification records, and source hashes contained in this release record constitute the authoritative LaborCoin Final Launch deployment package.

Any future deployment, audit, verification, or historical review should reference this document alongside:

* deployment-manifest.md
* deployments.md
* verification.md
* constructor-args.md
* build-environment.md

to reproduce the final deployed system.
