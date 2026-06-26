# LaborVote (LABRV) V7

## Address

`0x833242E933c675846D8f8982048FecA95B8e435A`

---

## Purpose

LaborVote (LABRV) is the governance token of the LaborCoin ecosystem.

Unlike LABR, which functions as the economic token of the system, LABRV exists solely to facilitate democratic participation in LaborCoin governance.

LABRV represents membership within the LaborCoin DAO and provides voting rights for treasury allocation proposals.

---

## Key Features

* ERC20Votes compatible
* One token per registered member
* Non-transferable (Soulbound)
* Delegation support
* Snapshot voting support
* Governance-only utility
* Immutable minting authority after deployment

---

## Governance Design

LABRV is intentionally soulbound.

Once issued, LABRV cannot be:

* Transferred
* Sold
* Traded
* Purchased
* Accumulated through market activity

Each registered member may possess only one LABRV token.

This design helps prevent governance capture through wealth concentration and ensures that voting participation is linked to DAO membership rather than token purchasing power.

---

## Voting Power

Each LABRV token represents one unit of governance participation.

Because LABRV is non-transferable and limited to one token per registered member, voting influence is distributed through membership rather than capital accumulation.

LABRV integrates with OpenZeppelin's ERC20Votes framework, enabling:

* On-chain vote delegation
* Historical vote snapshots
* Proposal vote accounting
* Transparent governance records

---

## Distribution

LABRV is minted only through successful registration with the LaborCoin DAO.

The registration system:

1. Verifies eligibility requirements.
2. Confirms identity verification criteria.
3. Assigns a unique membership number.
4. Mints one LABRV token if the member does not already possess one.

No public minting mechanism exists.

No market distribution exists.

No inflation mechanism exists.

---

## Minting Controls

LABRV uses a dedicated registration contract as its sole authorized minter.

Following deployment:

1. The registration contract is assigned as the LABRV minter.
2. The minter configuration is permanently locked.
3. Contract ownership is renounced.

After minter lock:

* No additional minters can be assigned.
* Minting authority cannot be redirected.
* Administrative control is removed.

This process ensures that governance membership issuance follows transparent and immutable rules.

---

## Security Features

LaborVote V7 includes:

* OpenZeppelin ERC20Votes implementation
* EIP-712 signature support
* Historical vote checkpointing
* Delegation support
* Immutable post-launch minting configuration
* Non-transferability enforcement

The contract does not include:

* Transfer functionality
* Trading functionality
* Administrative minting controls after lock
* Upgradeability mechanisms

---

## Immutability

LaborVote V7 is designed as permanent governance infrastructure.

After deployment and minter lock:

* Ownership is renounced.
* Minting configuration becomes immutable.
* Governance membership rules cannot be modified.

The contract continues operating according to its deployed logic without administrative intervention.

---

## Role in LaborCoin

LABRV serves as the democratic participation layer of the LaborCoin ecosystem.

Its purpose is to:

* Represent DAO membership
* Enable proposal voting
* Support treasury allocation decisions
* Provide transparent governance participation

LABRV is intentionally separated from LABR so that governance influence cannot be acquired through market purchases.

This distinction helps preserve democratic participation while allowing LABR to function as the economic token of the broader LaborCoin ecosystem.
