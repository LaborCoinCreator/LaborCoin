# LaborCoin Smart Contracts

**Network:** Polygon

Core contracts for the LaborCoin system:

- Token (LABR)
- Governance (LABRV + DAO)
- Registration
- Executors
- Exchange

---

## 📦 Deployed Contracts

| Component | Address |
|----------|--------|
| LABR Token | `0x460DD873A1D2a41e77410B125cD3027C5FEd2f78` |
| Exchange (V2) | `0xD0692ec758bb852421B702B187b6439f74f8Bf3b` |
| DAO | `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` |
| Registration | `0x4fD4fC509e83f011A509f0B3406d35652169B8FF` |
| LABRV (Voting) | `0x3586B123191be1944DBDa623079cED5b6c8d03fE` |

---

## ⚙️ Executors

| Contract | Address |
|---------|--------|
| PauseExecutor | `0x5a0C3d5F6A814Dda121Fe174FFD963451E9fCa4f` |
| TreasuryExecutor | `0x440A756e16D4b42a015eC61258759037A454Ec79` |
| MintExecutor (legacy) | `0xA361cB84422452BDef5A04a447492ad176B09C0B` |

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
  Fixed supply token used for exchange and access

- **LABRV**  
  Non-transferable voting token (1 per wallet)

- **Registration**  
  Requires ≥1 LABR → mints LABRV

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
- No on-chain Sybil resistance yet
- Ownership should be transferred to DAO after testing

---

## 📜 License

MIT
