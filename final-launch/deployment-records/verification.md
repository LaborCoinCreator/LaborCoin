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

Verification Status:

Verification Date:

Explorer:

Verification URL:

Constructor Arguments:

Notes:

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

## LaborCoinTreasuryModuleV1

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
