# Ownership Transfer and Finalization Records

Network: Polygon Mainnet
Chain ID: 137

## Purpose

This document records ownership, minter, and administrative finalization actions for the LaborCoin system.

The goal of these records is to make the final production state auditable and reproducible.

## LABRV Governance Token

Contract: `0x833242E933c675846D8f8982048FecA95B8e435A`
Contract Name: `LaborVoteV7`

### Minter Assignment

Minter Set To Registration Contract:
`0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C`

Transaction Hash:
`0x7768e6344a44b53b371c753c81379dcbfcc9abd96342a3d37fb6e324de69b074`

Purpose:
Allows the Registration contract to mint LABRV governance rights after successful registration.

### Minter Lock and Ownership Renouncement

Transaction Hash:
`0x30bad6d15a7aed4ec7ae8e30423ac10efe679f36549bb5f7fb81fa5baf42e6a4`

Block: `89001958`

Purpose:
Locks the LABRV minter configuration and renounces ownership after the Registration contract has been assigned as the permanent minter.

Final State:

* LABRV is non-transferable by policy.
* LABRV minting is controlled by Registration.
* Minter assignment is locked.
* Ownership has been renounced.

## Registration Contract

Contract: `0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C`
Contract Name: `LaborCoinRegistrationV4`

Final State:

* Requires LABR balance.
* Requires Passport verification.
* Requires verifier signature.
* Uses expiry-based replay protection.
* Mints LABRV through the locked LABRV minter configuration.

Ownership finalization transaction: `TO BE RECORDED IF APPLICABLE`

## Governance Contract

Contract: `0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c`

Final State:

* Uses Passport-verifier signatures for protected governance actions.
* Executes treasury transfers through DAO-approved permissions.
* Subject to proposal duration, participation, approval, execution window, and transfer cap rules.

Ownership finalization transaction: `TO BE RECORDED IF APPLICABLE`

## Treasury Module

Contract: `0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C`

Final State:

* Receives execution authorization through the DAO permission system.
* Tracks distributed support.
* Used only for governance-approved treasury distributions.

Ownership finalization transaction: `TO BE RECORDED IF APPLICABLE`

## Exchange Contract

Current Contract: `0x4Cf18cB39203B678f5C26f2338a10a79f9684749`
Contract Name: `LaborCoinExchangeV4`

Final State:

* Bonding curve exchange.
* Enforces exchange-level wallet limit.
* Enforces exchange-level transaction limit.
* Uses Chainlink POL/USD oracle.
* No admin withdrawal function.
* No pause function.
* No upgrade function.

Ownership finalization transaction: Not applicable if contract has no ownership controls.

## LABR Token

Contract: `0x460DD873A1D2a41e77410B125cD3027C5FEd2f78`

Final State:

* Primary LABR token.
* 20labs token deployment.
* Token-level wallet and transaction rules remain enforced by the token contract.
* Exchange V4 applies stricter exchange-specific limits.

Ownership transfer / renouncement transaction: `TO BE RECORDED IF APPLICABLE`

## Notes

Any remaining `TO BE RECORDED` entries should be completed only after confirming the exact transaction hash, block, timestamp, and final on-chain state.

This document should be updated together with:

* `deployment-records/deployments.md`
* `deployment-records/release-record.md`
* `deployment-records/verification.md`
* `deployment-records/aragon-permissions.md`
