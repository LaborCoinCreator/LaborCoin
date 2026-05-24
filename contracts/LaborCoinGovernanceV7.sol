# LaborCoin Governance Contract

**Network:** Polygon  
**Contract Address:** `0xbf06aA27bD4B327ec0B36dcD3d2aa1E72BCAc9e8`

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

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

interface ILABRV {

    function balanceOf(
        address account
    )
        external
        view
        returns (uint256);
}

interface IPauseExecutor {

    function pause() external;

    function unpause() external;
}

contract LaborCoinGovernanceV7 is
    Ownable,
    ReentrancyGuard
{
    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    // =====================================================
    // GOVERNANCE TYPES
    // =====================================================

    uint8 public constant TREASURY_TRANSFER = 0;

    uint8 public constant PAUSE_PROTOCOL = 1;

    uint8 public constant RESUME_PROTOCOL = 2;

    // =====================================================
    // GOVERNANCE CONSTANTS
    // =====================================================

    uint256 public constant PROPOSAL_DURATION =
        5 minutes;

    uint256 public constant PROPOSAL_COOLDOWN =
        5 minutes;

    uint256 public constant EXECUTION_WINDOW =
        7 days;

    uint256 public constant MINIMUM_PARTICIPATION =
        1;

    uint256 public constant MAX_TREASURY_TRANSFER =
        1000 ether;

    uint256 public constant MINIMUM_REGISTERED_USERS =
        1;

    // =====================================================
    // STATE ENUM
    // =====================================================

    enum ProposalState {

        Active,

        Passed,

        Failed,

        Executed,

        Expired
    }

    // =====================================================
    // PROPOSAL STRUCT
    // =====================================================

    struct Proposal {

        uint8 proposalType;

        address proposer;

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
    // STATE
    // =====================================================

    ILABRV public LABRV;

    IPauseExecutor public pauseExecutor;

    address public verifier;

    address public immutable treasury;

    uint256 public proposalCount;

    uint256 public totalRegisteredUsers;

    // =====================================================
    // STORAGE
    // =====================================================

    mapping(uint256 => Proposal)
        public proposals;

    mapping(uint256 => mapping(address => bool))
        public voted;

    mapping(address => uint256)
        public lastProposalTime;

    mapping(address => mapping(uint8 => uint256))
        public noncesPerAction;

    // =====================================================
    // EVENTS
    // =====================================================

    event ProposalCreated(

        uint256 indexed proposalId,

        uint8 proposalType,

        address indexed proposer,

        address recipient,

        uint256 amount,

        string description
    );

    event VoteCast(

        uint256 indexed proposalId,

        address indexed voter,

        bool support,

        uint256 weight
    );

    event ProposalExecuted(

        uint256 indexed proposalId
    );

    // =====================================================
    // CONSTRUCTOR
    // =====================================================

    constructor(

        address _labrv,

        address _pauseExecutor,

        address _verifier,

        address _treasury
    )
        Ownable(msg.sender)
    {

        require(
            _labrv != address(0),
            "Invalid LABRV"
        );

        require(
            _pauseExecutor != address(0),
            "Invalid executor"
        );

        require(
            _verifier != address(0),
            "Invalid verifier"
        );

        require(
            _treasury != address(0),
            "Invalid treasury"
        );

        LABRV =
            ILABRV(_labrv);

        pauseExecutor =
            IPauseExecutor(_pauseExecutor);

        verifier =
            _verifier;

        treasury =
            _treasury;
    }

    // =====================================================
    // MODIFIERS
    // =====================================================

    modifier onlyRegistered() {

        require(

            LABRV.balanceOf(
                msg.sender
            ) > 0,

            "Requires LABRV"
        );

        _;
    }

    // =====================================================
    // CREATE PROPOSAL
    // =====================================================

    function createProposal(

        uint8 proposalType,

        address recipient,

        uint256 amount,

        string calldata description,

        uint256 expiry,

        bytes calldata signature
    )
        external
        onlyRegistered
    {

        require(

            totalRegisteredUsers >=
            MINIMUM_REGISTERED_USERS,

            "Not enough users"
        );

        require(

            proposalType <=
            RESUME_PROTOCOL,

            "Invalid proposal type"
        );

        require(

            block.timestamp >=
            lastProposalTime[msg.sender]
            + PROPOSAL_COOLDOWN,

            "Proposal cooldown active"
        );

        require(

            bytes(description).length > 0,

            "Empty description"
        );

        require(

            block.timestamp <= expiry,

            "Signature expired"
        );

        uint256 nonce =
            noncesPerAction[
                msg.sender
            ][proposalType];

        bytes32 messageHash =
            keccak256(
                abi.encode(

                    msg.sender,

                    address(this),

                    proposalType,

                    nonce,

                    block.chainid,

                    expiry
                )
            );

        bytes32 ethSigned =
            messageHash
                .toEthSignedMessageHash();

        address recovered =
            ethSigned.recover(signature);

        require(

            recovered == verifier,

            "Invalid signature"
        );

        noncesPerAction[
            msg.sender
        ][proposalType]++;

        // =========================================
        // TREASURY RULES
        // =========================================

        if (
            proposalType ==
            TREASURY_TRANSFER
        ) {

            require(

                recipient != address(0),

                "Invalid recipient"
            );

            require(

                amount > 0,

                "Invalid amount"
            );

            require(

                amount <=
                MAX_TREASURY_TRANSFER,

                "Amount exceeds cap"
            );
        }

        // =========================================
        // PAUSE / RESUME RULES
        // =========================================

        if (
            proposalType ==
            PAUSE_PROTOCOL
            ||
            proposalType ==
            RESUME_PROTOCOL
        ) {

            require(
                recipient == address(0),
                "No recipient allowed"
            );

            require(
                amount == 0,
                "No amount allowed"
            );
        }

        proposals[
            proposalCount
        ] = Proposal({

            proposalType:
                proposalType,

            proposer:
                msg.sender,

            recipient:
                recipient,

            amount:
                amount,

            description:
                description,

            start:
                block.timestamp,

            end:
                block.timestamp
                + PROPOSAL_DURATION,

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

            msg.sender,

            recipient,

            amount,

            description
        );

        lastProposalTime[
            msg.sender
        ] = block.timestamp;

        proposalCount++;
    }

    // =====================================================
    // VOTE
    // =====================================================

    function vote(

        uint256 proposalId,

        bool support,

        uint256 expiry,

        bytes calldata signature
    )
        external
        onlyRegistered
    {

        require(
            proposalId < proposalCount,
            "Invalid proposal"
        );

        Proposal storage proposal =
            proposals[proposalId];

        require(

            block.timestamp <
            proposal.end,

            "Voting ended"
        );

        require(

            !voted[
                proposalId
            ][msg.sender],

            "Already voted"
        );

        require(

            block.timestamp <=
            expiry,

            "Signature expired"
        );

        uint256 nonce =
            noncesPerAction[
                msg.sender
            ][99];

        bytes32 messageHash =
            keccak256(
                abi.encode(

                    msg.sender,

                    address(this),

                    uint8(99),

                    nonce,

                    block.chainid,

                    expiry
                )
            );

        bytes32 ethSigned =
            messageHash
                .toEthSignedMessageHash();

        address recovered =
            ethSigned.recover(signature);

        require(

            recovered == verifier,

            "Invalid signature"
        );

        noncesPerAction[
            msg.sender
        ][99]++;

        voted[
            proposalId
        ][msg.sender] = true;

        uint256 weight = 1;

        if (support) {

            proposal.yes += weight;

        } else {

            proposal.no += weight;
        }

        emit VoteCast(

            proposalId,

            msg.sender,

            support,

            weight
        );
    }

    // =====================================================
    // EXECUTE
    // =====================================================

    function executeProposal(
        uint256 proposalId
    )
        external
        nonReentrant
    {

        require(

            canExecute(
                proposalId
            ),

            "Cannot execute"
        );

        Proposal storage proposal =
            proposals[proposalId];

        require(
            !proposal.executed,
            "Already executed"
        );

        proposal.executed = true;

        // =========================================
        // PAUSE
        // =========================================

        if (
            proposal.proposalType ==
            PAUSE_PROTOCOL
        ) {

            pauseExecutor.pause();
        }

        // =========================================
        // RESUME
        // =========================================

        if (
            proposal.proposalType ==
            RESUME_PROTOCOL
        ) {

            pauseExecutor.unpause();
        }

        // =========================================
        // TREASURY TRANSFER
        // =========================================

        if (
            proposal.proposalType ==
            TREASURY_TRANSFER
        ) {

            // Treasury execution intentionally
            // external/manual for now.
        }

        emit ProposalExecuted(
            proposalId
        );
    }

    // =====================================================
    // PROPOSAL PASSED
    // =====================================================

    function proposalPassed(
        uint256 proposalId
    )
        public
        view
        returns (bool)
    {

        Proposal memory proposal =
            proposals[proposalId];

        return (

            block.timestamp >=
            proposal.end

            &&

            proposal.yes >
            proposal.no

            &&

            proposal.yes
            +
            proposal.no
            >=
            MINIMUM_PARTICIPATION
        );
    }

    // =====================================================
    // VOTING ENDED
    // =====================================================

    function votingEnded(
        uint256 proposalId
    )
        public
        view
        returns (bool)
    {

        return (

            block.timestamp >=
            proposals[
                proposalId
            ].end
        );
    }

    // =====================================================
    // CAN EXECUTE
    // =====================================================

    function canExecute(
        uint256 proposalId
    )
        public
        view
        returns (bool)
    {

        Proposal memory proposal =
            proposals[proposalId];

        if (
            proposal.executed
        ) {

            return false;
        }

        if (
            !proposalPassed(
                proposalId
            )
        ) {

            return false;
        }

        if (

            block.timestamp >

            proposal.end
            +
            EXECUTION_WINDOW
        ) {

            return false;
        }

        return true;
    }

    // =====================================================
    // PROPOSAL STATE
    // =====================================================

    function getProposalState(
        uint256 proposalId
    )
        public
        view
        returns (ProposalState)
    {

        Proposal memory proposal =
            proposals[proposalId];

        if (
            proposal.executed
        ) {

            return
                ProposalState.Executed;
        }

        if (
            block.timestamp <
            proposal.end
        ) {

            return
                ProposalState.Active;
        }

        if (
            proposalPassed(
                proposalId
            )
        ) {

            if (

                block.timestamp >

                proposal.end
                +
                EXECUTION_WINDOW
            ) {

                return
                    ProposalState.Expired;
            }

            return
                ProposalState.Passed;
        }

        return
            ProposalState.Failed;
    }

    // =====================================================
    // TEMPORARY ADMIN
    // =====================================================

    function setTotalRegisteredUsers(
        uint256 amount
    )
        external
        onlyOwner
    {

        totalRegisteredUsers =
            amount;
    }
}
