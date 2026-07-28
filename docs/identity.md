# Identity, Accessibility, and Sybil Resistance

## Permanent rule

A direct Polygon wallet becomes a verified LaborCoin participant after receiving a valid EIP-712 authorization for a Human Passport score of at least 15.000 and submitting it to Identity Registry V1.

Verification is:

- one-time;
- permanent;
- wallet-bound;
- nontransferable;
- non-revocable;
- recorded on-chain;
- reusable by Exchange, LABR dividends, and Registration.

## Why the threshold is 15

LaborCoin prioritizes accessibility for people creating a new wallet or with limited on-chain history. A higher threshold would increase exclusion and onboarding friction. The score-15 rule is combined with credential deduplication by the configured scorer, a strict direct-wallet policy, a 10,000 LABR wallet cap, a 5,000 LABR trade limit, and a 12-hour cooldown.

The protocol does not claim that score 15 proves unique personhood. It raises the cost of simple multi-wallet participation and makes each additional eligible wallet independently satisfy the same published scorer.

## EIP-712 authorization

The signed authorization binds:

```text
participant wallet
passport score in thousandths
fixed scorer ID hash
current on-chain nonce
expiry
Polygon chain ID
exact Identity Registry address
```

The authorization lifetime is at most one hour. The registry rejects the wrong signer, wallet, scorer, nonce, chain, contract, score, or expiry.

## Permanent status and outages

Once verified, a wallet does not need the verifier or Human Passport for later trades, claims, or registration. An outage blocks new verification but does not disable already verified participants.

This permanence reduces ongoing dependence but creates an irreversible consequence: status cannot be revoked even if credentials later change or the verifier was compromised. The launch process must therefore protect the verifier key and scorer configuration before deployment.

## Direct-wallet restriction

Core participation calls require `msg.sender == tx.origin` and no code at the participant address. Smart-contract wallets, multisignature wallets, account-abstraction wallets, relays, and delegated contract calls are excluded.

This narrows composability and can exclude legitimate users. It is retained because the project prioritizes predictable one-wallet interactions and resistance to contract-mediated bypasses.

## Privacy

The registry stores wallet address, verified status, accepted score, verification timestamp, and nonce. It does not store a legal name, government identifier, social account, biometric record, or complete Passport response. Wallet activity remains public and can be correlated with other on-chain or off-chain information.

## No Action ID requirement

Revision 7.2 does not require a government-ID, phone, or biometric Action ID. The score gate is the selected balance between accessibility and anti-Sybil friction. A future immutable deployment cannot add a stronger identity regime without a separate replacement protocol.
