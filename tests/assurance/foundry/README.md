# Revision 7.2 Foundry Test Scaffold

This scaffold intentionally contains no claim of executed Solidity tests. Add unit, fuzz, invariant, and Polygon-fork tests after the seven sources compile under the frozen profile.

Minimum suites:

- Identity authorization, nonce, expiry, wrong domain, and permanent status
- equal-holder entry, exit, re-entry, claim, zero-holder redirect, and randomized accounting
- Exchange curve, reserve, inventory, identity, limits, and 90/5/5 distribution
- LABR launch cycle, transfer restrictions, and cooldown
- LaborVote and Registration finalization and one-membership invariants
- Governance threshold, deadline-electorate, historical-registration, execution, expiry, recipient, text-policy, and Aragon permission tests
