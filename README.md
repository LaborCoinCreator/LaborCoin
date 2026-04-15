# LaborCoin

LaborCoin is a decentralized governance system designed to enable the working class to coordinate, allocate resources, and make collective decisions on-chain. It is built to fund striking workers.

It combines a voting token, DAO governance, and controlled execution to create a transparent and accountable decision-making framework for the purpose of funding striking workers in solidarity to overcome the economic retaliation of wage slavery.

---

## What This Is

LaborCoin is not a speculative token or passive investment.

It is a system for:

* Collective funding decisions
* Democratic resource allocation
* Coordinated action through shared governance

---

## How It Works

1. Participants receive a voting token (LABRV)
2. Proposals are submitted through LABR Solidarity Proposals (LSP)
3. Participants vote (one person, one vote)
4. If thresholds are met, the DAO executes the decision

---

## Governance Rules

* **1 LABRV per participant**
* **Non-transferable voting power**
* **75% participation required**
* **75% approval required**

This ensures decisions reflect broad consensus.

---

## System Architecture

LaborCoin separates decision-making from execution:

```
DAO → Executors → Contracts
```

* The DAO decides
* Executors enforce limits
* Contracts perform actions

This prevents arbitrary control and reduces risk.

---

## Core Components

### LABR

Primary token

### LABRV (v5)

Voting token

* Non-transferable
* One per participant

### DAO (Aragon)

Handles proposals, voting, and execution

### Executors

* PauseExecutor → controls token state
* TreasuryExecutor → distributes funds
* MintExecutor → mints voting tokens

---

## Deployment (Polygon)

```
DAO: 0x0C2e5679153593b82a84eAB5CA90895BB291Cec4
LABRV (v5): 0x3586B123191be1944DBDa623079cED5b6c8d03fE

PauseExecutor:     0x5a0C3d5F6A814Dda121Fe174FFD963451E9fCa4f
TreasuryExecutor:  0x440A756e16D4b42a015eC61258759037A454Ec79
MintExecutor:      0xA361cB84422452BDef5A04a447492ad176B09C0B
```

---

## Current Status

* Governance system live and tested
* Voting token deployed (LABRV v5)
* Executor architecture implemented
* First proposal successfully created and passed

**In progress:**

* Registration system (automated onboarding)
* Permission lockdown (removal of unrestricted execution)

---

## Design Principles

* One person, one vote
* Transparent governance
* Controlled execution
* Minimal attack surface
* Upgrade through governance, not admin control

---

## Roadmap

* Finalize registration system
* Restrict DAO to executor-only actions
* Enable public participation
* Expand treasury governance

---

## Disclaimer

LaborCoin is an experimental governance system. It is not a traditional investment. Participation involves interacting with smart contracts and decentralized systems, which carry inherent risks.

---

## License

MIT
