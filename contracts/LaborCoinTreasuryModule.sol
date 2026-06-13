# Treasury Module

## Address

`0x0B018E45E4cB71E222C345a5341BdbaeE519c623`

## Purpose

The Treasury Module acts as the dedicated treasury distribution component of LaborCoin.

It receives treasury funds and executes approved distributions.

---

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LaborCoinTreasuryModule
{
    // =====================================================
    // DAO
    // =====================================================

    address public immutable DAO;

    uint256 public totalDistributed;

    // =====================================================
    // EVENTS
    // =====================================================

    event TransferExecuted(
        address indexed recipient,
        uint256 amount
    );

    // =====================================================
    // CONSTRUCTOR
    // =====================================================

    constructor(
        address _dao
    ) {

        require(
            _dao != address(0),
            "Invalid DAO"
        );

        DAO = _dao;
    }

    // =====================================================
    // ONLY DAO
    // =====================================================

    modifier onlyDAO() {

        require(
            msg.sender == DAO,
            "Only DAO"
        );

        _;
    }

    // =====================================================
    // EXECUTE TRANSFER
    // =====================================================

    function executeTransfer(
        address payable recipient
    )
        external
        payable
        onlyDAO
    {

        require(
            recipient != address(0),
            "Invalid recipient"
        );

        require(
            msg.value > 0,
            "Invalid amount"
        );

        (bool success,) =
            recipient.call{
                value: msg.value
            }("");

        require(
            success,
            "Transfer failed"
        );

        totalDistributed += msg.value;

        emit TransferExecuted(
            recipient,
            msg.value
        );
    }

    // =====================================================
    // RECEIVE
    // =====================================================

    receive() external payable {}
}
