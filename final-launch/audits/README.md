# LaborCoin Audit Package

This directory contains the internal launch provenance and security review package for LaborCoin.

## Current status

**Immutable launch approval is withheld.** Permission cleanup, LABR ownership evidence, retired-exchange token cleanup, current balance snapshots, and a separately audited successor exchange remain outstanding.

## Start here

1. [`provenance-security-audit.md`](provenance-security-audit.md)
2. [`aragon-permission-audit.md`](aragon-permission-audit.md)
3. [`exchange-retirement-audit.md`](exchange-retirement-audit.md)
4. [`deployment-provenance-inventory.md`](deployment-provenance-inventory.md)

## Machine-readable working files

- [`revocation-plan.csv`](revocation-plan.csv)
- [`deployment-provenance-inventory.csv`](deployment-provenance-inventory.csv)

## Raw evidence

The `evidence/` directory preserves the supplied files without content changes. Their hashes are:

| File | Bytes | SHA256 |
| --- | --- | --- |
| deployment_candidates.csv | 14865 | bb80bdca369b1ecb870b9a98fed4d7a63c17ac4e102bae2b75891ae42b33f44e |
| exchange_cleanup_candidates.csv | 715 | b36cb21809da924da2c81c2de566907f655aca4b3d006589c2595d7e9851fbfe |
| initial-extraction.md | 31546 | 9b3910f0d941e4254b08a4f1503f22e043bd57e230e0dbc55dbe992ad981327b |
| legacy-audit-draft.md | 13092 | aee3e0a854369ffe3dce45654bb3a589cf0f36e5d80824bd0e5f178740c84086 |
| permission_events.csv | 15035 | 15592fd30bb76b70502e532500d921bdd2987491379e5a863d1cc1ae53ca785b |
| revocation_checklist.csv | 10798 | 369401fc234b878c6f9213301e7cc2e735f787542963706a77ead49a2d8f5444 |

## Evidence rule

Do not mark a permission, ownership transfer, configuration change, or revocation complete from narrative documentation alone. Record the transaction hash and a current post-state read at a specific block.

## Critical sequencing rule

Complete all LABR owner-required configuration and retired-exchange cleanup before removing the final Admin Plugin or other arbitrary DAO execution path. Remove direct administration last.
