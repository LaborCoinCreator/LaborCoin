# Compilation and On-Chain Verification

## Source status

A complete seven-contract Revision 7.2 candidate was previously compiled and recorded. Proposal Text Policy V1.1.1 and Governance V15.2.0 now supersede the previously compiled Policy V1.0.1 and Governance V15.1.1 candidates. Those two old records are not valid deployment evidence for the current structured-proposal source.

The other five contract sources are unchanged and retain their recorded Revision 7.2 predeployment compilation evidence, subject to final dependency/runtime cross-checks.

The required provenance sequence for the two changed contracts is:

1. synchronize and re-freeze the exact current Policy V1.1.1 and Governance V15.2.0 sources, including pinned Remix copies and source manifest hashes;
2. run source checks and commit that exact source freeze;
3. bind `LaborCoin-Compilation-Records` to the full source commit and commit the precompilation binding;
4. compile Policy V1.1.1 and Governance V15.2.0 from that frozen source under the exact profile below;
5. replace and seal only their numbered compilation records;
6. rerun complete cross-contract, runtime, unit, fuzz, invariant, fork, and deployment-rehearsal verification.

Deployment testing, Polygon-fork rehearsal, mainnet deployment, and on-chain runtime verification remain pending.

## Frozen compiler profile

```text
Solidity 0.8.36+commit.8a079791
OpenZeppelin 5.6.1
Optimizer 200
EVM Prague
Via IR false
Metadata bytecode hash ipfs
```

## Required compilation evidence for each current contract

- exact normal source;
- exact Remix source with pinned imports;
- compiler settings JSON;
- Remix artifact JSON;
- metadata JSON;
- build-info JSON;
- all compiler diagnostics;
- creation bytecode length and Keccak-256;
- deployed runtime template length and Keccak-256;
- immutable-reference map;
- source SHA-256;
- sealed compilation-record ZIP and SHA-256.

## Runtime verification

After deployment, obtain on-chain runtime code and compare its Keccak-256 against the expected deployed runtime. For Governance, reconstruct immutable insertions from final addresses before calculating the expected deployed runtime.

Source-code verification on PolygonScan is useful but does not replace direct runtime comparison.

## Final address registry

Do not place a replacement address in active documentation or frontend configuration until:

1. deployment transaction is confirmed;
2. runtime code is present;
3. runtime hash matches;
4. constructor values match the sealed record;
5. finalization state is correct;
6. ownership state is correct;
7. cross-contract bindings match;
8. relevant tests pass.
