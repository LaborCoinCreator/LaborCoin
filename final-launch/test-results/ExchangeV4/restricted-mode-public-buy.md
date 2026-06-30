[01-restricted-mode-public-buy.md](https://github.com/user-attachments/files/29492023/01-restricted-mode-public-buy.md)
# Exchange V4 Validation Record

## Restricted-Mode Public Wallet Buy Test 001

## Document Control

| Field | Value |
|---|---|
| Network | Polygon Mainnet |
| Chain ID | 137 |
| Component | LaborCoin Exchange V4 |
| Test classification | Pre-launch restricted-mode diagnostic |
| Result | **PASS** |
| Record date | June 29, 2026 |
| On-chain timestamp | `ADD_EXACT_POLYGONSCAN_TIMESTAMP` |
| Evidence source | PolygonScan transaction record and protocol state reads |

---

## 1. Purpose

This test was conducted to determine why an ordinary public wallet could not purchase LABR through LaborCoin Exchange V4 while global LABR trading remained disabled.

The working hypothesis was that the LABR token classified Exchange V4 as an automated market maker and therefore required the non-AMM participant wallet to be excluded from the token's pre-trading restriction.

The tester wallet was temporarily excluded from the LABR trading restriction, and the same purchase flow was repeated through the official LaborCoin Exchange interface.

---

## 2. Test Result

**The purchase succeeded.**

This result confirms that the previous public-wallet failure was caused by the LABR token's pre-trading AMM restriction while `tradingEnabled()` was `false`.

The successful test also demonstrates that the following components operated correctly for this transaction:

- Wallet connection
- Polygon network connection
- Passport-gated Exchange interface
- Frontend transaction construction
- Exchange V4 `buy(uint256 minTokensOut)` execution
- Chainlink-based price calculation
- Exchange V4 LABR inventory transfer
- Exchange V4 treasury routing
- LABR balance accounting
- Dividend-tracker balance update

This test does **not** yet validate unrestricted public trading because the tester wallet had a temporary trading-restriction exclusion.

---

## 3. Contract and Wallet Addresses

| Component | Address |
|---|---|
| LABR Token | `0x460DD873A1D2a41e77410B125cD3027C5FEd2f78` |
| Exchange V4 | `0x4Cf18cB39203B678f5C26f2338a10a79f9684749` |
| DAO Treasury | `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` |
| Tester Wallet | `0x4ca6DDc4BA8a305054E9434738CEfb17fEA50b9d` |

---

## 4. Relevant Pre-Test State

| State | Recorded Value |
|---|---|
| `tradingEnabled()` | `false` |
| `AMMs(Exchange V4)` | `true` |
| `isExcludedFromTradingRestriction(Exchange V4)` | `true` |
| `isExcludedFromLimits(Exchange V4)` | `true` |
| `isExcludedFromFees(Exchange V4)` | `false` |
| `isExcludedFromDividends(Exchange V4)` | `true` |
| `isExcludedFromTradingRestriction(Tester Wallet)` | `true` temporarily |
| Tester excluded from token fees | `CONFIRM_AND_RECORD` |
| Tester excluded from token limits | `CONFIRM_AND_RECORD` |
| Tester blacklisted | `CONFIRM_FALSE` |
| LABR paused | `CONFIRM_FALSE` |

### Interpretation

For a LABR transfer from a recognized AMM to a user while global trading is disabled, the LABR token checks whether the recipient user is excluded from the trading restriction.

Temporarily excluding the tester wallet allowed the Exchange V4 transfer to complete.

Exchange V4's independent limits remained applicable:

- Maximum Exchange wallet balance: 10,000 LABR
- Maximum Exchange transaction: 5,000 LABR
- Exchange cooldown: 12 hours

---

## 5. Successful Transaction

| Field | Value |
|---|---|
| Transaction hash | `0x18aa24b6629a9dd461d32775e43039635feefe0767191f943c85831656e397f4` |
| PolygonScan | [View transaction](https://polygonscan.com/tx/0x18aa24b6629a9dd461d32775e43039635feefe0767191f943c85831656e397f4) |
| Status | Success |
| Block | `89394485` |
| From | `0x4ca6DDc4BA8a305054E9434738CEfb17fEA50b9d` |
| To | `0x4Cf18cB39203B678f5C26f2338a10a79f9684749` |
| Function | `buy(uint256 minTokensOut)` |
| Method ID | `0xd96a094a` |
| Input value | 15 POL |
| `minTokensOut` encoded | `0x0dbd26e31e59a400` |
| `minTokensOut` decoded | 0.98999025 LABR |
| LABR transferred to tester | Approximately 1.0419 LABR |
| POL transferred to DAO Treasury | 1.5 POL |
| Transaction fee | 0.22350018281885235 POL |
| Gas limit | 594,860 |
| Gas used | 588,030 |
| Gas utilization | 98.85% |
| Transaction type | EIP-1559 Type 2 |
| Tester nonce | 0 |
| Position in block | 38 |

---

## 6. Observed Asset Flows

### Purchase Input

```text
Tester Wallet
    |
    | 15 POL
    v
Exchange V4
```

### Treasury Allocation

```text
Exchange V4
    |
    | 1.5 POL
    v
DAO Treasury
```

The treasury allocation equals 10% of the 15 POL purchase value.

### LABR Output

```text
Exchange V4
    |
    | approximately 1.0419 LABR
    v
Tester Wallet
```

PolygonScan also displayed a DividendTracker token event associated with the tester wallet. This auxiliary event should be preserved as part of the evidence record but must not be counted as additional LABR received.

---

## 7. Finding

### Confirmed Cause of the Earlier Failure

The earlier transaction failed before wallet confirmation because gas estimation simulated the complete Exchange V4 purchase.

During that simulation:

1. Exchange V4 called LABR `transfer()` to send purchased LABR to the tester.
2. LABR recognized Exchange V4 as an AMM.
3. Global LABR trading was disabled.
4. The ordinary tester wallet was not yet excluded from the pre-trading restriction.
5. LABR reverted.
6. Exchange V4 converted the underlying token error into `Transfer fail`.
7. Gas estimation failed, so the wallet did not present a transaction confirmation.

After temporarily excluding the tester wallet, the same purchase path succeeded.

### Finding Status

**Confirmed by successful on-chain transaction.**

---

## 8. Scope and Limitations

This transaction validates a purchase under the following temporary condition:

```text
isExcludedFromTradingRestriction(Tester Wallet) = true
```

It does not yet prove that an arbitrary public wallet can purchase LABR after global trading is enabled.

It also does not complete validation of:

- Removal of the temporary tester exclusion
- Global `enableTrading()` activation
- Unrestricted public-wallet purchase
- Exchange V4 sell flow
- LABR sell-tax processing
- Treasury tax conversion
- Dividend distribution
- Uniswap pool behavior
- Final LABR parameter freeze
- LABR ownership renouncement

---

## 9. Required Follow-Up Evidence

Record each follow-up transaction in a separate validation file.

### 9.1 Remove Temporary Tester Exclusion

```text
Function:
excludeFromTradingRestriction(
    0x4ca6DDc4BA8a305054E9434738CEfb17fEA50b9d,
    false
)
```

| Field | Value |
|---|---|
| Transaction hash | `TO_BE_RECORDED` |
| Status | `TO_BE_RECORDED` |
| Post-state | `isExcludedFromTradingRestriction(Tester Wallet) = false` |

### 9.2 Enable Global LABR Trading

```text
Function:
enableTrading()
```

| Field | Value |
|---|---|
| Transaction hash | `TO_BE_RECORDED` |
| Status | `TO_BE_RECORDED` |
| Post-state | `tradingEnabled() = true` |

### 9.3 Unrestricted Public Buy Test

Use a fresh ordinary wallet that is not excluded from the LABR trading restriction.

| Field | Value |
|---|---|
| Validation file | `02-public-buy-after-trading-enabled.md` |
| Transaction hash | `TO_BE_RECORDED` |
| Result | `TO_BE_RECORDED` |

### 9.4 Public Sell Test

Because Exchange V4 applies a 12-hour cooldown, use a separate eligible wallet or wait at least 12 hours after its last Exchange V4 transaction.

| Field | Value |
|---|---|
| Validation file | `03-public-sell-after-trading-enabled.md` |
| Approval transaction | `TO_BE_RECORDED` |
| Sell transaction | `TO_BE_RECORDED` |
| Result | `TO_BE_RECORDED` |

---

## 10. Final Assessment

The restricted-mode diagnostic test passed and conclusively identified the token-level pre-trading restriction as the cause of the original public-wallet purchase failure.

The transaction provides positive evidence that Exchange V4, the official frontend, treasury routing, LABR transfer accounting, and the tester's wallet connection functioned correctly once the relevant pre-trading restriction was removed for the tester.

This record should be retained as diagnostic launch-validation evidence and should not be presented as the final unrestricted public-buy validation.
