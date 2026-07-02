[deployments.md](https://github.com/user-attachments/files/29590799/deployments.3.md)
# LaborCoin Deployment and Lifecycle Record

This document is the authoritative on-chain deployment and lifecycle ledger for LaborCoin. It records contract addresses, deployment transactions, configuration actions, verification results, functional validation, and contract retirement events.

Exact source hashes and archived artifact hashes are maintained separately in [`release-record.md`](release-record.md). This separation keeps the release-integrity record stable while allowing this document to track later operational events.

---

## 1. Release and Network Information

### Release

| Field | Record |
|---|---|
| Project | LaborCoin |
| Release name | Final Launch |
| Release tag | Not yet recorded |
| Git commit hash | Not yet recorded |
| Deployment window | June 16–25, 2026 |
| Deployment operator | The LaborCoin Creator |

### Network

| Field | Record |
|---|---|
| Network | Polygon Mainnet |
| Chain ID | 137 |
| RPC provider | Polygon Mainnet through MetaMask |
| Deployment wallet | `0x015b6D0990E56D908c876474C6A30eBa2b8A0CFB` |

### Repository Contract Build Environment

| Setting | Value |
|---|---|
| Solidity compiler | 0.8.30 |
| EVM version | Prague |
| Optimizer | Enabled |
| Optimizer runs | 200 |
| Via IR | False |
| OpenZeppelin Contracts | 5.6.1 |
| License | MIT |

> The external LABR token was generated separately through 20LABS. Its recorded compiler environment is Solidity 0.8.25 with EVM Paris.

---

## 2. External Dependencies

### LABR Token

| Field | Record |
|---|---|
| Contract | LaborCoin |
| Symbol | LABR |
| Deployment source | 20LABS Token Generator |
| Address | `0x460DD873A1D2a41e77410B125cD3027C5FEd2f78` |
| Network | Polygon Mainnet |
| Verification | Verified |
| Explorer | https://polygonscan.com/address/0x460DD873A1D2a41e77410B125cD3027C5FEd2f78#code |

LABR was deployed before the repository contracts recorded below.

### Chainlink POL/USD Price Feed

| Field | Record |
|---|---|
| Address | `0xAB594600376Ec9fD91F8e885dADF0CE036862dE0` |
| Network | Polygon Mainnet |
| Feed | POL/USD |
| Provider | Chainlink |
| Verification | Verified |
| Explorer | https://polygonscan.com/address/0xAB594600376Ec9fD91F8e885dADF0CE036862dE0 |

The feed converts the USD-denominated bonding-curve price into POL for exchange calculations. It is an external dependency and is not deployed, owned, or controlled by LaborCoin.

---

## 3. Deployment Sequence

1. Deploy and verify LaborVoteV7.
2. Deploy and verify LaborCoinRegistrationV4.
3. Assign LaborCoinRegistrationV4 as the LABRV minter.
4. Lock the LABRV minter and renounce LABRV ownership.
5. Deploy and verify LaborCoinTreasuryModuleV1.
6. Deploy and verify LaborCoinGovernanceV13.
7. Deploy and verify LaborCoinExchangeV4.
8. Update the frontend for the recorded release.
9. Conduct functional validation.
10. Archive source, metadata, artifacts, and deployment records.

---

## 4. Contract Lifecycle Summary

| Component | Address | Deployment block | Verification | Current lifecycle status |
|---|---|---:|---|---|
| LABR Token | `0x460DD873A1D2a41e77410B125cD3027C5FEd2f78` | External deployment | Verified | Deployed |
| LaborVoteV7 | `0x833242E933c675846D8f8982048FecA95B8e435A` | `88595455` | Verified | Deployed; minter locked; ownership renounced |
| LaborCoinRegistrationV4 | `0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C` | `88997813` | Verified | Deployed |
| LaborCoinTreasuryModuleV1 | `0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C` | `89052358` | Verified | Deployed |
| LaborCoinGovernanceV13 | `0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c` | `89084762` | Verified | Deployed |
| LaborCoinExchangeV2 | `0xD0692ec758bb852421B702B187b6439f74f8Bf3b` | Not recorded here | Historical | Retired |
| LaborCoinExchangeV3 | `0xE57ba76AED1B7B4142E3DfaBd6cf3E94970b86eA` | Not recorded here | Verified | Retired |
| LaborCoinExchangeV4 | `0x4Cf18cB39203B678f5C26f2338a10a79f9684749` | `89115657` | Verified | Retired |

> No exchange listed as retired in this record should be presented as the active LaborCoin exchange. A successor exchange must be added to this ledger explicitly after deployment and validation.

---

## 5. Contract Deployment Records

### 5.1 LaborVoteV7

| Field | Record |
|---|---|
| Address | `0x833242E933c675846D8f8982048FecA95B8e435A` |
| Deployment transaction | `0x83f241f7c3d3442d9a4a1d56c38d3354fb1803a5bb3bae05c6e22c547a143db7` |
| Timestamp | June 16, 2026, 08:22:48 UTC |
| Block | `88595455` |
| Deployment wallet | `0x015b6D0990E56D908c876474C6A30eBa2b8A0CFB` |
| Constructor arguments | None |
| Verification | Verified June 16, 2026 |
| Verification method | Solidity Standard JSON Input |
| Explorer | https://polygonscan.com/address/0x833242E933c675846D8f8982048FecA95B8e435A#code |

LaborVoteV7 is the non-transferable LABRV governance token. Its minter was assigned to LaborCoinRegistrationV4, permanently locked, and followed by ownership renunciation.

---

### 5.2 LaborCoinRegistrationV4

| Field | Record |
|---|---|
| Address | `0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C` |
| Deployment transaction | `0xbe8c2a8cc7f9322a36b9a6a1726d7f830531b601941f17324bffe1b995bc10fe` |
| Timestamp | June 22, 2026 |
| Block | `88997813` |
| Deployment wallet | `0x015b6D0990E56D908c876474C6A30eBa2b8A0CFB` |
| Verification | Verified June 22, 2026 |
| Verification method | Solidity Standard JSON Input |
| Explorer | https://polygonscan.com/address/0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C#code |

**Constructor arguments**

| Parameter | Address |
|---|---|
| LABR | `0x460DD873A1D2a41e77410B125cD3027C5FEd2f78` |
| LABRV | `0x833242E933c675846D8f8982048FecA95B8e435A` |
| Verifier | `0x475d519631d2406753aCA29F305f19b83E97513e` |

Registration requires a valid verifier signature, an unexpired signature timestamp, and the configured LABR balance threshold. An eligible participant receives one LABRV if the participant does not already hold LABRV.

---

### 5.3 LaborCoinTreasuryModuleV1

| Field | Record |
|---|---|
| Address | `0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C` |
| Deployment transaction | `0x6817331673fa3d178b78c9a7d4499a36a28913728767c870ffce5c2bb9a84cb8` |
| Timestamp | June 24, 2026 |
| Block | `89052358` |
| Deployment wallet | `0x015b6D0990E56D908c876474C6A30eBa2b8A0CFB` |
| Verification | Verified |
| Verification method | Solidity Standard JSON Input |
| Explorer | https://polygonscan.com/address/0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C#code |
| OpenZeppelin dependency | None |

**Constructor argument**

| Parameter | Address |
|---|---|
| DAO | `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` |

The treasury module is an immutable DAO-controlled POL transfer module. The DAO address is fixed at deployment. The contract has no owner, upgrade mechanism, administrative withdrawal function, or independent external control path.

---

### 5.4 LaborCoinGovernanceV13

| Field | Record |
|---|---|
| Address | `0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c` |
| Deployment transaction | `0xabd669c27e4bc94471241d433432e8c66375d258a0a6fa5413772d2aef0fbc6e` |
| Timestamp | June 24, 2026, 20:15:38 UTC |
| Block | `89084762` |
| Deployment wallet | `0x015b6D0990E56D908c876474C6A30eBa2b8A0CFB` |
| Verification | Verified June 24, 2026 |
| Verification method | Automatic exact-match verification through Standard JSON metadata |
| Explorer | https://polygonscan.com/address/0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c#code |

**Constructor arguments**

| Parameter | Address |
|---|---|
| DAO | `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` |
| LABRV | `0x833242E933c675846D8f8982048FecA95B8e435A` |
| Verifier | `0x475d519631d2406753aCA29F305f19b83E97513e` |
| Treasury module | `0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C` |
| Registration | `0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C` |

Governance V13 manages proposal creation, voting, approval validation, and treasury-execution authorization. Its DAO, LABRV, verifier, treasury-module, and registration references are immutable.

Recorded governance parameters include:

- 50 registered participants required before execution
- 14-day voting period
- 7-day execution window
- 25% participation requirement
- 67% approval requirement
- 5% maximum DAO treasury distribution per proposal

The contract has no owner controls, parameter-modification functions, upgrade mechanism, or emergency override.

---

### 5.5 LaborCoinExchangeV4

| Field | Record |
|---|---|
| Address | `0x4Cf18cB39203B678f5C26f2338a10a79f9684749` |
| Deployment transaction | `0xa5d1b14cd13c6aeaf7408878e4dddde141908dab12e27022ee565f5d207025fc` |
| Timestamp | June 25, 2026, 09:08:01 UTC |
| Block | `89115657` |
| Deployment wallet | `0x015b6D0990E56D908c876474C6A30eBa2b8A0CFB` |
| Verification | Verified June 25, 2026 |
| Verification method | Automatic exact-match verification through Sourcify / PolygonScan metadata |
| Explorer | https://polygonscan.com/address/0x4Cf18cB39203B678f5C26f2338a10a79f9684749#code |
| Current lifecycle status | **Retired** |

**Constructor arguments**

| Parameter | Address |
|---|---|
| LABR | `0x460DD873A1D2a41e77410B125cD3027C5FEd2f78` |
| DAO treasury | `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` |

**Oracle**

`0xAB594600376Ec9fD91F8e885dADF0CE036862dE0` — Chainlink POL/USD

Exchange V4 implemented the recorded bonding curve, automatic tranche unlocking, transaction cooldown, DAO treasury allocation, and reentrancy protection. It was later retired. Its recovery transaction is recorded in Section 7.

---

## 6. Post-Deployment Configuration

### LABRV Minter Assignment

| Field | Record |
|---|---|
| LABRV contract | `0x833242E933c675846D8f8982048FecA95B8e435A` |
| Assigned minter | `0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C` |
| Transaction | `0x7768e6344a44b53b371c753c81379dcbfcc9abd96342a3d37fb6e324de69b074` |
| Timestamp | June 23, 2026, 09:03:38 UTC |
| Result | Successful |

### LABRV Minter Lock and Ownership Renunciation

| Field | Record |
|---|---|
| Transaction | `0x30bad6d15a7aed4ec7ae8e30423ac10efe679f36549bb5f7fb81fa5baf42e6a4` |
| Timestamp | June 23, 2026, 09:45:32 UTC |
| Minter locked | Yes |
| Ownership renounced | Yes |

---

## 7. Exchange Retirement and LABR Recovery Ledger

Retired exchanges remain immutable historical contracts on Polygon. A retirement designation means the contract must no longer be presented or used as the active LaborCoin exchange.

LABR recovery was performed through each contract’s public `buy(uint256 minTokensOut)` function. This was an ordinary exchange interaction, not an administrative token withdrawal. Small residual balances remain because attempting to consume the exact final token unit could revert due to price conversion and integer rounding.

### 7.1 Retirement Summary

| Version | Contract address | Recovery transaction | LABR recovered | Residual LABR | Status |
|---|---|---|---:|---:|---|
| V2 | `0xD0692ec758bb852421B702B187b6439f74f8Bf3b` | `0x45f2e3c0f56b9cd3b66de9817f5643445f7b5e5903e89af2e0882b1b837c8dbf` | `0.50361236` | `0.0002534` | Retired |
| V3 | `0xE57ba76AED1B7B4142E3DfaBd6cf3E94970b86eA` | `0x0c6b1395af80f439a17847f131663b3abf07c3f2e016ef40474a5698f74c34c4` | `9.9901819422756` | `0.0098180577244` | Retired |
| V4 | `0x4Cf18cB39203B678f5C26f2338a10a79f9684749` | `0x98083f02852418ad83d3f8a0d4de60b6facc6c68f5d827f8dbe0cd76c2748fbc` | `9.63125642470365` | `0.00184357529635` | Retired |

---

### 7.2 Exchange V2 Retirement

| Field | Record |
|---|---|
| Contract address | `0xD0692ec758bb852421B702B187b6439f74f8Bf3b` |
| Recovery transaction | `0x45f2e3c0f56b9cd3b66de9817f5643445f7b5e5903e89af2e0882b1b837c8dbf` |
| LABR recovered | `0.50361236 LABR` |
| Residual dust | `0.0002534 LABR` |
| DAO treasury received | `0.6572 POL` |
| Final status | Retired; residual dust only |

No administrative withdrawal function existed on Exchange V2. Its remaining LABR was deemed economically insignificant and left in the retired contract.

---

### 7.3 Exchange V3 Retirement

| Field | Record |
|---|---|
| Contract address | `0xE57ba76AED1B7B4142E3DfaBd6cf3E94970b86eA` |
| Recovery transaction | `0x0c6b1395af80f439a17847f131663b3abf07c3f2e016ef40474a5698f74c34c4` |
| Transaction status | Success |
| Block | `89166866` |
| Caller | `laborcoin.eth` |
| Function | `buy(uint256 minTokensOut)` |
| Method ID | `0xd96a094a` |
| `minTokensOut` | `9990000000000000000` base units (`9.99 LABR`) |
| POL submitted | `137.56791438 POL` |
| DAO treasury transfer | `13.756791438 POL` |
| LABR recovered | `9.9901819422756 LABR` |
| Transaction fee | `0.15810194591402696 POL` |
| Residual LABR | `0.0098180577244 LABR` |
| Final status | **Retired; residual dust only** |

**Explorer:**  
https://polygonscan.com/tx/0x0c6b1395af80f439a17847f131663b3abf07c3f2e016ef40474a5698f74c34c4

The transaction recovered essentially all remaining economically accessible LABR from Exchange V3. The residual balance is intentionally left as dust.

---

### 7.4 Exchange V4 Retirement

| Field | Record |
|---|---|
| Contract address | `0x4Cf18cB39203B678f5C26f2338a10a79f9684749` |
| Recovery transaction | `0x98083f02852418ad83d3f8a0d4de60b6facc6c68f5d827f8dbe0cd76c2748fbc` |
| Transaction status | Success |
| Block | `89517970` |
| Caller | `0xEC811ecE6aF2Aae2Fa5337c40850BdA4F1d1D6cc` |
| Function | `buy(uint256 minTokensOut)` |
| Method ID | `0xd96a094a` |
| `minTokensOut` | `0` |
| POL submitted | `133.98144849 POL` |
| DAO treasury transfer | `13.398144849 POL` |
| LABR recovered | `9.63125642470365 LABR` |
| Transaction fee | `0.234972062858888992 POL` |
| Residual LABR | `0.00184357529635 LABR` |
| Final status | **Retired; residual dust only** |

**Explorer:**  
https://polygonscan.com/tx/0x98083f02852418ad83d3f8a0d4de60b6facc6c68f5d827f8dbe0cd76c2748fbc

The transaction began from a recorded Exchange V4 LABR balance of `9.6331 LABR` and recovered `9.63125642470365 LABR`. The remaining `0.00184357529635 LABR` is economically negligible and intentionally remains in the retired contract.

---

## 8. Verification Checklist

- [x] LaborVoteV7 verified
- [x] LaborCoinRegistrationV4 verified
- [x] LaborCoinTreasuryModuleV1 verified
- [x] LaborCoinGovernanceV13 verified
- [x] LaborCoinExchangeV4 verified
- [x] Verification links archived
- [x] Constructor arguments archived
- [x] Exchange V3 retirement transaction recorded
- [x] Exchange V4 retirement transaction recorded

---

## 9. Functional Validation Record

- [x] Registration test successful
- [x] Signature-expiry and replay-protection test successful
- [x] LABRV mint test successful
- [x] Governance proposal test successful
- [x] Governance vote test successful
- [x] Treasury execution test successful
- [x] Exchange V4 buy test successful before retirement
- [x] Exchange V4 sell test successful before retirement
- [ ] Multi-wallet test recorded as complete

The successful Exchange V4 tests are historical validation results and do not change its current retired status.

---

## 10. Archived Artifacts

| Artifact | Archived |
|---|---:|
| `LaborVoteV7.json` | Yes |
| `LaborCoinRegistrationV4.json` | Yes |
| `LaborCoinTreasuryModuleV1.json` | Yes |
| `LaborCoinGovernanceV13.json` | Yes |
| `LaborCoinExchangeV4.json` | Yes |
| Metadata files | Yes |

**Artifact location:** `final-launch/artifacts/`

Artifact and metadata hashes are recorded in [`release-record.md`](release-record.md).

---

## 11. Deployment Record Certification

The deployments, configuration actions, verification records, validation results, and retirement events listed here are the authoritative lifecycle record for the identified contracts.

Inclusion in this document does not imply that a contract remains active. The **Current lifecycle status** column and the retirement ledger control that determination.

| Field | Record |
|---|---|
| Deployment records archived | Yes |
| Constructor arguments archived | Yes |
| Verification records archived | Yes |
| Exchange V3 retired | Yes |
| Exchange V4 retired | Yes |
| Current active exchange recorded | No; successor deployment must be added separately |
| Maintainer | The LaborCoin Creator |
| Revision date | July 2, 2026 |
