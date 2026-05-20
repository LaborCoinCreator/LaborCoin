# LaborCoin Governance Contract

**Network:** Polygon  
**Contract Address:** `0xa0060E934377d3E9d74699D48D46A491aeb976b9`

---

## Overview

The `LaborCoinGovernance` contract manages proposal creation, voting, and execution for the LaborCoin DAO.

It enforces:
- One-person-one-vote via LABRV (soulbound token)
- Off-chain identity verification via signatures
- Quorum and approval thresholds
- Timelocked execution

---

## Parameters

- **Voting Period:** 5 days  
- **Execution Delay:** 1 day  
- **Quorum:** 40% participation  
- **Approval:** 67% yes votes  

---

## Contract

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

using ECDSA for bytes32;
using MessageHashUtils for bytes32;

// =====================================================
// LABRV INTERFACE
// =====================================================

interface ILABRV {

    function balanceOf(
        address account
    ) external view returns (uint256);

    function totalSupply()
        external
        view
        returns (uint256);
}

// =====================================================
// ARAGON ACTION STRUCT
// =====================================================

struct Action {
    address to;
    uint256 value;
    bytes data;
}

// =====================================================
// ADMIN PLUGIN INTERFACE
// =====================================================

interface IAdminPlugin {

    function createProposal(
        bytes memory _metadata,
        Action[] memory _actions,
        uint64 _startDate,
        uint64 _endDate,
        bytes memory _data
    ) external returns (uint256 proposalId);
}

// =====================================================
// GOVERNANCE V4
// =====================================================

contract LaborCoinGovernanceV4 is Ownable {

    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    // =====================================================
    // CONFIG
    // =====================================================

    ILABRV public LABRV;

    address public verifier;

    IAdminPlugin public adminPlugin;

    address public pauseExecutor;

    uint256 public proposalCount;

    uint256 public constant VOTING_PERIOD =
        5 days;

    uint256 public constant EXEC_DELAY =
        1 days;

    uint256 public constant QUORUM_PERCENT =
        25;

    uint256 public constant APPROVAL_PERCENT =
        67;

    uint256 public constant MAX_SIGNATURE_AGE =
        10 minutes;

    // =====================================================
    // NONCES
    // =====================================================

    mapping(address => uint256)
        public nonces;

    // =====================================================
    // PROPOSAL TYPES
    // =====================================================

    enum ProposalType {
        TreasuryTransfer,
        PauseTrading,
        ResumeTrading
    }

    // =====================================================
    // PROPOSAL STRUCT
    // =====================================================

    struct Proposal {

        ProposalType proposalType;

        address recipient;

        uint256 amount;

        string description;

        uint256 start;

        uint256 end;

        uint256 yes;

        uint256 no;

        bool executed;
    }

    // =====================================================
    // STORAGE
    // =====================================================

    mapping(uint256 => Proposal)
        public proposals;

    mapping(uint256 => mapping(address => bool))
        public voted;

    // =====================================================
    // TRACK ARAGON PROPOSALS
    // =====================================================

    mapping(uint256 => uint256)
        public aragonProposalIds;

    // =====================================================
    // EVENTS
    // =====================================================

    event ProposalCreated(
        uint256 indexed id,
        ProposalType proposalType,
        address indexed creator
    );

    event VoteCast(
        uint256 indexed proposalId,
        address indexed voter,
        bool support,
        uint256 weight
    );

    event ProposalExecuted(
        uint256 indexed id,
        uint256 adminProposalId
    );

    event VerifierUpdated(
        address indexed verifier
    );

    // =====================================================
    // CONSTRUCTOR
    // =====================================================

    constructor(

        address _labrv,

        address _verifier,

        address _adminPlugin,

        address _pauseExecutor

    )
        Ownable(msg.sender)
    {

        require(
            _labrv != address(0),
            "Invalid LABRV"
        );

        require(
            _verifier != address(0),
            "Invalid verifier"
        );

        require(
            _adminPlugin != address(0),
            "Invalid admin plugin"
        );

        require(
            _pauseExecutor != address(0),
            "Invalid pause executor"
        );

        LABRV =
            ILABRV(_labrv);

        verifier =
            _verifier;

        adminPlugin =
            IAdminPlugin(_adminPlugin);

        pauseExecutor =
            _pauseExecutor;
    }

    // =====================================================
    // ADMIN
    // =====================================================

    function setVerifier(
        address _verifier
    ) external onlyOwner {

        require(
            _verifier != address(0),
            "Invalid verifier"
        );

        verifier = _verifier;

        emit VerifierUpdated(
            _verifier
        );
    }

    // =====================================================
    // PROPOSE
    // =====================================================

    function propose(

        ProposalType proposalType,

        address recipient,

        uint256 amount,

        string calldata description,

        uint256 expiry,

        bytes calldata signature

    )
        external
        returns (uint256)
    {

        require(
            uint8(proposalType) <= 2,
            "Invalid proposal type"
        );

        require(
            block.timestamp <= expiry,
            "Signature expired"
        );

        require(
            expiry <=
            block.timestamp +
            MAX_SIGNATURE_AGE,
            "Expiry too long"
        );

        require(
            _verify(
                msg.sender,
                "propose",
                nonces[msg.sender],
                expiry,
                signature
            ),
            "Invalid signature"
        );

        require(
            LABRV.balanceOf(msg.sender) > 0,
            "No voting power"
        );

        // =================================================
        // VALIDATION
        // =================================================

        if (
            proposalType ==
            ProposalType.TreasuryTransfer
        ) {

            require(
                recipient != address(0),
                "Invalid recipient"
            );

            require(
                amount > 0,
                "Invalid amount"
            );
        }

        nonces[msg.sender]++;

        proposalCount++;

        proposals[proposalCount] = Proposal({

            proposalType:
                proposalType,

            recipient:
                recipient,

            amount:
                amount,

            description:
                description,

            start:
                block.timestamp,

            end:
                block.timestamp +
                VOTING_PERIOD,

            yes:
                0,

            no:
                0,

            executed:
                false
        });

        emit ProposalCreated(
            proposalCount,
            proposalType,
            msg.sender
        );

        return proposalCount;
    }

    // =====================================================
    // VOTE
    // =====================================================

    function vote(

        uint256 id,

        bool support,

        uint256 expiry,

        bytes calldata signature

    ) external {

        require(
            id > 0 &&
            id <= proposalCount,
            "Invalid proposal"
        );

        Proposal storage p =
            proposals[id];

        require(
            block.timestamp < p.end,
            "Voting ended"
        );

        require(
            !voted[id][msg.sender],
            "Already voted"
        );

        require(
            block.timestamp <= expiry,
            "Signature expired"
        );

        require(
            expiry <=
            block.timestamp +
            MAX_SIGNATURE_AGE,
            "Expiry too long"
        );

        require(
            _verify(
                msg.sender,
                "vote",
                nonces[msg.sender],
                expiry,
                signature
            ),
            "Invalid signature"
        );

        uint256 weight =
            LABRV.balanceOf(msg.sender);

        require(
            weight > 0,
            "No voting power"
        );

        nonces[msg.sender]++;

        voted[id][msg.sender] = true;

        if (support) {

            p.yes += weight;

        } else {

            p.no += weight;
        }

        emit VoteCast(
            id,
            msg.sender,
            support,
            weight
        );
    }

    // =====================================================
    // EXECUTE
    // =====================================================

    function execute(
        uint256 id
    ) external {

        require(
            id > 0 &&
            id <= proposalCount,
            "Invalid proposal"
        );

        Proposal storage p =
            proposals[id];

        require(
            block.timestamp >=
            p.end + EXEC_DELAY,
            "Delay not passed"
        );

        require(
            !p.executed,
            "Already executed"
        );

        uint256 totalVotes =
            p.yes + p.no;

        require(
            totalVotes > 0,
            "No votes"
        );

        uint256 supply =
            LABRV.totalSupply();

        require(
            supply > 0,
            "No supply"
        );

        // =================================================
        // PRECISION QUORUM
        // =================================================

        uint256 participation =
            (totalVotes * 10000)
            / supply;

        require(
            participation >=
            QUORUM_PERCENT * 100,
            "Quorum not met"
        );

        // =================================================
        // PRECISION APPROVAL
        // =================================================

        uint256 approval =
            (p.yes * 10000)
            / totalVotes;

        require(
            approval >=
            APPROVAL_PERCENT * 100,
            "Approval not met"
        );

        p.executed = true;

        // =================================================
        // BUILD SAFE ACTIONS
        // =================================================

        Action[]
            memory actions =
                new Action[](1);

        // =============================================
        // TREASURY TRANSFER
        // =============================================

        if (
            p.proposalType ==
            ProposalType.TreasuryTransfer
        ) {

            actions[0] = Action({

                to:
                    p.recipient,

                value:
                    p.amount,

                data:
                    ""
            });
        }

        // =============================================
        // PAUSE TRADING
        // =============================================

        else if (
            p.proposalType ==
            ProposalType.PauseTrading
        ) {

            actions[0] = Action({

                to:
                    pauseExecutor,

                value:
                    0,

                data:
                    abi.encodeWithSignature(
                        "pause()"
                    )
            });
        }

        // =============================================
        // RESUME TRADING
        // =============================================

        else if (
            p.proposalType ==
            ProposalType.ResumeTrading
        ) {

            actions[0] = Action({

                to:
                    pauseExecutor,

                value:
                    0,

                data:
                    abi.encodeWithSignature(
                        "unpause()"
                    )
            });
        }

        // =================================================
        // CREATE ARAGON PROPOSAL
        // =================================================

        uint256 adminProposalId =
            adminPlugin.createProposal(

                bytes(p.description),

                actions,

                uint64(block.timestamp),

                uint64(
                    block.timestamp + 1
                ),

                ""
            );

        aragonProposalIds[id] =
            adminProposalId;

        emit ProposalExecuted(
            id,
            adminProposalId
        );
    }

    // =====================================================
    // VERIFY
    // =====================================================

    function _verify(

        address user,

        string memory action,

        uint256 nonce,

        uint256 expiry,

        bytes calldata signature

    )
        internal
        view
        returns (bool)
    {

        bytes32 messageHash =
            keccak256(

                abi.encode(

                    user,

                    address(this),

                    action,

                    nonce,

                    block.chainid,

                    expiry
                )
            );

        bytes32 ethHash =
            messageHash
                .toEthSignedMessageHash();

        address recovered =
            ethHash.recover(signature);

        return recovered == verifier;
    }
}
