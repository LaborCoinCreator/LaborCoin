# LaborCoin Registration V4

## Address

`0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C`

---

## Purpose

LaborCoin Registration V4 controls entry into LaborCoin governance.

The registration system serves as the gateway between economic participation and democratic participation within the LaborCoin ecosystem.

Users who hold LABR and successfully complete identity verification may register as LaborCoin members and receive LABRV governance rights.

Registration is designed to ensure that governance participation is earned through community membership rather than acquired through token accumulation alone.

---

## Registration Requirements

To register, a user must:

* Hold at least 1 LABR
* Complete identity verification
* Obtain a valid verifier signature
* Submit a valid registration request before signature expiration

Registration is voluntary.

Holding LABR alone does not grant governance rights.

---

## Registration Process

1. User acquires LABR.
2. User completes identity verification.
3. The verifier issues a signed registration authorization.
4. The user submits the authorization to the registration contract.
5. The contract validates all registration requirements.
6. A membership record is created.
7. A unique member number is assigned.
8. LABRV governance rights are issued.

---

## Key Features

* One-time registration
* Minimum LABR holding requirement
* Verifier signature validation
* Signature expiration protection
* Membership tracking
* Sequential member numbering
* Registration timestamp tracking
* Automatic LABRV issuance
* Immutable verifier configuration

---

## Membership System

Each successful registration receives a permanent sequential member number.

Examples:

| Member                   | Assigned ID |
| ------------------------ | ----------- |
| First Registered Member  | 1           |
| Second Registered Member | 2           |
| Third Registered Member  | 3           |

Member numbers are assigned automatically and permanently recorded on-chain.

This provides a transparent historical record of LaborCoin membership growth.

---

## Registration Records

The contract maintains:

* Registration status
* Member number
* Registration timestamp
* Total registered member count

These records can be queried directly on-chain and provide a publicly verifiable membership registry.

---

## Governance Integration

Upon successful registration, the contract checks whether the member already possesses LABRV.

If not, the registration contract automatically mints one LABRV governance token to the registering member.

Each registered member may possess only one LABRV governance token.

This process establishes the connection between membership registration and governance participation.

---

## Replay Protection

Registration V4 includes signature expiration protection.

Verifier signatures are generated using:

* Wallet address
* Expiration timestamp

Expired signatures are rejected by the contract.

This prevents indefinite reuse of historical verification signatures while preserving a simple and auditable registration process.

---

## Security Features

Registration V4 includes:

* ECDSA signature verification
* Expiration-based replay protection
* Immutable verifier address
* One-time registration enforcement
* Membership uniqueness protection
* Automatic governance token issuance safeguards

The contract contains:

* No owner
* No administrator
* No pause controls
* No upgradeability mechanisms

---

## Immutability

The verifier address is configured during deployment and cannot be changed.

After deployment:

* Registration requirements remain fixed
* Membership records remain permanent
* Governance issuance rules remain unchanged

The contract operates according to transparent and publicly verifiable rules without administrative intervention.

---

## Role in LaborCoin

Registration V4 serves as the bridge between economic participation and democratic participation.

LABR enables participation in the economic system.

Registration establishes membership.

LABRV enables governance participation.

This separation helps ensure that governance rights are linked to verified membership rather than simple token ownership, while preserving open access to the broader LaborCoin economy.
