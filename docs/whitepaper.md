# LaborCoin Technical Whitepaper v3.2 Candidate

## Revision 7.2 equal-holder and deadline-electorate architecture

**Status:** Precompilation source candidate, not deployed<br>
**Network:** Polygon mainnet, chain ID 137<br>
**Document date:** July 27, 2026

---

## Disclaimer

LaborCoin is experimental public infrastructure intended to support working-class mutual aid and collective action. This paper explains the project's intended social function, the current source candidate, the proposed deployment procedure, and the fixed economic and governance rules that would govern the system after launch.

LaborCoin does not promise financial returns, price stability, liquidity, uninterrupted availability, favorable legal or tax treatment, successful labor outcomes, identity-provider availability, or freedom from smart-contract, network, governance, interface, key-management, and operational risk.

Revision 7.2 has not yet been compiled under the frozen profile, completed every unit, fuzz, invariant, fork, integration, and independent-review requirement, or been deployed. All replacement addresses and runtime commitments are pending. Nothing in this paper is legal, investment, tax, or financial advice.

---

# 1. Executive Summary

Workers have power when they act together, but collective action is difficult to sustain when employers can immediately cut off wages and workers still have to pay for food, housing, healthcare, transportation, childcare, and other necessities. Striking workers are barred from receiving federally funded welfare benefits such as SNAP, as well as state benefits such as Unemployment Insurance. The retaliation is built into the system itself, with eligibility rules that dissuade sustained direct action.

When people do push back, they often find out that fiat networks themselves can be controlled, monitored, and shut down. Many activists and journalists have recently found themselves barred from major banks, demonstrating the system's ability to take retribution on you personally if they disagree with your work. Economic retaliation turns a labor dispute into a test of who can survive without income the longest. In most cases, the employer begins with far greater reserves.

At the same time, people outside a workplace may strongly support a strike or organizing campaign but have no clear, durable, and accountable way to help. Support is often scattered across temporary fundraisers, separate organizations, private accounts, and social-media posts that disappear from public attention. The public may want to stand with workers but still lack a common place to build resources, see what is available, evaluate requests, and decide where aid should go.

LaborCoin is designed to help close that gap. It is public infrastructure intended to connect the broader public with people taking direct action to improve working-class material conditions. Participants can acquire LABR or contribute directly to the Aragon DAO treasury. Fixed economic flows add POL to the common treasury, and verified governance members decide through one-member-one-vote proposals which recipients should receive aid.

Striking workers are the clearest use case because lost wages are one of the strongest weapons employers use against collective action. The same infrastructure can support other working-class causes when participants democratically agree that the transfer advances mutual aid, organizing, legal defense, communications, emergency support, or another part of the class struggle. The contracts do not determine which cause is worthy. They provide a transparent process through which participants can make that judgment together.

LaborCoin is therefore a vehicle for solidarity, not technology for its own sake. The blockchain records balances, rules, votes, permissions, and transfers so that the system does not have to depend on a private administrator's promises. The technology matters only to the extent that it helps people pool resources, coordinate support, resist unilateral control, and sustain action that would otherwise be broken by economic pressure.

The immediate goal is practical: make it easier to build and democratically distribute mutual aid to people engaged in collective action. The longer-term possibility is scale. A widely adopted system could support prolonged regional or national campaigns and, if mass participation ever made it possible, help place substantial resources behind a general strike. A treasury capable of distributing billions of dollars would require extraordinary public participation and is not guaranteed, but the architecture is intended to remain usable if participation grows to that level.

The permanent dividend principle is central:

> Every verified participant holding at least 1 LABR receives exactly one equal dividend share. Holding more LABR does not increase that participant's dividend weight.

This prevents the holder distribution from turning wealth into greater recurring income. A verified eligible wallet holding 1 LABR, 100 LABR, or 10,000 LABR receives one dividend unit. LABR quantity affects how much a participant can sell and the economic exposure they hold, but it does not multiply their dividend share or governance vote.

Revision 7 uses a shared permanent Identity Registry. A direct Polygon wallet obtains a Human Passport score through a fixed scorer. When the score is at least 15.000, a fixed verifier may issue an EIP-712 authorization valid for no more than one hour. The wallet submits that authorization on-chain once. Successful verification is permanent and reused for official Exchange access, equal-holder dividend eligibility, dividend claims, and optional governance registration.

The score gate is intended to reduce simple Sybil behavior and require every additional eligible wallet to satisfy the same published scorer. It is not proof that one natural person controls only one wallet. The threshold remains 15 to avoid imposing government-ID, biometric, or substantially higher-score requirements that would exclude many ordinary participants.

The candidate consists of seven custom contracts:

1. **LaborCoin Identity Registry V1.0.1**, which records one-time score-15 verification.
2. **LABR V4.0.0**, which fixes token supply, transfer restrictions, launch finalization, and equal-holder dividend accounting.
3. **LaborCoin Exchange V7.0.0**, which provides identity-gated exact-token buying and selling through a direct-POL integral bonding curve.
4. **LaborVote V9.1.1**, which provides one permanent nontransferable LABRV membership unit per registrant.
5. **LaborCoin Registration V6.1.1**, which reuses the shared identity status, records historical member-count checkpoints, and mints membership after a 1 LABR threshold.
6. **Proposal Text Policy V1.0.1**, which applies fixed proposal-description rules.
7. **LaborCoin Governance V15.1.1**, which lets every member registered before a proposal deadline vote while voting is active and fixes final participation against that deadline electorate.

The existing Aragon DAO remains the treasury custodian. Governance does not hold proposal funds. A successful proposal can request exactly one native-POL transfer from the DAO to the approved recipient. Governance cannot change tokenomics, mint LABR, alter thresholds, pause trading, execute arbitrary calldata, upgrade contracts, or recover recipient funds.

Revision 7.2 is a replacement source candidate. The historical V4/V7/V13 deployment, superseded Revision 6 candidate, and uncompiled Revision 7.0 creation-snapshot candidate remain preserved for transparency. Neither is represented as the final replacement system.

---

# 2. Problem, Purpose, Scope, and Non-Objectives

## 2.1 Economic retaliation limits collective action

A strike can stop production, disrupt distribution, and force an employer to negotiate. That leverage weakens when workers cannot afford to remain off the job. Wages may stop immediately while rent, food, transportation, healthcare, childcare, debt, legal costs, and communication expenses continue. Employers often have access to credit, retained profits, insurance, investors, and large cash reserves. Individual workers usually do not.

This imbalance is not incidental. The threat of missed pay, discipline, termination, benefit loss, or prolonged uncertainty is one of the main ways collective action is discouraged and defeated. A group may have broad support and a legitimate demand but still be forced back to work because the immediate cost of continuing becomes unbearable.

LaborCoin begins from a simple premise: collective action becomes more sustainable when people taking the risk are not left to absorb the economic retaliation alone. LaborCoin is a digital bridge to solidarity.

## 2.2 The solidarity gap

Public sympathy does not automatically become material support. People may see a strike, agree with the workers, and still be unsure where to send money, whether a fundraiser is legitimate, how much has already been raised, who controls the funds, or how the money will be distributed. Separate campaigns must repeatedly rebuild attention and trust from the beginning.

Existing strike funds, unions, worker centers, mutual-aid networks, and public fundraisers remain essential. LaborCoin is not designed to displace them. It is intended to add a common, transparent layer through which the broader public can accumulate resources over time and direct them through a published democratic process.

The system is meant to serve as a bridge between people who want to help and people who are directly fighting to improve working-class material conditions.

## 2.3 Theory of change

LaborCoin's theory of change follows a direct path:

1. Economic retaliation makes strikes and other collective action difficult to sustain.
2. A broad public can reduce that pressure by pooling resources before and during a campaign.
3. Fixed economic rules and public treasury balances make the shared pool visible and inspectable.
4. Verified participants can evaluate proposals and decide where aid should go without allowing token wealth to buy more votes.
5. Approved funds can be transferred directly to a recipient chosen by the membership.
6. Greater material support can give workers more time to organize, remain on strike, communicate, provide mutual aid, and force an employer or institution to respond.

This mechanism cannot guarantee victory. Money does not replace workplace organization, strategy, trust, discipline, or mass participation. It can, however, address one concrete weakness that repeatedly limits direct action: the inability of ordinary people to withstand prolonged economic punishment.

At small scale, the system may help a local campaign cover urgent expenses. At larger scale, it may help sustain coordinated action across workplaces or regions. At mass scale, the same structure could support a general strike backed by a large public treasury. The architecture is built so the basic rules do not need to change as participation grows.

## 2.4 Scope of worker support

Strikes are the primary use case, but the treasury is not limited to a single organizational form or legally recognized union. Participants may consider proposals involving striking workers, locked-out workers, organizing campaigns, emergency mutual aid, legal defense, communications, workplace committees, worker centers, or other causes that materially aid the working class.

The protocol cannot decide whether a proposal advances the class struggle, accurately represents affected workers, or will distribute aid fairly. Those questions remain matters of investigation, discussion, political judgment, and democratic voting. The contracts only constrain how proposals are created, approved, and executed.

LaborCoin is not a replacement for unions, strike committees, worker centers, collective bargaining, legal representation, political education, or face-to-face organizing. It is a funding and decision-making tool that can strengthen those efforts when people choose to use it.

## 2.5 Design objectives

The system seeks to provide:

- a durable and publicly inspectable pool for working-class mutual aid;
- a clear path for the general public to contribute to collective action;
- democratic allocation without token-balance-weighted voting;
- transparent balances, proposal records, vote totals, and completed transfers;
- a fixed and inspectable LABR supply;
- an official Exchange with deterministic POL-denominated pricing;
- permanent wallet, transaction, and cooldown limits;
- a meaningful but accessible anti-Sybil gate;
- one equal dividend unit per verified eligible holder;
- one governance membership and one vote per registered participant;
- transparent DAO custody;
- narrow native-POL execution;
- exact runtime-code commitments between dependent contracts;
- no post-launch custom-contract owner, pause, upgrade, or economic setter;
- public source, compilation, deployment, and permission records.

## 2.6 Non-objectives

LaborCoin does not attempt to:

- guarantee strike success, employment protection, public support, or recipient conduct;
- determine which labor campaign or political cause deserves support;
- replace unions, workplace organization, collective bargaining, or human deliberation;
- guarantee a LABR market price or fiat value;
- provide a stablecoin or price peg;
- eliminate all Sybil behavior;
- store legal identities on-chain;
- support anonymous governance;
- provide broad DeFi composability;
- support contract wallets, relays, or account abstraction in the candidate design;
- permit governance to rewrite protocol economics;
- create an upgrade path or emergency administrator;
- guarantee that Polygon, Human Passport, RPC providers, website hosting, or the verifier remain available;
- replace legal, tax, security, or organizational advice.

## 2.7 Why economic equality requires explicit code

A project can use egalitarian language while quietly allowing wealth to control income and decision-making. Revision 7 therefore places the equality rules in the contracts rather than leaving them as website promises.

Dividend weight is one binary unit for each verified eligible wallet, not the wallet's LABR balance. Governance weight is one nontransferable LABRV membership unit, not the participant's LABR holdings. More tokens do not create more votes and do not create a larger percentage of holder dividends.

This does not make every participant economically equal. People may hold different amounts of LABR, face different risks, and have unequal access to wallets, gas, identity credentials, and information. The narrower commitment is enforceable and explicit: token quantity cannot be used to multiply governance or holder-dividend power.

---

# 3. Design Principles

The design principles translate the project's social purpose into rules that can be inspected and tested. They are intended to prevent the system from reproducing the same concentration of power it is meant to resist.

## 3.1 One verified holder, one dividend share

A verified wallet holding at least 1 LABR receives one equal share of each holder-dividend deposit made while eligible. A verified wallet holding 10,000 LABR receives the same share as a verified wallet holding 1 LABR. An unverified wallet receives no share.

## 3.2 One registered participant, one vote

Registration mints exactly one LABRV. LABRV cannot be transferred, delegated, burned, approved, or multiplied for the same wallet. Governance checks both the LABRV balance and the matching Registration record. Economic wealth is therefore separated from formal voting power.

## 3.3 Supporting the system does not require governing it

Economic participation and governance registration remain distinct. A verified participant may buy, hold, receive equal dividends, claim, and sell without registering to vote. A participant who wants to help build the common pool should not be required to become a governance member.

Governance registration is a separate, optional commitment. It requires at least 1 LABR and creates permanent membership.

## 3.4 Rules must survive the website

The website explains and simplifies the system, but it is not the source of authority. Identity, wallet, transaction, cooldown, dividend, and governance rules are enforced on-chain. Calling the contracts directly does not bypass those rules.

## 3.5 Narrow authority over administrative convenience

Revision 7 favors fixed, narrow behavior over an administrator who can intervene later. This reduces the risk that a founder, company, compromised key, or future governing faction can rewrite the system. It also means mistakes can be permanent. The launch process and testing burden are therefore unusually important.

## 3.6 Limitations must be stated plainly

The protocol does not claim one natural person per wallet. Human Passport scoring and credential deduplication raise the cost and difficulty of simple duplicate participation, but coordinated or independently credentialed wallets may still pass. Equal-per-wallet dividends make this residual risk important, so the system describes the rule honestly rather than claiming perfect identity.

## 3.7 Technology is an instrument

LaborCoin does not treat blockchain use as an achievement by itself. The technology is justified only where it serves a practical working-class purpose: keeping public records, constraining authority, making treasury activity visible, enforcing equal voting rules, and allowing approved aid to move without relying on a private custodian's discretion.

The success of the project must therefore be judged by whether it helps people organize solidarity and sustain material support, not by transaction volume, token price, or technical novelty.

---

# 4. System Architecture and Trust Boundaries

LaborCoin separates economic participation, identity verification, governance membership, proposal voting, and treasury custody so that no single custom contract controls the entire system. The following flow shows how the components work together.

## 4.1 Component flow

```text
Human Passport scorer
        |
        v
LaborCoin verifier -- EIP-712 --> Identity Registry V1
        |                              |
        |                              +--> Exchange V7 access
        |                              +--> LABR V4 dividend eligibility/claims
        |                              +--> Registration V6.1
        v
   no custody

POL --> Exchange V7 --> LABR V4 inventory and curve reserve
             |                 |
             |                 +--> equal-holder dividend accounting
             +--> Aragon DAO treasury

Registration V6.1 --> LaborVote V9.1 --> Governance V15.1
Proposal Text Policy V1 ---------> Governance V15.1
Governance V15.1 --> Aragon DAO --> approved recipient
```

## 4.2 Economic layer

LABR and Exchange provide the economic path through which participants enter, exit, and help build shared value. They implement the fixed supply, official inventory, curve reserve, protocol-only buys and sells, cooldown, wallet and transaction limits, fixed DAO contributions, and equal-holder dividend deposits and claims.

The economic layer does not decide who receives treasury aid. Its role is to apply the published rules and direct the fixed treasury share to the DAO.

## 4.3 Identity layer

Human Passport supplies a score under a fixed scorer. The verifier signs a narrow authorization, and Identity Registry checks that authorization on-chain before permanently recording the wallet's status.

The verifier cannot hold user funds, trade for a participant, register the participant, or vote on the participant's behalf. Its authority is limited to signing qualifying identity authorizations.

## 4.4 Membership layer

Registration requires verified status and at least 1 LABR. LaborVote then mints one permanent, nontransferable membership unit. Identity verification alone does not create governance rights, and holding additional LABR does not create additional memberships.

## 4.5 Governance layer

Governance is the decision-making path for treasury aid. It uses Registration and LABRV state, a fixed proposal-text policy, fixed voting thresholds, and the existing Aragon DAO's execute permission. A successful proposal can execute only one native-POL transfer with empty calldata to the approved recipient.

Governance cannot operate the Exchange, rewrite token rules, or use the DAO for arbitrary contract calls.

## 4.6 External infrastructure

Polygon consensus, Human Passport, the verifier service, RPC providers, domain registration, Netlify hosting, browser dependencies, and Aragon DAO permissions remain external trust and availability surfaces. Immutable custom contracts do not make those services permanent or immune from disruption.

The protocol therefore distinguishes between rules enforced by deployed contracts and services that participants still need in order to reach or use those contracts.

## 4.7 Component registry

| Component | Candidate | Address | Primary authority after launch |
|---|---|---|---|
| Identity Registry | V1.0.1 | `DEPLOYMENT_PENDING` | None |
| LABR | V4.0.0 | `DEPLOYMENT_PENDING` | None |
| Exchange | V7.0.0 | `DEPLOYMENT_PENDING` | None |
| LaborVote | V9.1.1 | `DEPLOYMENT_PENDING` | Registration only may mint |
| Registration | V6.1.1 | `DEPLOYMENT_PENDING` | None |
| Text Policy | V1.0.1 | `DEPLOYMENT_PENDING` | None |
| Governance | V15.1.1 | `DEPLOYMENT_PENDING` | Aragon execute permission only |
| Aragon DAO | Existing | `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` | DAO permission registry |

---

# 5. Identity Registry V1

## 5.1 Purpose

Identity Registry gives the system one shared answer to a basic question: has this wallet completed the required identity check? Exchange, LABR dividend accounting, and Registration all read the same permanent status.

Keeping this rule on-chain prevents the website from granting access by appearance alone. It also avoids repeating separate verification logic in several contracts, where mismatched scorers, thresholds, or signature rules could create conflicting results. Revision 7 therefore centralizes verification in one immutable registry.

## 5.2 Score rule

Scores are represented in thousandths:

```text
15.000 score = 15,000 contract units
```

The fixed minimum is 15,000. There is no threshold setter. The registry accepts scores above the minimum but does not grant greater rights for a higher score.

## 5.3 Authorization domain

The EIP-712 domain is intended to be:

```text
name: LaborCoin Identity
version: 1
chainId: 137
verifyingContract: exact Identity Registry address
```

The signed struct binds:

```text
Identity(
  participant,
  passportScore,
  scorerIdHash,
  nonce,
  expiry
)
```

The scorer ID itself is not stored as plaintext in the authorization. Its Keccak-256 hash is fixed in the registry. The verifier must compute the same hash from its environment configuration.

## 5.4 Replay protection

Each participant begins with nonce zero. Successful verification consumes the current nonce and stores verified status. The wallet cannot verify twice. A signature for another wallet, nonce, chain, scorer, Registry address, score, or expiry produces a different digest and fails.

## 5.5 Expiry and chain time

The authorization must not be expired and may not extend more than one hour beyond current chain time. The verifier should derive expiry from the latest Polygon block rather than server wall-clock time to reduce clock-skew failure.

## 5.6 Direct-wallet requirement

The participant must call Registry directly from an address with no code and `msg.sender == tx.origin`. This excludes smart-contract wallets, multisignatures, account-abstraction accounts, and relays. The restriction is intentionally broad and should be tested against future Polygon behavior before launch.

## 5.7 Launch binding

Identity Registry is deployed with the expected LABR runtime hash and a temporary launch owner. The owner may call `finalizeLaborCoin` exactly once. The Registry verifies the LABR runtime and confirms that LABR points back to the same Registry and Registry runtime hash. It stores LABR and sets owner to zero.

Verification remains disabled until LABR has also finalized the exact Exchange. This prevents participants from entering an incomplete system.

## 5.8 Atomic dividend synchronization

When verification succeeds, Registry calls LABR's eligibility synchronization in the same transaction. Under the protocol-only transfer policy, an unverified wallet cannot acquire LABR through an ordinary transfer or official purchase, so this synchronization is normally a zero-balance safety check. It also ensures the Registry and token remain consistent if verification and token state are tested together during deployment rehearsals.

## 5.9 Permanence and compromise

There is no revocation. If the verifier key signs an unauthorized wallet, that status is permanent. If Human Passport later reduces the wallet's score, status remains. This limits ongoing external dependence but makes prelaunch key security and scorer validation critical.

## 5.10 Accessibility and Sybil tradeoff

A threshold of 15 is selected because people creating a new wallet may have limited on-chain history and may not reach higher default thresholds. The scorer's credential deduplication makes reused qualifying credentials less effective across multiple wallets. Nevertheless, independent credential sets, coordinated persons, or changes in provider behavior can still permit multiple wallets. The protocol describes the gate as Sybil resistance, not proof of unique humanity.

## 5.11 Verification lifecycle and failure behavior

The complete verification lifecycle is deliberately separated into an off-chain evaluation and an on-chain permanent record:

1. The participant connects the exact direct wallet that will hold verified status.
2. The frontend asks the verifier service for an authorization for that address.
3. The verifier reads the fixed Human Passport scorer and converts the returned score to thousandths by flooring additional precision.
4. The verifier rejects scores below 15,000.
5. The verifier reads the Registry nonce, scorer hash, and current Polygon block timestamp.
6. The verifier signs an authorization valid for no more than one hour.
7. The participant sends the authorization to Identity Registry from the same wallet.
8. The Registry recomputes the digest, validates the fixed verifier signature, consumes the nonce, records permanent status, and synchronizes dividend eligibility in LABR.

The verifier cannot directly mark a wallet verified. It can only issue a signature that the exact participant must submit. A signature obtained for one participant cannot be redirected to another participant because the wallet address is part of the signed struct and `msg.sender` is the participant checked by Registry.

Failure behavior is intentionally fail-closed:

| Condition | Result |
|---|---|
| Score below 15.000 | No authorization is issued |
| Wrong scorer configured | Verifier refuses startup |
| Wrong Registry address | Verifier refuses startup or digest check fails |
| Wrong verifier key | Verifier refuses startup |
| Registry not launch-ready | Verifier refuses startup and Registry rejects verification |
| Expired authorization | Registry rejects |
| Authorization valid for more than one hour | Registry rejects |
| Replayed signature | Consumed nonce or existing verified status causes rejection |
| Smart-contract caller or relay | Registry rejects |
| Human Passport or verifier outage | New verification pauses; existing status remains usable |

## 5.12 Why verification is one-time rather than per transaction

A new Passport check on every buy, sell, or claim would create continuous dependence on the verifier and Passport service. Such a design could freeze ordinary economic activity during a service outage and would give an off-chain service recurring influence over access to already-held assets. Revision 7 instead places the external dependency at one permanent onboarding point.

This choice has a cost. If a wallet later falls below the scorer threshold, changes hands, or becomes compromised, its verification remains. The contract cannot distinguish those events. Permanent status is therefore a deliberate tradeoff between operational continuity and ongoing identity freshness.

The fixed score is an admission control, not a reputation score. A participant with score 40 has the same protocol rights as a participant with score 15. The score is never used to weight trades, dividends, registration, votes, or proposal authority.

---

# 6. LABR V4 Token

## 6.1 Fixed supply

LABR has 18 decimals and a fixed supply of:

```text
1,000,000,000 LABR
```

The constructor mints once to the LABR contract itself. There is no external mint function. Burns and transfers to the zero address are disabled.

## 6.2 Launch ownership

A temporary owner exists only to bind the exact Exchange. Before finalization, ordinary transfers and approvals are disabled. `finalizeLaunch` validates the Exchange runtime, token address, Identity Registry binding, DAO treasury, compatibility ID, and fixed allocation constants. It then records Exchange, transfers the entire supply to Exchange, enables protocol-only Exchange settlement, and sets owner to zero atomically.

A separate early renunciation path is prohibited because it could strand the supply in LABR.

## 6.3 Transfer limits

```text
Maximum transaction: 5,000 LABR
Maximum wallet: 10,000 LABR
Official trade cooldown: 12 hours
Minimum dividend balance: 1 LABR
```

The official Exchange holds more than the wallet maximum because it contains inventory. No ordinary participant receives an exemption.

## 6.4 Protocol-only transfers

LABR is permanently non-peer-transferable after launch. A holder cannot send LABR to another wallet, an arbitrary contract, a liquidity pool, a bridge, a custodian, or the Exchange directly. Every non-mint, non-burn movement must be initiated by the immutable official Exchange and must either deliver LABR from Exchange inventory to a verified buyer or return LABR from a verified seller to Exchange inventory.

This restriction prevents a holder from moving a completed balance into additional wallets and refilling the original wallet through the official Exchange. It also prevents unofficial token settlement paths from bypassing the identity gate, wallet limit, transaction limit, cooldown, curve accounting, and fixed treasury allocations. It does not prove that one person cannot independently verify and fund more than one wallet.

## 6.5 Allowances and `transferFrom`

Approvals are restricted to the official Exchange and require a verified direct wallet. Only Exchange may call `transferFrom`, and only for a sale returning LABR to Exchange inventory. This prevents general allowance-based movement, delegated transfers, wrappers, and third-party contract settlement, at the cost of composability.

## 6.6 Trade recording

Official buys and sells are token transfers initiated by Exchange. LABR validates the trader as a verified direct wallet, applies the wallet and transaction limits, enforces the cooldown, updates dividend eligibility after the balance change, and records the trade timestamp.

The token is the authoritative cooldown source used by Exchange's `canTrade` and `nextTradeTime` views.

---

# 7. Equal-Holder Dividend Accounting

## 7.1 Policy definition

Dividend weight is binary:

```text
weight(account) = 1 when:
  Identity Registry reports verified
  AND LABR balance >= 1 LABR
  AND account is not a protocol address

weight(account) = 0 otherwise
```

Balance above 1 LABR does not increase weight.

## 7.2 Why token-proportional accounting is rejected

A token-balance-weighted distribution would give the largest recurring payments to the people who already hold the most. That would reproduce a wealth-weighted model inside a project intended to support collective solidarity.

Revision 7 instead treats 1 LABR as the qualification threshold for the holder set. Once a verified wallet qualifies, additional LABR does not increase its dividend weight. LABR remains an economic participation token, but it is not a multiplier for influence or recurring holder income.

## 7.3 Global accumulator

LABR tracks:

```text
eligibleDividendHolderCount
magnifiedDividendPerEligibleHolder
totalDividendsDistributed
totalDividendsWithdrawn
totalDividendsRedirectedToDAO
```

For deposit `D` and eligible count `N > 0`:

```text
magnifiedDividendPerEligibleHolder += D * 2^128 / N
```

Each eligible account has a synthetic unit of one. The contract does not iterate over holder addresses.

## 7.4 Entry correction

When an account becomes eligible, its correction subtracts the current global accumulator. This prevents the new account from receiving deposits made before entry.

Example:

- Alice and Bob are eligible when 20 POL is deposited. Each earns 10 POL.
- Carol then verifies and reaches 1 LABR.
- Carol's entry correction excludes the previous 20 POL.
- A later 30 POL deposit is split three ways. Alice, Bob, and Carol each earn 10 POL from that deposit.

Totals are Alice 20, Bob 20, Carol 10.

## 7.5 Exit correction

When an eligible account falls below 1 LABR, its correction adds the current accumulator. This preserves prior accrual while setting future weight to zero.

A participant may later claim already accrued POL even with zero LABR, provided the wallet remains permanently verified. The account receives no deposits made while below the threshold.

## 7.6 Re-entry

Re-entry subtracts the then-current accumulator. The participant resumes with one unit but does not receive deposits made during absence.

## 7.7 Unequal-balance example

Assume the eligible set is:

| Holder | LABR balance | Dividend units |
|---|---:|---:|
| A | 1 | 1 |
| B | 100 | 1 |
| C | 10,000 | 1 |

A 90 POL deposit gives 30 POL to each. C does not receive more because C owns more LABR.

## 7.8 Multi-wallet risk

If one person controls several independently verified wallets and keeps at least 1 LABR in each, each wallet has one unit. This is precisely why identity verification gates eligibility and claims. Human Passport scoring and credential deduplication make simple replication harder, but do not eliminate the possibility. The design chooses an accessible score gate rather than requiring government ID or biometric proof.

## 7.9 Deposit source

Only official Exchange may call `depositDividends`. The 5% holder share from each sale is deposited after the seller's LABR balance and eligibility have been updated. A seller who exits below 1 LABR does not share in the dividend generated by that same sale.

## 7.10 Zero eligible holders

When no eligible holder exists, LABR sends the deposit to the DAO and records the redirection. Retaining it for future participants could award historical value to the first later entrant and create timing incentives.

## 7.11 Rounding

Integer division may leave a small undistributed residue inside LABR. Testing must bound this residue and prove it cannot be extracted through repeated entry, exit, trade, or claim operations. No administrator may sweep residue.

## 7.12 Claim gate

`claimDividends` requires the verified direct wallet. This expresses the project's policy that equal-holder distributions belong to verified participants. Since verification is permanent, claims do not depend on a fresh Passport API response.

## 7.13 Accounting state model

For each account, dividend accounting can be understood as a small state machine:

```text
UNVERIFIED_OR_BELOW_THRESHOLD
  weight = 0

VERIFIED_AND_AT_LEAST_ONE_LABR
  weight = 1

VERIFIED_BUT_BELOW_ONE_LABR
  weight = 0
```

Verification is permanent, but dividend eligibility is dynamic because the LABR balance may cross the one-token threshold. Only LABR can update the eligibility mapping, and every LABR balance-changing path invokes synchronization after the token movement. Identity Registry invokes the same synchronization after first verification so a pre-funded wallet is handled atomically.

The account correction is the ledger that separates deposits earned during eligible periods from deposits made before entry or during absence. The contract never needs to retain an array of all holders or iterate over the eligible set. The global count is used only as the denominator for a new deposit; the correction records each account's entry and exit boundaries.

The following conservation relationship should hold apart from bounded integer residue:

```text
total dividend POL received by LABR
=
POL withdrawn by participants
+ POL currently withdrawable
+ bounded rounding residue
+ POL redirected to DAO when holder count was zero
```

The test suite must calculate each term independently over randomized state sequences rather than trusting public counters alone.

## 7.14 Detailed distribution scenarios

### Scenario A: equal weight despite unequal balances

Assume three verified eligible wallets hold 1, 100, and 10,000 LABR. A sale contributes 12 POL to dividends. There are three units, so each wallet accrues approximately 4 POL. Token quantity does not enter the denominator or account weight.

### Scenario B: entry after a distribution

Alice is the only eligible holder when 8 POL arrives, so Alice accrues 8 POL. Bob then verifies while holding 2 LABR. Bob's entry correction excludes the earlier accumulator. A later 10 POL deposit is divided between Alice and Bob. Alice's cumulative accrual becomes 13 POL and Bob's becomes 5 POL.

### Scenario C: temporary exit and re-entry

Alice and Bob are eligible when 10 POL arrives, earning 5 POL each. Alice sells below 1 LABR and exits. A second 6 POL deposit goes entirely to Bob. Alice later buys enough LABR through the official Exchange to re-enter. A third 8 POL deposit is divided equally. Final accrual is Alice 9 POL and Bob 15 POL. Alice does not receive the 6 POL deposited during absence.

### Scenario D: claim after full exit

Alice accrues 4 POL and then sells all LABR. The exit correction preserves her accrued amount. She remains permanently verified and may claim the 4 POL even though her current dividend weight is zero. She receives no later deposits unless she again holds at least 1 LABR.

### Scenario E: attempted wallet splitting

A participant cannot split an existing LABR balance among nine wallets because peer transfers are disabled. Each additional wallet must independently complete score-15 verification and acquire at least 1 LABR through the official Exchange while obeying the same trade and wallet limits. This closes the direct token-splitting path but does not guarantee that one natural person can never qualify and fund multiple wallets.

## 7.15 Claim integrity and payout order

A claim performs the following operations in one non-reentrant transaction:

1. Confirm the caller is a direct wallet.
2. Confirm permanent Registry verification.
3. Synchronize current eligibility.
4. Compute cumulative entitlement from the global accumulator and account correction.
5. Subtract amounts already withdrawn.
6. Increase the withdrawn amount before transferring POL.
7. Transfer only the calculated withdrawal to the caller.

State is updated before the external POL call. Reentrancy protection prevents a recipient fallback from entering another claim. A failed POL transfer reverts the entire transaction, including the withdrawal counter change.

The contract rejects direct POL deposits. Dividend funds can enter through `depositDividends` only from the exact official Exchange. Forced POL delivered through protocol-level mechanisms may still exist outside accounted distributions and has no recovery path. Tests must distinguish accounted dividends from unrelated forced balance.

## 7.16 Policy implications

Equal-holder dividends are intended to give qualifying participants a shared benefit from official Exchange activity without rewarding larger token balances with larger percentages. The rule supports the broader principle that participation in LaborCoin should not become another mechanism through which wealth automatically accumulates more power and income.

The holder distribution is separate from the DAO treasury. Dividend claims provide one equal economic share to each verified eligible wallet, while the DAO treasury exists to fund collective working-class needs through proposals and votes. One mechanism supports participants in the holder set; the other directs common resources toward approved causes.

The minimum 1 LABR balance creates a clear economic membership threshold, and identity verification makes simple wallet replication more difficult. The result is still one share per verified eligible wallet, not a guaranteed one share per natural person. The fairness of the outcome therefore depends partly on the external identity system and participant behavior.

The policy should be evaluated by its enforceable commitment: larger LABR holdings do not buy a larger holder-dividend share.

---

# 8. Exchange V7 and Bonding Curve

## 8.1 Official market role

Exchange V7 is the official path for initial LABR distribution and redemption. It is also one of the mechanisms through which participation contributes to the shared system: the fixed buy allocation sends a portion of incoming POL to the DAO, and the fixed sell allocation sends portions to the DAO and equal-holder dividends.

The Exchange is not intended as a speculative marketplace detached from the project's purpose. Its role is to apply the published pricing and limit rules while helping build the common treasury and preserve a defined redemption path.

LABR cannot settle through direct transfers or third-party token markets because all nonzero-address token movements are restricted to the official Exchange. Off-chain sale of wallet control, compromised keys, or informal custody arrangements remain outside what the token contract can prevent.

## 8.2 Identity gate

Every buy and sell requires permanent Registry verification. This is contract-level enforcement. Direct contract calls cannot bypass it.

The frontend may help a wallet obtain verification, but its interface state does not grant access. Exchange reads Registry on-chain.

## 8.3 Permanent limits

```text
Maximum official transaction: 5,000 LABR
Maximum permitted participant wallet: 10,000 LABR
Cooldown between official trades: 12 hours
```

A wallet above 10,000 LABR is completely barred from both official buying and selling. At exactly 10,000 LABR it may sell but cannot buy more. These rules are permanent constants and must appear in source, tests, interface, FAQ, and whitepaper.

## 8.4 Direct POL denomination

Exchange uses POL directly. There is no Chainlink feed and no USD conversion. This removes oracle freshness and conversion failure, but the fiat value of every price changes with POL's external market value.

## 8.5 Marginal price

Let:

```text
S = 1,000,000,000 LABR
s = total LABR outside official Exchange inventory
x = s / S
Pmin = 14 POL per LABR
Pmax = 210 POL per LABR
R = 196 POL per LABR
```

Then:

```text
P(s) = Pmin + R x^2
```

At zero distribution, marginal price is 14 POL. At full distribution, it is 210 POL.

## 8.6 Integral reserve

A user buying a range of tokens must pay the area under the curve rather than the ending marginal price multiplied by amount. Define:

```text
F(s) = Pmin * s + (R/3) * s^3 / S^2
```

For exact amount `a`:

```text
buy reserve = F(s + a) - F(s)
sell gross redemption = F(s) - F(s - a)
```

The on-chain implementation uses 18-decimal token units and POL wei. Purchase calculations use protective rounding so reserve is not underfunded. Sale calculations use protective rounding so reserve is not overpaid.

## 8.7 Buy allocation

Exchange first determines the curve reserve contribution. The DAO contribution is calculated so it is 10% of total input:

```text
total POL in = reserve contribution + DAO contribution
DAO contribution = ceil(reserve contribution / 9)
```

This means approximately 90% of total input becomes curve reserve and 10% goes to the DAO.

The buyer provides an exact token amount, maximum POL input, deadline, and required `msg.value`. Excess above the exact required input is refunded within the user's maximum.

## 8.8 Sell allocation

For gross curve redemption `G`:

```text
seller = floor(90% of G)
DAO = floor(5% of G)
dividends = G - seller - DAO
```

The remainder is assigned to dividends so allocations sum exactly to gross redemption. Exchange returns LABR to inventory, updates `totalSold` and reserve, deposits dividends, sends DAO contribution, and pays seller.

## 8.9 Tranche unlocking

The initial unlocked supply is 100,000,000 LABR. Additional capacity unlocks in 50,000,000 LABR increments as a valid purchase requires it. Unlocking does not create tokens and does not move POL.

## 8.10 Inventory invariant

```text
Exchange LABR balance = 1,000,000,000 LABR - totalSold
```

A direct token transfer into Exchange is rejected by LABR because it would violate this relationship.

## 8.11 Reserve invariant

```text
accountedReserve = F(totalSold)
Exchange POL balance >= accountedReserve
```

DAO and dividend payments are excluded from accounted reserve. A forced POL transfer can create excess but cannot cover a recorded accounting mismatch. Excess has no recovery function and remains trapped.

## 8.12 Quote examples

At low distribution the curve is near 14 POL per LABR. A small exact-token buy therefore requires roughly 14 POL of reserve per LABR plus the DAO contribution. As distribution grows, the quadratic term increases marginal and interval prices. Exact values must always come from the deployed `quoteBuyExactTokens` and `quoteSellExactTokens` functions because integer rounding and current `totalSold` determine execution.

## 8.13 Restricted market scope

LABR cannot be transferred into an unofficial venue, liquidity pool, bridge, wrapper, or custodial token market. The official Exchange is the only contract permitted to settle LABR purchases and sales. This makes the published identity, wallet, transaction, cooldown, curve, reserve, and treasury-allocation rules authoritative for every on-chain LABR movement after launch.

The restriction cannot prevent sale of an entire wallet or private key, coercive custody, compromised accounts, or agreements that do not move LABR on-chain. Those residual risks must not be described as ordinary LABR transferability.

## 8.14 Amount units, rounding, and slippage controls

All token inputs use 18-decimal LABR units and all POL values use wei. Frontends may display decimals, but the contract executes integer arithmetic only. A whole-token example such as 5 LABR is submitted as `5 * 10^18` token units.

The buy quote calculates the increase in integral reserve between the current sold supply and the post-purchase sold supply. The 10% treasury contribution is calculated with ceiling division so the treasury contribution is never understated by integer truncation. The total required input is reserve contribution plus treasury contribution.

The sale quote calculates the decrease in integral reserve. The DAO and holder-dividend allocations use floor division. Any indivisible remainder favors the seller. This policy avoids creating an unassigned wei liability and is deterministic at every supply point.

A buy includes `maxPOLIn`; a sell includes `minPOLOut`; both include a deadline. The frontend should request a current on-chain quote immediately before submission and apply a narrowly disclosed tolerance. These arguments protect the participant from a state change between quote and execution. They do not guarantee execution because another transaction may change sold supply, inventory, cooldown, wallet balance, or allowance first.

## 8.15 Trade execution sequence

A successful buy performs these high-level steps:

1. Require a verified direct wallet and finalized launch.
2. Confirm deadline, amount, wallet room, inventory, and tranche capacity.
3. Confirm reserve and inventory invariants before accepting the new payment as evidence of solvency.
4. Compute exact reserve and DAO contributions.
5. Update sold supply and accounted reserve.
6. Transfer exact LABR to the buyer through token-enforced limits and cooldown.
7. Send DAO contribution and refund any excess payment.
8. Recheck reserve and inventory invariants.

A successful sell performs:

1. Require a verified direct wallet and finalized launch.
2. Confirm deadline, amount, wallet ceiling, balance, allowance, sold supply, and reserve.
3. Compute gross curve redemption and fixed 90/5/5 allocation.
4. Reduce sold supply and accounted reserve.
5. Transfer LABR back to Exchange, causing token eligibility synchronization.
6. Deposit the holder share after the seller's new eligibility is known.
7. Send DAO contribution and seller proceeds.
8. Recheck accounting invariants.

This order prevents a seller who exits below 1 LABR from receiving a share of the same sale's dividend deposit. A seller remaining above the threshold stays in the eligible set and receives the same one unit as every other eligible holder.

## 8.16 Official Exchange scope and bypass boundaries

Identity, wallet, transaction, and cooldown rules are enforced by contracts in the official path. A participant cannot bypass them by calling Exchange directly rather than using the website. The frontend is a convenience and safety layer, not the source of authorization.

The protocol prevents independent on-chain LABR markets by rejecting every peer transfer and every transfer operator other than the official Exchange. An unverified wallet cannot receive LABR through an ordinary transfer or official purchase. A verified holder who wants to change wallets must sell through the official Exchange from the old wallet and later verify and buy through the new wallet.

The website and documentation must state clearly that LABR is not a general payment token and cannot be sent peer to peer. Material support to workers should be distributed through approved treasury assets or direct POL contributions rather than by transferring LABR.

## 8.17 Economic stress conditions

The official curve is denominated in POL. A large change in POL's external purchasing power does not alter the contract's POL price function. It can materially change the fiat value of LABR, the DAO treasury, holder distributions, and redemptions.

Heavy selling reduces sold supply and reserve liability along the inverse integral. Selling remains bounded by the amount previously sold and by actual reserve coverage. The Exchange does not borrow, issue debt, or promise fiat redemption. Forced POL sent outside ordinary calls is excluded from `accountedReserve` and cannot be withdrawn.

The tranche mechanism limits how much inventory is distributable at a time but does not create discretionary control. Unlocking occurs mechanically when a valid purchase would exceed current unlocked capacity. It does not change total supply or curve mathematics.

---

# 9. Registration V6.1 and LaborVote V9.1

Registration is the step through which a verified participant chooses to become a permanent governance member. It turns economic participation into an optional democratic role without allowing additional LABR to create additional votes.

## 9.1 Shared identity

Registration reuses the wallet's permanent Identity Registry status. A participant does not need to complete a second Passport check or obtain another verifier signature in order to join governance.

This keeps economic and governance onboarding consistent while preserving the distinction between them: verification permits official economic participation, while Registration is a separate voluntary act that creates governance membership.

## 9.2 Requirements

The direct wallet must be verified, hold at least 1 LABR, have no prior registration, hold no LABRV, and interact after LaborVote has finalized Registration as its sole minter.

## 9.3 Permanent record

Registration stores:

- registered status;
- sequential member number;
- registration timestamp;
- registration timestamp indexed by member number;
- total member count.

The member-number timestamp index supports a bounded binary-search view that returns how many members registered strictly before a specified timestamp. Governance uses this historical count to determine each proposal's final electorate at its voting deadline without iterating over members.

Registration cannot be revoked. A participant who later transfers or sells all LABR keeps LABRV and governance membership under this candidate. The 1 LABR requirement is an admission threshold, not an ongoing wealth test for voting.

Permanent membership is intended to prevent voting rights from being bought, sold, temporarily borrowed, or removed by an administrator.

## 9.4 LaborVote

Each registrant receives exactly `1 ether` LABRV. The token uses 18 decimals only for ERC-20 representation; one whole LABRV is the fixed membership unit.

Transfers, approvals, `transferFrom`, and burns revert. No delegation or checkpoint system exists. Governance reads current LABRV balance and Registration records directly.

## 9.5 Launch finalization

LaborVote is deployed with expected LABR and Registration runtime hashes and a temporary launch owner. Registration is deployed with expected LABR, LABRV, Identity, and self runtime hashes. LaborVote validates Registration and atomically locks it as sole minter while setting owner to zero.

## 9.6 Certificate

The site can generate a US Letter membership certificate from confirmed on-chain member number and timestamp. It is a local presentation artifact. The blockchain record is authoritative and the certificate does not create rights.

---

# 10. Proposal Text Policy V1

## 10.1 Purpose

Proposal descriptions are permanent public data. Governance calls an exact immutable policy before storing description text. This prevents the official Governance contract from accepting categories of links, markup, encodings, and disallowed terms selected at launch.

## 10.2 Fixed properties

- maximum 1,000 bytes;
- fixed ASCII and character constraints;
- fixed link, markup, and encoding restrictions;
- fixed hashed lexicon commitment;
- no administrator or update path.

## 10.3 Limitations

A fixed policy can produce false positives, false negatives, and future linguistic mismatch. It cannot understand intent. Since it is immutable, correction requires a replacement governance deployment and new Aragon permission migration.

---

# 11. Governance V15.1

Governance V15.1 has one narrow purpose: allow registered participants to decide whether the Aragon DAO should send a specified amount of POL to a specified recipient. It is not a general protocol administration system.

## 11.1 One-member-one-vote

A wallet is eligible when it holds exactly one LABRV and has a matching Registration record. Every eligible member has one vote. LABR wealth, dividend history, proposal activity, and Passport score do not increase voting weight.

## 11.2 Activation

Proposal creation remains unavailable until at least 50 registered members exist. This prevents the final treasury-transfer process from being activated by a very small founding group and creates a minimum community base before collective funds can be directed through Governance V15.1.

## 11.3 Proposal creation

A registered direct wallet may have one active proposal at a time. The proposal title is fixed as `Treasury Transfer`. The description must pass Policy. Recipient cannot be zero, the DAO, the current protocol contracts, or listed superseded protocol addresses. Amount must be positive and at most 5% of the DAO's current native-POL balance.

The proposal records:

- creation-time member count for transparency;
- treasury balance at creation;
- creator;
- recipient;
- amount;
- description and hash;
- start and end time;
- deterministic call ID.

## 11.4 Deadline electorate

Every registered LABRV member may vote while the proposal remains active, including a participant who verifies, acquires LABR, registers, and receives LABRV after proposal creation. The member must register strictly before the voting deadline and must cast the vote before that deadline.

The final electorate is the number of members registered strictly before the proposal end time. Registration V6.1 reconstructs that count from its permanent member-number timestamp index through bounded binary search. Registrations at or after the deadline cannot vote and cannot change the closed proposal's denominator, result, or executability.

While voting is active, the interface reports the current electorate and a provisional participation requirement. Both may increase as new members register. At the deadline, the historical electorate becomes permanent without requiring a separate finalization transaction.

## 11.5 Participation threshold

Required participation is:

```text
ceil(deadlineElectorateSize * 25 / 100)
```

At 50 members, required participation is 13, not 12. If a proposal begins with 50 members and 50 more register before the deadline, the final electorate is 100 and required participation is 25. Every person included in that final denominator had an opportunity to vote while the proposal was active.

## 11.6 Approval threshold

Required yes votes are:

```text
ceil(votesCast * 67 / 100)
```

A proposal with no votes fails. At 3 votes cast, 3 yes are required because `ceil(2.01) = 3`. At 100 votes cast, 67 yes are required.

## 11.7 Timing

Voting lasts 14 days. A participant who registers at any point before the deadline may vote during the remaining active period. A successful proposal may execute for 7 days after voting ends. After the execution window, it expires.

## 11.8 Execution

Any wallet may call execution after success because execution is mechanical. Governance rechecks:

- proposal is not executed;
- voting has ended;
- the final deadline electorate and thresholds passed;
- execution window remains open;
- current DAO balance covers amount;
- amount remains at most 5% of current DAO balance;
- Governance has exact DAO execute permission.

It then builds one action:

```text
to = approved recipient
value = approved POL amount
data = empty
```

The DAO performs the transfer. Governance records execution and cannot execute the proposal again. Later registrations cannot change the final electorate or invalidate a completed vote.

## 11.9 Narrow authority

Governance cannot submit arbitrary calldata, token transfers, upgrades, permission changes, or multiple actions. It has no owner, pause, setter, or recovery function.

## 11.10 Open-enrollment tradeoff

An active proposal may motivate supporters or opponents to complete permanent identity verification and governance registration. This can be understood as democratic organizing or as coordinated bloc recruitment. The contracts cannot distinguish motive. The fixed score gate, permanent membership, nontransferable LABRV, 14-day public period, 25% participation requirement, 67% approval requirement, and 5% transfer cap limit but do not eliminate coordinated influence.

The chosen policy treats proposal-driven participation as legitimate because each qualifying participant becomes a permanent equal member rather than borrowing or purchasing temporary voting power. The final denominator grows with every member admitted before the deadline, so recruitment also raises the participation requirement.

## 11.11 Repeated-proposal risk

The 5% cap is per proposal, not per week, month, or year. Repeated approved proposals can spend a substantial fraction of treasury. The protocol relies on member participation and judgment rather than an additional cumulative cap.

---

# 12. Treasury and Aragon Permission Architecture

## 12.1 Custody

The Aragon DAO at `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` holds treasury POL. Custom Governance does not receive, escrow, or temporarily control proposal funds.

This separation matters politically as well as technically. The shared treasury is not placed in a founder wallet or a private organizational account. Its balance and outgoing transfers remain publicly visible, and Governance receives only the narrow authority needed to execute an approved transfer.

## 12.2 Execute permission

Governance requires Aragon's `EXECUTE_PERMISSION_ID`. The permission must be granted only after deployed runtime verification and fork rehearsal. Old Governance and Treasury Module permissions must be revoked after the new path is proven.

## 12.3 Recipient diligence

A technically valid proposal can still support the wrong recipient. Contracts cannot prove that an address represents affected workers, that a campaign has worker consent, that a workplace committee is accountable, or that the proposed use of funds will advance working-class interests.

Members must therefore investigate the recipient, confirm control of the destination address, evaluate the stated purpose, and consider how the funds will be distributed before voting. Public proposals and on-chain transfers improve transparency, but they do not replace political judgment or human accountability.

## 12.4 Irreversibility

A completed native-POL transfer cannot be reversed by Governance. There is no clawback, dispute administrator, or recipient freeze.

---

# 13. Runtime Commitments and Immutable Deployment

## 13.1 Why source verification is insufficient

Publishing source does not prove that a deployed address contains that runtime. Compiler version, optimizer, metadata, imports, constructor values, and immutables affect bytecode. Revision 7 records the complete build and compares on-chain runtime directly.

## 13.2 Record types

For each contract the release must preserve:

- source SHA-256;
- compiler profile;
- standard JSON or equivalent compiler input;
- artifact JSON;
- metadata JSON;
- build-info JSON;
- creation bytecode length and hash;
- runtime template length and hash;
- immutable reference locations;
- diagnostics;
- sealed compilation ZIP and hash.

## 13.3 Constructor-independent runtimes

Identity, LABR, Exchange, LABRV, Registration, and Policy intentionally store deployment values in ordinary storage or have no constructor inputs affecting runtime. Their runtime templates are intended to be independent of constructor values. Compilation must confirm this assumption.

## 13.4 Governance immutables

Governance stores final LABR, LABRV, Registration, Policy, and expected hashes in immutables. Its deployed runtime differs by final values. The compilation record must identify immutable offsets and reconstruct the exact expected deployed runtime after addresses are known.

## 13.5 Commitment cycle

Identity commits to LABR runtime. LABR commits to Identity and Exchange runtimes. Exchange validates Identity and LABR. This is resolved through the ordered finalization procedure rather than a permanent setter.

## 13.6 Source freeze

Any source edit after compilation invalidates affected artifacts and all downstream commitments. A comment-only edit can change metadata and bytecode. The final source tree must therefore be frozen before record creation.

## 13.7 Evidence chain from source to deployed runtime

A credible immutable deployment record should allow an independent reviewer to reproduce the following chain:

```text
canonical source files
  -> exact compiler input
  -> compiler version and settings
  -> creation bytecode and ABI
  -> constructor arguments
  -> deployment transaction
  -> deployed address
  -> actual runtime bytecode
  -> Keccak-256 runtime commitment
  -> cross-contract binding checks
```

Each arrow requires evidence. A verified explorer page alone is insufficient because an explorer may show source that compiles to matching bytecode without documenting the entire local release package, constructor intent, or dependency graph. Conversely, a local artifact is insufficient without comparing it to on-chain code.

For every contract, the compilation record should preserve at least:

- canonical non-Remix source;
- pinned Remix source used for deployment, when applicable;
- compiler standard JSON input or equivalent complete build information;
- compiler output artifact and metadata;
- creation-bytecode hash;
- runtime template hash;
- immutable references;
- compiler diagnostics;
- source-file hashes;
- constructor argument schema and encoded arguments;
- deployed transaction, block, address, and actual runtime hash after deployment.

## 13.8 Runtime commitments versus addresses

A runtime hash answers: "What exact executable code is present?" An address answers: "Where is that code and state located?" Both are required. Two contracts can share a runtime hash but have different storage configuration, balances, permissions, or histories. Constructor-independent runtime design improves precommitment but does not make all instances equivalent.

The launch checks therefore combine runtime commitments with explicit reciprocal state checks. LABR does not merely check Exchange bytecode; it also checks that Exchange reports the same LABR, Registry, DAO treasury, compatibility ID, and fee constants. Registry similarly checks that LABR points back to Registry and its expected code hash.

## 13.9 Mandatory abort conditions

Deployment must stop rather than improvise when any of the following occurs:

- source hash differs from the approved manifest;
- compiler version or settings differ;
- unexpected warning or error appears;
- runtime template differs from the sealed record;
- constructor encoding cannot be independently reproduced;
- a deployed address has unexpected code;
- actual runtime hash differs from predicted runtime;
- reciprocal contract binding differs;
- launch owner is not the intended temporary deployer;
- inventory, reserve, identity, minter, or governance readiness check fails;
- Aragon permission grant differs from the reviewed permission tuple;
- a superseded permission cannot be enumerated or safely revoked;
- frontend or verifier configuration does not match on-chain values.

An immutable launch should not rely on an undocumented exception made under time pressure. Any source correction returns the affected contract and every runtime-dependent contract to compilation and review.

---

# 14. Deployment Procedure

## 14.1 Build profile

```text
Solidity: 0.8.36+commit.8a079791
OpenZeppelin: 5.6.1
Optimizer: 200 runs
EVM: Prague
Via IR: false
Metadata bytecode hash: ipfs
Network: Polygon mainnet, chain ID 137
```

## 14.2 Compile order

1. Proposal Text Policy V1.0.1
2. Identity Registry V1.0.1
3. Exchange V7.0.0
4. LABR V4.0.0
5. LaborVote V9.1.1
6. Registration V6.1.1
7. Governance V15.1.1

## 14.3 Deploy and finalize identity/economic cycle

1. Deploy Policy and verify runtime.
2. Deploy Identity with verifier, scorer hash, and expected LABR runtime hash.
3. Deploy LABR with Identity address/hash and expected Exchange runtime hash.
4. Finalize Identity to exact LABR. Confirm Identity owner becomes zero.
5. Deploy Exchange with LABR, Identity, and Identity runtime hash.
6. Finalize LABR to exact Exchange. Confirm full inventory transfer and LABR owner zero.
7. Confirm Registry `identityReady`, Exchange `launchReady`, token/registry bindings, zero reserve, full inventory, and fixed constants.

## 14.4 Deploy and finalize membership

1. Deploy LaborVote with LABR and expected LABR and Registration hashes.
2. Deploy Registration with LABR, LABRV, Identity, and expected hashes.
3. Finalize LaborVote minter to Registration.
4. Confirm owner zero, Registration ready, zero members, and zero LABRV supply.

## 14.5 Deploy governance

1. Deploy Governance with LABRV, Registration, Policy, and expected hashes.
2. Compare final deployed runtime including immutables.
3. Grant exact Aragon execute permission.
4. Confirm readiness and run fork execution.
5. Revoke all obsolete LaborCoin execute permissions.

## 14.6 Production cutover

Update verifier environment to the final Registry. Update site addresses and runtime hashes. Verify frontend ABIs, EIP-712 domain, service worker assets, and fail-closed gate. Complete a real low-value end-to-end rehearsal before opening production.

---

# 15. Security Architecture and Threat Model

## 15.1 Immutability risk

The absence of upgrade and recovery authority prevents unilateral changes but also prevents patching. A severe defect can permanently disable or misallocate value. Compilation and tests are not substitutes for independent review.

## 15.2 Verifier compromise

The fixed verifier can authorize permanent status. A stolen key can admit unauthorized wallets until the service is stopped, and admitted status cannot be revoked. The key must be isolated, access-limited, backed up securely only when intended, and never used for unrelated blockchain transactions.

## 15.3 Scorer dependence

The scorer's composition and external provider behavior may change even though the on-chain threshold and scorer hash do not. The verifier must verify it is querying the intended scorer. Provider outages stop new verification.

## 15.4 Sybil residual risk

Passport scoring is not proof of a unique natural person. Equal-per-wallet dividends create an incentive to establish additional verified wallets. Deduplicated credentials, threshold, direct-wallet restrictions, and trading limits reduce ordinary abuse but cannot eliminate coordinated or independently credentialed participants.

## 15.5 Dividend accounting risk

The equal-holder accumulator is sensitive to eligibility transitions. A correction-sign error could award history, erase accrual, or duplicate value. Tests must cover every transition and randomized long sequences. No manual reconciliation exists after launch.

## 15.6 Exchange risk

Integral arithmetic, rounding, reserve updates, transfer order, and external POL sends must remain consistent under reentrancy protection. Forced POL remains trapped. POL volatility can make the real-world curve value unexpectedly high or low.

## 15.7 Smart-wallet exclusion

The direct-wallet policy excludes legitimate multisig and account-abstraction users. `tx.origin` is used as a restrictive condition, not an authentication secret. Future protocol changes on Polygon could affect assumptions and should be reviewed immediately before launch.

## 15.8 Treasury risk

Governance can approve a mistaken or malicious recipient. The DAO transfer is irreversible. The contract cannot evaluate worker legitimacy, fraud, coercion, or legal compliance.

## 15.9 Governance capture

One-member-one-vote reduces wealth weighting but does not prevent coordinated capture, low turnout, bribery, coercion, proposal-driven recruitment, or a verifier-admitted Sybil population. Members who register before an active proposal deadline may vote, and their admission also increases the final participation denominator. The 50-member activation threshold, permanent membership, 25% participation requirement, 67% approval requirement, and 5% transfer cap are fixed safeguards, not guarantees.

## 15.10 Permission migration

Leaving old Aragon execute permissions active can preserve obsolete control paths. The final audit must enumerate all grantees and revoke every superseded LaborCoin Governance, module, executor, and deployer permission not required after launch.

## 15.11 Frontend and infrastructure

A compromised site can display false addresses, request malicious signatures, or hide failures. Users can verify contracts independently, but many rely on the interface. Dependencies should be pinned or preserved locally, service-worker caches versioned, TLS and DNS protected, and final addresses displayed prominently.

## 15.12 Legal and operational uncertainty

Token, DAO, identity, labor-support, and tax treatment can vary by jurisdiction and change. No immutable contract can guarantee legal classification or service-provider access.

## 15.13 Cross-component failure matrix

| Failure | Immediate effect | Preserved capability | Required response |
|---|---|---|---|
| Human Passport outage | New authorizations unavailable | Existing verified wallets continue | Wait for service restoration; do not weaken threshold |
| Verifier hosting outage | New authorizations unavailable | Existing verified wallets continue | Restore identical service and key configuration |
| Verifier key loss | No new valid authorizations | Existing verified wallets continue | No in-protocol key rotation; disclose permanent onboarding halt |
| Verifier key compromise | Unauthorized permanent verification possible | Contract rules still apply | Stop verifier immediately, disclose incident, evaluate whether launch remains acceptable |
| Frontend compromise | Users may see false data or malicious prompts | Direct contract verification remains possible | Disable deployment, restore trusted build, rotate web infrastructure credentials |
| RPC outage | Interface reads and submissions fail | Contracts remain on-chain | Use verified alternate RPC configuration |
| Exchange invariant failure | Trade reverts | Transfers, prior claims, governance may remain | Investigate; no owner override exists |
| LABR dividend transfer failure | Claim or sale deposit reverts | Entitlement state remains unchanged | Diagnose recipient or DAO behavior; immutable recovery may be unavailable |
| Aragon permission missing | Proposal execution fails | Voting and treasury custody remain | Correct permission only before authority is fully frozen |
| Obsolete permission remains | Historical contract may retain execution authority | New protocol may otherwise work | Treat as launch-blocking security defect |
| Polygon halt or censorship | All on-chain operations stop or delay | State remains recorded | Await network recovery; no alternate chain path exists |

## 15.14 Verifier operational controls

Although verification status is on-chain, the signer is an operationally sensitive service. The production verifier should use a dedicated key with no POL or unrelated authority, restricted environment access, exact dependency locks, a narrow origin policy, rate limiting, request-size limits, and minimal logs. The signer key must not be reused as deployer, DAO administrator, treasury recipient, or general wallet.

Backups create a tradeoff. A recoverable key preserves future onboarding after infrastructure loss, but every backup increases compromise risk. The final operational plan should document where the key exists, who can access it, how service restoration is performed, and how an incident is publicly disclosed. The contract has no signer rotation, so this plan must be settled before deployment.

The verifier should refuse startup rather than serve partially when the chain ID, Registry code, Registry address, configured verifier, scorer hash, threshold, or launch-ready state differs. Health output should expose only public configuration and should never reveal private keys, API keys, raw Passport responses, or internal exception details.

## 15.15 Website and dependency integrity

The website does not enforce protocol authorization, but it influences most participant decisions. A compromised build could substitute addresses, misstate quotes, or request an unrelated signature. The final site should centralize addresses in one reviewed configuration, remain disabled until every address and runtime hash is present, and display predeployment status prominently.

Browser dependencies loaded from public CDNs create mutable external dependencies. The strongest launch approach is to preserve the exact tested browser bundles locally or use integrity-pinned immutable resources. The service worker must use a release-specific cache name so old ABI or address files cannot persist across cutover. Desktop and mobile tests should include a clean browser profile and an upgrade from the previous cached site.

---

# 16. Testing and Assurance

## 16.1 Source-level gates

Before compilation, automated guards should confirm versions, constants, compatibility strings, equal-holder variable names, absence of balance-weighted dividend denominators, required identity checks, and no stale Revision 6 active references.

## 16.2 Unit tests

Every public and external function, error branch, finalization state, eligibility transition, quote boundary, historical member-count boundary, and proposal transition requires deterministic tests. Governance tests must prove that members joining before a deadline can vote, registrations at or after the deadline are excluded, and later registrations cannot change a closed result.

## 16.3 Fuzz tests

Fuzz token amounts, supply points, wallet balances, holder counts, deposit sizes, entry/exit sequences, registration timestamps, repeated same-block timestamps, proposal deadlines, vote counts, electorate sizes, and treasury balances.

## 16.4 Stateful invariants

At all reachable states:

- total LABR supply remains fixed;
- no ordinary wallet exceeds 10,000 LABR;
- no transaction moves more than 5,000 LABR;
- Exchange inventory equals supply minus total sold;
- accounted reserve equals curve liability;
- one eligible account contributes one dividend unit;
- total withdrawn never exceeds total distributed plus direct redirections as defined;
- unverified accounts never accrue or claim;
- LABRV supply equals successful registrations;
- each registered wallet holds one LABRV;
- every registered LABRV member may vote before an active proposal deadline;
- final electorate equals members registered strictly before the deadline;
- registrations after the deadline cannot alter a closed result;
- executed proposals cannot execute again.

## 16.5 Fork tests

A Polygon fork should use the actual DAO and permission system. Rehearse deployment order, runtime comparisons, finalization, permission grant, proposal creation, voting, execution, permission revocation, and failure cases.

## 16.6 Frontend and verifier tests

Verify exact EIP-712 digest parity, startup fail-closed behavior, score conversion, origin restrictions, no secret logging, wallet reconnection, identity synchronization, equal-dividend display, claim, registration, certificate generation, mobile behavior, service-worker updates, and predeployment disablement.

## 16.7 Independent review

An independent reviewer should receive source, compiler profile, artifacts, tests, runtime graph, deployment sequence, authority matrix, threat model, and permission history. All findings must be resolved or explicitly accepted before deployment.

---

# 17. Participant Journey

A participant can support LaborCoin at several levels. They may simply learn about a campaign and share it, contribute POL to the DAO, acquire LABR and join the equal-holder set, register as a governance member, or help workers prepare and submit a treasury proposal. The system does not require every supporter to perform every role.

## 17.1 Wallet setup

A participant uses MetaMask or another compatible self-custody wallet that exposes a direct EOA. Contract wallets and relays are unsupported. The wallet switches to Polygon and obtains enough POL for gas and any intended purchase or donation.

## 17.2 Human Passport

To use the official Exchange, receive equal-holder dividends, claim, or register for governance, the participant builds a score through Human Passport. The site links to the Passport application. A score of at least 15 is required.

The identity step is intended to make simple duplicate-wallet participation harder while remaining more accessible than a government-ID or biometric requirement.

## 17.3 Permanent verification

The site requests an authorization from the LaborCoin verifier. The wallet submits it to Identity Registry and pays Polygon gas. Once confirmed, status is permanent and does not require a fresh Passport check for each later action.

## 17.4 Building the common system

A verified participant can open the Exchange, review the current curve metrics, and buy an exact LABR amount. A person may also send POL directly to the DAO treasury without buying LABR.

Official purchases help build the DAO treasury through the fixed buy allocation. The resulting LABR balance cannot exceed 10,000 LABR, and an official trade cannot exceed 5,000 LABR.

## 17.5 Equal-holder dividends

When a verified wallet holds at least 1 LABR, it enters the equal-holder set. Official sales contribute a fixed holder share, and each eligible wallet receives one equal dividend unit regardless of whether it holds 1, 100, or 10,000 LABR.

The Exchange page shows eligibility, the current eligible-holder count, and withdrawable POL. Claims are made from the participant's verified wallet.

## 17.6 Selling

A verified wallet may sell after the cooldown, subject to limits and available reserve. A sale that leaves the balance below 1 LABR ends future dividend eligibility while preserving amounts already accrued.

A worker preparing for direct action may choose to sell LABR for expenses, but LaborCoin does not require recipients to hold or sell LABR. The DAO can also approve a direct treasury transfer to an approved recipient address selected through governance.

## 17.7 Governance registration

A verified wallet holding at least 1 LABR may sign the worker-centered attestation and call Registration. One LABRV and a permanent member number are created. LABRV cannot be transferred or multiplied by purchasing more LABR.

The site may generate a US Letter membership certificate, but the on-chain Registration record is authoritative.

## 17.8 Proposing and voting on aid

After 50 members, eligible participants may create treasury-transfer proposals and vote. A proposal identifies one recipient, one POL amount, and a public description that passes the fixed text policy. A person who learns about an active proposal may complete verification, acquire at least 1 LABR, register, receive LABRV, and vote before the voting deadline. The provisional participation target may rise as new members join, and the final electorate is fixed when voting closes.

Before voting, members are expected to investigate whether the recipient represents the affected workers or cause, whether the address is controlled safely, and whether the proposed distribution plan is credible. The contract cannot perform that social verification.

A successful proposal executes through the Aragon DAO within the fixed window. The completed transfer is public and irreversible.

## 17.9 From local support to sustained action

The same participant path can serve different scales. A local group may seek emergency help during a short strike. A larger network may coordinate support across several workplaces. With broad adoption, a much larger treasury could help workers withstand prolonged action that would otherwise collapse under lost wages.

The protocol provides the funding and voting rails. Workers, supporters, organizations, and communities still have to build the campaign, establish legitimacy, communicate demands, and organize the collective action itself.

---

# 18. Historical Migration

## 18.1 Historical deployed stack

The previous deployed system includes the historical LABR token, Exchange V4, LaborVote V7, Registration V4, Governance V13, Treasury Module V1, and the existing Aragon DAO. Addresses remain in the public historical registry.

## 18.2 Superseded Revision 6

Revision 6 introduced direct-POL Exchange V5 and improved runtime commitments, but LABR V2.1 implemented token-balance-weighted dividends. That economic model was not the intended LaborCoin design. Revision 6 is permanently superseded and must not be deployed as final.

## 18.3 Superseded Revision 7.0 creation-snapshot candidate

Revision 7.0 restored equal-holder dividends and shared identity, but Governance V15.0 limited each proposal to members who were already registered at creation. That policy was rejected before compilation because it prevented a proposal from motivating new permanent members to join and vote while the proposal remained active. Revision 7.2 replaces it with a deadline electorate that permits voting by every member registered before the close while preventing post-deadline registration from changing the result.

## 18.4 Migration principles

- Preserve historical source and deployment evidence.
- Never relabel an old address as a Revision 7.2 component.
- Recompile every dependent contract after source changes.
- Grant new DAO permission only after runtime verification.
- Revoke obsolete permission only after successful rehearsal.
- Update frontend and verifier in a coordinated cutover.
- Communicate clearly that token replacement may require participant action if a migration is later defined.

This source package does not claim a finalized token-migration mechanism. Any migration from historical LABR must be separately specified, tested, and documented before deployment.

---

# 19. Risks and Limitations

## 19.1 No guaranteed one-person-one-wallet result

A score-15 Passport gate materially raises friction but does not guarantee unique humanity. Equal dividends remain vulnerable to multiple independently verified wallets.

## 19.2 Permanent verification

Verification cannot be revoked or recovered. A compromised wallet keeps status; a lost wallet cannot transfer status; a mistaken authorization cannot be undone.

## 19.3 Verifier and provider availability

New users depend on the verifier and Human Passport. Existing verified users continue, but growth can stop during an outage.

## 19.4 POL volatility and liquidity

The curve is denominated in POL. Fiat value can change sharply. External liquidity may differ from official Exchange pricing and may not exist.

## 19.5 Immutability

No owner can patch the final contracts. A bug can permanently halt or distort operation. Replacement deployment does not automatically migrate state or value.

## 19.6 Direct-wallet exclusion

Smart-wallet users are excluded. This can reduce accessibility for organizations, security-conscious multisig users, and people relying on account-abstraction recovery.

## 19.7 Governance outcomes

Members may approve ineffective, controversial, or fraudulent transfers. Fixed thresholds do not ensure wise decisions or fair geographic distribution. Open enrollment during an active proposal can mobilize legitimate participation and can also facilitate coordinated recruitment; every admitted member permanently joins the electorate and raises the final participation denominator.

## 19.8 Treasury depletion

Repeated proposals can spend treasury despite the 5% per-proposal cap. There is no cumulative budget period.

## 19.9 Recipient and legal risk

Recipients may lose keys, misuse funds, face sanctions, incur taxes, or be unable to distribute support. Jurisdictional treatment may change.

## 19.10 Infrastructure risk

Polygon congestion, RPC outage, site compromise, DNS loss, verifier hosting failure, and browser dependency changes can disrupt access even if contracts remain present.

## 19.11 Adoption risk

LaborCoin only becomes useful when people choose to participate. A technically correct treasury with no public support cannot sustain a strike, and a large balance without legitimate organizing cannot create collective power.

The project depends on workers and supporters learning how the system works, trusting the published rules, acquiring LABR or contributing POL, registering to vote, evaluating proposals, and connecting the on-chain process to real campaigns. Technology can reduce coordination and trust problems, but it cannot manufacture solidarity or social legitimacy.

## 19.12 Equal-holder policy limitations

Equal dividends remove token-balance weighting from the holder distribution, but they do not eliminate all inequality. Participants differ in their ability to satisfy Human Passport, maintain a secure wallet, pay gas, acquire 1 LABR, monitor claims, and recover from device loss. Some people may control more than one independently qualified wallet. Others may share devices or credentials in ways that are difficult for the scorer to interpret.

The protocol should therefore state the enforceable rule precisely: one equal share per verified eligible wallet. It should not simplify that rule into an absolute claim of one share per natural person.

## 19.13 Identity-gated exit risk

Revision 7.2 requires permanent verification before every official purchase or sale and permanently disables peer transfers. This prevents an existing balance from being distributed among ordinary wallets to refill the original wallet or create additional dividend-eligible balances through token movement.

The one-time model limits future dependence after verification, but the initial gate can still exclude a new participant during a Passport or verifier outage. Existing verified holders retain the ability to use the official Exchange. The site, FAQ, onboarding materials, and whitepaper must disclose the protocol-only transfer rule clearly.

## 19.14 Migration and continuity risk

A new immutable deployment does not automatically replace balances, registrations, proposals, treasury permissions, site caches, verifier configuration, or community expectations from the historical system. A migration can create parallel assets or conflicting sources of truth unless every state transition is documented.

This candidate intentionally does not invent a migration mechanism before it is reviewed. The final deployment plan must identify how historical transferable LABR is retired or distinguished from LABR V4, whether any exchange inventory is moved, whether holders receive replacement tokens, how registrations are treated, and when old interface paths become inaccessible. A technically correct new stack can still fail operationally if the migration is ambiguous.

## 19.15 Social and institutional limits

LaborCoin can make a treasury visible and constrain how a proposal is created, voted on, and executed. It cannot determine whether a labor dispute is legitimate, whether a campaign reflects worker consent, whether a recipient will distribute assistance fairly, or whether an organization remains accountable after receiving funds.

It also cannot substitute for the relationships that make collective action possible. Workers still need organization, communication, strategy, trusted representatives or committees, and a shared willingness to act. Supporters still need to investigate claims and remain engaged after sending money.

The protocol provides transparent rules and auditable transfers. The political and social work remains human.

---

# 20. Governance Philosophy and Conclusion

LaborCoin is built around the idea that solidarity becomes materially powerful when people can organize it before a crisis, see it clearly, and direct it together. Workers who challenge an employer should not have to face economic retaliation in isolation, and members of the public who support them should have a clear way to turn that support into sustained aid.

The system does not attempt to automate the class struggle. It cannot create a union, choose a just demand, verify worker consent, build trust inside a workplace, or decide whether a campaign deserves support. It can provide durable public infrastructure for one part of that work: pooling value and democratically transferring it to people engaged in collective action.

The governance design encodes a limited set of political-economic commitments:

- token wealth does not purchase more governance votes;
- token wealth does not purchase a larger holder-dividend share;
- each additional eligible wallet must independently pass the same identity gate;
- the general public can help build a common treasury without surrendering it to a private custodian;
- registered participants decide where treasury aid goes through one-member-one-vote proposals;
- treasury authority is narrow, transparent, and limited to approved native-POL transfers;
- core economic constants are not adjustable after launch;
- deployment evidence is part of the protocol's public accountability.

These rules are intended to keep the technology subordinate to the purpose. LABR, the Exchange, the Identity Registry, LaborVote, Governance, and the DAO are not ends in themselves. They are components of a solidarity system whose value depends on whether people use it to defend one another and improve material conditions.

At modest scale, LaborCoin may help people find and fund a strike that would otherwise receive little sustained attention. At greater scale, it may allow a broad public to support longer and more coordinated campaigns. At extraordinary scale, it could help place substantial resources behind a general strike or another mass working-class action. That outcome would require organizing and participation far beyond anything a contract can produce, but the system is intended to remain transparent and usable if such participation emerges.

The design does not claim to solve identity, governance, labor organization, or economic inequality in general. It addresses a specific problem: economic retaliation can break collective action, while public support is often fragmented and difficult to direct. LaborCoin provides one possible bridge between those who want to help and those taking the risk.

Revision 7.2 is ready for compilation review only when the source package, documentation, site, verifier, and compilation-record scaffold agree. It is ready for deployment only after the seven contracts compile exactly, all runtime commitments are sealed, the equal-holder accounting survives intensive tests, the Aragon permission migration is rehearsed, and independent review is complete.

The technical standard must remain uncompromising because the final system is intended to operate without a founder, administrator, or upgrade authority. The political standard is equally important: the infrastructure should be judged by whether it expands the working class's ability to organize solidarity, withstand retaliation, and sustain collective action.

---

# Appendix A. Fixed Constants

| Constant | Value |
|---|---:|
| Network | Polygon mainnet, chain ID 137 |
| LABR supply | 1,000,000,000 LABR |
| Wallet maximum | 10,000 LABR |
| Transaction maximum | 5,000 LABR |
| Trade cooldown | 12 hours |
| Minimum dividend balance | 1 LABR |
| Passport threshold | 15.000 |
| Authorization maximum life | 1 hour |
| Buy DAO share | 10% of total input |
| Sell seller share | 90% of gross redemption |
| Sell DAO share | 5% |
| Sell dividend share | 5% |
| Initial marginal price | 14 POL per LABR |
| Maximum marginal price | 210 POL per LABR |
| Initial tranche | 100,000,000 LABR |
| Later tranche | 50,000,000 LABR |
| Governance activation | 50 members |
| Proposal duration | 14 days |
| Electorate cutoff | Registration timestamp strictly before proposal end time |
| Execution window | 7 days |
| Participation | ceiling 25% of members registered before the voting deadline |
| Approval | ceiling 67% of votes cast |
| Proposal transfer cap | 5% of current DAO POL balance |
| Description maximum | 1,000 bytes |

# Appendix B. Address Registry

## Revision 7.2

All seven replacement addresses are `DEPLOYMENT_PENDING`.

## Existing infrastructure

```text
Aragon DAO: 0x0C2e5679153593b82a84eAB5CA90895BB291Cec4
Planned verifier EOA: 0x475d519631d2406753aCA29F305f19b83E97513e
```

The verifier address must be reconfirmed before compilation and deployment.

## Historical evidence

```text
Historical LABR:       0x460DD873A1D2a41e77410B125cD3027C5FEd2f78
Exchange V4:           0x4Cf18cB39203B678f5C26f2338a10a79f9684749
LaborVote V7:          0x833242E933c675846D8f8982048FecA95B8e435A
Registration V4:       0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C
Governance V13:        0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c
Treasury Module V1:    0x0B018E45E4cB71E222C345a5341BdbaeE519c623
```

# Appendix C. Runtime Commitment Status

| Contract | Source status | Compilation status | Runtime hash |
|---|---|---|---|
| Identity Registry V1 | Candidate | Pending | `PENDING_COMPILATION` |
| LABR V4 | Candidate | Pending | `PENDING_COMPILATION` |
| Exchange V7 | Candidate | Pending | `PENDING_COMPILATION` |
| LaborVote V9.1 | Candidate | Pending | `PENDING_COMPILATION` |
| Registration V6.1 | Candidate | Pending | `PENDING_COMPILATION` |
| Text Policy V1.0.1 | Candidate source preserved | Must be re-recorded in Revision 7.2 manifest | `PENDING_COMPILATION_RECORD` |
| Governance V15.1 | Candidate | Pending | `PENDING_FINAL_IMMUTABLE_VALUES` |

# Appendix D. Authority Matrix

| Component | Owner at deployment | Final owner | Mutable economic setters | Pause | Upgrade | Recovery |
|---|---|---|---|---|---|---|
| Identity Registry | Temporary launch owner | Zero | None | No | No | No |
| LABR | Temporary launch owner | Zero | None | No | No | No |
| Exchange | None | None | None | No | No | No |
| LaborVote | Temporary launch owner | Zero | None | No | No | No |
| Registration | None | None | None | No | No | No |
| Text Policy | None | None | None | No | No | No |
| Governance | None | None | None | No | No | No |

# Appendix E. State Transitions

## Identity

```text
Unverified -> valid score authorization -> Verified permanently
```

## Dividend eligibility

```text
Verified + balance <1 -> official buy reaches >=1 -> Eligible
Eligible -> official sell falls below 1 -> Ineligible with accrued claim preserved
Ineligible -> balance reaches >=1 -> Eligible without missed history
```

## Registration

```text
Verified + >=1 LABR + not registered -> register -> one permanent LABRV
```

## Proposal

```text
Nonexistent
  -> Active (current electorate may grow as members register)
  -> Voting deadline (final historical electorate fixed)
  -> Defeated
  \-> Succeeded -> Executed
                 \-> Expired
```

# Appendix F. Threat Model Matrix

| Threat | Preventive control | Detection | Residual consequence |
|---|---|---|---|
| Wrong runtime | Exact codehash commitments | Deployment comparison | Launch abort |
| Verifier theft | Secret isolation and startup checks | Logs, unexpected verification events | Permanent unauthorized status |
| Duplicate wallet | Score threshold and deduplication | On-chain and scorer analysis | Multiple equal shares may remain possible |
| Dividend history theft | Entry/exit corrections | Invariant and differential tests | Permanent accounting loss if defect exists |
| Reserve underfunding | Integral accounting and checks | `invariantsHold`, fork tests | Sell failure or insolvency |
| Old DAO permission | Revocation checklist | Aragon permission enumeration | Obsolete executor remains active |
| Proposal-driven bloc recruitment | Permanent identity and membership, growing deadline quorum, 67% approval, 5% cap | Registration and vote events | Coordinated influence remains possible |
| Bad recipient | Member diligence and fixed proposal record | Public proposal and transfer | Irreversible fund loss |
| Site compromise | Fail-closed config and address display | Repository and deployment comparison | Users may sign malicious transactions |

# Appendix G. Glossary

**Accounted reserve:** POL recorded as liability for official curve redemptions.<br>
**Deadline electorate:** All members registered strictly before a proposal voting deadline; this becomes the final participation denominator.<br>
**Direct wallet:** EOA with no code, calling without a relay.<br>
**Dividend unit:** Binary accounting weight of one for each verified eligible holder.<br>
**Eligible holder:** Verified non-protocol wallet holding at least 1 LABR.<br>
**Human Passport:** External credential scoring system used by the fixed scorer.<br>
**LABR:** Fixed-supply economic participation token.<br>
**LABRV:** Nontransferable governance membership token.<br>
**Mutual aid:** Direct material support organized among people and communities to meet shared needs.<br>
**Public infrastructure:** A shared system whose rules and records are available for public use and inspection rather than controlled as a private service.<br>
**Runtime code hash:** Keccak-256 of deployed contract bytecode.<br>
**Scorer ID hash:** Fixed hash identifying the configured Passport scorer.<br>
**Sybil behavior:** One actor attempting to appear as multiple participants.<br>
**Treasury snapshot:** DAO native-POL balance recorded at proposal creation.<br>

# Appendix H. Final Launch Checklist

- [ ] Seven sources frozen and hashed.
- [ ] All seven compile under exact profile with acceptable diagnostics.
- [ ] Creation and runtime records sealed.
- [ ] Equal-holder unit, fuzz, invariant, and differential tests pass.
- [ ] Exchange curve and reserve tests pass.
- [ ] Identity EIP-712 parity tests pass.
- [ ] Historical member-count binary-search tests pass at zero, exact timestamps, repeated timestamps, and large membership counts.
- [ ] Governance tests prove pre-deadline joiners can vote and post-deadline registrations cannot change a closed result.
- [ ] Membership and governance tests pass.
- [ ] Polygon-fork deployment rehearsal passes.
- [ ] Governance deployed runtime reconstructed from immutables.
- [ ] Aragon new permission grant rehearsed.
- [ ] Obsolete permissions enumerated and revocation transactions prepared.
- [ ] Verifier key and scorer configuration independently checked.
- [ ] Site addresses, hashes, ABIs, and EIP-712 domain verified.
- [ ] Membership certificate remains US Letter and unchanged.
- [ ] Whitepaper PDF and browser print use US Letter.
- [ ] Independent security review completed.
- [ ] Final deployment and provenance record prepared.

# Appendix I. References and Repository Records

The canonical implementation record is the public LaborCoin source repository together with the separate `LaborCoin-Compilation-Records`, site, and verifier repositories. Human Passport integration should be checked against the provider's official current documentation immediately before production deployment. Polygon and Aragon interactions should be checked against their official current documentation and actual deployed contracts.
