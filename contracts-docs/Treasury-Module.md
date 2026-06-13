# Treasury Module

## Address

`0x0B018E45E4cB71E222C345a5341BdbaeE519c623`

## Purpose

The Treasury Module acts as the dedicated treasury distribution component of LaborCoin.

It receives treasury funds and executes approved distributions.

## Features

- DAO-only execution
- Recipient validation
- Distribution tracking
- Transfer event logging

## Security

Only the DAO may instruct the Treasury Module to transfer funds.

The module cannot independently initiate distributions.

## Transparency

All treasury distributions are recorded on-chain and publicly auditable.
