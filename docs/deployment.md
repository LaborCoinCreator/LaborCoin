# Revision 7.2 Deployment Plan

## Prohibition

Do not deploy from this source package until all seven contracts compile under the frozen profile, all artifacts are recorded, all tests pass, and an independent review is complete.

## Compile order

1. Proposal Text Policy V1.0.1
2. Identity Registry V1.0.1
3. Exchange V7.0.0
4. LABR V4.0.0
5. LaborVote V9.1.1
6. Registration V6.1.1
7. Governance V15.1.1

Record creation bytecode, runtime template, metadata, build-info, diagnostics, source hashes, compiler settings, and runtime hashes for every contract.

## Constructor planning

### Identity Registry V1

```text
verifier EOA
scorer ID hash
expected LABR runtime hash
```

### LABR V4

```text
Identity Registry address
expected Identity Registry runtime hash
expected Exchange runtime hash
```

### Exchange V7

```text
LABR address
Identity Registry address
expected Identity Registry runtime hash
```

### LaborVote V9.1

```text
LABR address
expected LABR runtime hash
expected Registration runtime hash
```

### Registration V6.1

```text
LABR address
LABRV address
Identity Registry address
expected LABR runtime hash
expected LABRV runtime hash
expected Identity Registry runtime hash
expected Registration runtime hash
```

### Proposal Text Policy V1

No constructor arguments.

### Governance V15.1

```text
LABRV address
Registration address
Proposal Text Policy address
expected LABRV runtime hash
expected Registration runtime hash
expected Proposal Text Policy runtime hash
```

## Deployment sequence

1. Verify Polygon chain ID 137, deployer balance, verifier address, scorer hash, DAO address, and source hashes.
2. Deploy Proposal Text Policy and verify exact runtime.
3. Deploy Identity Registry using the frozen LABR runtime hash.
4. Deploy LABR using Registry address/hash and Exchange runtime hash.
5. Call `IdentityRegistry.finalizeLaborCoin(LABR)` and verify owner zero.
6. Deploy Exchange using LABR, Registry, and Registry hash.
7. Call `LABR.finalizeLaunch(Exchange)` and verify owner zero and 1 billion LABR inventory at Exchange.
8. Verify `identityReady`, `launchReady`, curve reserve, inventory, tax constants, identity bindings, and zero member/dividend state.
9. Deploy LaborVote using LABR and the expected Registration hash.
10. Deploy Registration using LABR, LABRV, Registry, and all expected hashes.
11. Call `LaborVote.finalizeMinter(Registration)` and verify owner zero.
12. Verify Registration readiness, zero members, and `totalMembersBefore(0) == 0`.
13. Deploy Governance with final membership, registration, policy, and hashes.
14. Grant Aragon DAO execute permission to Governance V15.1.
15. Verify `governanceReady` and run a complete fork rehearsal including a member who registers after proposal creation but before its deadline, plus post-deadline registration stability.
16. Revoke Governance V13, Governance V12, Treasury Module V1, and every obsolete LaborCoin executor permission.
17. Update verifier environment, website config, address registries, deployment records, and whitepaper appendices.
18. Perform end-to-end identity, buy, dividend, sell, registration, proposal, vote, execution, and certificate tests.
19. Activate production only after all independent comparisons pass.

## Abort conditions

Abort the deployment if any runtime code hash, compatibility ID, constructor encoding, fixed constant, owner state, balance, permission, or test output differs from the sealed record. Do not improvise a replacement deployment from altered source without restarting compilation and review.
