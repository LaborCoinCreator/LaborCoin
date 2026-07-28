# Prelaunch Deployment Retirement Register

This register contains only known prelaunch Polygon deployments that remain operationally relevant to retirement, permission revocation, asset recovery, or public chain disambiguation. It is not represented as a complete development history.

None of these addresses is a Revision 7.2 replacement contract.

| Component | Address | Required treatment |
|---|---|---|
| Historical LABR token | `0x460DD873A1D2a41e77410B125cD3027C5FEd2f78` | Treat as prelaunch unless a separately reviewed migration plan says otherwise |
| Exchange V2 | `0xD0692ec758bb852421B702B187b6439f74f8Bf3b` | Inactive legacy exchange; confirm no funds or authority remain |
| Exchange V3 | `0xE57ba76AED1B7B4142E3DfaBd6cf3E94970b86eA` | Retired test exchange; confirm final balances and interface removal |
| Exchange V4 | `0x4Cf18cB39203B678f5C26f2338a10a79f9684749` | Retire from production interfaces after Revision 7.2 cutover |
| LaborVote V6 | `0x113579220515cd59b884Ea2379b4C369025246e2` | Superseded membership token |
| LaborVote V7 | `0x833242E933c675846D8f8982048FecA95B8e435A` | Superseded by Revision 7.2 candidate |
| Registration V4 | `0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C` | Superseded by Revision 7.2 candidate |
| Governance V12 | `0x499b32e9E5a8b9865a9D69480d590252a56FA78F` | Revoke any surviving DAO execute permission |
| Governance V13 | `0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c` | Revoke DAO execute permission during final migration |
| Treasury Module V1 | `0x0B018E45E4cB71E222C345a5341BdbaeE519c623` | Revoke any surviving DAO execute permission |

## Publication rule

Prelaunch draft sources, partial revision folders, and incomplete compiler histories do not belong in the final public release. The final public record should contain:

1. the exact Revision 7.2 source freeze;
2. the exact Revision 7.2 compiler artifacts and hashes;
3. final deployment addresses and transactions;
4. ownership and permission finalization evidence; and
5. this minimum retirement register for materially relevant prelaunch deployments.

The blockchain remains the ultimate record that these test contracts existed. Repository cleanup must not be described as erasing on-chain history.
