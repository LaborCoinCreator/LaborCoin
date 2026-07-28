// SPDX-License-Identifier: MIT
pragma solidity 0.8.36;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

interface ILaborCoinIdentityRegistryV1ForToken {
    function isVerified(address participant) external view returns (bool);
    function COMPATIBILITY_ID() external view returns (bytes32);
    function MIN_PASSPORT_SCORE() external view returns (uint256);
    function LABR() external view returns (address);
    function labrFinalized() external view returns (bool);
    function expectedLABRRuntimeCodeHash() external view returns (bytes32);
}

interface ILaborCoinExchangeV7ForToken {
    function LABR() external view returns (address);
    function identityRegistry() external view returns (address);
    function expectedIdentityRegistryRuntimeCodeHash() external view returns (bytes32);
    function daoTreasury() external view returns (address);
    function COMPATIBILITY_ID() external view returns (bytes32);
    function BUY_TREASURY_BPS() external view returns (uint256);
    function SELL_TREASURY_BPS() external view returns (uint256);
    function SELL_DIVIDEND_BPS() external view returns (uint256);
}

/// @title LaborCoin V4
/// @notice Immutable-supply, protocol-restricted LABR with equal dividends per verified holder.
/// @dev Every verified direct wallet holding at least 1 LABR has exactly one
/// dividend unit. Token quantity above 1 LABR never increases dividend weight.
/// After launch, LABR can move only through the immutable official Exchange for
/// a verified purchase or sale. Peer transfers and arbitrary transfer operators
/// are permanently disabled.
contract LaborCoinV4 is ERC20, ReentrancyGuard {
    uint256 public constant TOTAL_SUPPLY = 1_000_000_000 ether;
    uint256 public constant MAX_WALLET = 10_000 ether;
    uint256 public constant MAX_TRANSACTION = 5_000 ether;
    uint256 public constant TRADE_COOLDOWN = 12 hours;
    uint256 public constant MIN_DIVIDEND_BALANCE = 1 ether;
    uint256 public constant POLYGON_MAINNET_CHAIN_ID = 137;

    uint256 public constant BPS_DENOMINATOR = 10_000;
    uint256 public constant BUY_TREASURY_BPS = 1_000;
    uint256 public constant SELL_TREASURY_BPS = 500;
    uint256 public constant SELL_DIVIDEND_BPS = 500;
    uint256 private constant MAGNITUDE = 2 ** 128;

    bytes32 public constant IDENTITY_COMPATIBILITY_ID = keccak256(
        "LABORCOIN_IDENTITY_V1_SCORE15_PERMANENT_EIP712_V1"
    );
    bytes32 public constant EXCHANGE_COMPATIBILITY_ID = keccak256(
        "LABORCOIN_EXCHANGE_V7_POL_IDENTITY_EQUAL_HOLDER_RESTRICTED_TRANSFER_V1"
    );
    string public constant CONTRACT_VERSION = "LaborCoin V4.0.0";

    address public constant daoTreasury =
        0x0C2e5679153593b82a84eAB5CA90895BB291Cec4;

    address public identityRegistry;
    bytes32 public expectedIdentityRegistryRuntimeCodeHash;
    bytes32 public expectedExchangeRuntimeCodeHash;

    address private _launchOwner;
    address public officialExchange;
    bool public launchFinalized;
    bool private _launchFinalizing;

    mapping(address account => uint256 timestamp) public lastTradeAt;

    uint256 public eligibleDividendHolderCount;
    uint256 public magnifiedDividendPerEligibleHolder;
    uint256 public totalDividendsDistributed;
    uint256 public totalDividendsWithdrawn;
    uint256 public totalDividendsRedirectedToDAO;

    mapping(address account => bool status) private _dividendEligible;
    mapping(address account => int256 correction) private _magnifiedDividendCorrections;
    mapping(address account => uint256 amount) public withdrawnDividends;

    error ZeroAddress();
    error ZeroCodeHash();
    error WrongChain(uint256 actualChainId);
    error AddressHasNoCode(address account);
    error InvalidRuntimeCodeHash(address account, bytes32 actual, bytes32 expected);
    error InvalidIdentityCompatibility(bytes32 actual);
    error InvalidIdentityThreshold(uint256 actual);
    error UnauthorizedLaunchOwner(address caller);
    error LaunchAlreadyFinalized();
    error LaunchNotFinalized();
    error CannotRenounceBeforeFinalization();
    error OwnershipAlreadyRenounced();
    error InvalidExchangeToken(address actual);
    error InvalidExchangeIdentity(address actual);
    error InvalidExchangeIdentityCodeHash(bytes32 actual);
    error InvalidExchangeTreasury(address actual);
    error InvalidExchangeCompatibility(bytes32 actual);
    error InvalidExchangeTaxConfiguration(uint256 buyBps, uint256 sellBps, uint256 dividendBps);
    error InventoryTransferFailed(uint256 exchangeBalance);
    error MintingDisabled();
    error BurningDisabled();
    error TransactionLimitExceeded(uint256 amount, uint256 maximum);
    error WalletLimitExceeded(address account, uint256 resultingBalance, uint256 maximum);
    error PeerTransfersDisabled();
    error OnlyDirectWallet(address account, address transactionOrigin);
    error IdentityVerificationRequired(address account);
    error UnauthorizedTransferOperator(address operator);
    error UnauthorizedAllowanceSpender(address spender);
    error DirectExchangeTransferForbidden();
    error InvalidExchangeTransferDirection();
    error TradeCooldownActive(address account, uint256 nextAvailableTime);
    error OnlyOfficialExchange(address caller);
    error DirectPOLDepositRejected();
    error ZeroDividendDeposit();
    error NoDividendsAvailable(address account);
    error NativeTransferFailed(address recipient, uint256 amount);
    error SignedIntegerOverflow(uint256 value);
    error DividendAccountingInvariant();

    event LaunchFinalized(address indexed exchange, address indexed identityRegistry, uint256 inventoryTransferred);
    event OwnershipRenounced(address indexed previousOwner);
    event TradeRecorded(address indexed account, bool indexed isBuy, uint256 amount, uint256 timestamp);
    event DividendsDeposited(uint256 amount, uint256 eligibleHolders, uint256 magnifiedDividendPerEligibleHolder);
    event DividendsRedirectedToDAO(uint256 amount);
    event DividendClaimed(address indexed account, uint256 amount);
    event DividendEligibilityUpdated(address indexed account, bool previousEligibility, bool newEligibility);

    constructor(
        address identityRegistry_,
        bytes32 expectedIdentityRegistryRuntimeCodeHash_,
        bytes32 expectedExchangeRuntimeCodeHash_
    ) ERC20("LaborCoin", "LABR") {
        if (block.chainid != POLYGON_MAINNET_CHAIN_ID) revert WrongChain(block.chainid);
        if (identityRegistry_ == address(0)) revert ZeroAddress();
        if (expectedIdentityRegistryRuntimeCodeHash_ == bytes32(0) || expectedExchangeRuntimeCodeHash_ == bytes32(0)) {
            revert ZeroCodeHash();
        }
        if (daoTreasury.code.length == 0) revert AddressHasNoCode(daoTreasury);
        _validateIdentityRegistry(identityRegistry_, expectedIdentityRegistryRuntimeCodeHash_);

        identityRegistry = identityRegistry_;
        expectedIdentityRegistryRuntimeCodeHash = expectedIdentityRegistryRuntimeCodeHash_;
        expectedExchangeRuntimeCodeHash = expectedExchangeRuntimeCodeHash_;
        _launchOwner = msg.sender;
        _mint(address(this), TOTAL_SUPPLY);
    }

    modifier onlyLaunchOwner() {
        if (msg.sender != _launchOwner) revert UnauthorizedLaunchOwner(msg.sender);
        _;
    }

    function owner() external view returns (address) { return _launchOwner; }

    function finalizeLaunch(address exchange) external onlyLaunchOwner {
        if (launchFinalized) revert LaunchAlreadyFinalized();
        if (exchange == address(0)) revert ZeroAddress();
        if (exchange.code.length == 0) revert AddressHasNoCode(exchange);
        if (exchange.codehash != expectedExchangeRuntimeCodeHash) {
            revert InvalidRuntimeCodeHash(exchange, exchange.codehash, expectedExchangeRuntimeCodeHash);
        }

        ILaborCoinIdentityRegistryV1ForToken identity =
            ILaborCoinIdentityRegistryV1ForToken(identityRegistry);
        if (!identity.labrFinalized() || identity.LABR() != address(this)) {
            revert InvalidExchangeIdentity(identity.LABR());
        }
        if (identity.expectedLABRRuntimeCodeHash() != address(this).codehash) {
            revert InvalidRuntimeCodeHash(
                address(this),
                address(this).codehash,
                identity.expectedLABRRuntimeCodeHash()
            );
        }

        ILaborCoinExchangeV7ForToken candidate = ILaborCoinExchangeV7ForToken(exchange);
        if (candidate.LABR() != address(this)) revert InvalidExchangeToken(candidate.LABR());
        if (candidate.identityRegistry() != identityRegistry) revert InvalidExchangeIdentity(candidate.identityRegistry());
        if (candidate.expectedIdentityRegistryRuntimeCodeHash() != expectedIdentityRegistryRuntimeCodeHash) {
            revert InvalidExchangeIdentityCodeHash(candidate.expectedIdentityRegistryRuntimeCodeHash());
        }
        if (candidate.daoTreasury() != daoTreasury) revert InvalidExchangeTreasury(candidate.daoTreasury());
        if (candidate.COMPATIBILITY_ID() != EXCHANGE_COMPATIBILITY_ID) {
            revert InvalidExchangeCompatibility(candidate.COMPATIBILITY_ID());
        }
        uint256 buyBps = candidate.BUY_TREASURY_BPS();
        uint256 sellBps = candidate.SELL_TREASURY_BPS();
        uint256 dividendBps = candidate.SELL_DIVIDEND_BPS();
        if (buyBps != BUY_TREASURY_BPS || sellBps != SELL_TREASURY_BPS || dividendBps != SELL_DIVIDEND_BPS) {
            revert InvalidExchangeTaxConfiguration(buyBps, sellBps, dividendBps);
        }

        officialExchange = exchange;
        _launchFinalizing = true;
        super._update(address(this), exchange, TOTAL_SUPPLY);
        _launchFinalizing = false;
        if (balanceOf(exchange) != TOTAL_SUPPLY) revert InventoryTransferFailed(balanceOf(exchange));
        launchFinalized = true;
        address previousOwner = _launchOwner;
        _launchOwner = address(0);
        emit LaunchFinalized(exchange, identityRegistry, TOTAL_SUPPLY);
        emit OwnershipRenounced(previousOwner);
    }

    function renounceOwnership() external onlyLaunchOwner {
        if (!launchFinalized) revert CannotRenounceBeforeFinalization();
        revert OwnershipAlreadyRenounced();
    }

    function approve(address spender, uint256 value) public override returns (bool) {
        if (!launchFinalized) revert LaunchNotFinalized();
        if (spender != officialExchange) revert UnauthorizedAllowanceSpender(spender);
        _requireDirectWallet(msg.sender);
        if (!_isVerified(msg.sender)) revert IdentityVerificationRequired(msg.sender);
        return super.approve(spender, value);
    }

    function transferFrom(address from, address to, uint256 value) public override returns (bool) {
        if (msg.sender != officialExchange) revert UnauthorizedTransferOperator(msg.sender);
        return super.transferFrom(from, to, value);
    }

    function _update(address from, address to, uint256 value) internal override {
        if (from == address(0)) {
            if (totalSupply() != 0) revert MintingDisabled();
            super._update(from, to, value);
            return;
        }
        if (to == address(0)) revert BurningDisabled();
        if (_launchFinalizing) {
            super._update(from, to, value);
            return;
        }
        if (!launchFinalized) revert LaunchNotFinalized();
        if (value > MAX_TRANSACTION) revert TransactionLimitExceeded(value, MAX_TRANSACTION);

        address exchange = officialExchange;
        bool fromExchange = from == exchange;
        bool toExchange = to == exchange;
        bool isTrade = fromExchange || toExchange;
        address trader;
        bool isBuy;

        if (isTrade) {
            if (fromExchange && toExchange) revert InvalidExchangeTransferDirection();
            if (msg.sender != exchange) revert DirectExchangeTransferForbidden();
            isBuy = fromExchange;
            trader = isBuy ? to : from;
            _requireDirectWallet(trader);
            if (!_isVerified(trader)) revert IdentityVerificationRequired(trader);
            if (value != 0) {
                uint256 last = lastTradeAt[trader];
                if (last != 0 && block.timestamp < last + TRADE_COOLDOWN) {
                    revert TradeCooldownActive(trader, last + TRADE_COOLDOWN);
                }
            }
        } else {
            revert PeerTransfersDisabled();
        }

        if (to != exchange && from != to) {
            uint256 resultingBalance = balanceOf(to) + value;
            if (resultingBalance > MAX_WALLET) {
                revert WalletLimitExceeded(to, resultingBalance, MAX_WALLET);
            }
        }

        super._update(from, to, value);
        _synchronizeDividendEligibility(from);
        if (to != from) _synchronizeDividendEligibility(to);

        if (isTrade && value != 0) {
            lastTradeAt[trader] = block.timestamp;
            emit TradeRecorded(trader, isBuy, value, block.timestamp);
        }
    }

    function _requireDirectWallet(address account) private view {
        if (account != tx.origin || account.code.length != 0) {
            revert OnlyDirectWallet(account, tx.origin);
        }
    }

    function _isVerified(address account) private view returns (bool) {
        return ILaborCoinIdentityRegistryV1ForToken(identityRegistry).isVerified(account);
    }

    function nextTradeTime(address account) external view returns (uint256) {
        uint256 last = lastTradeAt[account];
        return last == 0 ? 0 : last + TRADE_COOLDOWN;
    }

    function canTrade(address account) external view returns (bool) {
        if (!launchFinalized || account.code.length != 0 || !_isVerified(account)) return false;
        uint256 last = lastTradeAt[account];
        return last == 0 || block.timestamp >= last + TRADE_COOLDOWN;
    }

    function syncDividendEligibility(address account) public returns (bool eligible) {
        _synchronizeDividendEligibility(account);
        return _dividendEligible[account];
    }

    function dividendEligible(address account) external view returns (bool) {
        return _dividendEligible[account];
    }

    function depositDividends() external payable nonReentrant {
        if (msg.sender != officialExchange) revert OnlyOfficialExchange(msg.sender);
        if (!launchFinalized) revert LaunchNotFinalized();
        if (msg.value == 0) revert ZeroDividendDeposit();
        uint256 count = eligibleDividendHolderCount;
        if (count == 0) {
            totalDividendsRedirectedToDAO += msg.value;
            (bool sent, ) = daoTreasury.call{value: msg.value}("");
            if (!sent) revert NativeTransferFailed(daoTreasury, msg.value);
            emit DividendsRedirectedToDAO(msg.value);
            return;
        }
        magnifiedDividendPerEligibleHolder += (msg.value * MAGNITUDE) / count;
        totalDividendsDistributed += msg.value;
        emit DividendsDeposited(msg.value, count, magnifiedDividendPerEligibleHolder);
    }

    function claimDividends() external nonReentrant returns (uint256 amount) {
        _requireDirectWallet(msg.sender);
        if (!_isVerified(msg.sender)) revert IdentityVerificationRequired(msg.sender);
        _synchronizeDividendEligibility(msg.sender);
        amount = withdrawableDividendOf(msg.sender);
        if (amount == 0) revert NoDividendsAvailable(msg.sender);
        withdrawnDividends[msg.sender] += amount;
        totalDividendsWithdrawn += amount;
        (bool sent, ) = msg.sender.call{value: amount}("");
        if (!sent) revert NativeTransferFailed(msg.sender, amount);
        emit DividendClaimed(msg.sender, amount);
    }

    function accumulativeDividendOf(address account) public view returns (uint256) {
        uint256 currentUnit = _dividendEligible[account] ? 1 : 0;
        uint256 magnifiedBase = magnifiedDividendPerEligibleHolder * currentUnit;
        int256 corrected = _toInt256(magnifiedBase) + _magnifiedDividendCorrections[account];
        if (corrected < 0) revert DividendAccountingInvariant();
        return uint256(corrected) / MAGNITUDE;
    }

    function withdrawableDividendOf(address account) public view returns (uint256) {
        uint256 accumulated = accumulativeDividendOf(account);
        uint256 withdrawn = withdrawnDividends[account];
        if (withdrawn > accumulated) revert DividendAccountingInvariant();
        return accumulated - withdrawn;
    }

    function _synchronizeDividendEligibility(address account) private {
        if (account == address(0)) return;
        bool target = !_isProtocolAddress(account)
            && balanceOf(account) >= MIN_DIVIDEND_BALANCE
            && _isVerified(account);
        _setDividendEligibility(account, target);
    }

    function _isProtocolAddress(address account) private view returns (bool) {
        return account == address(this)
            || account == officialExchange
            || account == daoTreasury
            || account == identityRegistry;
    }

    function _setDividendEligibility(address account, bool newEligibility) private {
        bool previous = _dividendEligible[account];
        if (previous == newEligibility) return;
        if (newEligibility) {
            eligibleDividendHolderCount += 1;
            _magnifiedDividendCorrections[account] -= _toInt256(magnifiedDividendPerEligibleHolder);
        } else {
            eligibleDividendHolderCount -= 1;
            _magnifiedDividendCorrections[account] += _toInt256(magnifiedDividendPerEligibleHolder);
        }
        _dividendEligible[account] = newEligibility;
        emit DividendEligibilityUpdated(account, previous, newEligibility);
    }

    function _validateIdentityRegistry(address registry, bytes32 expectedHash) private view {
        if (registry.code.length == 0) revert AddressHasNoCode(registry);
        if (registry.codehash != expectedHash) {
            revert InvalidRuntimeCodeHash(registry, registry.codehash, expectedHash);
        }
        ILaborCoinIdentityRegistryV1ForToken identity = ILaborCoinIdentityRegistryV1ForToken(registry);
        if (identity.COMPATIBILITY_ID() != IDENTITY_COMPATIBILITY_ID) {
            revert InvalidIdentityCompatibility(identity.COMPATIBILITY_ID());
        }
        if (identity.MIN_PASSPORT_SCORE() != 15_000) {
            revert InvalidIdentityThreshold(identity.MIN_PASSPORT_SCORE());
        }
    }

    function _toInt256(uint256 value) private pure returns (int256) {
        if (value > uint256(type(int256).max)) revert SignedIntegerOverflow(value);
        return int256(value);
    }

    receive() external payable { revert DirectPOLDepositRejected(); }
    fallback() external payable { revert DirectPOLDepositRejected(); }
}
