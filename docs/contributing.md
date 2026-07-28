# Contributing

LaborCoin Revision 7.2 is being prepared as immutable public infrastructure. Changes must preserve exact source provenance and must not blur active release files with prelaunch drafts.

- Modify active Solidity only in `contracts/`.
- Rebuild the matching `release/revision-7.2-source-freeze/` copy and `SOURCE_MANIFEST.json` whenever an active source changes.
- Do not add compiler artifacts to this repository.
- Do not add superseded source trees or incomplete revision archives to the public release.
- Keep known deployed test addresses in `docs/prelaunch-deployments.md` until retirement and permission revocation are complete.
- Any source change after compilation begins invalidates the affected compilation record and requires a new reviewed source freeze.
