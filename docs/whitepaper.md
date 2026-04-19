# LaborCoin Whitepaper

## Abstract
LaborCoin is a decentralized governance system designed to enable collective decision-making and resource allocation for the working class. It combines a non-transferable voting token, DAO-based governance, and controlled execution through dedicated smart contracts to create a transparent, accountable, and scalable coordination mechanism.

The system enforces a one-person, one-vote model and restricts execution to predefined actions, minimizing attack surface while preserving flexibility through governance.

---

## 1. Introduction
Modern economic systems concentrate decision-making power in centralized institutions, limiting the ability of workers to coordinate and act collectively. While blockchain technology enables decentralized coordination, many implementations prioritize speculation over governance.

LaborCoin addresses this gap by providing:

- A governance-first architecture  
- Equalized voting power  
- Transparent, on-chain decision execution  
- Controlled and auditable action pathways  

The goal is not to create a speculative asset, but a functional coordination system.

---

## 2. System Overview
LaborCoin consists of four primary components:

- LABR (primary token)  
- LABRV (voting token)  
- DAO governance (Aragon)  
- Executor contracts (controlled execution layer)  

The system separates decision-making from execution:

**DAO → Executors → Contracts**

This ensures governance decisions are enforced through constrained and auditable mechanisms.

---

## 3. Governance Model

### 3.1 LABR Solidarity Proposals (LSP)
Governance actions are executed through LABR Solidarity Proposals. Participants may submit proposals, vote on proposals, and approve or reject system actions.

### 3.2 Voting Mechanism
- 1 LABRV per participant  
- Non-transferable (soulbound)  
- Equal voting weight  

This enforces a one-person, one-vote structure.

### 3.3 Proposal Requirements
- 75% participation threshold  
- 75% approval threshold  

### 3.4 Proposal Lifecycle
1. Proposal submission  
2. Voting period  
3. Threshold validation  
4. Execution via DAO  

---

## 4. Token Design

### 4.1 LABR
**Contract Address:** 0x460DD873A1D2a41e77410B125cD3027C5FEd2f78  

Total Supply: 1,000,000,000 LABR (pre-minted)  
Initial Circulating Supply: 100,000,000 LABR (10%)  
Remaining supply is held in the bonding curve treasury  

Token release is governed by a staged mechanism:

- 50,000,000 LABR sold per tranche  
- 1:1 release ratio up to 50% of total supply  
- 1:0.8 release ratio beyond the 50% threshold  

This introduces controlled scarcity and reduces emission rate as adoption increases.

---

### 4.2 Token Mechanics and Constraints

**Transaction Limits**  
- Token-level: 0.05% (500,000 LABR)  
- Exchange-level: 0.005% (50,000 LABR)  

**Wallet Limits**  
- Token-level: 0.1% (1,000,000 LABR)  
- Exchange-level: 0.01% (100,000 LABR)  

**Cooldown Mechanism**  
- 12-hour cooldown between transactions per wallet  
- Applies to both buy and sell actions  

These constraints reduce volatility, limit extractive behavior, and encourage broad participation.

---

### 4.3 Bonding Curve and Pricing Mechanism

LaborCoin utilizes a bonding curve to provide continuous liquidity and deterministic pricing.

**Pricing Model**
- Price increases as tokens are purchased  
- Price decreases as tokens are sold  
- Pricing is fully algorithmic and on-chain  

**Treasury Interaction**
- Buyers deposit base asset (POL) into the treasury  
- Sellers withdraw from the treasury  
- No reliance on external liquidity pools  

**Emission Integration**
- The bonding curve operates alongside staged token release  
- Supply expansion is controlled and decreases over time  

**Interaction Flow**
1. User submits transaction  
2. Protocol constraints are validated  
3. Bonding curve calculates price  
4. Treasury balances are updated  
5. Tokens are issued or burned  

---

### 4.4 LABRV (Voting Token)

- ERC20Votes-based  
- Non-transferable (soulbound)  
- One token per participant  
- Minted upon registration  

This enforces equal voting power and prevents accumulation of governance control.

---

## 5. Execution Architecture

The DAO does not directly execute arbitrary actions.

Instead:

**DAO → Executor → Target Contract**

Executor Contracts:
- PauseExecutor  
- TreasuryExecutor  
- LaborVoteMintExecutor  

This architecture limits attack surface and ensures predictable execution paths.

---

## 6. Deployment

**Network:** Polygon (Mainnet)

**Core Contracts:**
- LABR: 0x460DD873A1D2a41e77410B125cD3027C5FEd2f78  
- DAO: 0x0C2e5679153593b82a84eAB5CA90895BB291Cec4  
- LABRV: 0x3586B123191be1944DBDa623079cED5b6c8d03fE  

---

## 7. Current System State

- Governance is active  
- Voting is functional  
- Executors are deployed  
- System is in bootstrap phase  

**Temporary condition:**  
DAO currently has unrestricted execution ("Any Action")

---

## 8. Planned Upgrades

- Executor-only execution permissions  
- Registration system for LABRV minting  
- Full decentralization of control  

---

## 9. Security Model

LaborCoin prioritizes structural security through:

- Restricted execution pathways  
- Non-transferable voting power  
- High participation thresholds  
- Transparent on-chain actions  

Risk is reduced by limiting what governance can execute rather than relying on trust.

---

## 10. Use Cases

- Strike funding and support  
- Collective bargaining coordination  
- Resource distribution  
- Community-led initiatives  

---

## 11. Limitations

- Early-stage system  
- Registration system not yet deployed  
- User experience dependent on external interfaces  

---

## 12. Conclusion

LaborCoin represents a shift from speculative crypto systems toward functional governance infrastructure.

By combining equalized voting, controlled execution, and transparent coordination, it provides a foundation for scalable collective action.

---

## Disclaimer

LaborCoin is an experimental governance system. Participation involves interacting with smart contracts and decentralized infrastructure, which carry inherent risks.
