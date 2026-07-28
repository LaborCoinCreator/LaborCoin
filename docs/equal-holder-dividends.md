# Equal-Holder Dividend Specification

## Canonical policy

Every verified wallet holding at least 1 LABR has exactly one dividend unit. Token wealth does not increase dividend weight.

```text
1 LABR      = 1 unit
100 LABR    = 1 unit
10,000 LABR = 1 unit
```

An unverified wallet has zero units regardless of balance.

## Distribution formula

For a dividend deposit `D` and `N` eligible holders:

```text
equal share per eligible holder = D / N
```

LABR uses magnified accounting to avoid iterating through every holder. The global accumulator advances by `D * MAGNITUDE / N`. Each eligible account has a synthetic balance of one unit and a correction that records when it entered or left the eligible set.

## Eligibility transitions

A wallet enters the set when all conditions become true:

- permanent Identity Registry status is verified;
- balance is at least 1 LABR;
- the account is not LABR, Exchange, Identity Registry, or the DAO treasury.

A wallet leaves when its balance falls below 1 LABR. Verification itself is permanent.

## Historical-entitlement protection

- A newly eligible holder receives no distribution deposited before entry.
- A holder that exits retains all amounts earned before exit.
- A former holder receives no distributions deposited while ineligible.
- Re-entry starts from the current accumulator and does not award missed distributions.
- Moving tokens cannot duplicate a past entitlement.

## Claims

Claims require the verified direct wallet. A wallet may claim previously accrued dividends even after its LABR balance falls below 1, because verification remains true and historical entitlement remains in accounting.

## Zero-holder deposits

If Exchange attempts to deposit the 5% holder allocation while no eligible holder exists, LABR redirects that POL to the DAO and emits an event. The amount is not reserved for a future first holder.

## Example

Assume 90 POL is deposited and three eligible wallets hold 1, 100, and 10,000 LABR. Each receives 30 POL. The largest holder receives no additional weight.

If a fourth verified wallet reaches 1 LABR after that deposit, it receives no portion of the prior 90 POL. A later 40 POL deposit is split four ways, yielding 10 POL to each eligible wallet.

## Sybil limitation

Equal-per-wallet distribution makes multi-wallet eligibility a direct economic risk. Identity Registry therefore gates both eligibility and claims. Each additional equal-share wallet must independently pass the same fixed Human Passport scorer. This is substantial friction but not a mathematical guarantee of one natural person per wallet.
