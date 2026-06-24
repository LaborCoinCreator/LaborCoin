# Contract Verification Record

This document records verification details for all LaborCoin final launch contracts.

---

## Build Environment

Solidity Compiler: 0.8.30

EVM Version: Prague

Optimizer: Enabled

Optimizer Runs: 200

OpenZeppelin Version: 5.6.1

License: MIT

---

## LaborCoin (LABR)

Contract Address:

0x460DD873A1D2a41e77410B125cD3027C5FEd2f78

Verification Status:

Verified

Verification Date:

Jun-08-2026

Explorer:

Polygonscan

Verification URL:

https://polygonscan.com/address/0x460DD873A1D2a41e77410B125cD3027C5FEd2f78#code

Constructor Arguments:

None

Compiler Version:

0.8.25

EVM Version:

Paris

Optimizer:

Enabled

Optimizer Runs:

200

Contract Generator:

20Lab Token Generator

License:

No License

Verification Method:

Solidity Standard JSON Input

Notes:

Successfully verified on Polygonscan using Solidity Standard JSON Input. This contract was generated using the 20Lab Token Generator and therefore uses a different compiler environment than the custom LaborCoin contracts. The token was compiled with Solidity 0.8.25 and the Paris EVM version, while all custom LaborCoin system contracts (Exchange, Registration, Governance, Treasury Module, and LaborVote) were compiled separately using Solidity 0.8.30 and the Prague EVM version.

The token includes dividend distribution functionality, transfer restrictions, configurable fee mechanisms, trading cooldown controls, wallet and transaction limits, and ownership transfer capabilities. Post-launch fee configuration updates were performed through the 20Lab management interface in accordance with the final LaborCoin tokenomics.

Source Code Verification:

Verified as an Exact Match on Polygonscan.

---

# Verification Records

## LaborVoteV7

Contract Address:

0x833242E933c675846D8f8982048FecA95B8e435A

Verification Status:

Verified

Verification Date:

Jun-16-2026

Explorer:

Polygonscan

Contract URL:

https://polygonscan.com/address/0x833242E933c675846D8f8982048FecA95B8e435A#code

Deployment Transaction:

0x83f241f7c3d3442d9a4a1d56c38d3354fb1803a5bb3bae05c6e22c547a143db7

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

Verification Status:

Verified

Verification Date:

Jun-22-2026

Explorer:

Polygonscan

Contract URL:

https://polygonscan.com/address/0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C#code

Deployment Transaction:

0xbe8c2a8cc7f9322a36b9a6a1726d7f830531b601941f17324bffe1b995bc10fe

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

Successfully verified on Polygonscan using Standard JSON Input. Registration requires a valid verifier signature, an unexpired signature timestamp, and a minimum balance of 1 LABR. The contract assigns sequential member numbers, records registration timestamps, and mints one LABRV governance token to eligible participants who do not already hold LABRV.

---

## LaborCoinExchangeV3

Contract Address:

0xE57ba76AED1B7B4142E3DfaBd6cf3E94970b86eA

Verification Status:

Verified

Verification Date:

Jun-24-2026

Explorer:

Polygonscan

Contract URL:

https://polygonscan.com/address/0xE57ba76AED1B7B4142E3DfaBd6cf3E94970b86eA#code

Deployment Transaction:

0x7eafc77c8e5a0e5f2d2c6f83f2cd1fd4e104f963dca1c0325e2b93d563c9d876

Constructor Arguments:

_labr:
0x460DD873A1D2a41e77410B125cD3027C5FEd2f78

_daoTreasury:
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

Automatic Exact Match Verification (Sourcify / PolygonScan Metadata Match)

Notes:

Successfully verified on Polygonscan as an Exact Match. The contract implements the LaborCoin bonding curve exchange, uses the Chainlink POL/USD oracle at 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0, enforces a 12-hour transaction cooldown, distributes 10% of buy volume to the DAO treasury, and automatically unlocks supply tranches as distribution milestones are reached.

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

## LaborCoinTreasuryModuleV1

Contract Address:

0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C

Verification Status:

Verified

Verification Date:

Jun-24-2026

Explorer:

Polygonscan

Contract URL:

https://polygonscan.com/address/0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C#code

Deployment Transaction:

0x6817331673fa3d178b78c9a7d4499a36a28913728767c870ffce5c2bb9a84cb8

Constructor Arguments:

_dao:
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

Verification Method:

Solidity Standard JSON Input

Notes:

Successfully verified on Polygonscan using Standard JSON Input. The contract is an immutable DAO-controlled treasury transfer module. The DAO address is fixed at deployment, and the contract has no owner, no admin withdrawal function, no upgrade mechanism, and no arbitrary external control path. Only the configured DAO may execute transfers through executeTransfer, with the transfer amount determined by the POL value sent in the DAO call. The contract records cumulative distributed POL through totalDistributed and emits TransferExecuted events for transparency.

---

## LaborCoinGovernanceV13

Contract Address:

Verification Status:

Verification Date:

Explorer:

Verification URL:

Constructor Arguments:

Notes:

---

## Verification Checklist

* [ ] Source code matches deployed bytecode
* [ ] Compiler version recorded
* [ ] EVM version recorded
* [ ] Optimizer settings recorded
* [ ] Constructor arguments recorded
* [ ] Verification successful for all contracts
* [ ] Verification links archived
