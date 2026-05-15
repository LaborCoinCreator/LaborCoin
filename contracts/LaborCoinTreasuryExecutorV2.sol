Address: 0xf80D9Ea4c9bbB393D390B5568f04C81931a8f599

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract TreasuryExecutor is Ownable {

    address public governance;

    constructor()
        Ownable(msg.sender)
    {}

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

    // ===== RECEIVE POL =====
    receive() external payable {}

    // ===== TREASURY TRANSFER =====
    function sendPOL(
        address payable recipient,
        uint256 amount
    )
        external
        onlyGovernance
    {

        require(
            recipient != address(0),
            "Invalid recipient"
        );

        require(
            amount > 0,
            "Invalid amount"
        );

        require(
            address(this).balance >= amount,
            "Insufficient treasury"
        );

        (bool success,) =
            recipient.call{
                value: amount
            }("");

        require(
            success,
            "Transfer failed"
        );
    }
}
