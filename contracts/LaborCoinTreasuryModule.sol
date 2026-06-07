Address: 0x84AC5be86e2102496949862F59aCeB5d7Dc3Df77

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
