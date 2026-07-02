[release-record.md](https://github.com/user-attachments/files/29590848/release-record.2.md)
# LaborCoin Release Integrity Record

This document identifies the source files, build settings, deployment artifacts, and verification records associated with the LaborCoin launch release package.

It is an **integrity and reproducibility record**, not the operational lifecycle ledger. Current deployment status, post-deployment configuration, contract retirement, and asset-recovery transactions are recorded in [`deployments.md`](deployments.md).

---

## 1. Release Identity

| Field | Record |
|---|---|
| Project | LaborCoin |
| Release name | Final Launch |
| Release status | Historical release package; Exchange V4 was subsequently retired |
| Release tag | Not yet recorded |
| Git commit hash | Not yet recorded |
| Release date | Not yet recorded |
| Prepared by | The LaborCoin Creator |

---

## 2. Source Repository

| Field | Record |
|---|---|
| Repository | https://github.com/LaborCoinCreator/LaborCoin |
| Primary branch | Not yet recorded |
| Release tag | Not yet recorded |
| Commit hash | Not yet recorded |
| Commit URL | Not yet recorded |

---

## 3. Build Environment

The following environment applies to the repository-deployed launch contracts unless a contract-specific record states otherwise.

| Setting | Value |
|---|---|
| Solidity compiler | 0.8.30 |
| EVM version | Prague |
| Optimizer | Enabled |
| Optimizer runs | 200 |
| Via IR | False |
| OpenZeppelin Contracts | 5.6.1 |
| License | MIT |

> **External LABR token note:** LABR was generated separately through 20LABS and is not reproduced from the repository build environment above. Its recorded compiler environment is Solidity 0.8.25 with EVM Paris.

---

## 4. External Token Dependency

### LABR Token

| Field | Record |
|---|---|
| Contract | LaborCoin |
| Symbol | LABR |
| Network | Polygon Mainnet |
| Address | `0x460DD873A1D2a41e77410B125cD3027C5FEd2f78` |
| Deployment source | 20LABS Token Generator |
| Source SHA256 | Not archived in this release record |
| Verification | Verified |
| Explorer | https://polygonscan.com/address/0x460DD873A1D2a41e77410B125cD3027C5FEd2f78#code |

---

## 5. Contract Source Integrity Records

### 5.1 LaborVoteV7.sol

| Field | Record |
|---|---|
| SHA256 | `aa2c75d1a4ecd36cb8544e9890dfc4c4804bfe65359feb693e912eb5630545a1` |
| File size | 1,520 bytes |
| Contract address | `0x833242E933c675846D8f8982048FecA95B8e435A` |
| Deployment transaction | `0x83f241f7c3d3442d9a4a1d56c38d3354fb1803a5bb3bae05c6e22c547a143db7` |
| Block | `88595455` |
| Deployment order | 1 |
| Constructor arguments | None |
| Verification status | Verified |
| Verification method | Solidity Standard JSON Input |
| Lifecycle status | Deployed; minter locked; ownership renounced |

**Role:** Final LABRV governance-token implementation. LABRV is non-transferable, and its permanently assigned minter is LaborCoinRegistrationV4.

---

### 5.2 LaborCoinRegistrationV4.sol

| Field | Record |
|---|---|
| SHA256 | `1350c96ba556beb4804e3d084accc586b9727955681f41133ee4bfd5eaf8df13` |
| File size | 5,706 bytes |
| Contract address | `0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C` |
| Deployment transaction | `0xbe8c2a8cc7f9322a36b9a6a1726d7f830531b601941f17324bffe1b995bc10fe` |
| Block | `88997813` |
| Deployment order | 2 |
| Verification status | Verified |
| Verification method | Solidity Standard JSON Input |
| Lifecycle status | Deployed |

**Constructor arguments**

| Parameter | Address |
|---|---|
| `_labr` | `0x460DD873A1D2a41e77410B125cD3027C5FEd2f78` |
| `_labrv` | `0x833242E933c675846D8f8982048FecA95B8e435A` |
| `_verifier` | `0x475d519631d2406753aCA29F305f19b83E97513e` |

**Role:** Registration and membership-recording contract. A successful registration requires the configured LABR balance threshold, a valid verifier signature, and an unexpired signature. The contract records the participant’s member number and registration timestamp and mints one LABRV to an eligible participant who does not already hold LABRV.

---

### 5.3 LaborCoinExchangeV4.sol

| Field | Record |
|---|---|
| SHA256 | `18bbfb468c1d24a6c031130afeca10ec0e1b03f17b698b8c277353058a12d271` |
| File size | 6,571 bytes |
| Contract address | `0x4Cf18cB39203B678f5C26f2338a10a79f9684749` |
| Deployment transaction | `0xa5d1b14cd13c6aeaf7408878e4dddde141908dab12e27022ee565f5d207025fc` |
| Block | `89115657` |
| Deployment order | 5 |
| Verification status | Verified |
| Verification method | Automatic exact-match verification through Sourcify / PolygonScan metadata |
| Lifecycle status | **Retired**; residual LABR dust only |

**Constructor arguments**

| Parameter | Address |
|---|---|
| `_labr` | `0x460DD873A1D2a41e77410B125cD3027C5FEd2f78` |
| `_daoTreasury` | `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` |

**Release role:** Exchange V4 implemented the LABR bonding curve, Chainlink POL/USD conversion, automatic tranche unlocking, the transaction cooldown, DAO treasury allocation on buys, and reentrancy protection.

**Current status:** Exchange V4 is no longer designated as an active exchange. Its retirement and LABR recovery transaction are documented in [`deployments.md`](deployments.md).

---

### 5.4 LaborCoinTreasuryModuleV1.sol

| Field | Record |
|---|---|
| SHA256 | `a6c8ceb4b1b20cc048fc2615ff447f5cc7a274028e835b7c99e1efe6fba35be2` |
| File size | 2,151 bytes |
| Contract address | `0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C` |
| Deployment transaction | `0x6817331673fa3d178b78c9a7d4499a36a28913728767c870ffce5c2bb9a84cb8` |
| Block | `89052358` |
| Deployment order | 3 |
| OpenZeppelin dependency | None |
| Verification status | Verified |
| Verification method | Solidity Standard JSON Input |
| Lifecycle status | Deployed |

**Constructor argument**

| Parameter | Address |
|---|---|
| `_dao` | `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` |

**Role:** Immutable DAO-controlled POL transfer module. The DAO address is fixed at deployment. The contract has no owner, upgrade path, administrative withdrawal function, or independent external control path.

---

### 5.5 LaborCoinGovernanceV13.sol

| Field | Record |
|---|---|
| SHA256 | `8e0feaa4567833d6d3af4ffde6bd00ca19e2aebfad3bee67a1ea1be611b5efc7` |
| File size | 13,241 bytes |
| Contract address | `0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c` |
| Deployment transaction | `0xabd669c27e4bc94471241d433432e8c66375d258a0a6fa5413772d2aef0fbc6e` |
| Block | `89084762` |
| Deployment order | 4 |
| Verification status | Verified |
| Verification method | Automatic exact-match verification through Sourcify / PolygonScan metadata |
| Lifecycle status | Deployed |

**Constructor arguments**

| Parameter | Address |
|---|---|
| `_dao` | `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` |
| `_labrv` | `0x833242E933c675846D8f8982048FecA95B8e435A` |
| `_verifier` | `0x475d519631d2406753aCA29F305f19b83E97513e` |
| `_treasuryModule` | `0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C` |
| `_registration` | `0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C` |

**Role:** Proposal, voting, approval, and execution-authorization layer for DAO treasury distributions. The contract applies the recorded membership requirement, participation threshold, approval threshold, voting duration, execution window, and per-proposal treasury cap.

---

## 6. Deployment Artifact Integrity

### LaborVoteV7

| Artifact | Path | SHA256 |
|---|---|---|
| Contract artifact | `final-launch/artifacts/LaborVoteV7/LaborVoteV7.json` | `79e9d402a794cca2a854a9eebadcd81f729723008deac10cee5a8b501114d9f5` |
| Metadata | `final-launch/artifacts/LaborVoteV7/LaborVoteV7_metadata.json` | `569952c8ae4f91093b6efdc16ecc3c80c6f59eaf8d7beabc32587a3e884a8add` |

### LaborCoinRegistrationV4

| Artifact | Path | SHA256 |
|---|---|---|
| Contract artifact | `final-launch/artifacts/LaborCoinRegistrationV4/LaborCoinRegistrationV4.json` | `999b2c57f169c36c51df4513ca9274cde54148829dcd248b015aa690674dc0de` |
| Metadata | `final-launch/artifacts/LaborCoinRegistrationV4/LaborCoinRegistrationV4_metadata.json` | `bf6ecded77da8917df464fffd6d05140744b559d4ca9d98773ad52ff88f47ad6` |

### LaborCoinExchangeV4

| Artifact | Path | SHA256 |
|---|---|---|
| Contract artifact | `final-launch/artifacts/LaborCoinExchangeV4/LaborCoinExchangeV4.json` | `8818a193ddd5041f8d47874568c6bc7ab00753ec10cf8bbfe163072073ffc249` |
| Metadata | `final-launch/artifacts/LaborCoinExchangeV4/LaborCoinExchangeV4_metadata.json` | `b7b70a5279454000bb97cc03713958808f5d5add353e1fea3dba99beb4e40061` |

### LaborCoinTreasuryModuleV1

| Artifact | Path | SHA256 |
|---|---|---|
| Contract artifact | `final-launch/artifacts/LaborCoinTreasuryModuleV1/LaborCoinTreasuryModuleV1.json` | `58bf825f038b1bcaa6af357d069db7f041e5027783c2028b0fca9d9e350e2f0b` |
| Metadata | `final-launch/artifacts/LaborCoinTreasuryModuleV1/LaborCoinTreasuryModuleV1_metadata.json` | `8ecf1120c38671706264c859bb7d31aaf912ff40a5d149a3b9e2a3053da7f90a` |

### LaborCoinGovernanceV13

| Artifact | Path | SHA256 |
|---|---|---|
| Contract artifact | `final-launch/artifacts/LaborCoinGovernanceV13/LaborCoinGovernanceV13.json` | `64d0db4ed7c277a950501c7cd4bf915b2746376f25ce14fc274ecd95c5ddaf1a` |
| Metadata | `final-launch/artifacts/LaborCoinGovernanceV13/LaborCoinGovernanceV13_metadata.json` | `c54a360099be00947b24f5ade7b186062f0f8d7356052fa32e5c9568816b15c0` |

---

## 7. Verification Summary

| Contract | Address | Verified | Explorer |
|---|---|---:|---|
| LABR | `0x460DD873A1D2a41e77410B125cD3027C5FEd2f78` | Yes | https://polygonscan.com/address/0x460DD873A1D2a41e77410B125cD3027C5FEd2f78#code |
| LaborVoteV7 | `0x833242E933c675846D8f8982048FecA95B8e435A` | Yes | https://polygonscan.com/address/0x833242E933c675846D8f8982048FecA95B8e435A#code |
| LaborCoinRegistrationV4 | `0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C` | Yes | https://polygonscan.com/address/0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C#code |
| LaborCoinExchangeV4 | `0x4Cf18cB39203B678f5C26f2338a10a79f9684749` | Yes | https://polygonscan.com/address/0x4Cf18cB39203B678f5C26f2338a10a79f9684749#code |
| LaborCoinTreasuryModuleV1 | `0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C` | Yes | https://polygonscan.com/address/0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C#code |
| LaborCoinGovernanceV13 | `0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c` | Yes | https://polygonscan.com/address/0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c#code |

---

## 8. Post-Release Exchange Status

This section records only the status necessary to prevent retired exchanges from being mistaken for active deployments. Full transaction details belong in [`deployments.md`](deployments.md).

| Exchange | Address | Recovery transaction | LABR recovered | Residual LABR | Status |
|---|---|---|---:|---:|---|
| Exchange V3 | `0xE57ba76AED1B7B4142E3DfaBd6cf3E94970b86eA` | `0x0c6b1395af80f439a17847f131663b3abf07c3f2e016ef40474a5698f74c34c4` | `9.9901819422756` | `0.0098180577244` | Retired |
| Exchange V4 | `0x4Cf18cB39203B678f5C26f2338a10a79f9684749` | `0x98083f02852418ad83d3f8a0d4de60b6facc6c68f5d827f8dbe0cd76c2748fbc` | `9.63125642470365` | `0.00184357529635` | Retired |

The residual balances are economically negligible dust and remain in the retired contracts.

---

## 9. Release Summary

| Field | Record |
|---|---|
| Network | Polygon Mainnet |
| Chain ID | 137 |
| Deployment wallet | `0x015b6D0990E56D908c876474C6A30eBa2b8A0CFB` |
| Deployment window | June 16–25, 2026 |
| Repository contracts recorded | 5 |
| Recorded contracts verified | Yes |
| Frontend updated for this release | Yes |
| Release testing recorded | Yes |
| Exchange V4 current status | Retired |

---

## 10. Integrity Statement

The source hashes, artifact hashes, metadata hashes, compiler settings, constructor arguments, deployment identifiers, and verification links in this document define the archived LaborCoin launch release package.

Operational status must not be inferred from inclusion in this release record. Contract lifecycle events, including the retirement of Exchanges V3 and V4, are governed by [`deployments.md`](deployments.md).

For reproduction or audit, review this document together with:

- `deployment-manifest.md`
- `deployments.md`
- `verification.md`
- `constructor-args.md`
- `build-environment.md`
