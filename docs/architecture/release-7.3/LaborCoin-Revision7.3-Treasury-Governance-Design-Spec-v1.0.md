# LaborCoin Revision 7.3 — Treasury & Governance Design Specification v1.0

**Status:** Pre-implementation design target  
**Purpose:** Define the exact multi-asset treasury behavior and clean-DAO integration before any Solidity edits, recompilation, test-harness rebuild, or external audit.

## 1. Release identity

- Overall release: **LaborCoin Revision 7.3**
- Governance contract: **LaborCoinGovernanceV16**
- Governance semantic version: **16.0.0**
- Structured Treasury Proposal Schema: **V2**
- Exchange lineage: **LaborCoinExchangeV7**, version bump to **7.1.0** for final-DAO rebinding
- LABR lineage: **LaborCoinV4**, version bump to **4.1.0** for final-DAO rebinding
- Proposal Text Policy V1.1.1: source behavior unchanged unless later documentation review identifies a required text-policy change
- Identity Registry V1.0.1: source behavior unchanged
- LaborVote V9.1.1: source behavior unchanged
- Registration V6.1.1: source behavior unchanged

Revision 7.2 remains preserved as a fully documented superseded pre-audit release candidate.

## 2. Final DAO architecture

Revision 7.3 binds the protocol to a newly created final Aragon DAO on Polygon PoS.

The final DAO must be created and permission-audited before its address is inserted into the Revision 7.3 source.

Final desired permission state after deployment and handoff:

- DAO self-ROOT: **true**
- Governance V16 DAO EXECUTE: **true**
- Non-DAO ROOT holders: **0**
- ANY_ADDR / wildcard EXECUTE: **0**
- Temporary Admin plugin DAO EXECUTE: **false**
- Temporary bootstrap account Admin execution authority: **false**
- Other external DAO EXECUTE holders: **0**

A temporary Admin/bootstrap path may exist during setup. It must be removed only after Governance V16 has been deployed, runtime-verified, granted EXECUTE, and the final handoff transaction has been rehearsed.

The dedicated Revision 7.2/7.3 production deployment EOA must remain untouched at nonce 0 until the new production freeze deliberately uses it.

## 3. Treasury asset model

The final DAO is a Polygon treasury.

Governance V16 supports exactly two classes of payout assets:

1. **Native POL**
2. **Strict-transfer-compatible fungible ERC-20 tokens deployed on Polygon**

The following are not supported by Governance V16:

- native BTC on Bitcoin
- native ETH on Ethereum
- ERC-721 NFTs
- ERC-1155 assets
- cross-chain execution
- automatic bridging
- swaps
- DEX routing
- staking
- lending
- approvals
- `transferFrom`
- arbitrary DAO calldata
- arbitrary external contract calls

Wrapped or bridged fungible assets on Polygon are treated only as ERC-20 contracts. Governance makes no claim about their backing, bridge security, issuer risk, price, or redemption.

## 4. Asset representation

Every proposal contains an immutable `asset` address.

- `asset == address(0)` means native POL.
- `asset != address(0)` means the specified Polygon token contract.

No symbol, name, decimals value, price, or off-chain identifier is authoritative on-chain.

The token contract address is the authoritative ERC-20 identity.

The UI may query token metadata for display only.

## 5. Proposal schema V2

Recommended `ProposalInput`:

```solidity
struct ProposalInput {
    string organizationName;
    address asset;
    address recipient;
    string workerGroupOrCampaign;
    uint256 amount;
    Purpose purpose;
    string verificationURI;
    ContactMethod contactMethod;
    DistributionPlan distributionPlan;
}
```

Recommended stored proposal fields:

```solidity
struct Proposal {
    string organizationName;
    address asset;
    address recipient;
    string workerGroupOrCampaign;
    uint256 amount;
    Purpose purpose;
    string verificationURI;
    ContactMethod contactMethod;
    DistributionPlan distributionPlan;
    bytes32 contentHash;
    uint256 yesVotes;
    uint256 noVotes;
    uint256 startTime;
    uint256 endTime;
    bool executed;
    address creator;
    uint256 creationElectorateSize;
    uint256 assetBalanceSnapshot;
    uint256 executedAt;
    bytes32 callId;
}
```

The existing electorate, voting, activation, execution-window, direct-wallet, structured-text, and one-active-proposal-per-creator policies remain unchanged.

## 6. Proposal identity commitments

The proposal content hash must commit to the `asset` address.

Schema commitment should become a new V2 identifier, for example:

```solidity
keccak256(
    "LABORCOIN_STRUCTURED_TREASURY_PROPOSAL_SCHEMA_V2_MULTI_ASSET"
)
```

The Governance compatibility identifier must be changed to a new V16 identifier that explicitly commits to:

- structured treasury schema V2
- deadline electorate
- direct-wallet governance
- final DAO
- native POL + constrained ERC-20 transfers
- per-asset 5% cap
- no arbitrary calldata

The proposal call ID must explicitly commit to at least:

- chain ID
- Governance contract address
- proposal ID
- asset
- recipient
- amount
- content hash

Even though `asset` is already inside the content hash, including it directly in the call ID is defense in depth and makes the execution identity self-evident.

## 7. Asset validation

### Native POL

`address(0)` is always the native-asset sentinel and does not require contract code.

### ERC-20 candidate

For `asset != address(0)`:

- `asset.code.length` must be nonzero.
- The asset must not be a protected current or legacy LaborCoin protocol address.
- LABR and LABRV must be explicitly rejected as treasury payout assets because their protocol transfer restrictions make them inappropriate for generic treasury distribution.
- The selected token must return a valid 32-byte `uint256` balance from `balanceOf(DAO)` at proposal creation.
- No `name()`, `symbol()`, `decimals()`, `totalSupply()`, ERC-165, oracle, or token-list dependency is required.

Recommended additional invariant:

- for ERC-20 proposals, `asset != recipient`.

This prevents accidental transfers into the token contract itself and removes an unnecessary pathological case.

## 8. Protected recipient policy

Preserve the existing recipient protections.

The recipient must not be:

- zero address
- final DAO
- Governance itself
- LABR
- LABRV
- Registration
- Proposal Text Policy
- official Exchange
- known superseded LaborCoin protocol contracts

The recipient must continue to contain deployed contract code.

Revision 7.3 does not broaden treasury grants to arbitrary EOAs.

## 9. Generic asset-balance function

Governance should use one internal asset-balance primitive.

Conceptual behavior:

```solidity
_assetBalance(asset, account)
```

Rules:

- if `asset == address(0)`, return `account.balance`
- otherwise perform a `staticcall` to `IERC20.balanceOf(account)`
- revert if the call fails
- revert if return data length is not exactly 32 bytes
- decode the result as `uint256`

Using `staticcall` prevents a malicious `balanceOf` implementation from changing state during a Governance balance query.

A malicious token can lie about its own balance. That affects only proposals for that token and must never affect POL or another asset.

## 10. Per-asset spending cap

`MAX_TRANSFER_BPS` remains **500 basis points = 5%**.

The maximum is calculated independently for the selected asset:

```text
maximum = floor(current selected-asset DAO balance × 5%)
```

Use full-precision `Math.mulDiv(balance, MAX_TRANSFER_BPS, BPS_DENOMINATOR)` or an equivalently overflow-safe calculation.

No asset's market value, balance, decimals, or reported metadata may influence another asset's limit.

Examples:

```text
POL maximum  = 5% of DAO POL
USDC maximum = 5% of DAO USDC
WETH maximum = 5% of DAO WETH
WBTC maximum = 5% of DAO WBTC
```

There is no aggregate "treasury USD value."

There are no price feeds or oracles.

## 11. Proposal-creation cap

At proposal creation:

1. validate proposer and governance activation
2. validate structured proposal text
3. validate categories
4. validate recipient
5. validate asset
6. require `amount > 0`
7. read selected asset's current DAO balance
8. reject zero selected-asset balance
9. calculate the 5% selected-asset maximum
10. reject amount above that maximum
11. perform existing membership-supply invariant check
12. commit the asset in the content hash
13. store the selected asset's creation-time balance as `assetBalanceSnapshot`

The snapshot is in raw smallest token units.

Token decimals are irrelevant to contract arithmetic.

## 12. Execution-time cap

Immediately before execution, Governance must again read the current balance of the proposal's selected asset.

Execution must fail if:

- current balance is below the approved amount, or
- approved amount is now greater than 5% of the current selected-asset balance.

This preserves the existing V15.2 rule that the cap is checked both at proposal creation and execution.

A later donation can increase the balance but cannot increase the already approved proposal amount.

A prior treasury payment can reduce the balance and make a later proposal non-executable if its amount has become too large relative to the remaining treasury.

## 13. Native POL execution

For `asset == address(0)`, preserve the existing execution shape:

```text
actions.length = 1
action.to       = approved recipient
action.value    = approved POL amount
action.data     = empty
allowFailureMap = 0
```

After execution:

```text
DAO POL balance after = DAO POL balance before - approved amount
```

The DAO action remains a single native transfer.

## 14. ERC-20 execution

For `asset != address(0)`, Governance constructs the only permitted token call itself.

Conceptual action:

```text
actions.length = 1
action.to       = selected token contract
action.value    = 0
action.data     = ABI encoding of transfer(recipient, amount)
allowFailureMap = 0
```

The proposer never supplies calldata.

Governance must never expose a generic `bytes calldata`, function selector, action array, arbitrary target, approval, or `transferFrom` path.

## 15. ERC-20 return-value validation

Aragon's DAO executor determines low-level call success by whether the target call reverts. ERC-20 itself requires callers to handle a returned `false`, and some historical tokens return no value.

Therefore, after `DAO.execute()` returns, Governance must inspect the single action result.

Accept:

- zero-length return data, subject to the balance-delta checks below
- exactly 32 bytes whose decoded value is exactly boolean `true`

Reject:

- exactly 32 bytes representing boolean `false`
- a malformed/non-boolean 32-byte value
- any other nonzero return-data length

If validation fails, Governance reverts the entire outer transaction so the nested DAO/token state changes revert as well.

## 16. Strict ERC-20 balance-delta invariant

Before ERC-20 execution, record:

```text
daoBalanceBefore
recipientBalanceBefore
```

After successful DAO execution and return-value validation, record:

```text
daoBalanceAfter
recipientBalanceAfter
```

Require exactly:

```text
daoBalanceBefore - daoBalanceAfter == amount
recipientBalanceAfter - recipientBalanceBefore == amount
```

Any mismatch reverts the entire transaction.

This deliberately rejects incompatible token behavior such as:

- fee-on-transfer deductions
- sender-side taxes
- receiver-side taxes
- unusual rebasing during transfer
- transfers that report success without moving the expected amount

LaborCoin should prefer strict accounting over attempting to support every non-standard token.

## 17. Reentrancy and execution ordering

Preserve the existing `nonReentrant` protection on proposal execution.

Preserve the existing ordering in which the proposal is marked executed before the external DAO execution call.

If any later check reverts, the entire transaction reverts and the executed state rolls back atomically.

A malicious token callback must not be able to execute the same or another Governance proposal reentrantly.

The final DAO permission model provides a second boundary: an arbitrary token contract does not possess DAO EXECUTE permission.

## 18. No automatic asset processing

Governance never:

- enumerates DAO-held ERC-20s
- automatically processes airdrops
- automatically sweeps assets
- automatically converts assets
- automatically splits a grant across multiple assets

A token has no effect merely because it exists in the DAO.

It becomes relevant only when a registered member deliberately creates a proposal specifying its exact contract address and that proposal obtains the required democratic approval.

## 19. No on-chain asset registry

Do not maintain a mutable or enumerable asset allowlist.

Reasons:

- immutable allowlists become obsolete
- mutable allowlists create another governance subsystem
- ERC-20 ownership is not natively enumerable across token contracts
- spam tokens could create registry/gas problems
- no registry is required for isolated one-asset proposals

The website may maintain a non-authoritative display list of common Polygon assets, but Governance accepts the contract address as the authoritative asset identifier.

## 20. No basket payouts

A proposal must not distribute "5% of the whole treasury" across multiple assets.

Reasons:

- requires asset enumeration
- creates gas growth
- one malicious/reverting token could block a basket
- partial failures create ambiguous payout outcomes
- aggregate valuation introduces oracle/manipulation risk

If a campaign is to receive POL and USDC, they are two separate proposals.

## 21. No aggregate valuation

Governance must never calculate:

```text
POL value + USDC value + WBTC value + ...
```

No price oracle, DEX quote, stablecoin assumption, or token market price may enter the spending-cap calculation.

This prevents a malicious or mispriced asset from increasing the amount of POL or another valuable asset that Governance can spend.

## 22. Per-proposal cap remains deliberate

The existing 5% policy remains a **per-proposal** limit, not a weekly, monthly, annual, or cumulative limit.

Repeated democratically approved proposals can spend a substantial fraction of an asset over time.

Revision 7.3 does not add a rolling expenditure budget.

This must remain explicit in the whitepaper and external-audit threat model.

## 23. Public getters

Recommended public interface changes:

```solidity
function assetBalance(address asset)
    external
    view
    returns (uint256);

function maxProposalAmount(address asset)
    external
    view
    returns (uint256);
```

`maxProposalAmount(address(0))` returns the current POL maximum.

`maxProposalAmount(token)` returns the current maximum for that token.

`proposalTerms(proposalId)` should return `asset` as an explicit executable term.

`proposalVoteData(proposalId)` should expose `assetBalanceSnapshot` rather than a POL-specific treasury snapshot name.

## 24. Events

`ProposalCreated` should include the exact `asset` address and creation-time selected-asset balance.

Recommended semantic contents:

```text
proposalId
creator
asset
recipient
amount
creationElectorateSize
assetBalanceSnapshot
startTime
endTime
callId
proposalType
proposalSchemaId
contentHash
```

`ProposalExecuted` should include:

```text
proposalId
executor
asset
recipient
amount
callId
assetBalanceBefore
assetBalanceAfter
executionResultHash
```

The exact indexed fields will be selected to stay within the EVM event-topic limit.

## 25. Recommended new/changed custom errors

At minimum, the implementation should distinguish:

```text
InvalidAsset(address asset)
AssetHasNoCode(address asset)
ProtectedProtocolAsset(address asset)
AssetEqualsRecipient(address asset)
AssetBalanceQueryFailed(address asset, address account)
InvalidAssetBalanceReturnData(address asset, address account, uint256 length)
EmptyAssetBalance(address asset)
TransferExceedsLimit(address asset, uint256 amount, uint256 maximum)
InsufficientAssetBalance(address asset, uint256 balance, uint256 amount)
ERC20TransferReturnedFalse(address asset)
InvalidERC20TransferReturnData(address asset, uint256 length)
InvalidERC20TransferReturnValue(address asset, uint256 value)
ERC20TreasuryBalanceDeltaMismatch(...)
ERC20RecipientBalanceDeltaMismatch(...)
```

Exact names may be optimized during implementation, but each failure class must remain explicitly distinguishable in tests.

## 26. Proposal type/version identifiers

Recommended conceptual changes:

```text
PROPOSAL_TYPE:
LABORCOIN_TREASURY_ASSET_TRANSFER

PROPOSAL_SCHEMA_VERSION:
LaborCoin Structured Treasury Proposal Schema V2

CONTRACT_VERSION:
LaborCoin Governance V16.0.0
```

The compatibility ID and call-ID prefix must be changed so V16 cannot be confused with the frozen V15.2 POL-only release.

## 27. Exchange and LABR final-DAO rebinding

The new final DAO address must replace the old DAO constant in:

- LaborCoinExchangeV7
- LaborCoinV4
- Governance V16

Recommended version-string bumps:

```text
LaborCoin Exchange V7.1.0
LaborCoin V4.1.0
LaborCoin Governance V16.0.0
```

No Exchange or LABR economic policy changes are authorized by this revision.

Buy and sell mechanics remain exactly:

```text
Buy: 10% POL to DAO; no buy dividend
Sell: 10% LABR tax = 5% DAO + 5% equal-per-eligible-holder dividend
```

## 28. Cross-contract provenance consequence

Because the final DAO address changes LABR/Exchange runtime commitments and the architecture cross-commits expected runtime hashes, Revision 7.3 must regenerate the entire production evidence chain.

Do not carry forward production runtime commitments from Revision 7.2.

Create a new complete Revision 7.3 seven-contract evidence set even where canonical Solidity source is unchanged.

## 29. Required unit and integration tests

### Existing governance behavior

Must continue to test:

- 50-member activation gate
- direct-wallet requirement
- one membership unit
- structured text policy
- one active proposal per creator
- 14-day proposal duration
- deadline electorate
- 25% participation
- 67% approval
- 7-day execution window
- recipient contract requirement
- protected current/legacy recipients
- membership-supply invariant
- proposal state transitions
- execution permission requirement

### Native POL

Must test:

- POL proposal creation
- zero POL treasury rejection
- creation-time 5% cap
- execution-time 5% recheck
- insufficient current balance
- one action only
- exact recipient target
- exact native value
- empty calldata
- `allowFailureMap == 0`
- DAO POL decreases by exactly amount
- ERC-20 balances cannot affect POL maximum

### Standard ERC-20

Must test at least:

- 18-decimal standard token
- 6-decimal standard token
- token without optional metadata
- exact creation cap
- exact execution cap
- correct token target
- zero native action value
- exact `transfer(recipient, amount)` selector/calldata
- DAO token balance decreases exactly amount
- recipient token balance increases exactly amount
- DAO native POL balance remains unchanged

### Return-value variants

Must test:

- standard `true` return: PASS
- legacy no-return token with exact balance movement: PASS
- explicit `false` return: REVERT
- malformed short return: REVERT
- malformed long return: REVERT
- invalid 32-byte boolean word: REVERT
- reverting token transfer: REVERT

### Non-standard accounting

Must test:

- fee-on-transfer token: REVERT
- sender-tax token: REVERT
- recipient receives less than amount: REVERT
- DAO loses more than amount: REVERT
- transfer reports success but does not move balances: REVERT
- unusual rebase/delta mismatch: REVERT

### Malicious token isolation

Must test:

- fake enormous `balanceOf`: cannot affect POL cap
- token callback attempts Governance reentrancy: REVERT/no duplicate execution
- token callback attempts DAO execute: lacks permission
- token reverts from `balanceOf`: only that asset/proposal fails
- token reverts during transfer: only that execution fails
- spam token sitting in DAO: no automatic effect
- malicious token cannot alter another asset's cap

### Asset validation

Must test:

- EOA/non-contract token address: REVERT
- zero-address sentinel treated only as POL
- LABR as asset: REVERT
- LABRV as asset: REVERT
- protected LaborCoin protocol address as asset: REVERT
- asset equals recipient: REVERT
- zero selected-asset balance: REVERT
- selected balance too small for nonzero 5% maximum: proposal cannot exceed zero maximum

### Multi-asset independence

Must test:

- POL + USDC + WETH-like balances coexist
- executing USDC proposal leaves POL unchanged
- executing POL proposal leaves token balances unchanged
- changing token A balance cannot change token B maximum
- changing token B balance cannot change POL maximum
- multiple proposals for different assets remain independently bounded

### Concurrent/repeated proposals

Must test:

- proposal valid at creation but exceeds 5% after earlier payout: execution REVERT
- proposal valid at creation and still within current limit: PASS
- treasury donation after creation does not change approved amount
- multiple approved proposals cannot bypass each proposal's execution-time cap
- document that no cumulative-period cap exists

## 30. Fuzz/invariant suite

Required invariants should include:

### Asset isolation

For any two distinct assets A and B:

```text
changing A's DAO balance must not change maxProposalAmount(B)
```

### POL execution

For every successful POL proposal:

```text
DAO_POL_before - DAO_POL_after == amount
```

### ERC-20 execution

For every successful ERC-20 proposal:

```text
DAO_token_before - DAO_token_after == amount
recipient_token_after - recipient_token_before == amount
DAO_POL_before == DAO_POL_after
```

### Action restriction

Every Governance execution must produce exactly one of only two action shapes:

```text
POL:
to = recipient
value = amount
data = empty

ERC20:
to = asset
value = 0
data = exact transfer(recipient, amount)
```

No other target/value/calldata combination is reachable.

### Permission restriction

After final DAO handoff:

```text
Governance EXECUTE = true
Admin EXECUTE = false
external ROOT count = 0
wildcard EXECUTE count = 0
DAO self-ROOT = true
```

## 31. Frontend requirements

The Governance page must make the asset contract address visible and authoritative.

Recommended flow:

```text
Asset:
- Native POL
- ERC-20 contract address
```

For ERC-20:

- fetch symbol/name/decimals only for display
- always show full contract address
- warn that metadata can be spoofed
- show raw/current DAO balance
- show formatted balance
- show 5% maximum
- show proposal amount
- link to the token contract on the canonical Polygon explorer

The UI must not offer arbitrary calldata or arbitrary DAO actions.

## 32. Direct-contract-access documentation

The future Direct Contract Access page must document:

- `address(0)` means native POL
- exact final DAO address
- exact Governance address
- exact proposal schema
- exact supported asset classes
- exact per-asset cap
- no aggregate valuation
- no automatic basket payout
- strict ERC-20 transfer rules
- canonical function signatures
- final runtime hashes
- third-party frontend warnings

## 33. Treasury documentation warnings

Documentation must state:

- the DAO may technically receive assets Governance does not support
- NFTs/ERC-1155s may be permanently inaccessible
- native BTC and native Ethereum ETH must not be sent to the Polygon DAO as if it existed on those chains
- wrapped/bridged assets carry their own issuer/bridge/custody risks
- an ERC-20 being visible in Aragon does not guarantee Governance can successfully distribute it
- strict-transfer-incompatible ERC-20s may remain stuck
- users should prefer native POL or well-understood standard ERC-20s on Polygon

## 34. Independent-audit focus

The external auditor must specifically review:

- arbitrary-call impossibility
- asset isolation
- malicious-token callbacks
- ERC-20 return parsing
- strict balance-delta correctness
- reentrancy
- Aragon `execute` return semantics
- execution rollback after post-call validation failure
- permission handoff
- concurrent proposal behavior
- per-proposal 5% semantics
- token balance-query abuse
- integer/rounding behavior
- all cross-contract runtime commitments

## 35. Fresh release process

After the final DAO is created and its bootstrap permissions are audited:

1. Record final DAO address, creation tx and block.
2. Freeze the DAO's pre-handoff permission baseline.
3. Apply the final DAO address to Exchange and LABR.
4. Implement Governance V16 exactly to this specification.
5. Update compatibility/version/schema IDs.
6. Update site and documentation, including treasury and direct-access guidance.
7. Create a new Revision 7.3 source freeze.
8. Recompile/re-record all seven contracts.
9. Regenerate all runtime commitments and constructor bindings.
10. Rebuild exact-artifact Stage 1.
11. Rebuild fresh-DAO Polygon-fork Stage 2.
12. Rehearse final Governance permission handoff.
13. Rebuild deterministic production transaction plan.
14. Rehearse the entire production deployment sequence.
15. Obtain independent external security review against the exact Revision 7.3 freeze.
16. Resolve any source-changing findings by creating a new freeze and rerunning affected gates.
17. Rerun time-sensitive DAO/deployer/address/gas checks.
18. Deploy one transaction at a time with runtime verification after each deployment.
19. Grant Governance V16 EXECUTE and remove all temporary bootstrap authority.
20. Publish final provenance and Direct Contract Access material.

## 36. Non-goals

Revision 7.3 does not add:

- protocol upgrades
- owner/admin recovery
- emergency pause
- arbitrary governance execution
- treasury swaps
- oracle-priced budgets
- multi-chain treasury control
- automatic bridge interaction
- NFT management
- token allowlist governance
- cumulative spending periods
- investment/portfolio management

## 37. Final design invariant

The central treasury invariant is:

> **One proposal. One asset. One recipient. One bounded transfer.**

For every asset, Governance can move no more than 5% of that asset's current DAO balance through one proposal, and no other asset can increase that allowance.

This is the Revision 7.3 implementation target.
