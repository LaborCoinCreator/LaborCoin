# Exchange Retirement and Cleanup Audit

**Status:** LABR recovery documented; token-configuration cleanup pending  
**Network:** Polygon Mainnet

---

## 1. Retirement summary

| Version | Address | LABR recovery transaction | LABR recovered | Residual LABR | Lifecycle |
|---|---|---|---:|---:|---|
| V2 | `0xD0692ec758bb852421B702B187b6439f74f8Bf3b` | `0x45f2e3c0f56b9cd3b66de9817f5643445f7b5e5903e89af2e0882b1b837c8dbf` | `0.50361236` | `0.0002534` | Retired |
| V3 | `0xE57ba76AED1B7B4142E3DfaBd6cf3E94970b86eA` | `0x0c6b1395af80f439a17847f131663b3abf07c3f2e016ef40474a5698f74c34c4` | `9.9901819422756` | `0.0098180577244` | Retired |
| V4 | `0x4Cf18cB39203B678f5C26f2338a10a79f9684749` | `0x98083f02852418ad83d3f8a0d4de60b6facc6c68f5d827f8dbe0cd76c2748fbc` | `9.63125642470365` | `0.00184357529635` | Retired |

No active successor exchange is identified in the supplied release package.

---

## 2. Exchange V2

| Field | Record |
|---|---|
| Contract | `0xD0692ec758bb852421B702B187b6439f74f8Bf3b` |
| Recovery transaction | `0x45f2e3c0f56b9cd3b66de9817f5643445f7b5e5903e89af2e0882b1b837c8dbf` |
| LABR recovered | `0.50361236 LABR` |
| Residual LABR | `0.0002534 LABR` |
| DAO treasury transfer | `0.6572 POL` |
| Status | Retired; residual dust only |

---

## 3. Exchange V3

| Field | Record |
|---|---|
| Contract | `0xE57ba76AED1B7B4142E3DfaBd6cf3E94970b86eA` |
| Recovery transaction | `0x0c6b1395af80f439a17847f131663b3abf07c3f2e016ef40474a5698f74c34c4` |
| Status | Success |
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
| Final status | Retired; residual dust only |

Explorer: https://polygonscan.com/tx/0x0c6b1395af80f439a17847f131663b3abf07c3f2e016ef40474a5698f74c34c4

---

## 4. Exchange V4

| Field | Record |
|---|---|
| Contract | `0x4Cf18cB39203B678f5C26f2338a10a79f9684749` |
| Recovery transaction | `0x98083f02852418ad83d3f8a0d4de60b6facc6c68f5d827f8dbe0cd76c2748fbc` |
| Status | Success |
| Block | `89517970` |
| Caller | `0xEC811ecE6aF2Aae2Fa5337c40850BdA4F1d1D6cc` |
| Function | `buy(uint256 minTokensOut)` |
| Method ID | `0xd96a094a` |
| `minTokensOut` | `0` |
| POL submitted | `133.98144849 POL` |
| DAO treasury transfer | `13.398144849 POL` |
| LABR recovered | `9.63125642470365 LABR` |
| Transaction fee | `0.234972062858888992 POL` |
| Starting LABR balance used for recovery planning | `9.6331 LABR` |
| Residual LABR | `0.00184357529635 LABR` |
| Final status | Retired; residual dust only |

Explorer: https://polygonscan.com/tx/0x98083f02852418ad83d3f8a0d4de60b6facc6c68f5d827f8dbe0cd76c2748fbc

A separate recorded V4 transfer sent `1.5 POL` to the DAO in transaction:

`0x18aa24b6629a9dd461d32775e43039635feefe0767191f943c85831656e397f4`

Total observed V4-to-DAO POL in the supplied records is therefore at least:

```text
1.5 POL + 13.398144849 POL = 14.898144849 POL
```

This total is limited to the supplied evidence and is not asserted to be the complete lifetime V4 treasury total.

---

## 5. Why dust remains

The exchanges had no administrative LABR withdrawal path. Recovery used the public buy function. Exact exhaustion can revert because the oracle conversion and integer rounding may calculate output slightly above the contract’s remaining LABR balance. The remaining balances are economically negligible and are intentionally documented as dust.

---

## 6. Required LABR token cleanup

For each retired exchange, query and record all available token states:

| Check | V2 | V3 | V4 |
|---|---|---|---|
| `AMMs(address)` | Pending | Pending | Pending |
| `isExcludedFromFees(address)` | Pending | Pending | Pending |
| `isExcludedFromLimits(address)` | Pending | Pending | Pending |
| `isExcludedFromTradingRestriction(address)` | Pending | Pending | Pending |
| Dividend exclusion getter | Pending | Pending | Pending |
| `blacklisted(address)` | Pending | Pending | Pending |

Then:

1. Remove every retired exchange from AMM status unless a documented historical reason requires otherwise.
2. Remove retired exchanges from every reversible fee, limit, and trading exemption unless retaining a setting is explicitly justified.
3. Determine whether dividend exclusion is reversible. If it is not, record the permanent exclusion as inert historical state rather than attempting an impossible removal.
4. Record transaction hashes and post-state getter results.
5. Remove all retired addresses from frontend write paths, ABI configuration, service-worker caches, documentation links, and contract maps.
6. Monitor for unexpected future transactions.

Do this **before** the final Admin Plugin or arbitrary DAO execution path is removed.

---

## 7. Successor exchange requirements

The successor exchange must receive a separate audit confirming:

- correct LABR and DAO addresses;
- exact bonding-curve and oracle arithmetic;
- oracle freshness and anomaly checks;
- slippage protection;
- reentrancy protection;
- treasury transfer behavior;
- liquidity and insolvency behavior;
- 12-hour cooldown;
- official-exchange transaction limits;
- complete prohibition on official-exchange buying and selling by any wallet holding more than 10,000 LABR;
- verifier authorization enforced on-chain for every interaction source;
- inability to bypass restrictions through direct contract calls;
- no owner, upgrade, pause, or withdrawal path unless explicitly intended and finalized;
- funding, salvage, and retirement procedures.

Until that review is complete, the audit package records **no active final exchange**.
