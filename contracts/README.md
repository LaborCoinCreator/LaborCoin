# LaborCoin Smart Contracts

**Network:** Polygon

Core contracts for the LaborCoin system:

- Token (LABR)
- Governance (LABRV + DAO)
- Registration
- Governance
- Executors
- Exchange

---

## 📦 Deployed Contracts

| Component | Address |
|----------|--------|
| LABR Token | `0x460DD873A1D2a41e77410B125cD3027C5FEd2f78` |
| Exchange (V2) | `0xD0692ec758bb852421B702B187b6439f74f8Bf3b` |
| DAO | `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` |
| Registration (V2) | `0xFFc3499A71b806C3919f4B54D236b151cFdCB453` |
| LABRV (V6) | `0x113579220515cd59b884Ea2379b4C369025246e2` |
| DAO Governance | `xxx` |


---

## ⚙️ Executors

| Contract | Address |
|---------|--------|
| PauseExecutor (V2) | `0xe2a791FD057bBA5AEa0efcfb8b97f9de74cC7c06` |

---

## 🧠 Architecture

User
 ↓
Frontend
 ↓
Registration Contract
 ↓
LABRV Mint (1 per wallet)
 ↓
DAO Governance
 ↓
Executors
 ↓
Treasury / Actions

---

## 🪙 System Summary

- **LABR**  
  Fixed supply token with built-in: wallet, buy/sell and cooldown limits, as well as a 10% sell tax, used for exchange and DAO access

- **LABRV**  
  Non-transferable voting token (1 per wallet)

- **Registration**  
  Requires ≥1 LABR → Verify Uniquenss → Verify ID → Sign Attestation → mints LABRV

- **Exchange**  
  Bonding curve (quadratic) using pre-minted supply  
  10% of buy volume → DAO treasury  
  Sell tax handled by LABR token

---

## 🗳 Governance

- DAO controlled (Aragon)
- LABRV determines voting power
- Executors enforce actions

---

## 🔐 Notes

- Registration is one-time (LABR not continuously checked)
- No on-chain Sybil resistance yet (coming soon before launch!)
- Ownership will be transferred to DAO executor contracts after testing

---

## 📜 License

MIT
