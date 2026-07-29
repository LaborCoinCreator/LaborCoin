// SPDX-License-Identifier: MIT
pragma solidity 0.8.36;

import {ReentrancyGuard} from "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v5.6.1/contracts/utils/ReentrancyGuard.sol";

/// @notice Exact protocol-restricted LABR V4 interface required by the immutable Exchange V7.
interface ILaborCoinV4ForExchange {
    function balanceOf(address account) external view returns (uint256);
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);
    function transfer(
        address to,
        uint256 value
    ) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function depositDividends() external payable;

    function launchFinalized() external view returns (bool);
    function officialExchange() external view returns (address);
    function daoTreasury() external view returns (address);
    function identityRegistry() external view returns (address);
    function expectedIdentityRegistryRuntimeCodeHash() external view returns (bytes32);

    function TOTAL_SUPPLY() external view returns (uint256);
    function MAX_WALLET() external view returns (uint256);
    function MAX_TRANSACTION() external view returns (uint256);
    function TRADE_COOLDOWN() external view returns (uint256);

    function BUY_TREASURY_BPS() external view returns (uint256);
    function SELL_TREASURY_BPS() external view returns (uint256);
    function SELL_DIVIDEND_BPS() external view returns (uint256);

    function EXCHANGE_COMPATIBILITY_ID()
        external
        view
        returns (bytes32);

    function canTrade(
        address account
    ) external view returns (bool);

    function nextTradeTime(
        address account
    ) external view returns (uint256);
}

interface ILaborCoinIdentityRegistryV1ForExchange {
    function isVerified(address participant) external view returns (bool);
    function COMPATIBILITY_ID() external view returns (bytes32);
    function MIN_PASSPORT_SCORE() external view returns (uint256);
    function LABR() external view returns (address);
    function labrFinalized() external view returns (bool);
    function expectedLABRRuntimeCodeHash() external view returns (bytes32);
}

/// @title LaborCoin Exchange V7
/// @notice Immutable official LABR market using a POL-denominated integral curve.
/// @dev
/// Core invariants:
/// - LABR is the sole traded token.
/// - The curve is denominated directly in native POL; no oracle is used.
/// - Buys purchase an exact LABR amount using the integral of the curve.
/// - The 10% buy treasury contribution is charged outside the curve reserve.
/// - Sells redeem the exact inverse integral and split the gross redemption:
///   90% seller, 5% DAO treasury, and 5% LABR-holder POL dividends.
/// - `accountedReserve` always equals `curveReserveAt(totalSold)`.
/// - Exchange LABR inventory always equals `MAX_SUPPLY - totalSold`.
/// - Identity Registry V1 independently verifies every official buyer and seller.
/// - The LABR token independently enforces the 5,000 transaction limit,
///   10,000 wallet limit, protocol-only transfer policy, and 12-hour trade cooldown.
/// - No owner, pause, upgrade, withdrawal, recovery, setter, or arbitrary call exists.
///
/// Runtime-code-hash requirement:
/// - `LABR` is deliberately stored in contract storage rather than declared
///   immutable. Constructor arguments therefore do not alter deployed runtime
///   bytecode, allowing LABR V4 to precommit to this contract's exact runtime
///   code hash before the Exchange address exists.
contract LaborCoinExchangeV7 is ReentrancyGuard {
    /*//////////////////////////////////////////////////////////////
                                CONSTANTS
    //////////////////////////////////////////////////////////////*/

    uint256 public constant POLYGON_MAINNET_CHAIN_ID = 137;

    uint256 public constant WAD = 1 ether;
    uint256 public constant BPS_DENOMINATOR = 10_000;

    uint256 public constant MAX_SUPPLY = 1_000_000_000 ether;
    uint256 public constant MAX_SUPPLY_TOKENS = 1_000_000_000;

    uint256 public constant MAX_EXCHANGE_WALLET = 10_000 ether;
    uint256 public constant MAX_EXCHANGE_TRANSACTION = 5_000 ether;
    uint256 public constant TRADE_COOLDOWN = 12 hours;

    uint256 public constant BUY_TREASURY_BPS = 1_000;
    uint256 public constant SELL_TREASURY_BPS = 500;
    uint256 public constant SELL_DIVIDEND_BPS = 500;
    uint256 public constant SELLER_BPS =
        BPS_DENOMINATOR
            - SELL_TREASURY_BPS
            - SELL_DIVIDEND_BPS;

    /// @notice Starting curve price: 14 POL per LABR.
    uint256 public constant MIN_PRICE_POL = 14 ether;

    /// @notice Maximum curve price at full distribution: 210 POL per LABR.
    uint256 public constant MAX_PRICE_POL = 210 ether;

    uint256 public constant PRICE_RANGE_POL =
        MAX_PRICE_POL - MIN_PRICE_POL;

    uint256 public constant INITIAL_TRANCHE = 100_000_000 ether;
    uint256 public constant TRANCHE_SIZE = 50_000_000 ether;

    address public constant daoTreasury =
        0x0C2e5679153593b82a84eAB5CA90895BB291Cec4;

    bytes32 public constant COMPATIBILITY_ID =
        keccak256(
            "LABORCOIN_EXCHANGE_V7_POL_IDENTITY_EQUAL_HOLDER_RESTRICTED_TRANSFER_V1"
        );

    string public constant CONTRACT_VERSION =
        "LaborCoin Exchange V7.0.0";

    /*//////////////////////////////////////////////////////////////
                                 STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice Final LABR V4 address. Stored, not immutable, by design.
    address public LABR;
    address public identityRegistry;
    bytes32 public expectedIdentityRegistryRuntimeCodeHash;

    /// @notice LABR currently outside the Exchange inventory.
    uint256 public totalSold;

    /// @notice Permanently unlocked distribution capacity.
    uint256 public unlockedSupply;

    /// @notice POL reserved exclusively for integral-curve redemptions.
    uint256 public accountedReserve;

    struct BuyCache {
        uint256 buyerBalance;
        uint256 resultingBalance;
        uint256 soldBefore;
        uint256 soldAfter;
        uint256 inventoryBefore;
        uint256 reserveContribution;
        uint256 daoContribution;
        uint256 requiredPOL;
        uint256 buyerBalanceBefore;
        uint256 buyerReceived;
        uint256 inventoryAfter;
        uint256 inventoryMoved;
        uint256 refund;
    }

    struct SellCache {
        uint256 sellerBalance;
        uint256 approved;
        uint256 soldBefore;
        uint256 soldAfter;
        uint256 grossRedemption;
        uint256 sellerPOL;
        uint256 daoContribution;
        uint256 dividendContribution;
        uint256 inventoryBefore;
        uint256 inventoryAfter;
        uint256 inventoryReceived;
        uint256 sellerDebited;
    }

    /*//////////////////////////////////////////////////////////////
                                  ERRORS
    //////////////////////////////////////////////////////////////*/

    error ZeroAddress();
    error WrongChain(uint256 actualChainId);
    error AddressHasNoCode(address account);
    error OnlyDirectWallet(address caller, address transactionOrigin);
    error ZeroCodeHash();
    error IdentityVerificationRequired(address account);
    error InvalidIdentityRuntimeCodeHash(bytes32 actual, bytes32 expected);
    error InvalidIdentityCompatibility(bytes32 actual);
    error InvalidIdentityThreshold(uint256 actual);
    error InvalidTokenIdentity(address actual);
    error InvalidTokenIdentityCodeHash(bytes32 actual);

    error InvalidTokenTreasury(address reportedTreasury);
    error InvalidTokenCompatibility(bytes32 reportedCompatibility);
    error InvalidTokenSupply(uint256 reportedSupply);
    error InvalidTokenWalletLimit(uint256 reportedLimit);
    error InvalidTokenTransactionLimit(uint256 reportedLimit);
    error InvalidTokenCooldown(uint256 reportedCooldown);
    error InvalidTokenTaxConfiguration(
        uint256 buyTreasuryBps,
        uint256 sellTreasuryBps,
        uint256 sellDividendBps
    );

    error LaunchNotFinalized();
    error WrongOfficialExchange(address reportedExchange);

    error ZeroTokenAmount();
    error TransactionLimitExceeded(uint256 amount, uint256 maximum);
    error WalletAboveLimit(address account, uint256 balance);
    error WalletLimitExceeded(
        address account,
        uint256 resultingBalance,
        uint256 maximum
    );
    error InsufficientTokenBalance(uint256 available, uint256 required);
    error RedemptionExceedsSoldSupply(
        uint256 requested,
        uint256 totalSold
    );
    error InsufficientAllowance(uint256 available, uint256 required);
    error InsufficientInventory(uint256 available, uint256 required);
    error SupplyExceeded(uint256 resultingSold, uint256 maximum);
    error SupplyLocked(uint256 resultingSold, uint256 unlocked);

    error DeadlineExpired(uint256 deadline, uint256 currentTimestamp);
    error MaximumPOLExceeded(uint256 required, uint256 maximum);
    error PaymentExceedsMaximum(uint256 payment, uint256 maximum);
    error InsufficientPOLPayment(uint256 payment, uint256 required);
    error MinimumPOLNotMet(uint256 actual, uint256 minimum);

    error TokenTransferFailed();
    error UnexpectedTokenMovement(uint256 expected, uint256 actual);
    error NativeTransferFailed(address recipient, uint256 amount);
    error DirectPOLDepositRejected();

    error ReserveAccountingMismatch(
        uint256 accounted,
        uint256 expected
    );
    error ReserveUnderfunded(uint256 actual, uint256 required);
    error InventoryAccountingMismatch(
        uint256 actual,
        uint256 expected
    );

    /*//////////////////////////////////////////////////////////////
                                  EVENTS
    //////////////////////////////////////////////////////////////*/

    event BuyExecuted(
        address indexed buyer,
        uint256 tokensOut,
        uint256 totalPOLIn,
        uint256 reserveContribution,
        uint256 daoContribution,
        uint256 refund,
        uint256 totalSoldAfter
    );

    event SellExecuted(
        address indexed seller,
        uint256 tokensIn,
        uint256 grossRedemption,
        uint256 sellerPOL,
        uint256 daoContribution,
        uint256 dividendContribution,
        uint256 totalSoldAfter
    );

    event TrancheUnlocked(
        uint256 previousUnlockedSupply,
        uint256 newUnlockedSupply
    );

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(
        address labr_,
        address identityRegistry_,
        bytes32 expectedIdentityRegistryRuntimeCodeHash_
    ) {
        _validateDeploymentInputs(
            labr_,
            identityRegistry_,
            expectedIdentityRegistryRuntimeCodeHash_
        );
        _validateIdentityConfiguration(
            labr_,
            identityRegistry_,
            expectedIdentityRegistryRuntimeCodeHash_
        );
        _validateTokenConfiguration(
            labr_,
            identityRegistry_,
            expectedIdentityRegistryRuntimeCodeHash_
        );

        LABR = labr_;
        identityRegistry = identityRegistry_;
        expectedIdentityRegistryRuntimeCodeHash =
            expectedIdentityRegistryRuntimeCodeHash_;
        unlockedSupply = INITIAL_TRANCHE;
    }

    /*//////////////////////////////////////////////////////////////
                           EXACT-TOKEN PURCHASES
    //////////////////////////////////////////////////////////////*/

    /// @notice Purchases an exact amount of LABR.
    /// @param tokenAmount Exact LABR amount, including 18 decimals.
    /// @param maxPOLIn User's maximum acceptable total POL cost.
    /// @param deadline Final timestamp at which the trade may execute.
    /// @return totalPOLIn Exact total POL charged before refund.
    function buyExactTokens(
        uint256 tokenAmount,
        uint256 maxPOLIn,
        uint256 deadline
    )
        external
        payable
        nonReentrant
        returns (uint256 totalPOLIn)
    {
        _requireDirectWallet();
        _requireVerified(msg.sender);
        _requireLaunchReady();
        _requireDeadline(deadline);

        // `msg.value` is credited before function execution. Excluding it here
        // prevents a new buyer payment from masking any preexisting deficit.
        _assertReserveAccounting();
        _assertTokenInventory();
        _assertReserveCoverageBeforePayment(msg.value);

        _requireValidTransactionAmount(tokenAmount);

        ILaborCoinV4ForExchange token = ILaborCoinV4ForExchange(LABR);
        BuyCache memory cache;

        cache.buyerBalance =
            token.balanceOf(msg.sender);
        if (
            cache.buyerBalance
                > MAX_EXCHANGE_WALLET
        ) {
            revert WalletAboveLimit(
                msg.sender,
                cache.buyerBalance
            );
        }

        cache.resultingBalance =
            cache.buyerBalance + tokenAmount;
        if (
            cache.resultingBalance
                > MAX_EXCHANGE_WALLET
        ) {
            revert WalletLimitExceeded(
                msg.sender,
                cache.resultingBalance,
                MAX_EXCHANGE_WALLET
            );
        }

        cache.soldBefore = totalSold;
        cache.soldAfter =
            cache.soldBefore + tokenAmount;
        if (cache.soldAfter > MAX_SUPPLY) {
            revert SupplyExceeded(
                cache.soldAfter,
                MAX_SUPPLY
            );
        }

        _unlockToCover(cache.soldAfter);

        cache.inventoryBefore =
            token.balanceOf(address(this));
        if (
            cache.inventoryBefore
                < tokenAmount
        ) {
            revert InsufficientInventory(
                cache.inventoryBefore,
                tokenAmount
            );
        }

        (
            cache.reserveContribution,
            cache.daoContribution,
            cache.requiredPOL
        ) = quoteBuyExactTokens(tokenAmount);

        if (cache.requiredPOL > maxPOLIn) {
            revert MaximumPOLExceeded(
                cache.requiredPOL,
                maxPOLIn
            );
        }
        if (msg.value > maxPOLIn) {
            revert PaymentExceedsMaximum(
                msg.value,
                maxPOLIn
            );
        }
        if (msg.value < cache.requiredPOL) {
            revert InsufficientPOLPayment(
                msg.value,
                cache.requiredPOL
            );
        }

        totalSold = cache.soldAfter;
        accountedReserve +=
            cache.reserveContribution;

        cache.buyerBalanceBefore =
            cache.buyerBalance;

        bool transferred =
            token.transfer(
                msg.sender,
                tokenAmount
            );
        if (!transferred) {
            revert TokenTransferFailed();
        }

        cache.buyerReceived =
            token.balanceOf(msg.sender)
                - cache.buyerBalanceBefore;
        if (cache.buyerReceived != tokenAmount) {
            revert UnexpectedTokenMovement(
                tokenAmount,
                cache.buyerReceived
            );
        }

        cache.inventoryAfter =
            token.balanceOf(address(this));
        cache.inventoryMoved =
            cache.inventoryBefore
                - cache.inventoryAfter;
        if (cache.inventoryMoved != tokenAmount) {
            revert UnexpectedTokenMovement(
                tokenAmount,
                cache.inventoryMoved
            );
        }

        _assertTokenInventory();

        cache.refund =
            msg.value - cache.requiredPOL;

        _sendPOL(
            daoTreasury,
            cache.daoContribution
        );
        _sendPOL(msg.sender, cache.refund);

        _assertReserveAccounting();
        _assertReserveCoverage();

        emit BuyExecuted(
            msg.sender,
            tokenAmount,
            cache.requiredPOL,
            cache.reserveContribution,
            cache.daoContribution,
            cache.refund,
            cache.soldAfter
        );

        return cache.requiredPOL;
    }

    /*//////////////////////////////////////////////////////////////
                              EXACT-TOKEN SALES
    //////////////////////////////////////////////////////////////*/

    /// @notice Sells an exact amount of LABR.
    /// @param tokenAmount Exact LABR amount, including 18 decimals.
    /// @param minPOLOut Minimum acceptable POL paid to the seller.
    /// @param deadline Final timestamp at which the trade may execute.
    /// @return sellerPOL Exact POL paid to the seller.
    function sellExactTokens(
        uint256 tokenAmount,
        uint256 minPOLOut,
        uint256 deadline
    )
        external
        nonReentrant
        returns (uint256 sellerPOL)
    {
        _requireDirectWallet();
        _requireVerified(msg.sender);
        _requireLaunchReady();
        _requireDeadline(deadline);
        _assertAccountingInvariants();

        _requireValidTransactionAmount(tokenAmount);

        ILaborCoinV4ForExchange token = ILaborCoinV4ForExchange(LABR);
        SellCache memory cache;

        cache.sellerBalance =
            token.balanceOf(msg.sender);
        if (
            cache.sellerBalance
                > MAX_EXCHANGE_WALLET
        ) {
            revert WalletAboveLimit(
                msg.sender,
                cache.sellerBalance
            );
        }
        if (
            cache.sellerBalance
                < tokenAmount
        ) {
            revert InsufficientTokenBalance(
                cache.sellerBalance,
                tokenAmount
            );
        }

        cache.approved =
            token.allowance(
                msg.sender,
                address(this)
            );
        if (cache.approved < tokenAmount) {
            revert InsufficientAllowance(
                cache.approved,
                tokenAmount
            );
        }

        cache.soldBefore = totalSold;
        if (tokenAmount > cache.soldBefore) {
            revert RedemptionExceedsSoldSupply(
                tokenAmount,
                cache.soldBefore
            );
        }

        (
            cache.grossRedemption,
            cache.sellerPOL,
            cache.daoContribution,
            cache.dividendContribution
        ) = quoteSellExactTokens(tokenAmount);

        sellerPOL = cache.sellerPOL;

        if (sellerPOL < minPOLOut) {
            revert MinimumPOLNotMet(
                sellerPOL,
                minPOLOut
            );
        }

        if (
            accountedReserve
                < cache.grossRedemption
        ) {
            revert ReserveUnderfunded(
                accountedReserve,
                cache.grossRedemption
            );
        }
        if (
            address(this).balance
                < cache.grossRedemption
        ) {
            revert ReserveUnderfunded(
                address(this).balance,
                cache.grossRedemption
            );
        }

        cache.soldAfter =
            cache.soldBefore - tokenAmount;
        totalSold = cache.soldAfter;
        accountedReserve -=
            cache.grossRedemption;

        cache.inventoryBefore =
            token.balanceOf(address(this));

        bool transferred = token.transferFrom(
            msg.sender,
            address(this),
            tokenAmount
        );
        if (!transferred) {
            revert TokenTransferFailed();
        }

        cache.inventoryAfter =
            token.balanceOf(address(this));
        cache.inventoryReceived =
            cache.inventoryAfter
                - cache.inventoryBefore;
        if (
            cache.inventoryReceived
                != tokenAmount
        ) {
            revert UnexpectedTokenMovement(
                tokenAmount,
                cache.inventoryReceived
            );
        }

        cache.sellerDebited =
            cache.sellerBalance
                - token.balanceOf(msg.sender);
        if (cache.sellerDebited != tokenAmount) {
            revert UnexpectedTokenMovement(
                tokenAmount,
                cache.sellerDebited
            );
        }

        _assertTokenInventory();

        // The seller's returned LABR has already been removed from dividend
        // eligibility before this sale's holder share is deposited.
        if (cache.dividendContribution != 0) {
            token.depositDividends{
                value: cache.dividendContribution
            }();
        }

        _sendPOL(
            daoTreasury,
            cache.daoContribution
        );
        _sendPOL(msg.sender, sellerPOL);

        _assertReserveAccounting();
        _assertReserveCoverage();

        emit SellExecuted(
            msg.sender,
            tokenAmount,
            cache.grossRedemption,
            sellerPOL,
            cache.daoContribution,
            cache.dividendContribution,
            cache.soldAfter
        );

        return sellerPOL;
    }

    /*//////////////////////////////////////////////////////////////
                              CURVE QUOTES
    //////////////////////////////////////////////////////////////*/

    /// @notice Current marginal price in POL wei per whole LABR.
    function currentSpotPricePOL()
        external
        view
        returns (uint256)
    {
        return spotPricePOL(totalSold);
    }

    /// @notice Marginal price at a supplied distribution point.
    function spotPricePOL(
        uint256 sold
    ) public pure returns (uint256) {
        if (sold > MAX_SUPPLY) {
            revert SupplyExceeded(sold, MAX_SUPPLY);
        }

        uint256 normalized =
            (sold * WAD) / MAX_SUPPLY;
        uint256 normalizedSquared =
            (normalized * normalized) / WAD;

        return
            MIN_PRICE_POL
                + (
                    PRICE_RANGE_POL
                        * normalizedSquared
                ) / WAD;
    }

    /// @notice Total POL curve liability at a supplied distribution point.
    /// @dev Integral of:
    /// P(s) = MIN_PRICE_POL
    ///      + PRICE_RANGE_POL * (s / MAX_SUPPLY)^2
    ///
    /// F(s) = MIN_PRICE_POL * s
    ///      + PRICE_RANGE_POL * MAX_TOKENS * x^3 / 3
    ///
    /// where token-unit conversion and fixed-point scaling are applied below.
    function curveReserveAt(
        uint256 sold
    ) public pure returns (uint256) {
        if (sold > MAX_SUPPLY) {
            revert SupplyExceeded(sold, MAX_SUPPLY);
        }

        uint256 normalized =
            (sold * WAD) / MAX_SUPPLY;
        uint256 normalizedSquared =
            (normalized * normalized) / WAD;
        uint256 normalizedCubed =
            (normalizedSquared * normalized) / WAD;

        uint256 linearComponent =
            (MIN_PRICE_POL * sold) / WAD;

        uint256 curvedComponent =
            (
                PRICE_RANGE_POL
                    * MAX_SUPPLY_TOKENS
                    * normalizedCubed
            ) / (3 * WAD);

        return linearComponent + curvedComponent;
    }

    /// @notice Quotes the exact POL requirements for an exact-token purchase.
    function quoteBuyExactTokens(
        uint256 tokenAmount
    )
        public
        view
        returns (
            uint256 reserveContribution,
            uint256 daoContribution,
            uint256 totalPOLIn
        )
    {
        _requireValidTransactionAmount(tokenAmount);

        uint256 soldAfter = totalSold + tokenAmount;
        if (soldAfter > MAX_SUPPLY) {
            revert SupplyExceeded(
                soldAfter,
                MAX_SUPPLY
            );
        }

        reserveContribution =
            curveReserveAt(soldAfter)
                - curveReserveAt(totalSold);

        uint256 netBps =
            BPS_DENOMINATOR - BUY_TREASURY_BPS;

        totalPOLIn = _ceilDiv(
            reserveContribution * BPS_DENOMINATOR,
            netBps
        );

        daoContribution =
            totalPOLIn - reserveContribution;
    }

    /// @notice Quotes the exact inverse-curve redemption and sell split.
    function quoteSellExactTokens(
        uint256 tokenAmount
    )
        public
        view
        returns (
            uint256 grossRedemption,
            uint256 sellerPOL,
            uint256 daoContribution,
            uint256 dividendContribution
        )
    {
        _requireValidTransactionAmount(tokenAmount);

        uint256 soldBefore = totalSold;
        if (tokenAmount > soldBefore) {
            revert RedemptionExceedsSoldSupply(
                tokenAmount,
                soldBefore
            );
        }

        uint256 soldAfter = soldBefore - tokenAmount;

        grossRedemption =
            curveReserveAt(soldBefore)
                - curveReserveAt(soldAfter);

        daoContribution =
            (
                grossRedemption
                    * SELL_TREASURY_BPS
            ) / BPS_DENOMINATOR;

        dividendContribution =
            (
                grossRedemption
                    * SELL_DIVIDEND_BPS
            ) / BPS_DENOMINATOR;

        // Any indivisible-wei remainder favors the seller.
        sellerPOL =
            grossRedemption
                - daoContribution
                - dividendContribution;
    }

    /*//////////////////////////////////////////////////////////////
                              MARKET VIEWS
    //////////////////////////////////////////////////////////////*/

    /// @notice Maximum LABR this account can buy in one current transaction.
    function maxBuyableTokens(
        address buyer
    ) external view returns (uint256) {
        if (!_launchReady()) return 0;
        if (buyer.code.length != 0) return 0;
        if (!_isVerified(buyer)) return 0;

        ILaborCoinV4ForExchange token = ILaborCoinV4ForExchange(LABR);
        if (!token.canTrade(buyer)) return 0;

        uint256 balance = token.balanceOf(buyer);
        if (balance >= MAX_EXCHANGE_WALLET) return 0;

        uint256 walletRoom =
            MAX_EXCHANGE_WALLET - balance;
        uint256 remainingSupply =
            MAX_SUPPLY - totalSold;
        uint256 inventory =
            token.balanceOf(address(this));

        return
            _min(
                MAX_EXCHANGE_TRANSACTION,
                _min(
                    walletRoom,
                    _min(remainingSupply, inventory)
                )
            );
    }

    /// @notice Maximum LABR this account can currently sell in one transaction.
    function maxSellableTokens(
        address seller
    ) external view returns (uint256) {
        if (!_launchReady()) return 0;
        if (seller.code.length != 0) return 0;
        if (!_isVerified(seller)) return 0;

        ILaborCoinV4ForExchange token = ILaborCoinV4ForExchange(LABR);
        if (!token.canTrade(seller)) return 0;

        uint256 balance = token.balanceOf(seller);
        if (balance > MAX_EXCHANGE_WALLET) return 0;

        return
            _min(
                MAX_EXCHANGE_TRANSACTION,
                _min(balance, totalSold)
            );
    }

    /// @notice Forwards LABR's authoritative cooldown eligibility.
    function canTrade(
        address account
    ) external view returns (bool) {
        return
            _launchReady()
                && account.code.length == 0
                && _isVerified(account)
                && ILaborCoinV4ForExchange(LABR).canTrade(account);
    }

    /// @notice Forwards LABR's authoritative next trade timestamp.
    function nextTradeTime(
        address account
    ) external view returns (uint256) {
        return
            ILaborCoinV4ForExchange(LABR).nextTradeTime(account);
    }

    /// @notice Returns surplus POL that is not part of curve liabilities.
    /// @dev No recovery function exists. Forced POL remains permanently trapped.
    function excessPOL() external view returns (uint256) {
        uint256 actual = address(this).balance;
        return
            actual > accountedReserve
                ? actual - accountedReserve
                : 0;
    }

    /// @notice Returns whether all launch, inventory, and reserve invariants hold.
    function invariantsHold() external view returns (bool) {
        if (!_launchReady()) return false;

        ILaborCoinV4ForExchange token = ILaborCoinV4ForExchange(LABR);

        return
            accountedReserve
                == curveReserveAt(totalSold)
            && token.balanceOf(address(this))
                == MAX_SUPPLY - totalSold
            && address(this).balance
                >= accountedReserve;
    }

    /// @notice Returns whether LABR has atomically bound this exact Exchange.
    function launchReady() external view returns (bool) {
        return _launchReady();
    }

    /*//////////////////////////////////////////////////////////////
                           INTERNAL VALIDATION
    //////////////////////////////////////////////////////////////*/

    function _validateDeploymentInputs(
        address labr_,
        address identityRegistry_,
        bytes32 expectedIdentityRegistryRuntimeCodeHash_
    ) private view {
        if (block.chainid != POLYGON_MAINNET_CHAIN_ID) {
            revert WrongChain(block.chainid);
        }
        if (
            labr_ == address(0)
                || identityRegistry_ == address(0)
        ) {
            revert ZeroAddress();
        }
        if (
            expectedIdentityRegistryRuntimeCodeHash_
                == bytes32(0)
        ) {
            revert ZeroCodeHash();
        }
        if (labr_.code.length == 0) {
            revert AddressHasNoCode(labr_);
        }
        if (daoTreasury.code.length == 0) {
            revert AddressHasNoCode(daoTreasury);
        }
        if (identityRegistry_.code.length == 0) {
            revert AddressHasNoCode(identityRegistry_);
        }
    }

    function _validateIdentityConfiguration(
        address labr_,
        address identityRegistry_,
        bytes32 expectedIdentityRegistryRuntimeCodeHash_
    ) private view {
        bytes32 actualRuntimeCodeHash =
            identityRegistry_.codehash;
        if (
            actualRuntimeCodeHash
                != expectedIdentityRegistryRuntimeCodeHash_
        ) {
            revert InvalidIdentityRuntimeCodeHash(
                actualRuntimeCodeHash,
                expectedIdentityRegistryRuntimeCodeHash_
            );
        }

        ILaborCoinIdentityRegistryV1ForExchange identity =
            ILaborCoinIdentityRegistryV1ForExchange(
                identityRegistry_
            );

        bytes32 expectedCompatibility = keccak256(
            "LABORCOIN_IDENTITY_V1_SCORE15_PERMANENT_EIP712_V1"
        );
        bytes32 actualCompatibility =
            identity.COMPATIBILITY_ID();
        if (actualCompatibility != expectedCompatibility) {
            revert InvalidIdentityCompatibility(
                actualCompatibility
            );
        }

        uint256 actualThreshold =
            identity.MIN_PASSPORT_SCORE();
        if (actualThreshold != 15_000) {
            revert InvalidIdentityThreshold(
                actualThreshold
            );
        }

        address reportedLABR = identity.LABR();
        if (
            !identity.labrFinalized()
                || reportedLABR != labr_
        ) {
            revert InvalidTokenIdentity(reportedLABR);
        }
    }

    function _validateTokenConfiguration(
        address labr_,
        address identityRegistry_,
        bytes32 expectedIdentityRegistryRuntimeCodeHash_
    ) private view {
        ILaborCoinV4ForExchange token =
            ILaborCoinV4ForExchange(labr_);

        _validateTokenBindings(
            token,
            identityRegistry_,
            expectedIdentityRegistryRuntimeCodeHash_
        );
        _validateTokenLimits(token);
        _validateTokenTaxes(token);
    }

    function _validateTokenBindings(
        ILaborCoinV4ForExchange token,
        address identityRegistry_,
        bytes32 expectedIdentityRegistryRuntimeCodeHash_
    ) private view {
        address reportedTreasury = token.daoTreasury();
        if (reportedTreasury != daoTreasury) {
            revert InvalidTokenTreasury(reportedTreasury);
        }

        address reportedIdentity = token.identityRegistry();
        if (reportedIdentity != identityRegistry_) {
            revert InvalidTokenIdentity(reportedIdentity);
        }

        bytes32 reportedIdentityCodeHash =
            token.expectedIdentityRegistryRuntimeCodeHash();
        if (
            reportedIdentityCodeHash
                != expectedIdentityRegistryRuntimeCodeHash_
        ) {
            revert InvalidTokenIdentityCodeHash(
                reportedIdentityCodeHash
            );
        }

        bytes32 reportedCompatibility =
            token.EXCHANGE_COMPATIBILITY_ID();
        if (reportedCompatibility != COMPATIBILITY_ID) {
            revert InvalidTokenCompatibility(
                reportedCompatibility
            );
        }
    }

    function _validateTokenLimits(
        ILaborCoinV4ForExchange token
    ) private view {
        uint256 reportedSupply = token.TOTAL_SUPPLY();
        if (reportedSupply != MAX_SUPPLY) {
            revert InvalidTokenSupply(reportedSupply);
        }

        uint256 reportedWalletLimit = token.MAX_WALLET();
        if (
            reportedWalletLimit
                != MAX_EXCHANGE_WALLET
        ) {
            revert InvalidTokenWalletLimit(
                reportedWalletLimit
            );
        }

        uint256 reportedTransactionLimit =
            token.MAX_TRANSACTION();
        if (
            reportedTransactionLimit
                != MAX_EXCHANGE_TRANSACTION
        ) {
            revert InvalidTokenTransactionLimit(
                reportedTransactionLimit
            );
        }

        uint256 reportedCooldown =
            token.TRADE_COOLDOWN();
        if (reportedCooldown != TRADE_COOLDOWN) {
            revert InvalidTokenCooldown(
                reportedCooldown
            );
        }
    }

    function _validateTokenTaxes(
        ILaborCoinV4ForExchange token
    ) private view {
        uint256 buyTreasuryBps =
            token.BUY_TREASURY_BPS();
        uint256 sellTreasuryBps =
            token.SELL_TREASURY_BPS();
        uint256 sellDividendBps =
            token.SELL_DIVIDEND_BPS();

        if (
            buyTreasuryBps != BUY_TREASURY_BPS
                || sellTreasuryBps
                    != SELL_TREASURY_BPS
                || sellDividendBps
                    != SELL_DIVIDEND_BPS
        ) {
            revert InvalidTokenTaxConfiguration(
                buyTreasuryBps,
                sellTreasuryBps,
                sellDividendBps
            );
        }
    }

    function _requireDirectWallet() private view {
        if (
            msg.sender != tx.origin
                || msg.sender.code.length != 0
        ) {
            revert OnlyDirectWallet(
                msg.sender,
                tx.origin
            );
        }
    }


    function _isVerified(address account) private view returns (bool) {
        return ILaborCoinIdentityRegistryV1ForExchange(identityRegistry)
            .isVerified(account);
    }

    function _requireVerified(address account) private view {
        if (!_isVerified(account)) {
            revert IdentityVerificationRequired(account);
        }
    }

    function _launchReady() private view returns (bool) {
        ILaborCoinV4ForExchange token = ILaborCoinV4ForExchange(LABR);

        return
            token.launchFinalized()
                && token.officialExchange() == address(this)
                && token.identityRegistry() == identityRegistry
                && token.expectedIdentityRegistryRuntimeCodeHash()
                    == expectedIdentityRegistryRuntimeCodeHash;
    }

    function _requireLaunchReady() private view {
        ILaborCoinV4ForExchange token = ILaborCoinV4ForExchange(LABR);

        if (!token.launchFinalized()) {
            revert LaunchNotFinalized();
        }

        address reportedExchange =
            token.officialExchange();
        if (reportedExchange != address(this)) {
            revert WrongOfficialExchange(
                reportedExchange
            );
        }
    }

    function _requireDeadline(
        uint256 deadline
    ) private view {
        if (block.timestamp > deadline) {
            revert DeadlineExpired(
                deadline,
                block.timestamp
            );
        }
    }

    function _requireValidTransactionAmount(
        uint256 tokenAmount
    ) private pure {
        if (tokenAmount == 0) revert ZeroTokenAmount();

        if (
            tokenAmount
                > MAX_EXCHANGE_TRANSACTION
        ) {
            revert TransactionLimitExceeded(
                tokenAmount,
                MAX_EXCHANGE_TRANSACTION
            );
        }
    }

    function _unlockToCover(
        uint256 resultingSold
    ) private {
        uint256 currentUnlocked = unlockedSupply;

        while (
            resultingSold > currentUnlocked
                && currentUnlocked < MAX_SUPPLY
        ) {
            uint256 previous = currentUnlocked;
            uint256 next =
                currentUnlocked + TRANCHE_SIZE;

            if (next > MAX_SUPPLY) {
                next = MAX_SUPPLY;
            }

            currentUnlocked = next;

            emit TrancheUnlocked(
                previous,
                currentUnlocked
            );
        }

        if (resultingSold > currentUnlocked) {
            revert SupplyLocked(
                resultingSold,
                currentUnlocked
            );
        }

        unlockedSupply = currentUnlocked;
    }

    function _assertAccountingInvariants()
        private
        view
    {
        _assertReserveAccounting();
        _assertTokenInventory();
        _assertReserveCoverage();
    }

    function _assertReserveAccounting() private view {
        uint256 expected =
            curveReserveAt(totalSold);

        if (accountedReserve != expected) {
            revert ReserveAccountingMismatch(
                accountedReserve,
                expected
            );
        }
    }

    function _assertTokenInventory() private view {
        uint256 actual =
            ILaborCoinV4ForExchange(LABR).balanceOf(
                address(this)
            );
        uint256 expected =
            MAX_SUPPLY - totalSold;

        if (actual != expected) {
            revert InventoryAccountingMismatch(
                actual,
                expected
            );
        }
    }

    function _assertReserveCoverage() private view {
        uint256 actual = address(this).balance;

        if (actual < accountedReserve) {
            revert ReserveUnderfunded(
                actual,
                accountedReserve
            );
        }
    }

    function _assertReserveCoverageBeforePayment(
        uint256 currentPayment
    ) private view {
        uint256 balanceBeforePayment =
            address(this).balance - currentPayment;

        if (balanceBeforePayment < accountedReserve) {
            revert ReserveUnderfunded(
                balanceBeforePayment,
                accountedReserve
            );
        }
    }

    function _sendPOL(
        address recipient,
        uint256 amount
    ) private {
        if (amount == 0) return;

        (bool sent, ) =
            recipient.call{value: amount}("");

        if (!sent) {
            revert NativeTransferFailed(
                recipient,
                amount
            );
        }
    }

    function _ceilDiv(
        uint256 numerator,
        uint256 denominator
    ) private pure returns (uint256) {
        if (numerator == 0) return 0;

        return
            ((numerator - 1) / denominator)
                + 1;
    }

    function _min(
        uint256 a,
        uint256 b
    ) private pure returns (uint256) {
        return a < b ? a : b;
    }

    /*//////////////////////////////////////////////////////////////
                              POL REJECTION
    //////////////////////////////////////////////////////////////*/

    receive() external payable {
        revert DirectPOLDepositRejected();
    }

    fallback() external payable {
        revert DirectPOLDepositRejected();
    }
}
