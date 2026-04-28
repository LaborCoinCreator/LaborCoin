# LaborCoin Exchange V2

**Network:** Polygon  
**Contract Address:** `0xD0692ec758bb852421B702B187b6439f74f8Bf3b`

---

## Overview

LaborCoin Exchange V2 is a **non-mint bonding curve exchange** that distributes a pre-minted LABR supply over time using a deterministic pricing function.

Key characteristics:

- Uses **existing LABR supply (no minting)**
- Implements a **quadratic bonding curve**
- Uses **Chainlink POL/USD oracle** for pricing
- Enforces **cooldowns and anti-abuse protections**
- Automatically unlocks supply in **tranches**
- Routes **10% of buy volume to DAO treasury**
- Sell-side taxes handled by the **LABR token itself**

---

## Key Features

### Bonding Curve Pricing

- Price increases as supply is sold
- Quadratic curve:
  - Starts near ~$1
  - Scales toward ~$15
- Oracle-adjusted via Chainlink POL/USD feed

---

### Tranche Unlocking

- Initial available supply: **100M LABR**
- Unlocks **50M LABR per tranche**
- Automatic unlock as tokens are sold
- Hard cap: **1B LABR total supply**

---

### Buy Mechanics

- Users send POL to purchase LABR
- Tokens are transferred from contract reserves
- 10% of POL sent directly to DAO treasury
- No token tax applied on buy

---

### Sell Mechanics

- Users send LABR back to contract
- Token-level tax is applied (handled by LABR)
- Contract pays out POL based on curve price
- Uses **post-tax received amount** for accuracy

---

### Protections

- Reentrancy protection
- 12-hour per-wallet cooldown
- Oracle freshness validation (30 min)
- Max price guard
- Reserve protection (20% minimum liquidity)
- Two-step ownership transfer

---

## Solidity Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/* ========== INTERFACES ========== */
interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

interface AggregatorV3Interface {
    function latestRoundData()
        external
        view
        returns (
            uint80,
            int256,
            uint256,
            uint256 updatedAt,
            uint80
        );
}

/* ========== REENTRANCY GUARD ========== */
abstract contract ReentrancyGuard {
    uint256 private constant _ENTERED = 2;
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private _status = _NOT_ENTERED;

    modifier nonReentrant() {
        require(_status != _ENTERED, "Reentrancy");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }
}

/* ========== MAIN CONTRACT ========== */
contract LaborCoinExchangeV2 is ReentrancyGuard {

    IERC20 public immutable LABR;

    AggregatorV3Interface public immutable priceFeed =
        AggregatorV3Interface(0xAB594600376Ec9fD91F8e885dADF0CE036862dE0);

    address public daoTreasury;
    address public owner;
    address public pendingOwner;

    uint256 public constant MAX_SUPPLY = 1_000_000_000 ether;
    uint256 public constant INITIAL_TRANCHE = 100_000_000 ether;
    uint256 public constant TRANCHE_SIZE = 50_000_000 ether;
    uint256 public constant COOLDOWN = 12 hours;
    uint256 public constant MAX_PRICE_POL = 100 ether;

    uint256 public totalSold;
    uint256 public unlockedSupply;

    bool public paused;

    mapping(address => uint256) public lastTxTime;

    event Buy(address indexed user, uint256 polIn, uint256 tokensOut);
    event Sell(address indexed user, uint256 tokensIn, uint256 polOut);
    event TrancheUnlocked(uint256 unlocked);
    event Paused(bool status);
    event Withdraw(uint256 amount);
    event OwnershipTransferStarted(address indexed newOwner);
    event OwnershipTransferred(address indexed newOwner);

    constructor(address _labr, address _daoTreasury) {
        require(_labr != address(0), "Bad LABR");
        require(_daoTreasury != address(0), "Bad DAO");

        LABR = IERC20(_labr);
        daoTreasury = _daoTreasury;

        owner = msg.sender;
        unlockedSupply = INITIAL_TRANCHE;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier cooldownCheck() {
        require(block.timestamp >= lastTxTime[msg.sender] + COOLDOWN, "Cooldown");
        _;
        lastTxTime[msg.sender] = block.timestamp;
    }

    modifier notPaused() {
        require(!paused, "Paused");
        _;
    }

    /* ---------- SAFE TOKEN WRAPPERS ---------- */

    function _safeTransfer(address to, uint256 amount) internal {
        (bool success, bytes memory data) =
            address(LABR).call(abi.encodeWithSelector(LABR.transfer.selector, to, amount));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "Transfer fail");
    }

    function _safeTransferFrom(address from, address to, uint256 amount) internal {
        (bool success, bytes memory data) =
            address(LABR).call(abi.encodeWithSelector(LABR.transferFrom.selector, from, to, amount));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferFrom fail");
    }

    /* ---------- ORACLE ---------- */

    function getPOLPriceUSD() public view returns (uint256) {
        (, int256 price,, uint256 updatedAt,) = priceFeed.latestRoundData();
        require(price > 0, "Bad oracle");
        require(updatedAt > block.timestamp - 30 minutes, "Stale");
        return uint256(price);
    }

    /* ---------- CURVE ---------- */

    function getPrice(uint256 sold) public view returns (uint256) {
        if (sold > MAX_SUPPLY) sold = MAX_SUPPLY;

        uint256 P_MIN = 1e8;
        uint256 P_MAX = 15e8;

        uint256 x = (sold * 1e18) / MAX_SUPPLY;
        uint256 x2 = (x * x) / 1e18;

        uint256 usd = P_MIN + ((P_MAX - P_MIN) * x2) / 1e18;

        uint256 polUSD = getPOLPriceUSD();
        uint256 price = (usd * 1e18) / polUSD;

        require(price <= MAX_PRICE_POL, "Oracle anomaly");

        return price;
    }

    /* ---------- BUY ---------- */

    function buy(uint256 minTokensOut)
        external
        payable
        nonReentrant
        cooldownCheck
        notPaused
    {
        require(msg.value > 0);

        uint256 price = getPrice(totalSold);
        uint256 expected = (msg.value * 1e18) / price;

        require(totalSold + expected <= unlockedSupply);
        require(LABR.balanceOf(address(this)) >= expected);

        uint256 before = LABR.balanceOf(msg.sender);
        _safeTransfer(msg.sender, expected);
        uint256 received = LABR.balanceOf(msg.sender) - before;

        require(received >= minTokensOut);

        totalSold += received;

        _autoUnlock();

        uint256 daoShare = (msg.value * 10) / 100;
        (bool sent, ) = daoTreasury.call{value: daoShare}("");
        require(sent);

        emit Buy(msg.sender, msg.value, received);
    }

    /* ---------- SELL ---------- */

    function sell(uint256 amount, uint256 minPOL)
        external
        nonReentrant
        cooldownCheck
        notPaused
    {
        require(amount > 0);
        require(amount <= totalSold);

        uint256 price = getPrice(totalSold);

        uint256 before = LABR.balanceOf(address(this));
        _safeTransferFrom(msg.sender, address(this), amount);
        uint256 received = LABR.balanceOf(address(this)) - before;

        require(totalSold >= received);

        uint256 payout = (received * price) / 1e18;

        require(payout >= minPOL);
        require(address(this).balance >= payout);

        totalSold -= received;

        (bool sent, ) = msg.sender.call{value: payout}("");
        require(sent);

        emit Sell(msg.sender, received, payout);
    }

    /* ---------- UNLOCK ---------- */

    function _autoUnlock() internal {
        uint256 i;
        while (totalSold >= unlockedSupply && i < 10) {
            uint256 next = unlockedSupply + TRANCHE_SIZE;
            if (next > MAX_SUPPLY) next = MAX_SUPPLY;
            unlockedSupply = next;
            emit TrancheUnlocked(unlockedSupply);
            i++;
        }
    }

    /* ---------- CONTROL ---------- */

    function setPaused(bool _paused) external onlyOwner {
        paused = _paused;
        emit Paused(_paused);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Bad owner");
        pendingOwner = newOwner;
        emit OwnershipTransferStarted(newOwner);
    }

    function acceptOwnership() external {
        require(msg.sender == pendingOwner, "Not pending");
        owner = pendingOwner;
        pendingOwner = address(0);
        emit OwnershipTransferred(owner);
    }

    function withdrawPOL(uint256 amount) external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance - amount >= (balance * 20) / 100, "Reserve breach");

        (bool sent, ) = daoTreasury.call{value: amount}("");
        require(sent);

        emit Withdraw(amount);
    }

    receive() external payable {}
}

License: MIT
