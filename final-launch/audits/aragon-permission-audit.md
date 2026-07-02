# Aragon Permission Audit and Revocation Plan

**Status:** Pre-revocation working record  
**DAO:** `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4`  
**Known Admin Plugin:** `0xB51Bf5812Fd8FF0c3F1A1AB1e8F24426d497D5CF`  
**Known DAO execute permission:** `0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d`

---

## 1. Controlling rule

Historical events are not proof of current permission state. No candidate revocation in this file should be submitted until the exact tuple has been checked with:

```text
DAO.isGranted(where, who, permissionId, 0x)
```

Record the block, timestamp, result, and data argument for every check.

The supplied extraction parsed **45 permission events** and reconstructed **21 candidate-active tuples**. The corrected architectural disposition is:

- **Retain:** Governance V13 DAO execute permission
- **Revoke after current-state confirmation:** 19 tuples
- **Investigate before deciding:** 1 plugin-helper tuple

---

## 2. Expected final permission state

| Where | Who | Permission | Expected |
|---|---|---|---|
| DAO `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` | Governance V13 `0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c` | `EXECUTE_PERMISSION_ID` | **Granted** |
| DAO `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` | Treasury Module V1 `0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C` | `EXECUTE_PERMISSION_ID` | **Not granted** |
| DAO `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` | Admin Plugin `0xB51Bf5812Fd8FF0c3F1A1AB1e8F24426d497D5CF` | `EXECUTE_PERMISSION_ID` | **Not granted after final cleanup** |
| DAO `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` | Any retired governance/module/executor | Any execution authority | **Not granted** |
| DAO permission manager | Any creator EOA | Root or arbitrary execution authority | **Not granted** |
| DAO permission manager | DAO itself | Required Aragon root authority | **Granted as required by DAO architecture** |

Governance V13 constructs a fixed DAO action to the current Treasury Module. The Treasury Module is the **target** of that action and does not itself call `DAO.execute`; it does not require DAO execute permission.

---

## 3. Candidate-active tuple disposition

| Priority | Where | Who | Classification | Permission ID | Grant transaction | Disposition | Reason |
| --- | --- | --- | --- | --- | --- | --- | --- |
| HIGH | `0xd9a660fad6fe13c5a88bcf3156f9e3200340152b` | `0x8cbf8cec3f1762e614e6ed4d569998aa19dafb8b` | Plugin helper / manager candidate | `0x8c433a4cd6b51969eca37f974940894297b9fcf4b282a213fea5cd8f85289c90` | `0xf5e3c173828c1b058cfe727343626631b4a68efb836976d35cf65149f598cabd` | **INVESTIGATE** | Plugin-specific permission. Identify both contracts and confirm whether the plugin remains installed before any revocation. |
| HIGH | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0x556fceb6d1ab85f7bf588843d93da960d6028093` | Unclassified permission holder | `0xf281525e53675515a6ba7cc7bea8a81e649b3608423ee2d73be1752cea887889` | `0x5e6438e741b09b4ca854be045fae9864ffaf32d32759db12cbc71607e888dc57` | **REVOKE** | Not part of the documented final authority graph. Revoke only after current isGranted state and contract identity are recorded. |
| HIGH | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0xb43cc57d4a67f3995211f0f5d630e34ba60123b8` | Unclassified permission holder | `0xf281525e53675515a6ba7cc7bea8a81e649b3608423ee2d73be1752cea887889` | `0x3ecaeb5f645a5d7edd80719621e3fb2315864debdc3cfa9a3abbf9a699532cd4` | **REVOKE** | Not part of the documented final authority graph. Revoke only after current isGranted state and contract identity are recorded. |
| HIGH | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0x43de58067f46217263a36848f948dc4d3cacc49f` | Unclassified permission holder | `0xf281525e53675515a6ba7cc7bea8a81e649b3608423ee2d73be1752cea887889` | `0x5f79d64a17068039b6c4d69842cee0b6584921b988d527463150ace192d28456` | **REVOKE** | Not part of the documented final authority graph. Revoke only after current isGranted state and contract identity are recorded. |
| HIGH | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0x63066b0dd3a0e52212b934f7602056082c187e4b` | Unclassified permission holder | `0xf281525e53675515a6ba7cc7bea8a81e649b3608423ee2d73be1752cea887889` | `0x247e8c34c6100136eb786e3e46ab41ab7e35265bb0ed4ae17140498e142b1e29` | **REVOKE** | Not part of the documented final authority graph. Revoke only after current isGranted state and contract identity are recorded. |
| HIGH | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0xe4fd8127ad01c2691c8955cb240d2062d1731020` | Unclassified permission holder | `0xf281525e53675515a6ba7cc7bea8a81e649b3608423ee2d73be1752cea887889` | `0xb64cce3adb987c08167c2ae9b89a663cdf33121c669029c3d6eeaceb1f21332f` | **REVOKE** | Not part of the documented final authority graph. Revoke only after current isGranted state and contract identity are recorded. |
| HIGH | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0xab7cfc38f65b79a4c7bd92810c70e78eaf2670ac` | Unclassified permission holder | `0xf281525e53675515a6ba7cc7bea8a81e649b3608423ee2d73be1752cea887889` | `0x2b55bc16f389d20f32c1a8b05fdc33fff7567e47a94fab93c05c146d61111da4` | **REVOKE** | Not part of the documented final authority graph. Revoke only after current isGranted state and contract identity are recorded. |
| HIGH | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0x232bd1c5fd0917df766eedb713ca47bba9e44bc5` | Unclassified permission holder | `0xf281525e53675515a6ba7cc7bea8a81e649b3608423ee2d73be1752cea887889` | `0x305a6052f1da280966fee8f646b19337d6cb2347c29870fbab17c5ed96e2fab0` | **REVOKE** | Not part of the documented final authority graph. Revoke only after current isGranted state and contract identity are recorded. |
| HIGH | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0x6cabeb549db04e82d79045f348b32418bd99b726` | Unclassified permission holder | `0xf281525e53675515a6ba7cc7bea8a81e649b3608423ee2d73be1752cea887889` | `0x06e55e806204a5de01332299a5dffc12c7c187bf99c9596acc8d220ac3e9b9df` | **REVOKE** | Not part of the documented final authority graph. Revoke only after current isGranted state and contract identity are recorded. |
| HIGH | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0x232bd1c5fd0917df766eedb713ca47bba9e44bc5` | Unclassified permission holder | `0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d` | `0x8c236306b8ab7776c9655abf22efafff2bb650e1cb7ff764a841040142c1c2cb` | **REVOKE** | Not part of the documented final authority graph. Revoke only after current isGranted state and contract identity are recorded. |
| HIGH | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0x6cabeb549db04e82d79045f348b32418bd99b726` | Unclassified permission holder | `0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d` | `0xbdd927cf81f327b72073dbcd98aeec25719a7592383c7e142d77fada08e74a06` | **REVOKE** | Not part of the documented final authority graph. Revoke only after current isGranted state and contract identity are recorded. |
| HIGH | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0x52419b9977f50918eb98558f39bb40abafb4ed2a` | Unclassified permission holder | `0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d` | `0xe2f29e13efe76ff484b65adafecf2855f85361c3e900ea951a876cdcc6abf172` | **REVOKE** | Not part of the documented final authority graph. Revoke only after current isGranted state and contract identity are recorded. |
| HIGH | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0xcaf66c6f4f168625e732032b88e903b39cc8ecde` | Unclassified permission holder | `0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d` | `0xaf1edc59d602546196959dc10b2d1b09001ee977da27563477a328c30ed9b6f0` | **REVOKE** | Not part of the documented final authority graph. Revoke only after current isGranted state and contract identity are recorded. |
| HIGH | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0x4d4bc3d4039b6a9fcd9a9d0c2cff655a52bb4516` | Unclassified permission holder | `0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d` | `0xb5d7ddd6e160c2ae8642cdcde5aaadfb0a35fd09afe04605e2e388267a3a1a30` | **REVOKE** | Not part of the documented final authority graph. Revoke only after current isGranted state and contract identity are recorded. |
| HIGH | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0x286292f67a6ac9a6ea1c894cf64f6dd8cdd76436` | Unclassified permission holder | `0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d` | `0x56ca00de9aa8746cda81041a7f57851b99505ca3b47ea706a9e1790898aa3d6b` | **REVOKE** | Not part of the documented final authority graph. Revoke only after current isGranted state and contract identity are recorded. |
| HIGH | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0xefbb3f8f873282a5d6789e6ae11409b43fc18910` | Unclassified permission holder | `0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d` | `0x10432f69242e952b73a5724b298829a27a6698d1569e459f66b852994779ace1` | **REVOKE** | Not part of the documented final authority graph. Revoke only after current isGranted state and contract identity are recorded. |
| HIGH | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0x84ac5be86e2102496949862f59aceb5d7dc3df77` | Unclassified permission holder | `0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d` | `0x13209a8a5f73486928eb983dceae4258aea127ba85dd40c31fd32ded8e1853c1` | **REVOKE** | Not part of the documented final authority graph. Revoke only after current isGranted state and contract identity are recorded. |
| HIGH | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0x499b32e9e5a8b9865a9d69480d590252a56fa78f` | Governance V12, retired | `0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d` | `0xec6638a618299672fcb4d166086e8f58b223e9923797d2efd29dec2158c5e90f` | **REVOKE** | Superseded governance contract. |
| HIGH | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0x0b018e45e4cb71e222c345a5341bdbaee519c623` | Treasury Module V1, superseded deployment | `0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d` | `0x974cb10ead303aa901678d7b908b6a2ca65e054294630fcd5c95e45fa4e3bbf4` | **REVOKE** | Superseded module; no obsolete module should retain DAO execution authority. |
| RETAIN | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0x8238105d31f6bb26897d8ab270a0a521fef03e8c` | Governance V13 | `0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d` | `0x1e9bc8d427a417ad84b1d52fd08a3592fa682c9ebf51213096ea38e2a6e591fd` | **RETAIN** | The final governance contract requires DAO EXECUTE permission to execute its fixed Treasury Module action. |
| HIGH | `0x0c2e5679153593b82a84eab5ca90895bb291cec4` | `0x10f2798ef055950b897af4b3a8ae90de34f6c56c` | Treasury Module V1, current deployment | `0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d` | `0x2e34480efe13043df5318d77242b11c078a02dc0bba3a5aa7cfdf61f91fc45b0` | **REVOKE** | The module is called by the DAO and has no code path that calls DAO.execute; DAO EXECUTE permission is unnecessary. |

---

## 4. Candidate tuple calls

These calls were generated from historical reconstruction. Treat them as candidates only.

```text
revoke(0xd9a660fad6fe13c5a88bcf3156f9e3200340152b, 0x8cbf8cec3f1762e614e6ed4d569998aa19dafb8b, 0x8c433a4cd6b51969eca37f974940894297b9fcf4b282a213fea5cd8f85289c90)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0x556fceb6d1ab85f7bf588843d93da960d6028093, 0xf281525e53675515a6ba7cc7bea8a81e649b3608423ee2d73be1752cea887889)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0xb43cc57d4a67f3995211f0f5d630e34ba60123b8, 0xf281525e53675515a6ba7cc7bea8a81e649b3608423ee2d73be1752cea887889)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0x43de58067f46217263a36848f948dc4d3cacc49f, 0xf281525e53675515a6ba7cc7bea8a81e649b3608423ee2d73be1752cea887889)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0x63066b0dd3a0e52212b934f7602056082c187e4b, 0xf281525e53675515a6ba7cc7bea8a81e649b3608423ee2d73be1752cea887889)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0xe4fd8127ad01c2691c8955cb240d2062d1731020, 0xf281525e53675515a6ba7cc7bea8a81e649b3608423ee2d73be1752cea887889)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0xab7cfc38f65b79a4c7bd92810c70e78eaf2670ac, 0xf281525e53675515a6ba7cc7bea8a81e649b3608423ee2d73be1752cea887889)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0x232bd1c5fd0917df766eedb713ca47bba9e44bc5, 0xf281525e53675515a6ba7cc7bea8a81e649b3608423ee2d73be1752cea887889)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0x6cabeb549db04e82d79045f348b32418bd99b726, 0xf281525e53675515a6ba7cc7bea8a81e649b3608423ee2d73be1752cea887889)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0x232bd1c5fd0917df766eedb713ca47bba9e44bc5, 0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0x6cabeb549db04e82d79045f348b32418bd99b726, 0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0x52419b9977f50918eb98558f39bb40abafb4ed2a, 0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0xcaf66c6f4f168625e732032b88e903b39cc8ecde, 0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0x4d4bc3d4039b6a9fcd9a9d0c2cff655a52bb4516, 0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0x286292f67a6ac9a6ea1c894cf64f6dd8cdd76436, 0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0xefbb3f8f873282a5d6789e6ae11409b43fc18910, 0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0x84ac5be86e2102496949862f59aceb5d7dc3df77, 0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0x499b32e9e5a8b9865a9d69480d590252a56fa78f, 0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0x0b018e45e4cb71e222c345a5341bdbaee519c623, 0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0x8238105d31f6bb26897d8ab270a0a521fef03e8c, 0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d)
revoke(0x0c2e5679153593b82a84eab5ca90895bb291cec4, 0x10f2798ef055950b897af4b3a8ae90de34f6c56c, 0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d)
```

---

## 5. Admin Plugin checks that must be added

The supplied 21-row reconstruction is not guaranteed to include installation-time or plugin-internal permissions. Query and document at minimum:

1. Whether the known Admin Plugin holds DAO `EXECUTE_PERMISSION_ID`.
2. Every address that can call the Admin Plugin’s `createProposal` or `executeProposal`.
3. Any plugin target-config, upgrade, uninstall, metadata, or implementation authority.
4. Any condition contract that can authorize an executor.
5. Every non-DAO holder of root permission.
6. Whether an older Admin Plugin or governance plugin remains installed.

**Do not remove the final Admin path until all required LABR token and permission cleanup has been executed.**

---

## 6. Complete supplied event ledger

{md_table(events)}

---

## 7. Post-revocation evidence table

Fill one row immediately after each transaction.

| Revocation transaction | Block | UTC time | Where | Who | Permission ID | Pre-state | Post-state | Notes |
|---|---:|---|---|---|---|---|---|---|
| | | | | | | `true` | `false` | |

---

## 8. Final permission certification

This section may be marked complete only after live post-state checks.

- [ ] Governance V13 has DAO execute permission
- [ ] Treasury Module V1 lacks DAO execute permission
- [ ] Governance V12 lacks DAO execute permission
- [ ] Superseded Treasury Module lacks DAO execute permission
- [ ] Every unclassified historical executor lacks DAO execute permission
- [ ] Every unresolved permission ID has been identified or removed
- [ ] Admin Plugin lacks DAO execute permission
- [ ] No creator-controlled address can execute arbitrary DAO actions
- [ ] No non-DAO address retains root permission
- [ ] Final permission export and block number are archived
