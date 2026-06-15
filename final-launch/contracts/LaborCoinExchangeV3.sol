// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

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

/* ========== MAIN CONTRACT ========== */
contract LaborCoinExchangeV3 is ReentrancyGuard {

    IERC20 public immutable LABR;

    AggregatorV3Interface public immutable priceFeed =
        AggregatorV3Interface(0xAB594600376Ec9fD91F8e885dADF0CE036862dE0);

    address public daoTreasury;

    uint256 public constant MAX_SUPPLY = 1_000_000_000 ether;
    uint256 public constant INITIAL_TRANCHE = 100_000_000 ether;
    uint256 public constant TRANCHE_SIZE = 50_000_000 ether;
    uint256 public constant COOLDOWN = 12 hours;

    uint256 public constant MAX_PRICE_POL = 100 ether;

    uint256 public totalSold;
    uint256 public unlockedSupply;

    mapping(address => uint256) public lastTxTime;

    event Buy(address indexed user, uint256 polIn, uint256 tokensOut);
    event Sell(address indexed user, uint256 tokensIn, uint256 polOut);
    event TrancheUnlocked(uint256 unlocked);

    constructor(
        address _labr,
        address _daoTreasury
    ) {
        require(_labr != address(0), "Bad LABR");
        require(_daoTreasury != address(0), "Bad DAO");

        LABR = IERC20(_labr);
        daoTreasury = _daoTreasury;

        unlockedSupply = INITIAL_TRANCHE;
    }

    modifier cooldownCheck() {
        require(block.timestamp >= lastTxTime[msg.sender] + COOLDOWN, "Cooldown");
        _;
        lastTxTime[msg.sender] = block.timestamp;
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

    receive() external payable {}
}
