Address: 0xEFd26AFA3a3F91EF371b22a596A3502E7745212C

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

interface ILaborToken {

    function pause() external;

    function unpause() external;

    function paused()
        external
        view
        returns (bool);
}

contract PauseExecutor is
    Ownable,
    ReentrancyGuard
{

    // ===== GOVERNANCE =====
    address public governance;

    // ===== TOKEN =====
    address public immutable laborToken;

    // ===== COOLDOWNS =====
    uint256 public constant
        ACTION_COOLDOWN = 1 days;

    uint256 public lastPauseAction;

    // ===== EVENTS =====
    event GovernanceSet(
        address indexed governance
    );

    event TradingPaused(
        address indexed executor,
        uint256 timestamp
    );

    event TradingResumed(
        address indexed executor,
        uint256 timestamp
    );

    // ===== CONSTRUCTOR =====
    constructor(
        address _laborToken
    )
        Ownable(msg.sender)
    {

        require(
            _laborToken != address(0),
            "Invalid token"
        );

        laborToken =
            _laborToken;
    }

    // ===== GOVERNANCE ONLY =====
    modifier onlyGovernance() {

        require(
            msg.sender == governance,
            "Only governance"
        );

        _;
    }

    // ===== COOLDOWN =====
    modifier cooldownPassed() {

        require(
            block.timestamp >=
            lastPauseAction
                + ACTION_COOLDOWN,
            "Cooldown active"
        );

        _;
    }

    // ===== SET GOVERNANCE =====
    // One-time governance assignment
    function setGovernance(
        address _governance
    )
        external
        onlyOwner
    {

        require(
            governance == address(0),
            "Governance already set"
        );

        require(
            _governance != address(0),
            "Invalid governance"
        );

        governance =
            _governance;

        emit GovernanceSet(
            _governance
        );
    }

    // ===== PAUSE =====
    function pause()
        external
        onlyGovernance
        cooldownPassed
        nonReentrant
    {

        require(
            !ILaborToken(
                laborToken
            ).paused(),
            "Already paused"
        );

        lastPauseAction =
            block.timestamp;

        ILaborToken(
            laborToken
        ).pause();

        emit TradingPaused(
            msg.sender,
            block.timestamp
        );
    }

    // ===== UNPAUSE =====
    function unpause()
        external
        onlyGovernance
        cooldownPassed
        nonReentrant
    {

        require(
            ILaborToken(
                laborToken
            ).paused(),
            "Not paused"
        );

        lastPauseAction =
            block.timestamp;

        ILaborToken(
            laborToken
        ).unpause();

        emit TradingResumed(
            msg.sender,
            block.timestamp
        );
    }
}
