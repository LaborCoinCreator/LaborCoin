# LaborCoin

A governance system for coordinating labor, allocating resources, and executing collective decisions on-chain.

LaborCoin is a decentralized governance system designed to enable the working class to coordinate, allocate resources, and make collective decisions on-chain. It is built to support striking workers.

It combines a voting token, DAO governance, and controlled execution to create a transparent and accountable decision-making framework.

The goal: enable sustained collective action by overcoming economic retaliation with working-class organizing and financial solidarity.

---

## What This Is

LaborCoin is not a speculative token or passive investment.

It is a system for:

- Collective funding decisions  
- Democratic resource allocation  
- Coordinated action through shared governance  

---

## How It Works

1. Participants register and receive a voting token (LABRV)  
2. Proposals are submitted through LaborCoin Solidarity Proposals (LSP)  
3. Participants vote (one person, one vote)  
4. If thresholds are met, the DAO executes decisions through executors  

---

## Governance Rules

- **1 LABRV per participant**
- **Non-transferable voting power**
- **75% participation required**
- **75% approval required**

These constraints ensure decisions reflect broad consensus.

---

## System Architecture

LaborCoin separates decision-making from execution:

DAO → Executors → Contracts → Treasury → Distribution

- The DAO decides  
- Executors enforce constraints  
- Contracts perform actions  

This structure minimizes centralized control and reduces risk.

---

## Core Components

### LABR

Primary token distributed through the bonding curve exchange.

---

### LABRV (v6)

Voting token

- Non-transferable  
- One per participant  
- Enables one-person, one-vote governance  

---

### DAO (Aragon)

Handles proposals, voting, and execution logic.

---

### Executors

Restricted execution layer between governance and contracts.

- PauseExecutor → controls trading state (pause/unpause)  
- TreasuryExecutor → distributes funds  

Executors enforce boundaries on what governance can do.

---

## Exchange Contract (LABR)

**Network:** Polygon  
**Address:**  
0xD0692ec758bb852421B702B187b6439f74f8Bf3b

The LaborCoin exchange contract implements a bonding curve token system designed to fund worker solidarity.

### Core Mechanics

- Deterministic pricing curve (~$1 → ~$15)  
- Continuous liquidity via bonding curve  
- POL/USD oracle pricing  
- Slippage-protected trades  

---

### Constraints

- Transaction limit: 5,000 LABR  
- Wallet limit: 10,000 LABR  
- 12-hour cooldown between transactions  
- 10% buy fee routed to DAO treasury  

---

### Safety Mechanisms

- Oracle staleness protection  
- Circuit breaker (auto-pause on abnormal price movement)  
- Reentrancy protection  
- Treasury accounting enforcement  

---

### Governance Control

The exchange contract is parameter-locked.

The DAO (via executor) can only:

- Pause trading  
- Resume trading  

It cannot:

- Change pricing  
- Change limits  
- Change fees  
- Modify supply mechanics  

---

## Deployment (Polygon)

| Component            | Address |
|---------------------|--------|
| LABR Token          | `0x460DD873A1D2a41e77410B125cD3027C5FEd2f78` |
| Exchange (v2)       | `0xD0692ec758bb852421B702B187b6439f74f8Bf3b` |
| LaborCoin DAO       | `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` |
| Registration (v3)   | `0xa7D0C092C2391379046cACDc56BEbDe5A0CBD113` |
| Governance (v7)     | `0xbf06aA27bD4B327ec0B36dcD3d2aa1E72BCAc9e8` |
| LABRV (v6)          | `0x113579220515cd59b884Ea2379b4C369025246e2` |
| PauseExecutor (v3)  | `0x63a55Bd2C7e7d473a8DD74c1e568fb415Ba38A76` |

---

## Current Status

- Governance system live and tested  
- Voting token deployed (LABRV v6)  
- Executor architecture implemented  
- First proposal successfully created and passed  

In progress:

- Registration system (automated onboarding)  
- Final permission lockdown  

---

## Design Principles

- One person, one vote  
- Transparent governance  
- Controlled execution  
- Minimal attack surface  
- Immutable economic rules  

---

## Roadmap

- Finalize registration system  
- Restrict DAO to executor-only actions  
- Enable public participation  
- Expand treasury governance  

---

## Disclaimer

LaborCoin is an experimental governance system. It is not a traditional investment. Participation involves interacting with smart contracts and decentralized systems, which carry inherent risks.

---

## License

MIT
