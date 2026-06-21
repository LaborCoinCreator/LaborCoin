# LaborCoin Final Launch Deployment Record

This document serves as the authoritative deployment manifest and deployment record for the LaborCoin final launch.

It defines the deployment environment, deployment sequence, deployed contract metadata, verification status, and post-deployment validation results.

---

# Release Information

Release Name:

Final Launch

Release Tag:

Git Commit Hash:

Deployment Date:

Deployment Operator:

---

# Network

Network:

Polygon Mainnet

Chain ID:

137

RPC Provider:

Polygon Mainnet (via MetaMask)

Deployment Wallet:

0x015b6D0990E56D908c876474C6A30eBa2b8A0CFB

---

# Build Environment

Solidity Version:

0.8.30

EVM Version:

Prague

Optimizer:

Enabled

Optimizer Runs:

200

Via IR:

False

License:

MIT

OpenZeppelin Version:

5.6.1

---

# External Dependencies

## LABR Token

Deployment Source:

20LABS Token Generator

Contract Address:

0x460DD873A1D2a41e77410B125cD3027C5FEd2f78

Notes:

LABR was generated and deployed through the 20LABS platform prior to the final launch contract deployment process documented in this repository.

---

### Chainlink POL/USD Feed

Contract Address:

0xAB594600376Ec9fD91F8e885dADF0CE036862dE0

Verification Status:

Verified

Notes:

Chainlink POL/USD Price Feed used by LaborCoinExchangeV3 for USD-denominated bonding curve pricing.

Network: Polygon Mainnet

Feed Type: POL/USD

Provider: Chainlink

Usage:
Converts USD bonding curve prices into POL amounts during LABR purchases and sales.

Integration:
Referenced as an immutable constructor parameter within LaborCoinExchangeV3.

Verification:
Official Chainlink price feed contract verified on Polygonscan.

Explorer:
https://polygonscan.com/address/0xAB594600376Ec9fD91F8e885dADF0CE036862dE0

Notes:
This contract is an external dependency and is not deployed, owned, or controlled by LaborCoin. The address was selected as the canonical Chainlink POL/USD feed available on Polygon Mainnet at the time of deployment.

---

# Deployment Sequence

1. Deploy LaborVoteV7
2. Verify LaborVoteV7
3. Deploy LaborCoinRegistrationV4
4. Verify LaborCoinRegistrationV4
5. Configure Registration as LABRV minter
6. Lock LABRV minter
7. Verify ownership renounced
8. Deploy LaborCoinTreasuryModuleV1
9. Verify LaborCoinTreasuryModuleV1
10. Deploy LaborCoinGovernanceV13
11. Verify LaborCoinGovernanceV13
12. Deploy LaborCoinExchangeV3
13. Verify LaborCoinExchangeV3
14. Update frontend addresses
15. Conduct final testing
16. Archive deployment artifacts and records

---

# Contract Deployments

## LaborVoteV7

Contract Address: 0x833242E933c675846D8f8982048FecA95B8e435A

Deployment Transaction:
0x83f241f7c3d3442d9a4a1d56c38d3354fb1803a5bb3bae05c6e22c547a143db7

Timestamp: Jun-16-2026 08:22:48 AM +UTC

Block Number: 88595455

Verification Status: Verified

Verification Date: Jun-16-2026

Explorer: Polygonscan

Contract URL:
https://polygonscan.com/address/0x833242E933c675846D8f8982048FecA95B8e435A#code

Constructor Arguments: None

Compiler Version: 0.8.30

EVM Version: Prague

Optimizer: Enabled

Optimizer Runs: 200

OpenZeppelin Version: 5.6.1

License: MIT

Verification Method: Solidity Standard JSON Input

Notes:
Successfully verified using Standard JSON Input. No constructor arguments.

---

## LaborCoinRegistrationV4

Contract Address:

Deployment Transaction:

Block Number:

Timestamp:

Verification Status:

Verification URL:

Constructor Arguments:

LABR:

LABRV:

Verifier:

Notes:

---

## LaborCoinTreasuryModuleV1

Contract Address:

Deployment Transaction:

Block Number:

Timestamp:

Verification Status:

Verification URL:

Constructor Arguments:

DAO:

Notes:

---

## LaborCoinGovernanceV13

Contract Address:

Deployment Transaction:

Block Number:

Timestamp:

Verification Status:

Verification URL:

Constructor Arguments:

Notes:

---

## LaborCoinExchangeV3

Contract Address:

Deployment Transaction:

Block Number:

Timestamp:

Verification Status:

Verification URL:

Constructor Arguments:

LABR:

DAO Treasury:

Notes:

---

# Post-Deployment Configuration

## LaborVoteV7

Registration Contract Assigned As Minter:

Transaction Hash:

Timestamp:

---

## LaborVoteV7

Minter Locked:

Transaction Hash:

Timestamp:

---

# Verification Checklist

* [ ] LaborVoteV7 verified
* [ ] LaborCoinRegistrationV4 verified
* [ ] LaborCoinTreasuryModuleV1 verified
* [ ] LaborCoinGovernanceV13 verified
* [ ] LaborCoinExchangeV3 verified
* [ ] Verification links archived
* [ ] Constructor arguments archived

---

# Functional Validation

* [ ] Registration test successful
* [ ] Replay protection test successful
* [ ] LABRV mint test successful
* [ ] Governance proposal test successful
* [ ] Governance vote test successful
* [ ] Treasury execution test successful
* [ ] Exchange buy test successful
* [ ] Exchange sell test successful
* [ ] Multi-wallet test successful

---

# Archived Artifacts

* [ ] LaborVoteV7.json
* [ ] LaborCoinRegistrationV4.json
* [ ] LaborCoinTreasuryModuleV1.json
* [ ] LaborCoinGovernanceV13.json
* [ ] LaborCoinExchangeV3.json

Metadata Files Archived:

* [ ] Yes
* [ ] No

Artifact Location:

final-launch/artifacts/

---

# Final Launch Certification

All contracts were deployed from the source code associated with the Git commit recorded in this document.

All contracts were compiled using the build environment documented in build-environment.md.

All contract addresses, deployment transactions, verification records, and constructor arguments have been archived.

Final Launch Approved:

Date:

Signature / Maintainer:
