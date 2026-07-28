# Exchange V7

## Purpose

Exchange V7 is the only official LABR distribution and redemption venue. It holds undistributed LABR, maintains the integral-curve reserve, sends fixed contributions to the DAO, and deposits the sell-side holder allocation into LABR's equal-holder dividend system.

## Access rules

A participant must be:

- permanently verified in Identity Registry V1;
- a direct EOA on Polygon;
- at or below the 10,000 LABR official wallet maximum;
- outside the 12-hour cooldown;
- within the 5,000 LABR transaction maximum.

These checks are enforced in contracts. The frontend is guidance, not the security boundary.

## Whale rule

A wallet holding more than 10,000 LABR is completely barred from both official buying and official selling. At exactly 10,000 LABR it cannot buy more but may sell when other conditions pass.

## Curve

Let `S = 1,000,000,000 LABR`, `s` be total distributed supply, and `x = s/S`.

```text
P(s) = 14 + 196x^2 POL per LABR
```

The integral reserve function is:

```text
F(s) = 14s + (196/3) * s^3 / S^2
```

Exact-token buys add `F(s+a)-F(s)` to reserve. Exact-token sells remove `F(s)-F(s-a)` from reserve. Solidity uses integer arithmetic, explicit scaling, ceiling division where the protocol must not undercharge, and floor division where the protocol must not overpay.

## Allocations

### Buy

```text
90% economic amount enters curve reserve
10% is sent to the DAO
```

More precisely, the contract calculates the curve reserve contribution for the exact token amount and then adds a DAO contribution equal to one ninth of the reserve amount so the DAO receives 10% of total input.

### Sell

```text
90% of gross curve redemption to seller
5% to DAO
5% to equal-holder dividends
```

The seller's returned LABR is transferred before the dividend deposit. If the sale causes the seller to fall below 1 LABR, the seller exits eligibility before that sale's dividend is allocated.

## Tranches

The initial unlocked inventory is 100,000,000 LABR. Capacity expands in 50,000,000 LABR tranches as required until the fixed supply is available. Unlocking does not mint tokens or change total supply.

## Solvency invariants

- `accountedReserve == curveReserveAt(totalSold)`
- Exchange LABR inventory equals `MAX_SUPPLY - totalSold`
- Exchange native POL balance is at least `accountedReserve`
- LABR reports Exchange as its official Exchange
- LABR and Exchange report the same Identity Registry and runtime commitment

Forced POL above accounted reserve remains trapped because there is no recovery function.
