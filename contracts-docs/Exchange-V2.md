# LaborCoin Exchange V2

## Address

`0xD0692ec758bb852421B702B187b6439f74f8Bf3b`

## Purpose

The Exchange contract provides the primary entry and exit point for LABR.

Users purchase LABR directly from the protocol using POL through a deterministic bonding curve. The exchange also processes LABR sales and distributes treasury funding through protocol-defined taxes.

## Key Features

- On-chain bonding curve pricing
- Deterministic pricing model
- Automatic treasury funding
- Holder reward distribution
- Supply tranche unlocking
- 12-hour cooldown enforcement
- Transaction limits
- Wallet limits
- Reentrancy protection

## Economic Parameters

| Parameter | Value |
|------------|------------|
| Total Supply | 1,000,000,000 LABR |
| Initial Tranche | 100,000,000 LABR |
| Tranche Unlock Size | 50,000,000 LABR |
| Cooldown | 12 Hours |

## Security

Exchange V2 includes:

- Reentrancy protection
- Cooldown enforcement
- Supply controls
- Ownership transfer safeguards
- Pause functionality

## Role in LaborCoin

The exchange serves as the economic engine of the LaborCoin ecosystem by managing token issuance, treasury funding, and market participation.
