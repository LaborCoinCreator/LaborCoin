# Revision 7.2 Test Status

## Current source state

Proposal Text Policy V1.1.1 and Governance V15.2.0 supersede their preceding compiled candidates. The current seven-contract source set therefore requires a controlled Policy/Governance precompilation refreeze, new Policy/Governance compilation records, and full structured-governance assurance before deployment.

## Passed against the current active sources

- Equal-holder accounting model tests.
- Historical member-count and deadline-electorate boundary/randomized tests.
- Static source guards for identity gating, protocol-only LABR movement, fixed limits, and version markers.
- Structured Treasury Proposal Schema V1 source guards.
- Proposal Text Policy V1.1.1 field-limit, validator-presence, and canonical IPFS-root source guards.
- Frontend Proposal Text Policy regression cases reject empty/punctuation/short malformed IPFS roots and accept representative CIDv0, CIDv1 base32, and CIDv1 base36 forms.
- Governance V15.2 closed-enum, Democratic Worker Enterprise Development, content-hash, and contract-recipient guards.

## Temporarily invalidated by the source revision

The preceding Policy V1.0.1 and Governance V15.1.1 source-freeze and compilation records do not represent the current structured-proposal candidates. Active-source/release-source equality is intentionally not restored until the controlled precompilation refreeze.

## Pending

1. Replace the Policy/Governance source-freeze and Remix copies with the reviewed V1.1.1/V15.2.0 active sources.
2. Run source-freeze checks and the complete Python assurance suite, then commit the exact source freeze.
3. Bind and commit the Compilation Records repository to that source commit before compilation.
4. Compile Policy V1.1.1 and Governance V15.2.0 under Solidity 0.8.36 and the exact frozen profile.
5. Record replacement Policy/Governance artifacts and bytecode evidence.
6. Run Solidity unit tests for all structured proposal fields, enums, text boundaries, URI rules, recipient-code requirement, `contentHash`, and `callId`.
7. Run fuzz, stateful invariant, Polygon-fork, and deployment-rehearsal tests.
8. Complete independent review.

This current source set must not be represented as fully recompiled or deployment-ready.
