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

LABRV V7 Minter Set

Contract:

0x833242E933c675846D8f8982048FecA95B8e435A

New Minter:

0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C

Minter Set Transaction:

0x7768e6344a44b53b371c753c81379dcbfcc9abd96342a3d37fb6e324de69b074

Minter Lock Transaction:

0x30bad6d15a7aed4ec7ae8e30423ac10efe679f36549bb5f7fb81fa5baf42e6a4

Ownership Status:

Renounced

Minter Locked:

True

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

LABR:
0x460DD873A1D2a41e77410B125cD3027C5FEd2f78

LABRV:
0x833242E933c675846D8f8982048FecA95B8e435A

Verifier:
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

Successfully verified on Polygonscan using Standard JSON Input. Registration requires a valid verifier signature, an unexpired signature timestamp, and a minimum balance of 1 LABR. Eligible participants receive one non-transferable LABRV governance token if they do not already hold LABRV.

---

## LaborCoinExchangeV4

Contract Address:

0x4Cf18cB39203B678f5C26f2338a10a79f9684749

Deployment Transaction:

0xa5d1b14cd13c6aeaf7408878e4dddde141908dab12e27022ee565f5d207025fc

Timestamp:

Jun-25-2026 09:08:01 AM +UTC

Block Number:

89115657

Deployment Wallet:

0x015b6D0990E56D908c876474C6A30eBa2b8A0CFB

Verification Status:

Verified

Verification Date:

Jun-25-2026

Explorer:

Polygonscan

Contract URL:

https://polygonscan.com/address/0x4Cf18cB39203B678f5C26f2338a10a79f9684749#code

Constructor Arguments:

LABR:
0x460DD873A1D2a41e77410B125cD3027C5FEd2f78

DAO Treasury:
0x0C2e5679153593b82a84eAB5CA90895BB291Cec4

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

Successfully verified on Polygonscan as an Exact Match.

Chainlink POL/USD Oracle:
0xAB594600376Ec9fD91F8e885dADF0CE036862dE0

Old Exchange V2 Retirement Record:

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

No administrative withdrawal function existed on Exchange V2. Remaining dust balance was deemed economically insignificant and retained as a retired contract balance.


---

## LaborCoinTreasuryModuleV1

Contract Address:

0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C

Deployment Transaction:

0x6817331673fa3d178b78c9a7d4499a36a28913728767c870ffce5c2bb9a84cb8

Timestamp:

Jun-24-2026

Block Number:

89052358

Deployment Wallet:

0x015b6D0990E56D908c876474C6A30eBa2b8A0CFB

Verification Status:

Verified

Verification Date:

Jun-24-2026

Verification Method:

Automatic verification via Remix / Sourcify metadata match

Explorer:

Polygonscan

Contract URL:

https://polygonscan.com/address/0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C#code

Constructor Arguments:

DAO:
0x0C2e5679153593b82a84eAB5CA90895BB291Cec4

Compiler Version:

0.8.30

EVM Version:

Prague

Optimizer:

Enabled

Optimizer Runs:

200

OpenZeppelin Version:

None

License:

MIT

Notes:

Deployment successful on Polygon Mainnet.

The treasury module is an immutable DAO-controlled transfer module. The DAO address is fixed at deployment and cannot be changed. The contract has no owner, no admin withdrawal function, no upgrade mechanism, and no arbitrary external control path.

The module allows only the configured DAO address to execute POL transfers through executeTransfer. Transfer amount is determined by the POL value sent with the DAO call. The module records cumulative distributed POL through totalDistributed and emits TransferExecuted events for transparency.

Sourcify and Blockscout verification were submitted from Remix. Polygonscan verification still requires final confirmation or manual verification.

---

## LaborCoinGovernanceV13

Contract Address:

0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c

Deployment Transaction:

0xabd669c27e4bc94471241d433432e8c66375d258a0a6fa5413772d2aef0fbc6e

Timestamp:

Jun-24-2026 08:15:38 PM +UTC

Block Number:

89084762

Deployment Wallet:

0x015b6D0990E56D908c876474C6A30eBa2b8A0CFB

Verification Status:

Verified

Verification Date:

Jun-24-2026

Explorer:

Polygonscan

Contract URL:

https://polygonscan.com/address/0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c#code

Constructor Arguments:

DAO:
0x0C2e5679153593b82a84eAB5CA90895BB291Cec4

LABRV:
0x833242E933c675846D8f8982048FecA95B8e435A

Verifier:
0x475d519631d2406753aCA29F305f19b83E97513e

Treasury Module:
0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C

Registration:
0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C

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

Automatic Polygonscan verification via Standard JSON Input metadata match

Notes:

Deployment successful on Polygon Mainnet.

LaborCoinGovernanceV13 is the final governance contract for the LaborCoin system. The contract manages proposal creation, voting, approval validation, and treasury execution authorization through the Aragon DAO treasury architecture.

The contract is permanently connected to the deployed Aragon DAO, LABRV governance token, RegistrationV4 contract, Treasury Module V1, and verifier address through immutable constructor parameters.

Governance activation requires a minimum of 50 registered participants before proposal execution is permitted. Proposal duration is fixed at 14 days and approved proposals may be executed only during the 7 day execution window following vote completion.

Proposal approval requires at least 25% participation from registered members and at least 67% affirmative voting support. Treasury distributions are limited to a maximum of 5% of the DAO treasury balance per proposal.

Replay protection is implemented through per-wallet nonces and signature expiry validation for both proposal creation and voting actions. Signature verification uses the designated verifier address established during deployment.

The contract includes reentrancy protection and contains no owner privileges, no administrative controls, no parameter modification functions, no upgrade mechanism, and no emergency override functionality after deployment.

Source code verification completed successfully on Polygonscan with Exact Match verification status.

The governance contract serves exclusively as a proposal, voting, and execution authorization layer. Treasury assets remain controlled by the Aragon DAO treasury architecture and are distributed only through approved governance actions.

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

* [x] LaborVoteV7 verified
* [x] LaborCoinRegistrationV4 verified
* [x] LaborCoinTreasuryModuleV1 verified
* [x] LaborCoinGovernanceV13 verified
* [x] LaborCoinExchangeV3 verified
* [x] Verification links archived
* [x] Constructor arguments archived

---

# Functional Validation

* [x] Registration test successful
* [x] Replay protection test successful
* [x] LABRV mint test successful
* [x] Governance proposal test successful
* [x] Governance vote test successful
* [x] Treasury execution test successful
* [x] Exchange buy test successful
* [x] Exchange sell test successful
* [ ] Multi-wallet test successful

---

# Archived Artifacts

* [x] LaborVoteV7.json
* [x] LaborCoinRegistrationV4.json
* [x] LaborCoinTreasuryModuleV1.json
* [x] LaborCoinGovernanceV13.json
* [x] LaborCoinExchangeV3.json

Metadata Files Archived:

* [x] Yes
* [ ] No

Artifact Location:

final-launch/artifacts/

---

# Final Launch Certification

All contracts were deployed from the source code associated with the Git commit recorded in this document.

All contracts were compiled using the build environment documented in build-environment.md.

All contract addresses, deployment transactions, verification records, and constructor arguments have been archived.

Final Launch Approved: True

Date: 2026-06-24

Signature / Maintainer: The LaborCoin Creator
