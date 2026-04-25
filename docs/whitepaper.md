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

LaborCoin consists of five primary components:

- LABR (primary token)  
- LABRV (voting token)  
- DAO governance (Aragon)  
- Executor contracts (controlled execution layer)  
- Bonding curve exchange contract  

System flow:

Participants → LABR → LABRV → Proposals → DAO → Executors → Treasury → Worker Support

This architecture ensures that governance decisions are enforced through constrained and auditable mechanisms while maintaining economic backing through the bonding curve.

---

## 3. Governance Model

### 3.1 LABR Solidarity Proposals (LSP)

Governance actions are executed through LABR Solidarity Proposals. Participants may submit proposals, vote on proposals, and approve or reject system actions.

### 3.2 Voting Mechanism

- 1 LABRV per participant  
- Non-transferable (soulbound)  
- Equal voting weight  

Reasoning:

Prevents capital-based governance capture and ensures democratic participation.

### 3.3 Proposal Requirements

- 75% participation threshold  
- 75% approval threshold  

Reasoning:

High thresholds ensure legitimacy and prevent small groups from controlling outcomes.

### 3.4 Proposal Lifecycle

1. Proposal submission  
2. Voting period  
3. Threshold validation  
4. Execution via DAO  

---

## 4. Token Design

### 4.1 LABR

Contract Address: 0x460DD873A1D2a41e77410B125cD3027C5FEd2f78  
Total Supply: 1,000,000,000 LABR (pre-minted)  
Initial Circulating Supply: 100,000,000 LABR  

Remaining supply is held in the bonding curve treasury.

---

### 4.2 Emission Model

- 50,000,000 LABR per tranche  
- 1:1 release ratio up to 50% of supply  
- 1:0.8 release ratio beyond 50%  

Reasoning:

- Early phase encourages participation  
- Later phase slows inflation  
- Introduces increasing scarcity  

---

### 4.3 Constraints

Transaction Limits:

- Token-level: 0.05%  
- Exchange-level: 0.005%  

Wallet Limits:

- Token-level: 0.1%  
- Exchange-level: 0.01%  

Cooldown:

- 12 hours between transactions  

Reasoning:

- Prevents whale accumulation  
- Reduces volatility  
- Encourages distributed ownership  

---

## 5. Bonding Curve Exchange

Exchange Contract: 0xED8C432FdFBa629387eeD06C1DC5cA6087c1C09b  

The bonding curve provides continuous liquidity and deterministic pricing.

### 5.1 Pricing Model

- Smooth sigmoid curve  
- Approximate range: $1 to ~$15  
- Price increases with adoption  

Reasoning:

- Early accessibility  
- Long-term sustainability  
- Prevents extreme speculation spikes  

---

### 5.2 Treasury Model

- Purchases deposit POL into treasury  
- Sales withdraw from treasury  
- 10% buy fee routed to DAO  

Reasoning:

- Builds real funds for worker support  
- Aligns participation with funding  

---

### 5.3 Safety Mechanisms

- Oracle-based pricing (POL/USD)  
- Slippage protection  
- Circuit breaker (auto pause)  
- Reentrancy protection  
- Treasury balance enforcement  

Reasoning:

- Protects users  
- Prevents exploits  
- Ensures solvency  

---

## 6. Execution Architecture

DAO → Executor → Contract  

Executors:

- PauseExecutor  
- TreasuryExecutor  
- MintExecutor  

Reasoning:

- Prevents arbitrary execution  
- Limits attack surface  
- Enforces predictable actions  

---

## 7. Deployment

Network: Polygon  

LABR: 0x460DD873A1D2a41e77410B125cD3027C5FEd2f78  
Exchange: 0xED8C432FdFBa629387eeD06C1DC5cA6087c1C09b  
DAO: 0x0C2e5679153593b82a84eAB5CA90895BB291Cec4  
LABRV: 0x3586B123191be1944DBDa623079cED5b6c8d03fE  

---

## 8. Security Model

- Restricted execution pathways  
- Non-transferable governance  
- High consensus thresholds  
- Immutable economic parameters  

---

## 9. Use Cases

- Strike funding  
- Mutual aid  
- Collective bargaining  
- Resource allocation  

---

## 10. Conclusion

LaborCoin shifts blockchain systems from speculation to coordination infrastructure. It combines governance, economics, and execution into a unified system capable of supporting real-world collective action.
