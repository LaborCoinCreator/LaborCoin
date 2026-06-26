# LaborCoin Exchange V4

## Address

```text
0x4Cf18cB39203B678f5C26f2338a10a79f9684749
```

---

## Purpose

The LaborCoin Exchange contract provides the primary entry and exit point for LABR.

Users purchase LABR directly from the protocol using POL through a deterministic bonding curve. The exchange also allows users to sell LABR back to the protocol according to the same pricing model.

The contract is designed to operate as immutable public infrastructure with no privileged administrative controls after deployment.

---

## Key Features

* On-chain bonding curve pricing
* Deterministic pricing model
* Automatic treasury funding
* Supply tranche unlocking
* 12-hour cooldown enforcement
* Chainlink POL/USD oracle integration
* Oracle anomaly protection
* Immutable contract design
* OpenZeppelin ReentrancyGuard protection

---

## Economic Parameters

| Parameter           | Value                |
| ------------------- | -------------------- |
| Total Supply        | 1,000,000,000 LABR   |
| Initial Tranche     | 100,000,000 LABR     |
| Tranche Unlock Size | 50,000,000 LABR      |
| Cooldown            | 12 Hours             |
| Treasury Allocation | 10% of POL purchases |

---

## Pricing Model

The exchange uses a deterministic quadratic bonding curve.

LABR pricing increases automatically as additional tokens are sold. The curve is calculated entirely on-chain and does not depend on external market makers or liquidity providers.

POL/USD pricing data is supplied through the Chainlink oracle to maintain consistent curve behavior relative to USD-denominated target pricing.

---

## Supply Controls

LABR is released in tranches.

* Initial circulating supply is limited to 100,000,000 LABR.
* Additional tranches of 50,000,000 LABR unlock automatically as distribution milestones are reached.
* Total supply can never exceed 1,000,000,000 LABR.

This mechanism limits early distribution while preserving long-term availability.

---

## Security Features

The exchange includes:

* OpenZeppelin ReentrancyGuard
* 12-hour cooldown enforcement
* Supply tranche controls
* Oracle freshness validation
* Oracle anomaly protection
* Buy slippage protection
* Sell slippage protection

The contract contains no pause functionality, no owner privileges, and no administrative withdrawal mechanisms.

---

## Immutability

LaborCoin Exchange V4 is designed as immutable public infrastructure.

The final launch version contains:

* No owner
* No administrator
* No pause controls
* No treasury withdrawal controls
* No ownership transfer functionality

POL liquidity reserves held by the exchange are permanently dedicated to exchange operations and seller payouts.

---

## Role in LaborCoin

The exchange serves as the economic engine of the LaborCoin ecosystem by:

* Issuing LABR through deterministic market participation
* Providing a protocol-native buy and sell mechanism
* Funding the LaborCoin treasury through automated purchase taxes
* Enforcing transparent and predictable issuance rules

All pricing, issuance, treasury funding, and tranche unlocking logic is performed entirely on-chain according to publicly verifiable rules.
