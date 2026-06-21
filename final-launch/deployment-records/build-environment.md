# Build Environment

This document records the exact build environment used to compile, verify, and deploy the LaborCoin final launch contracts.

Maintaining a complete build record is critical for deployment reproducibility, source verification, future audits, and long-term archival purposes.

---

## Compiler Configuration

Solidity Compiler Version:

0.8.30

Compiler Build:

v0.8.30+commit.73712a01

Via IR:

False

---

Language:

Solidity

Optimization:

Enabled

Optimizer Runs:

200

EVM Version:

Prague

License:

MIT

---

## OpenZeppelin Dependencies

OpenZeppelin Contracts Version:

5.6.1

Dependency Source:

npm/@openzeppelin/contracts@5.6.1

Repository:

https://github.com/OpenZeppelin/openzeppelin-contracts

---

## Development Environment

Development Platform:

Remix IDE

Remix Version:

2.4.1

Native Currency:

POL

---

Deployment Network:

Polygon Mainnet

---

Chain ID:

137

---

Deployment Date:

June 16, 2026

---

## Final Launch Contracts

### LaborCoin (LABR)

Deployment Source:

20LABS Token Generator

Contract Address:

0x460DD873A1D2a41e77410B125cD3027C5FEd2f78

Notes:

LABR was generated and deployed through the 20LABS platform prior to the final launch contract deployment process documented in this repository.

---

### LaborVoteV7

Source File:

final-launch/contracts/LaborVoteV7.sol

Compiler Version:

0.8.30

Optimizer:

Enabled

Optimizer Runs:

200

---

### LaborCoinRegistrationV4

Source File:

contracts/LaborCoinRegistrationV4.sol

Compiler Version:

0.8.30

Optimizer:

Enabled

Optimizer Runs:

200

---

### LaborCoinExchangeV3

Source File:

contracts/LaborCoinExchangeV3.sol

Compiler Version:

0.8.30

Optimizer:

Enabled

Optimizer Runs:

200

---

### LaborCoinGovernanceV13

Source File:

contracts/LaborCoinGovernanceV13.sol

Compiler Version:

0.8.30

Optimizer:

Enabled

Optimizer Runs:

200

---

### LaborCoinTreasuryModuleV1

Source File:

contracts/LaborCoinTreasuryModuleV1.sol

Compiler Version:

0.8.30

Optimizer:

Enabled

Optimizer Runs:

200

---

## Deployment Assumptions

All final launch contracts were compiled using the same build environment.

Any deviation from the settings documented in this file may result in:

* Different deployed bytecode
* Verification failures
* Inability to reproduce deployments
* Audit inconsistencies

---

## Verification Settings

Compiler Version:

0.8.30

EVM Version:

Prague

Optimization:

Enabled

Optimizer Runs:

200

License:

MIT

Constructor Arguments:

Recorded separately in:

deployment-records/constructor-args.md

Verification Method:

Solidity Standard JSON Input

---

## Build Validation Checklist

* [ ] All contracts compile successfully
* [ ] No compiler warnings requiring action
* [ ] OpenZeppelin version documented
* [ ] Compiler version documented
* [ ] EVM version documented
* [ ] Optimizer settings documented
* [ ] Constructor arguments archived
* [ ] Deployment artifacts archived
* [ ] Verification settings archived

---

## Final Build Certification

The configuration documented in this file represents the authoritative LaborCoin final launch build environment.

All deployed contracts, deployment records, verification records, and artifacts should reference these settings as the canonical source of truth for future verification and reproduction efforts.
