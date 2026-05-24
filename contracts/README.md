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
| Exchange (v2) | `0xD0692ec758bb852421B702B187b6439f74f8Bf3b` |
| DAO | `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` |
| Registration (v3) | `0xa7D0C092C2391379046cACDc56BEbDe5A0CBD113` |
| LABRV (v6) | `0x113579220515cd59b884Ea2379b4C369025246e2` |
| DAO Governance (v7) | `0xbf06aA27bD4B327ec0B36dcD3d2aa1E72BCAc9e8` |


---

## ⚙️ Executors

| Contract | Address |
|---------|--------|
| PauseExecutor (v3) | `0x63a55Bd2C7e7d473a8DD74c1e568fb415Ba38A76` |

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
