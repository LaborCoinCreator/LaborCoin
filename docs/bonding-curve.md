# POL Bonding Curve

Exchange V7 uses a direct-POL quadratic integral curve.

## Marginal function

```text
S = 1,000,000,000 LABR
x = sold / S
P(x) = 14 + 196x^2 POL per LABR
```

## Integral

```text
F(s) = 14s + (196/3) * s^3 / S^2
```

The contract evaluates exact-token buy and sell intervals using integer arithmetic. Purchase arithmetic must never undercharge the required curve reserve. Sale arithmetic must never overpay the available curve reserve.

## Economic interpretation

The marginal price increases from 14 POL to 210 POL as official net distribution progresses from zero to full supply. The protocol makes no fiat-value promise. POL volatility changes the external purchasing power of every quoted amount.

See [Exchange V7](exchange.md) and the [technical whitepaper](whitepaper.md) for the full specification.
