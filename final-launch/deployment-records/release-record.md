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

File Size:

Notes:

---

### LaborCoinGovernanceV13.sol

SHA256:

File Size:

Notes:

---

### LaborCoinTreasuryModuleV1.sol

SHA256:

File Size:

Notes:

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

Artifact SHA256:

Metadata SHA256:

---

### LaborCoinExchangeV3

Artifact SHA256:

Metadata SHA256:

---

### LaborCoinGovernanceV13

Artifact SHA256:

Metadata SHA256:

---

### LaborCoinTreasuryModuleV1

Artifact SHA256:

Metadata SHA256:

---

## Verification Summary

LaborCoin:

Verified:

Verification URL:

---

LaborVoteV7:

Verified:

Verification URL:

---

LaborCoinRegistrationV4:

Verified:

Verification URL:

---

LaborCoinExchangeV3:

Verified:

Verification URL:

---

LaborCoinGovernanceV13:

Verified:

Verification URL:

---

LaborCoinTreasuryModuleV1:

Verified:

Verification URL:

---

## Deployment Summary

Network:

Chain ID:

Deployment Wallet:

Deployment Date:

Total Contracts Deployed:

All Contracts Verified:

Frontend Updated:

Final Testing Completed:

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
