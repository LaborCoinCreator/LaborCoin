Address: 0xe2a791FD057bBA5AEa0efcfb8b97f9de74cC7c06

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

interface ILaborToken {

    function pause() external;

    function unpause() external;
}

contract PauseExecutor is Ownable {

    address public governance;

    address public laborToken;

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

    modifier onlyGovernance() {

        require(
            msg.sender == governance,
            "Only governance"
        );

        _;
    }

    // ===== ONE-TIME GOVERNANCE SET =====
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

        governance = _governance;
    }

    // ===== PAUSE =====
    function pause()
        external
        onlyGovernance
    {

        ILaborToken(
            laborToken
        ).pause();
    }

    // ===== UNPAUSE =====
    function unpause()
        external
        onlyGovernance
    {

        ILaborToken(
            laborToken
        ).unpause();
    }
}
