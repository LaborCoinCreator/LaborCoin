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

## Chainlink POL/USD Feed

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

Contract Address:

0x833242E933c675846D8f8982048FecA95B8e435A

Deployment Transaction:

0x83f241f7c3d3442d9a4a1d56c38d3354fb1803a5bb3bae05c6e22c547a143db7

Timestamp:

Jun-16-2026 08:22:48 AM +UTC

Block Number:

88595455

Deployment Wallet:

0x015b6D0990E56D908c876474C6A30eBa2b8A0CFB

Verification Status:

Verified

Verification Date:

Jun-16-2026

Explorer:

Polygonscan

Contract URL:

https://polygonscan.com/address/0x833242E933c675846D8f8982048FecA95B8e435A#code

Constructor Arguments:

None

Compiler Version:

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

Verification Method:

Solidity Standard JSON Input

Notes:

Successfully verified on Polygonscan using Standard JSON Input. No constructor arguments required.

---

## LaborCoinRegistrationV4

Contract Address:

0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C

Deployment Transaction:

0xbe8c2a8cc7f9322a36b9a6a1726d7f830531b601941f17324bffe1b995bc10fe

Timestamp:

Jun-22-2026

Block Number:

88997813

Deployment Wallet:

0x015b6D0990E56D908c876474C6A30eBa2b8A0CFB

Verification Status:

Verified

Verification Date:

Jun-22-2026

Explorer:

Polygonscan

Contract URL:

https://polygonscan.com/address/0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C#code

Constructor Arguments:

_labr:
0x460DD873A1D2a41e77410B125cD3027C5FEd2f78

_labrv:
0x833242E933c675846D8f8982048FecA95B8e435A

_verifier:
0x475d519631d2406753aCA29F305f19b83E97513e

Compiler Version:

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

Verification Method:

Solidity Standard JSON Input

Notes:

Successfully verified on Polygonscan using Standard JSON Input. Registration requires a valid verifier signature, an unexpired signature timestamp, and a minimum balance of 1 LABR. Mints one non-transferable LABRV governance token to eligible participants who do not already hold LABRV.

LABRV V7 Minter Set

Contract:
0x833242E933c675846D8f8982048FecA95B8e435A

New Minter:
0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C

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

Testing Contract Dust:

Old Exchange V2 retired with 0.0002534 LABR unrecovered dust balance.
No admin withdrawal function available. Further recovery attempts not justified.

Recovered:
0.50361236 LABR

Remaining:
0.0002534 LABR

Successful dust-clearing tx:
0x45f2e3c0f56b9cd3b66de9817f5643445f7b5e5903e89af2e0882b1b837c8dbf

DAO treasury received:
0.6572 POL

---

# Post-Deployment Configuration

## LaborVoteV7

Registration Contract Assigned As Minter: True

Transaction Hash: 0x7768e6344a44b53b371c753c81379dcbfcc9abd96342a3d37fb6e324de69b074

Timestamp: Jun-23-2026 09:03:38 AM +UTC

---

## LaborVoteV7

Minter Locked: True

Transaction Hash: 0x30bad6d15a7aed4ec7ae8e30423ac10efe679f36549bb5f7fb81fa5baf42e6a4

Timestamp: Jun-23-2026 09:45:32 AM +UTC

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
