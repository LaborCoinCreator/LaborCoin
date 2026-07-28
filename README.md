# LaborCoin

LaborCoin is a Polygon protocol for building a transparent native-POL treasury and allocating that treasury through constrained one-member-one-vote governance for worker support, strikes, labor actions, and mutual aid.

## Current release status

**Revision 7.2 is a frozen source candidate. It has not been compiled, audited, deployed, or activated.**

Revision 7.2 corrects the dividend policy, introduces a shared immutable identity layer, and makes LABR permanently non-peer-transferable. The permanent economic and transfer rules are:

> One verified holder with at least 1 LABR receives one equal dividend share. Holding additional LABR does not increase dividend weight. LABR moves only through the immutable official Exchange for verified purchases and sales.

The active candidate contains seven contracts:

| Order | Contract | Candidate version | Role |
|---:|---|---|---|
| 1 | Proposal Text Policy | V1.0.1 | Immutable proposal-description validation |
| 2 | Identity Registry | V1.0.1 | Permanent score-15 Human Passport verification |
| 3 | Exchange | V7.0.0 | Identity-gated POL bonding-curve buys and sells |
| 4 | LABR | V4.0.0 | Fixed-supply protocol-restricted token and equal-holder dividend accounting |
| 5 | LaborVote | V9.1.1 | One permanent nontransferable LABRV membership unit |
| 6 | Registration | V6.1.1 | Shared-identity governance registration |
| 7 | Governance | V15.1.1 | One-member-one-vote Aragon treasury execution |

The existing Aragon DAO treasury remains:

```text
0x0C2e5679153593b82a84eAB5CA90895BB291Cec4
```

All Revision 7.2 replacement contract addresses are `DEPLOYMENT_PENDING`.

## Permanent protocol rules

### Identity

- Human Passport score threshold: 15.000.
- Verification is one-time, wallet-bound, permanent, and recorded on-chain.
- Verification cannot be revoked, reassigned, or administered after finalization.
- Official buys, official sells, dividend eligibility, dividend claims, and governance registration require verified status.
- Human Passport reduces simple Sybil behavior but cannot mathematically prove one natural person controls only one wallet.

### Dividends

- Minimum eligible balance: 1 LABR.
- Every verified eligible holder has exactly one dividend unit.
- A holder with 10,000 LABR receives the same share as a holder with 1 LABR.
- Newly eligible holders receive no historical dividends.
- Departing holders keep already accrued dividends but receive no future distributions.
- If no eligible holder exists, the sale dividend allocation is redirected to the DAO.

### LABR transfer policy

- Peer-to-peer LABR transfers are permanently disabled.
- The immutable official Exchange is the only permitted transfer operator.
- Exchange-to-buyer movements require a verified purchase.
- Seller-to-Exchange movements require a verified sale and Exchange-only allowance.
- Direct deposits to Exchange, arbitrary approvals, wrappers, bridges, liquidity pools, and unofficial on-chain LABR markets are rejected.

### Official Exchange

- Maximum trade: 5,000 LABR.
- Maximum wallet: 10,000 LABR.
- Cooldown: 12 hours.
- Wallets holding more than 10,000 LABR are completely barred from both official buying and official selling.
- Buy allocation: 90% curve reserve, 10% DAO.
- Sell allocation: 90% seller, 5% DAO, 5% equal-holder dividends.
- Exchange prices are denominated directly in POL and do not use a fiat oracle.

### Governance

- Minimum activation: 50 registered members.
- Proposal duration: 14 days.
- Execution window: 7 days.
- Any member registered before an active proposal deadline may vote.
- Final electorate: all members registered strictly before the voting deadline.
- Participation threshold: ceiling of 25% of the final deadline electorate.
- Approval threshold: ceiling of 67% of votes cast.
- Maximum transfer: 5% of the DAO native-POL balance.
- Each registered participant receives exactly one nontransferable LABRV and one vote.

## Repository authority

```text
contracts/                              Active readable Solidity sources
release/revision-7.2-source-freeze/    Frozen source and compiler-profile hashes
docs/                                   Architecture, security, deployment, and whitepaper
tests/                                  Source and model assurance tests
```

Compiler artifacts do not belong in this repository. They belong only in the matching numbered folder of `LaborCoin-Compilation-Records`.

Prelaunch source drafts and incomplete revision history are intentionally excluded from the public release. Known deployed test addresses remain documented in `docs/prelaunch-deployments.md` because on-chain contracts and permission-retirement obligations cannot be erased.

## Required build profile

```text
Solidity: 0.8.36+commit.8a079791
OpenZeppelin: 5.6.1
Optimizer: enabled, 200 runs
EVM: Prague
Via IR: false
Metadata bytecode hash: ipfs
License: MIT
Network: Polygon mainnet, chain ID 137
```

## Compile order

1. Proposal Text Policy V1.0.1
2. Identity Registry V1.0.1
3. Exchange V7.0.0
4. LABR V4.0.0
5. LaborVote V9.1.1
6. Registration V6.1.1
7. Governance V15.1.1

Do not deploy until all seven artifacts are compiled under the frozen profile, independently checked, recorded in `LaborCoin-Compilation-Records`, tested, and sealed.

## Documentation

- [Technical whitepaper](docs/whitepaper.md)
- [Architecture](docs/architecture.md)
- [Identity and Sybil resistance](docs/identity.md)
- [Equal-holder dividends](docs/equal-holder-dividends.md)
- [Exchange](docs/exchange.md)
- [Registration](docs/registration.md)
- [Governance](docs/governance-flow.md)
- [Security](docs/security.md)
- [Deployment](docs/deployment.md)
- [Verification](docs/verification.md)
- [Testing](docs/testing.md)
- [Address registry](docs/address-registry.md)
- [Prelaunch deployment retirement](docs/prelaunch-deployments.md)
- [Current status](docs/status.md)
