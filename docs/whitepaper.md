# LaborCoin Whitepaper

## Abstract

LaborCoin is a decentralized governance system designed to enable collective decision-making and resource allocation for the working class. It combines a non-transferable voting token, DAO-based governance, and controlled execution through dedicated smart contracts to create a transparent, accountable, and scalable coordination mechanism.

The system enforces a one-person, one-vote model and restricts execution to predefined actions, minimizing attack surface while preserving flexibility through governance.

In addition, LaborCoin integrates a bonding curve exchange mechanism that enables continuous liquidity, deterministic pricing, and treasury accumulation to support striking workers and collective action.

---

## 1. Introduction

Modern economic systems concentrate decision-making power in centralized institutions, limiting the ability of workers to coordinate and act collectively. While blockchain technology enables decentralized coordination, many implementations prioritize speculation over governance.

LaborCoin addresses this gap by providing:

- A governance-first architecture  
- Equalized voting power  
- Transparent, on-chain decision execution  
- Controlled and auditable action pathways  
- A treasury-building mechanism tied to real economic participation  

The goal is not to create a speculative asset, but a functional coordination system capable of sustaining worker-led movements.

---

## 2. System Overview

- LABR (primary token)  
- LABRV (voting token)  
- DAO governance (Aragon)  
- Executor contracts  
- Bonding curve exchange  

**Participants → LABR → LABRV → Proposals → DAO → Executors → Treasury → Worker Support**

This architecture ensures decisions are enforced through constrained execution while maintaining economic backing through the bonding curve.

---

## 3. Governance Model

### Voting Mechanism

- 1 LABRV per participant  
- Non-transferable (soulbound)  
- Equal voting weight  

Prevents capital-based governance capture and ensures democratic participation.

### Thresholds

- 25% participation  
- 67% approval  

High thresholds ensure legitimacy and prevent minority control.

---

## 4. Token Design

**Contract Address:**  
`0x460DD873A1D2a41e77410B125cD3027C5FEd2f78`

**Total Supply:** 1,000,000,000  
**Initial Supply:** 100,000,000  

### Emission Model

- 50,000,000 LABR released per tranche  
- 1:1 release ratio up to 50% of total supply  
- 1:0.8 release ratio beyond 50%  

This structure encourages early participation while gradually introducing scarcity.

### Constraints

- Transaction Limit: 5,000 LABR per transaction  
- Wallet Limit: 10,000 LABR per wallet  
- Cooldown: 12 hours between transactions  

These constraints are enforced at the contract level to prevent accumulation of disproportionate influence and reduce volatility.

---

## 5. Bonding Curve Exchange

**Exchange Contract:**  
`0xD0692ec758bb852421B702B187b6439f74f8Bf3b`

### Pricing Model

- Quadratic bonding curve with smooth price progression  
- Price increases as total tokens sold increases  
- Approximate range: $1 → ~$15  

### Economic Behavior

- Early participants enter at lower prices, incentivizing initial adoption  
- Price increases smoothly as participation grows  
- Discourages speculation-driven spikes  

### Treasury Model

- All purchases deposit POL into the contract treasury  
- Sales withdraw from treasury liquidity  
- 10% of each purchase is routed to the DAO treasury  

This creates a direct link between participation and available support funds.

---

## 6. Execution Architecture

**DAO → Executor → Contract**

### Executors

- PauseExecutor → controls trading state  
- TreasuryExecutor → distributes funds  
- MintExecutor → mints voting tokens  

Execution is constrained to prevent arbitrary control and reduce attack surface.

---

## 7. Deployment

**Network:** Polygon

**LaborCoin (LABR):**  
`0x460DD873A1D2a41e77410B125cD3027C5FEd2f78`

**LaborCoin Exchange v2:**  
`0xD0692ec758bb852421B702B187b6439f74f8Bf3b`

**LaborCoin DAO:**  
`0x0C2e5679153593b82a84eAB5CA90895BB291Cec4`

**LaborCoin DAO Registration (V2):**  
`0xFFc3499A71b806C3919f4B54D236b151cFdCB453`

**LaborVote (LABRV v6):**  
`0x113579220515cd59b884Ea2379b4C369025246e2`

**LaborCoinGovernance (v5):**  
`0x8840368d41B93dB9C718e9A9039B625028b23B0B`

**Pause Executor:**  
`0x8ceb1CC33FF4f1eC30901fc5795b57a5b175a12e`

---

## 8. Security Model

- Restricted execution pathways  
- Immutable economic parameters  
- Non-transferable governance  
- High consensus thresholds  

### Additional Protections

- Oracle-based pricing validation  
- Slippage protection  
- Circuit breaker (pause mechanism)  
- Reentrancy protection  

---

## 9. System Invariants

The following conditions are designed to always hold:

- No participant can obtain more than one voting token  
- Governance decisions cannot execute arbitrary contract logic  
- Treasury withdrawals cannot exceed available balance  
- Token supply cannot exceed maximum defined limits  
- Pricing remains deterministic and independent of external markets  

These invariants define the core guarantees of the system.

---

## 10. Threat Model

LaborCoin assumes adversarial behavior as a baseline condition.

### Adversarial Actors

- Wealthy participants attempting to accumulate influence  
- Coordinated voting blocs attempting governance capture  
- Smart contract exploiters targeting liquidity  
- External actors manipulating price inputs  

### Attack Surfaces

- Bonding curve pricing  
- Treasury liquidity  
- DAO participation thresholds  
- Executor permissions  
- Oracle feeds  

---

## 11. Economic Attack Vectors

### Whale Accumulation

Mitigation: Wallet caps, transaction limits, and non-transferable voting tokens.

### Liquidity Drain Attacks

Mitigation: Increasing price curve, cooldown enforcement, treasury constraints.

### Speculative Volatility

Mitigation: Deterministic pricing independent of external markets.

---

## 12. Governance Risks

### Low Participation

Mitigation: High quorum requirements.

### Coordination Attacks

Mitigation: 75% approval threshold.

### Voter Apathy

Acknowledged as a social limitation inherent to democratic systems.

---

## 13. Failure Scenarios

### Oracle Failure

If price oracle data becomes invalid, transactions relying on price inputs may fail or pause.

### Treasury Depletion

If treasury liquidity is insufficient, sell transactions may fail until replenished.

### Low Participation

Governance may stall if participation thresholds are not met.

### Contract Pause

The system may enter a paused state under emergency conditions to prevent further damage.

---

## 14. System Assumptions

- Participants engage in governance  
- Worker solidarity can be coordinated  
- Blockchain infrastructure remains secure  
- Oracle pricing remains reliable  

LaborCoin minimizes trust in individuals but depends on collective participation.

---

## 15. Use Cases

- Strike funding  
- Mutual aid  
- Collective bargaining  
- Resource allocation  

---

## 16. Conclusion

LaborCoin shifts blockchain systems from speculation to coordination infrastructure. It combines governance, economics, and execution into a unified system capable of supporting real-world collective action.
