# Registration V6.1 and LaborVote V9.1

## Registration requirements

A participant may register once when:

- the caller is a direct EOA;
- Identity Registry reports the wallet verified;
- the wallet holds at least 1 LABR;
- the wallet has not registered before;
- the wallet holds no LABRV;
- LaborVote has finalized Registration as its sole minter.

Registration no longer validates a second Passport signature. The permanent shared Identity Registry is the sole identity source.

## State changes

A successful registration:

1. increments `totalMembers`;
2. assigns a permanent sequential member number;
3. records the registration timestamp for the wallet and sequential member number;
4. records the wallet as registered;
5. mints exactly 1 LABRV.

The transaction reverts atomically if the membership mint fails. `totalMembersBefore(timestampExclusive)` uses bounded binary search over the immutable member-number timestamp index so Governance can reconstruct the electorate that existed before any proposal deadline.

## LaborVote V9.1

LABRV is a minimal ERC-20-shaped membership record with 18 decimals and one unit equal to `1 ether`. Transfers, approvals, `transferFrom`, and burns revert. There is no delegation, permit, checkpoint, or balance-weighted vote mechanism.

The temporary launch owner may finalize exactly one Registration V6.1 runtime. Finalization stores Registration, locks the minter, and sets owner to zero in one transaction.

## Registration permanence

Registration cannot be revoked, transferred, or repeated. Losing the wallet can therefore mean losing governance participation associated with that membership. No administrator or recovery procedure exists.

## Certificate

The website may generate a local membership certificate after confirming on-chain membership. The certificate is a convenience artifact, not an authority source. Registration and member number on Polygon are authoritative.
