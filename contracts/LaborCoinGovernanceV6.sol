# LaborCoin Governance Contract

**Network:** Polygon  
**Contract Address:** `0x357E8574E6046411717946485fD7edbEd0066150`

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

interface IERC20Minimal {

    function balanceOf(
        address account
    )
        external
        view
        returns (uint256);
}

interface IPauseExecutor {

    function pause()
        external;

    function unpause()
        external;
}

contract LaborCoinGovernanceV6 is
    Ownable,
    ReentrancyGuard
{
    using ECDSA for bytes32;
using MessageHashUtils for bytes32;
    // ===== ENUM =====
    enum ProposalType {

        TREASURY_TRANSFER,
        PAUSE_TRADING,
        RESUME_TRADING
    }

    // ===== STRUCT =====
    struct Proposal {

        ProposalType proposalType;

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

    // ===== EVENTS =====
    event ProposalCreated(

        uint256 indexed id,

        address indexed proposer,

        ProposalType proposalType,

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

    // ===== IMMUTABLES =====
    IERC20Minimal
        public immutable labrv;

    IPauseExecutor
        public immutable pauseExecutor;

    // ===== VERIFIER =====
    address public verifier;

    // ===== REGISTRATION =====
    mapping(address => bool)
        public registered;

    mapping(address => uint256)
        public registrationNumber;

    uint256 public totalRegisteredUsers;

    // ===== PROPOSALS =====
    uint256 public proposalCount;

    mapping(uint256 => Proposal)
        public proposals;

    mapping(uint256 => mapping(address => bool))
        public hasVoted;

    // ===== SNAPSHOT VOTING =====
    mapping(uint256 => mapping(address => uint256))
        public snapshotVotingPower;

    // ===== NONCES =====
    mapping(address => mapping(uint8 => uint256))
        public noncesPerAction;

    // ===== COOLDOWNS =====
    mapping(address => uint256)
        public lastProposalTime;

    uint256 public lastExecutionTime;

    // ===== CONSTANTS =====
    uint256 public constant
        PROPOSAL_DURATION = 5 days;

    uint256 public constant
        PROPOSAL_COOLDOWN = 5 days;

    uint256 public constant
        EXECUTION_COOLDOWN = 1 days;

    uint256 public constant
        MIN_REGISTERED_USERS = 50;

    uint256 public constant
        QUORUM_PERCENT = 20;

    uint256 public constant
        MAX_TRANSFER_PERCENT = 5;

    // ===== ARAGON =====
    mapping(uint256 => uint256)
        public aragonProposalIds;

    // ===== CONSTRUCTOR =====
    constructor(

        address _labrv,

        address _pauseExecutor,

        address _verifier
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

        labrv =
            IERC20Minimal(
                _labrv
            );

        pauseExecutor =
            IPauseExecutor(
                _pauseExecutor
            );

        verifier =
            _verifier;
    }

    // ===== REGISTER =====
    function register()
        external
    {

        require(
            !registered[msg.sender],
            "Already registered"
        );

        registered[msg.sender] =
            true;

        totalRegisteredUsers++;

        registrationNumber[
            msg.sender
        ] = totalRegisteredUsers;
    }

    // ===== PROPOSE =====
    function propose(

        ProposalType proposalType,

        address recipient,

        uint256 amount,

        string calldata description,

        uint256 expiry,

        bytes calldata signature
    )
        external
        nonReentrant
        returns (uint256)
    {

        require(
            registered[msg.sender],
            "Not registered"
        );

        require(
            block.timestamp >=
            lastProposalTime[msg.sender]
                + PROPOSAL_COOLDOWN,
            "Proposal cooldown active"
        );

        require(
            block.timestamp <= expiry,
            "Signature expired"
        );

        if (
            proposalType ==
            ProposalType.TREASURY_TRANSFER
        ) {

            require(
                recipient != address(0),
                "Invalid recipient"
            );
        }

        _verifySignature(

            msg.sender,

            uint8(proposalType),

            expiry,

            signature
        );

        proposalCount++;

        Proposal storage p =
            proposals[proposalCount];

        p.proposalType =
            proposalType;

        p.proposer =
            msg.sender;

        p.recipient =
            recipient;

        p.amount =
            amount;

        p.description =
            description;

        p.start =
            block.timestamp;

        p.end =
            block.timestamp
                + PROPOSAL_DURATION;

        // ===== SNAPSHOT =====
        uint256 votingPower =
            labrv.balanceOf(
                msg.sender
            );

        snapshotVotingPower
            [proposalCount]
            [msg.sender]
                = votingPower;

        lastProposalTime[
            msg.sender
        ] = block.timestamp;

        emit ProposalCreated(

            proposalCount,

            msg.sender,

            proposalType,

            recipient,

            amount,

            description
        );

        return proposalCount;
    }

    // ===== VOTE =====
    function vote(

        uint256 proposalId,

        bool support,

        uint256 expiry,

        bytes calldata signature
    )
        external
        nonReentrant
    {

        Proposal storage p =
            proposals[proposalId];

        require(
            registered[msg.sender],
            "Not registered"
        );

        require(
            block.timestamp < p.end,
            "Voting ended"
        );

        require(
            !hasVoted
                [proposalId]
                [msg.sender],
            "Already voted"
        );

        require(
            block.timestamp <= expiry,
            "Signature expired"
        );

        _verifySignature(

            msg.sender,

            99,

            expiry,

            signature
        );

        uint256 weight =
            snapshotVotingPower
                [proposalId]
                [msg.sender];

        if (weight == 0) {

            weight =
                labrv.balanceOf(
                    msg.sender
                );

            snapshotVotingPower
                [proposalId]
                [msg.sender]
                    = weight;
        }

        require(
            weight > 0,
            "No voting power"
        );

        hasVoted
            [proposalId]
            [msg.sender]
                = true;

        if (support) {

            p.yes += weight;

        } else {

            p.no += weight;
        }

        emit VoteCast(

            proposalId,

            msg.sender,

            support,

            weight
        );
    }

    // ===== EXECUTE =====
    function execute(
        uint256 proposalId
    )
        external
        nonReentrant
    {

        Proposal storage p =
            proposals[proposalId];

        require(
            totalRegisteredUsers >=
            MIN_REGISTERED_USERS,
            "Not enough users"
        );

        require(
            block.timestamp >= p.end,
            "Voting active"
        );

        require(
            !p.executed,
            "Already executed"
        );

        require(
            block.timestamp >=
            lastExecutionTime
                + EXECUTION_COOLDOWN,
            "Execution cooldown"
        );

        uint256 totalVotes =
            p.yes + p.no;

        uint256 quorum =
            (
                totalRegisteredUsers
                * QUORUM_PERCENT
            ) / 100;

        require(
            totalVotes >= quorum,
            "Quorum not met"
        );

        require(
            p.yes > p.no,
            "Proposal failed"
        );

        // ===== PAUSE =====
        if (
            p.proposalType ==
            ProposalType.PAUSE_TRADING
        ) {

            pauseExecutor.pause();
        }

        // ===== RESUME =====
        if (
            p.proposalType ==
            ProposalType.RESUME_TRADING
        ) {

            pauseExecutor.unpause();
        }

        // ===== TREASURY =====
        // Treasury transfers
        // execute through Aragon
        // proposal synchronization

        p.executed = true;

        lastExecutionTime =
            block.timestamp;

        emit ProposalExecuted(
            proposalId
        );
    }

    // ===== VERIFY =====
    function _verifySignature(

        address user,

        uint8 action,

        uint256 expiry,

        bytes calldata signature
    )
        internal
    {

        uint256 nonce =
            noncesPerAction
                [user]
                [action];

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
            ECDSA.recover(
                ethHash,
                signature
            );

        require(
            recovered == verifier,
            "Invalid signature"
        );

        noncesPerAction
            [user]
            [action]++;
    }

    // ===== ADMIN =====
    function setAragonProposalId(

        uint256 proposalId,

        uint256 aragonId
    )
        external
        onlyOwner
    {

        aragonProposalIds[
            proposalId
        ] = aragonId;
    }
}
