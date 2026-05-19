Address: 0x260e5c1dA01a51A3059FDb2163914AC9ff83c0F7

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

// ===== ARAGON ACTION =====
struct Action {

    address to;

    uint256 value;

    bytes data;
}

// ===== ARAGON DAO INTERFACE =====
interface IDAO {

    function execute(
        bytes32 _callId,
        Action[] memory _actions,
        uint256 _allowFailureMap
    )
        external
        returns (
            bytes[] memory,
            uint256
        );
}

contract TreasuryExecutor is Ownable {

    // ===== STATE =====
    address public governance;

    IDAO public dao;

    // ===== EVENTS =====
    event GovernanceSet(
        address governance
    );

    event TreasuryTransferExecuted(
        address recipient,
        uint256 amount
    );

    // ===== CONSTRUCTOR =====
    constructor(
        address _dao
    )
        Ownable(msg.sender)
    {

        require(
            _dao != address(0),
            "Invalid DAO"
        );

        dao = IDAO(_dao);
    }

    // ===== GOVERNANCE ONLY =====
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

        emit GovernanceSet(
            _governance
        );
    }

    // ===== SEND POL =====
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

        // ===== BUILD ACTION =====
        Action[]
            memory actions =
                new Action[](1);

        actions[0] = Action({

            to:
                recipient,

            value:
                amount,

            data:
                ""
        });

        // ===== EXECUTE VIA DAO =====
        dao.execute(

            keccak256(
                abi.encode(
                    recipient,
                    amount
                )
            ),

            actions,

            0 // no failures allowed
        );

        emit TreasuryTransferExecuted(
            recipient,
            amount
        );
    }
}
