# Compilation and On-Chain Verification

## Source status

The Revision 7.2 files in this repository are source candidates. No successful Solidity compilation is claimed by this package.

## Frozen compiler profile

```text
Solidity 0.8.36+commit.8a079791
OpenZeppelin 5.6.1
Optimizer 200
EVM Prague
Via IR false
Metadata bytecode hash ipfs
```

## Required record for each contract

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
