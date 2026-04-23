```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
LaborCoin Bonding Curve Exchange

Deployed on Polygon:
0xd9210DE64a369C0b89B82949A84eFe170801F79D

Description:
- Bonding curve token distribution (1B supply)
- Smooth pricing curve ($1 → $15)
- DAO-funded via buy fee
- Slippage protection
- Cooldown + anti-whale limits
*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface AggregatorV3Interface {
    function latestRoundData()
        external
        view
        returns (
            uint80,
            int256 answer,
            uint256,
            uint256 updatedAt,
            uint80
        );
}

contract LaborCoinExchange is ERC20, Ownable {

    // -----------------------------
    // CONSTANTS
    // -----------------------------

    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 1e18;
    uint256 public constant INITIAL_AVAILABLE = 100_000_000 * 1e18;

    uint256 public constant TX_LIMIT = 5_000 * 1e18;
    uint256 public constant WALLET_LIMIT = 10_000 * 1e18;

    uint256 public constant COOLDOWN = 12 hours;
    uint256 public constant BUY_FEE = 10; // %

    uint256 public constant TRANCHE_SIZE = 50_000_000 * 1e18;

    uint256 public constant ORACLE_TIMEOUT = 1 hours;

    // -----------------------------
    // STATE
    // -----------------------------

    uint256 public totalSold;
    uint256 public treasuryBalance;
    uint256 public unlockedSupply;

    address public daoTreasury;
    AggregatorV3Interface public priceFeed;

    mapping(address => uint256) public lastTxTime;

    // -----------------------------
    // CONSTRUCTOR
    // -----------------------------

    constructor(address _daoTreasury, address _priceFeed)
        ERC20("LaborCoin", "LABR")
        Ownable(msg.sender)
    {
        require(_daoTreasury != address(0), "Invalid treasury");
        require(_priceFeed != address(0), "Invalid oracle");

        daoTreasury = _daoTreasury;
        priceFeed = AggregatorV3Interface(_priceFeed);

        unlockedSupply = INITIAL_AVAILABLE;

        _mint(address(this), INITIAL_AVAILABLE);
    }

    // -----------------------------
    // ORACLE (SAFE)
    // -----------------------------

    function getPOLPriceUSD() public view returns (uint256) {
        (, int256 price,, uint256 updatedAt,) = priceFeed.latestRoundData();

        require(price > 0, "Invalid price");
        require(block.timestamp - updatedAt < ORACLE_TIMEOUT, "Stale oracle");

        return uint256(price) * 1e10; // normalize to 1e18
    }

    // -----------------------------
    // SMOOTH PRICING CURVE ($1 → $15)
    // -----------------------------

    function getPriceUSD(uint256 sold) public pure returns (uint256) {
        uint256 x = sold / 1e18;

        uint256 t = (x * 1e18) / 1_000_000_000;

        uint256 t2 = (t * t) / 1e18;
        uint256 t3 = (t2 * t) / 1e18;

        uint256 smooth = (3 * t2) - (2 * t3);

        return 1e18 + (smooth * 14e18) / 1e18;
    }

    function getPricePOL(uint256 sold) public view returns (uint256) {
        uint256 priceUSD = getPriceUSD(sold);
        uint256 polUSD = getPOLPriceUSD();
        return (priceUSD * 1e18) / polUSD;
    }

    // -----------------------------
    // TRANCHE RELEASE
    // -----------------------------

    function updateTranche() internal {
        uint256 trancheIndex = totalSold / TRANCHE_SIZE;
        uint256 newUnlocked;

        if (totalSold <= 500_000_000 * 1e18) {
            newUnlocked = INITIAL_AVAILABLE + (trancheIndex * TRANCHE_SIZE);
        } else {
            uint256 extra = trancheIndex * (TRANCHE_SIZE * 8 / 10);
            newUnlocked = INITIAL_AVAILABLE + extra;
        }

        if (newUnlocked > MAX_SUPPLY) {
            newUnlocked = MAX_SUPPLY;
        }

        unlockedSupply = newUnlocked;
    }

    // -----------------------------
    // COOLDOWN
    // -----------------------------

    modifier cooldownCheck() {
        require(
            block.timestamp >= lastTxTime[msg.sender] + COOLDOWN,
            "Cooldown active"
        );
        _;
        lastTxTime[msg.sender] = block.timestamp;
    }

    // -----------------------------
    // BUY (SLIPPAGE PROTECTED)
    // -----------------------------

    function buy(uint256 minTokensOut) external payable cooldownCheck {
        require(msg.value > 0, "No POL sent");

        uint256 fee = (msg.value * BUY_FEE) / 100;
        uint256 net = msg.value - fee;

        uint256 price = getPricePOL(totalSold);
        uint256 tokens = (net * 1e18) / price;

        require(tokens >= minTokensOut, "Slippage exceeded");
        require(tokens <= TX_LIMIT, "Tx limit exceeded");
        require(balanceOf(msg.sender) + tokens <= WALLET_LIMIT, "Wallet cap exceeded");

        updateTranche();
        require(totalSold + tokens <= unlockedSupply, "Supply locked");

        totalSold += tokens;
        treasuryBalance += net;

        _mint(msg.sender, tokens);

        (bool success, ) = payable(daoTreasury).call{value: fee}("");
        require(success, "DAO transfer failed");
    }

    // -----------------------------
    // SELL (SLIPPAGE PROTECTED)
    // -----------------------------

    function sell(uint256 amount, uint256 minPOLOut) external cooldownCheck {
        require(amount <= TX_LIMIT, "Tx limit exceeded");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        uint256 price = getPricePOL(totalSold);
        uint256 payout = (amount * price) / 1e18;

        require(payout >= minPOLOut, "Slippage exceeded");
        require(address(this).balance >= payout, "Insufficient liquidity");

        totalSold -= amount;
        treasuryBalance -= payout;

        _burn(msg.sender, amount);

        (bool success, ) = payable(msg.sender).call{value: payout}("");
        require(success, "Payout failed");
    }

    // -----------------------------
    // RECEIVE PROTECTION
    // -----------------------------

    receive() external payable {
        revert("Use buy()");
    }
}
```
