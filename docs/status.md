# LaborCoin Revision 7.2 Status

## Current classification

**PREDEPLOYMENT SOURCE REVISION - PRECOMPILATION REFREEZE REQUIRED**

## Completed and retained

- Corrected equal-per-verified-holder dividend policy.
- Shared permanent score-15 Identity Registry design.
- Identity-gated official buys and sells.
- Permanent protocol-only LABR transfers that block peer movement and unofficial on-chain markets.
- Identity-gated dividend eligibility and claims.
- Registration reuse of shared verified status.
- Registration V6.1 historical member checkpoints and deadline-electorate voting model.
- Five unchanged contracts retain their previously recorded Revision 7.2 compilation evidence: Identity Registry V1.0.1, Exchange V7.0.0, LABR V4.0.0, LaborVote V9.1.1, and Registration V6.1.1.

## Current source revision

- Proposal Text Policy V1.1.1 replaces the old general-description policy with independent short-text and verification-URI validation and tightens IPFS roots to canonical CIDv0 base58btc or CIDv1 base32/base36 forms.
- Governance V15.2.0 replaces the unrestricted proposal description with Structured Treasury Proposal Schema V1.
- Purpose, contact method, and distribution plan are closed on-chain enums.
- `DemocraticWorkerEnterpriseDevelopment` is a permanent distribution-plan category.
- Proposal recipients must contain deployed contract code; ordinary EOAs are rejected.
- Each proposal receives a deterministic `contentHash` over the complete structured proposal, and the execution `callId` binds that commitment.
- The governance site has been migrated to the same structured schema and no longer presents a proposal-description textarea.
- Public documentation, site presentation, and assurance guards are synchronized to the structured proposal architecture.

The prior Policy V1.0.1 and Governance V15.1.1 compilation records and frozen release copies are superseded for deployment purposes. They remain evidence of the earlier reviewed candidate until replacement records are produced; they must not be deployed as the current Revision 7.2 system.

## Pending before deployment

1. Synchronize Proposal Text Policy V1.1.1 and Governance V15.2.0 into the authoritative Revision 7.2 source-freeze and Remix source copies.
2. Run the source-freeze and assurance checks, then commit and push that exact precompilation source state.
3. Bind `LaborCoin-Compilation-Records` to the full source commit, verify the expected `PRECOMPILATION PENDING` state, and commit that binding before compilation.
4. Compile Proposal Text Policy V1.1.1 and Governance V15.2.0 under the exact frozen compiler profile.
5. Replace only the corresponding Policy/Governance compilation records and verify the five unchanged records against the committed source/runtime dependency graph.
6. Run the complete Solidity unit, fuzz, stateful invariant, Polygon-fork, and deployment-rehearsal suites against the frozen structured schema.
7. Complete independent security review, constructor/runtime cross-checks, permission migration rehearsal, verifier/site cutover checks, and final launch approval.
