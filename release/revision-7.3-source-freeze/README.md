# LaborCoin Revision 7.3 Precompilation Source Freeze

Status: PRECOMPILATION_SOURCE_FREEZE

Authoritative source-freeze commit:

`f5a1b200a6f703538b88319d5135b20f36dbae1c`

Branch:

`revision-7.3`

This directory records the exact seven-contract source set selected for LaborCoin Revision 7.3 predeployment compilation and testing.

The authoritative source commit is the Git commit identified above. This release directory is a post-commit evidence snapshot of those sources and does not replace or redefine the authoritative source commit.

## Active Revision 7.3 contracts

1. LaborCoinProposalTextPolicyV1
2. LaborCoinIdentityRegistryV1
3. LaborCoinExchangeV7
4. LaborCoinV4
5. LaborVoteV9
6. LaborCoinRegistrationV6
7. LaborCoinGovernanceV16

Revision 7.3 changes include the final DAO treasury binding, LaborCoin Exchange V7.1.0, LaborCoin V4.1.0, and LaborCoin Governance V16.0.0 with Structured Treasury Proposal Schema V2 multi-asset governance.

The source freeze precedes the official Revision 7.3 compilation records. Compiler artifacts, metadata, build-info files, compilation records, and sealed compilation packages do not belong in this source-freeze directory.

Each contract directory contains:

- the canonical repository source;
- the Remix-compatible source using pinned OpenZeppelin v5.6.1 raw GitHub imports; and
- the compiler settings corresponding to `COMPILER_PROFILE.json`.

Run the source validation with:

`python .\release\revision-7.3-source-freeze\tests\run_source_checks.py`

A successful validation must end with:

`REVISION 7.3 SOURCE CHECKS: PASS`