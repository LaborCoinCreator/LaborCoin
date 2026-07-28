# Revision 7.2 Testing Requirements

## Current status

Source guards and documentation checks may run before compilation. Solidity unit, fuzz, invariant, fork, deployment, and end-to-end tests remain mandatory and pending.

## Identity Registry

Test wrong chain, zero inputs, wrong LABR runtime, wrong Registry binding, premature verification, score below 15, wrong signer, wrong scorer, wrong nonce, wrong participant, wrong chain, wrong Registry address, expired authorization, authorization over one hour, replay, already verified, direct-wallet requirement, owner renunciation, and atomic LABR eligibility synchronization.

## Equal-holder dividends

Prove:

- 1 LABR and 10,000 LABR receive equal distributions;
- N eligible holders receive N equal units;
- unverified holders receive zero;
- new entrants receive no history;
- exits retain accrued value;
- exits receive no future value;
- re-entry receives no missed value;
- peer transfers always revert and cannot duplicate accrual;
- claims cannot exceed entitlement;
- zero-holder funds redirect exactly to DAO;
- integer residue is bounded and cannot be captured by entry timing;
- random buy, sell, verification, deposit, and claim sequences preserve accounting invariants.

## Exchange

Test all curve boundaries, randomized quote intervals, tranche boundaries, exact-token rounding, reserve equality, inventory equality, forced POL, excess POL, refund behavior, slippage, deadlines, identity gate, wallet >10,000 bar, 10,000 exact behavior, 5,000 trade maximum, cooldown, peer-transfer rejection, direct transfers to Exchange, arbitrary allowance rejection, sell distribution, and zero-holder dividend redirection.

## Membership and governance

Test one-time registration, shared identity requirement, 1 LABR threshold, LABRV finalization, nontransferability, member-number timestamp indexing, binary-search historical counts, 50-member activation, voting by members who join before an active proposal deadline, exclusion at and after the deadline, final-electorate stability after later registrations, ceiling thresholds, active-proposal restriction, proposal text policy, recipient restrictions, 5% cap, execution window, Aragon permission, repeated execution prevention, and complete state transitions.

## Integration

Run local and Polygon-fork tests for:

1. verify wallet;
2. buy LABR;
3. confirm equal-holder entry;
4. deposit sell dividend with multiple unequal balances;
5. claim equal amounts;
6. sell and exit eligibility;
7. prove transfers to verified wallets, unverified wallets, contracts, and Exchange all revert while official buys and sells succeed;
8. register and mint LABRV;
9. create a proposal, register an additional member during voting, vote from that member, close voting, register another member, prove the result is unchanged, and execute;
10. confirm website and verifier match exact deployed ABIs and domains.
