# LaborCoin Final Launch Testing Checklist

This document records the testing and validation procedures completed prior to final deployment.

All critical protocol functionality should be tested using multiple wallets before launch.

---

## Testing Environment

Network: POL Mainnet 137

Deployment Date: Site-Files finalized June-30-2026

Tester(s):

Build Environment Reference:

deployment-records/build-environment.md

---

# Registration System

## Registration Test

Objective:

Verify successful registration and LABRV issuance.

Steps:

1. Acquire at least 1 LABR.
2. Complete identity verification.
3. Obtain verifier signature.
4. Register through the DAO interface.

Expected Result:

* Registration succeeds.
* Member number assigned.
* Registration timestamp recorded.
* LABRV minted.

Status:

* [ ] Passed

Notes:

---

## Duplicate Registration Test

Objective:

Verify one-time registration enforcement.

Steps:

1. Register successfully.
2. Attempt to register again.

Expected Result:

Transaction reverts with:

```text
Already registered
```

Status:

* [ ] Passed

Notes:

---

## Replay Protection Test

Objective:

Verify signature expiration protection.

Steps:

1. Generate valid registration signature.
2. Modify expiration value.
3. Attempt registration.

Expected Result:

Transaction reverts with:

```text
Not verified
```

Status:

* [ ] Passed

Notes:

---

## Expired Signature Test

Objective:

Verify expired signatures cannot be used.

Steps:

1. Generate valid registration signature.
2. Wait until expiration.
3. Attempt registration.

Expected Result:

Transaction reverts with:

```text
Signature expired
```

Status:

* [ ] Passed

Notes:

---

# LaborVote (LABRV)

## Governance Token Mint Test

Objective:

Verify LABRV issuance during registration.

Expected Result:

* One LABRV minted.
* Voting power assigned.

Status:

* [ ] Passed

Notes:

---

## Soulbound Enforcement Test

Objective:

Verify LABRV cannot be transferred.

Steps:

1. Attempt LABRV transfer.

Expected Result:

Transaction reverts.

Status:

* [ ] Passed

Notes:

---

## Delegation Test

Objective:

Verify ERC20Votes delegation functionality.

Steps:

1. Delegate voting power.
2. Verify vote checkpoint updates.

Expected Result:

Delegation succeeds.

Status:

* [ ] Passed

Notes:

---

# Exchange

## Buy Test

Objective:

Verify LABR purchases.

Steps:

1. Purchase LABR with POL.

Expected Result:

* LABR received.
* Treasury allocation sent.
* totalSold updated.

Status:

* [ ] Passed

Notes:

---

## Sell Test

Objective:

Verify LABR sales.

Steps:

1. Approve LABR.
2. Sell LABR to exchange.

Expected Result:

* POL received.
* totalSold reduced.

Status:

* [ ] Passed

Notes:

---

## Cooldown Test

Objective:

Verify cooldown enforcement.

Steps:

1. Execute buy or sell.
2. Attempt second transaction immediately.

Expected Result:

Transaction reverts with:

```text
Cooldown
```

Status:

* [ ] Passed

Notes:

---

## Oracle Validation Test

Objective:

Verify POL price retrieval.

Expected Result:

* Valid price returned.
* No stale data errors.

Status:

* [ ] Passed

Notes:

---

## Tranche Unlock Test

Objective:

Verify automatic tranche unlocking.

Expected Result:

* unlockedSupply increases when thresholds are reached.

Status:

* [ ] Passed

Notes:

---

# Governance

## Proposal Creation Test

Objective:

Verify proposal creation.

Expected Result:

* Proposal created successfully.
* Proposal recorded on-chain.

Status:

* [ ] Passed

Notes:

---

## Voting Test

Objective:

Verify voting functionality.

Steps:

1. Create proposal.
2. Vote from multiple wallets.

Expected Result:

Votes recorded correctly.

Status:

* [ ] Passed

Notes:

---

## Quorum Validation Test

Objective:

Verify participation requirements.

Expected Result:

* Proposal fails when quorum is not met.

Status:

* [ ] Passed

Notes:

---

## Approval Threshold Test

Objective:

Verify approval percentage requirements.

Expected Result:

* Proposal executes only when threshold is met.

Status:

* [ ] Passed

Notes:

---

## Execution Window Test

Objective:

Verify execution timing restrictions.

Expected Result:

* Execution only permitted during valid execution window.

Status:

* [ ] Passed

Notes:

---

# Treasury Module

## Treasury Execution Test

Objective:

Verify treasury distribution execution.

Steps:

1. Pass governance proposal.
2. Execute approved proposal.

Expected Result:

* Funds transferred successfully.
* Treasury records updated.
* Execution event emitted.

Status:

* [ ] Passed

Notes:

---

# Multi-Wallet Integration Test

Objective:

Verify complete system operation across multiple participants.

Participants:

Wallet A:

Wallet B:

Wallet C:

Wallet D:

Expected Result:

* Registration works.
* Governance works.
* Exchange works.
* Treasury execution works.

Status:

* [ ] Passed

Notes:

---

# Final Launch Validation

* [ ] Registration system operational
* [ ] Replay protection operational
* [ ] LABRV minting operational
* [ ] LABRV transfer restrictions operational
* [ ] Exchange buy functionality operational
* [ ] Exchange sell functionality operational
* [ ] Cooldown enforcement operational
* [ ] Oracle integration operational
* [ ] Tranche unlocking operational
* [ ] Governance proposal creation operational
* [ ] Governance voting operational
* [ ] Governance execution operational
* [ ] Treasury execution operational
* [ ] Multi-wallet testing completed
* [ ] All contracts verified
* [ ] Deployment records completed

---

## Final Certification

All required testing has been completed and reviewed prior to final launch deployment.

Testing Date:

Reviewed By:

Result:

* [ ] Approved for Final Deployment
