# Security Architecture and Threat Model

## Security posture

Revision 7.2 is designed to minimize post-launch contract authority, constrain economic and governance behavior, and make deployment substitution detectable. Immutability does not guarantee correctness. A defect, mistaken constant, unexpected interaction, or compromised external dependency may be permanent.

## Principal controls

| Threat | Control | Residual risk |
|---|---|---|
| Substitute contract at launch | Runtime-code commitments and compatibility IDs | Incorrect source could still be faithfully committed |
| Multi-wallet Exchange access | Permanent score-15 identity gate | Passport is not mathematical unique-person proof |
| Wealth-weighted dividends | One synthetic unit per eligible holder | Multiple independently verified wallets can still multiply units |
| Historical dividend theft | Magnified correction accounting | Integer rounding and implementation defects require testing |
| Exchange insolvency | Integral reserve and inventory invariants | Forced POL is trapped; chain or code failure remains |
| Whale activity | Protocol-only transfers, 10,000 wallet cap, 5,000 trade cap, 12-hour cooldown | Independently verified and funded wallets remain possible |
| Contract-mediated bypass | Direct EOA and strict-wallet rules | Excludes legitimate smart-wallet users |
| Verifier replay | Nonce, chain, registry, scorer, score, expiry binding | Verifier-key compromise can authorize bad wallets |
| Governance wealth capture | One nontransferable LABRV per registrant | Identity system can still admit coordinated participants |
| Arbitrary DAO action | One native-POL transfer with empty calldata | Recipient misuse cannot be prevented after transfer |
| Malicious proposal text | Immutable Text Policy | Fixed policy can reject legitimate content or miss undesirable content |
| Permission persistence | Explicit Aragon grant and revocation checklist | DAO permission system is external to custom contracts |
| Frontend compromise | Fail-closed config, pinned dependencies, source review | Domain, host, RPC, CDN, and service worker remain mutable surfaces |

## Verifier security

The verifier is a narrow signer. Startup must fail if the chain, Registry code, Registry address, verifier address, scorer hash, threshold, or launch-ready state differs from expected values. The private key must never be committed, logged, embedded in frontend code, or reused for unrelated transactions.

A compromised verifier can permanently verify unauthorized wallets. There is no revocation. Key generation, secret storage, deployment access, and final environment-variable review are launch-critical controls.

## Identity-provider dependence

New verification depends on Human Passport and the configured scorer. Already verified wallets continue during provider or verifier outages. New participants cannot verify until service returns. The protocol cannot change the scorer or threshold after launch.

## Equal-holder dividend risks

Equal dividends align the economic design with one participant, one share, but they increase the value of multi-wallet identity abuse. Tests must prove entry, exit, re-entry, peer-transfer rejection, authorized Exchange settlement, claim, zero-holder, rounding, and forced-POL behavior across large randomized sequences.

## Direct-wallet risks

`tx.origin` and code-length checks deliberately reject smart wallets and relays. They do not prove natural-person uniqueness and can be affected by future account-model changes. The design chooses narrow compatibility over broad composability.

## Governance and treasury risks

A valid vote can transfer irreversible POL to an incorrect, compromised, or malicious recipient. The contract cannot evaluate labor legitimacy or recover funds. Participants must perform off-chain diligence. The per-proposal cap does not prevent repeated approved transfers.

## Immutable-launch risks

The temporary launch owners exist only to bind cyclic dependencies. Losing a launch key before finalization can strand the release. Finalizing the wrong address is prevented by commitments but an incorrect committed source remains possible. Every deployment transaction must be simulated, recorded, and verified before authority is renounced.
