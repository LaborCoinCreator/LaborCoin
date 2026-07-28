# LaborCoin Revision 7.2 Source Freeze

This directory is the frozen, precompilation source snapshot for the seven Revision 7.2 contracts. It contains no compiler artifacts and no superseded contract revisions.

## Authority

- `contracts/` at the repository root is the readable active source tree.
- This directory is the release source freeze used for hash comparison.
- `LaborCoin-Compilation-Records` is the only repository that receives compiler artifacts and sealed compilation records.

## Compile order and matching artifact folder

| Order | Source folder | Contract | Compilation-record folder |
|---:|---|---|---|
| 1 | `01-policy` | `LaborCoinProposalTextPolicyV1` | `01-policy` |
| 2 | `02-identity-registry` | `LaborCoinIdentityRegistryV1` | `02-identity-registry` |
| 3 | `03-exchange` | `LaborCoinExchangeV7` | `03-exchange` |
| 4 | `04-token` | `LaborCoinV4` | `04-token` |
| 5 | `05-labrv` | `LaborVoteV9` | `05-labrv` |
| 6 | `06-registration` | `LaborCoinRegistrationV6` | `06-registration` |
| 7 | `07-governance` | `LaborCoinGovernanceV15` | `07-governance` |

Normal sources use package imports. `_Remix.sol` sources use exact OpenZeppelin 5.6.1 URLs. Both forms must produce equivalent contract bytecode under `COMPILER_PROFILE.json`.

Run the source-freeze checks from the repository root:

```powershell
python .\release\revision-7.2-source-freeze\tests\run_source_checks.py
```
