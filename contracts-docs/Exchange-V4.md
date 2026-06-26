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
* Oracle freshness validation
* Oracle anomaly protection
* Exchange wallet limit enforcement
* Exchange transaction limit enforcement
* Buy slippage protection
* Sell slippage protection
* Immutable contract design
* OpenZeppelin ReentrancyGuard protection
* Safe token transfer wrappers

---

## Economic Parameters

| Parameter                      | Value                                      |
| ------------------------------ | ------------------------------------------ |
| Total Supply                   | 1,000,000,000 LABR                         |
| Initial Tranche                | 100,000,000 LABR                           |
| Tranche Unlock Size            | 50,000,000 LABR                            |
| Cooldown                       | 12 Hours                                   |
| Max Exchange Wallet            | 10,000 LABR                                |
| Max Exchange Transaction       | 5,000 LABR                                 |
| Treasury Allocation            | 10% of POL purchases                       |
| Maximum Oracle-Protected Price | 100 POL per LABR                           |
| Chainlink POL/USD Oracle       | 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0 |

---

## Pricing Model

The exchange uses a deterministic quadratic bonding curve.

LABR pricing increases automatically as additional tokens are sold. The curve is calculated entirely on-chain and does not depend on external market makers or liquidity providers.

The curve uses a USD-denominated target price range of approximately $1 to $15 per LABR over the full 1,000,000,000 LABR supply distribution. POL/USD pricing data is supplied through the Chainlink oracle to convert the USD-denominated bonding curve price into POL.

The exchange caps accepted oracle-derived prices at 100 POL per LABR as an oracle anomaly protection mechanism.

---

## Supply Controls

LABR is released in tranches.

* Initial unlocked exchange supply is limited to 100,000,000 LABR.
* Additional tranches of 50,000,000 LABR unlock automatically as distribution milestones are reached.
* Total sold supply can never exceed 1,000,000,000 LABR.

This mechanism limits early distribution while preserving long-term availability.

---

## Wallet and Transaction Limits

The exchange enforces strict participation limits at the contract level.

| Limit                                                      | Value       |
| ---------------------------------------------------------- | ----------- |
| Maximum LABR held by a wallet for exchange participation   | 10,000 LABR |
| Maximum LABR purchased or sold in one exchange transaction | 5,000 LABR  |
| Cooldown between exchange transactions                     | 12 hours    |

On buys, the contract checks that the expected LABR output does not exceed the transaction limit and that the buyer's resulting LABR balance does not exceed the exchange wallet limit.

On sells, the contract checks that the seller's wallet balance does not exceed the exchange wallet limit and that the sold amount does not exceed the exchange transaction limit.

These limits are separate from any limits enforced by the LABR token contract itself.

---

## Treasury Funding

For each LABR purchase, 10% of the POL sent by the buyer is automatically forwarded to the DAO treasury.

The remaining POL stays in the exchange contract as liquidity for future seller payouts.

Sell transactions are paid from the exchange contract's POL liquidity balance according to the current bonding curve price.

---

## Security Features

The exchange includes:

* OpenZeppelin ReentrancyGuard
* 12-hour cooldown enforcement
* Supply tranche controls
* Oracle freshness validation
* Oracle anomaly protection
* Buy slippage protection through `minTokensOut`
* Sell slippage protection through `minPOL`
* Safe token transfer wrappers
* Contract-level wallet limits
* Contract-level transaction limits

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
* No post-deployment parameter modification functions

POL liquidity reserves held by the exchange are permanently dedicated to exchange operations and seller payouts.

---

## Role in LaborCoin

The exchange serves as the economic engine of the LaborCoin ecosystem by:

* Issuing LABR through deterministic market participation
* Providing a protocol-native buy and sell mechanism
* Funding the LaborCoin treasury through automated purchase taxes
* Enforcing transparent and predictable issuance rules
* Enforcing wallet and transaction limits for exchange participation
* Maintaining protocol-native POL liquidity for seller payouts

All pricing, issuance, treasury funding, liquidity retention, wallet limits, transaction limits, and tranche unlocking logic is performed entirely on-chain according to publicly verifiable rules.
