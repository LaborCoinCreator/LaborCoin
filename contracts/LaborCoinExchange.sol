// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
LaborCoin Exchange Contract (LABR)

Deployed on Polygon:
0xED8C432FdFBa629387eeD06C1DC5cA6087c1C09b

Description:
This contract implements a bonding curve exchange with:
- Deterministic pricing (sigmoid curve)
- Slippage protection
- Cooldown + anti-whale limits
- Oracle-based USD pricing (POL/USD)
- Circuit breaker for abnormal volatility
- DAO-controlled pause/unpause only (no mutable parameters)

Architecture:
Users → Contract → Treasury (DAO)
Governance → Executor → pause/unpause

All economic parameters are immutable after deployment.
*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

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

contract LaborCoinExchange is ERC20, Ownable, ReentrancyGuard {

    // -----------------------------
    // IMMUTABLE PARAMETERS (LOCKED)
    // -----------------------------

    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 1e18;
    uint256 public constant INITIAL_AVAILABLE = 100_000_000 * 1e18;

    uint256 public constant TX_LIMIT = 5_000 * 1e18;
    uint256 public constant WALLET_LIMIT = 10_000 * 1e18;

    uint256 public constant COOLDOWN = 12 hours;
    uint256 public constant BUY_FEE = 10;

    uint256 public constant TRANCHE_SIZE = 50_000_000 * 1e18;
    uint256 public constant ORACLE_TIMEOUT = 1 hours;

    uint256 public constant CIRCUIT_BREAK_THRESHOLD = 80; // %

    // -----------------------------
    // STATE
    // -----------------------------

    uint256 public totalSold;
    uint256 public treasuryBalance;
    uint256 public unlockedSupply;

    address public daoTreasury;
    AggregatorV3Interface public priceFeed;

    mapping(address => uint256) public lastTxTime;

    bool public paused;
    uint256 public lastPrice;

    // -----------------------------
    // EVENTS
    // -----------------------------

    event Buy(address indexed user, uint256 polIn, uint256 tokensOut);
    event Sell(address indexed user, uint256 tokensIn, uint256 polOut);
    event Paused(bool state);

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
    // MODIFIERS
    // -----------------------------

    modifier notPaused() {
        require(!paused, "Paused");
        _;
    }

    modifier cooldownCheck() {
        require(
            block.timestamp >= lastTxTime[msg.sender] + COOLDOWN,
            "Cooldown active"
        );
        _;
        lastTxTime[msg.sender] = block.timestamp;
    }

    // -----------------------------
    // ORACLE
    // -----------------------------

    function getPOLPriceUSD() public view returns (uint256) {
        (, int256 price,, uint256 updatedAt,) = priceFeed.latestRoundData();

        require(price > 0, "Invalid price");
        require(block.timestamp - updatedAt < ORACLE_TIMEOUT, "Stale oracle");

        return uint256(price) * 1e10;
    }

    // -----------------------------
    // CIRCUIT BREAKER
    // -----------------------------

    function checkCircuit(uint256 price) internal {
        if (lastPrice == 0) {
            lastPrice = price;
            return;
        }

        uint256 change = price > lastPrice
            ? price - lastPrice
            : lastPrice - price;

        if ((change * 100) / lastPrice > CIRCUIT_BREAK_THRESHOLD) {
            paused = true;
            emit Paused(true);
        }

        lastPrice = price;
    }

    // -----------------------------
    // PRICING
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
    // TRANCHE
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
    // BUY
    // -----------------------------

    function buy(uint256 minTokensOut)
        external
        payable
        cooldownCheck
        nonReentrant
        notPaused
    {
        require(msg.value > 0, "No POL sent");

        uint256 price = getPricePOL(totalSold);
        checkCircuit(price);

        uint256 fee = (msg.value * BUY_FEE) / 100;
        uint256 net = msg.value - fee;

        uint256 tokens = (net * 1e18) / price;

        require(tokens >= minTokensOut, "Slippage exceeded");
        require(tokens <= TX_LIMIT, "Tx limit exceeded");
        require(balanceOf(msg.sender) + tokens <= WALLET_LIMIT, "Wallet cap");

        updateTranche();
        require(totalSold + tokens <= unlockedSupply, "Supply locked");

        totalSold += tokens;
        treasuryBalance += net;

        _mint(msg.sender, tokens);

        (bool success, ) = payable(daoTreasury).call{value: fee}("");
        require(success, "DAO transfer failed");

        emit Buy(msg.sender, msg.value, tokens);
    }

    // -----------------------------
    // SELL
    // -----------------------------

    function sell(uint256 amount, uint256 minPOLOut)
        external
        cooldownCheck
        nonReentrant
        notPaused
    {
        require(amount <= TX_LIMIT, "Tx limit exceeded");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        uint256 price = getPricePOL(totalSold);
        checkCircuit(price);

        uint256 payout = (amount * price) / 1e18;

        require(payout >= minPOLOut, "Slippage exceeded");
        require(address(this).balance >= payout, "Insufficient liquidity");
        require(treasuryBalance >= payout, "Treasury underflow");

        totalSold -= amount;
        treasuryBalance -= payout;

        _burn(msg.sender, amount);

        (bool success, ) = payable(msg.sender).call{value: payout}("");
        require(success, "Payout failed");

        emit Sell(msg.sender, amount, payout);
    }

    // -----------------------------
    // CONTROL (EXECUTOR ONLY)
    // -----------------------------

    function pause() external onlyOwner {
        paused = true;
        emit Paused(true);
    }

    function unpause() external onlyOwner {
        paused = false;
        emit Paused(false);
    }

    // -----------------------------
    // RECEIVE
    // -----------------------------

    receive() external payable {
        revert("Use buy()");
    }
}
