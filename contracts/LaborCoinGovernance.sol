# LaborCoin Governance Contract

**Network:** Polygon  
**Contract Address:** `0x716452CF3D183bC2392f80cFACa3F9d88CCB6882`

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

interface ILABRV {

    function balanceOf(address account)
        external
        view
        returns (uint256);

    function totalSupply()
        external
        view
        returns (uint256);
}

interface ITreasuryExecutor {

    function sendPOL(
        address payable recipient,
        uint256 amount
    ) external;
}

interface IPauseExecutor {

    function pause() external;

    function unpause() external;
}

contract LaborCoinGovernance is Ownable {

    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    // ===== ENUMS =====
    enum ProposalType {
        TreasuryTransfer,
        PauseTrading,
        ResumeTrading
    }

    // ===== STATE =====
    ILABRV public LABRV;

    ITreasuryExecutor
        public treasuryExecutor;

    IPauseExecutor
        public pauseExecutor;

    address public verifier;

    uint256 public proposalCount;

    // ===== NONCES =====
    mapping(address => uint256)
        public nonces;

    // ===== SETTINGS =====
    uint256 public constant VOTING_PERIOD =
        5 days;

    uint256 public constant EXEC_DELAY =
        1 days;

    uint256 public constant QUORUM_PERCENT =
        40;

    uint256 public constant APPROVAL_PERCENT =
        67;

    uint256 public constant MAX_EXPIRY_WINDOW =
        10 minutes;

    // ===== STRUCT =====
    struct Proposal {

        ProposalType proposalType;

        address payable recipient;

        uint256 amount;

        uint256 start;

        uint256 end;

        uint256 yes;

        uint256 no;

        bool executed;
    }

    // ===== STORAGE =====
    mapping(uint256 => Proposal)
        public proposals;

    mapping(uint256 => mapping(address => bool))
        public voted;

    // ===== EVENTS =====
    event ProposalCreated(
        uint256 indexed id,
        address indexed proposer,
        ProposalType proposalType,
        address recipient,
        uint256 amount
    );

    event VoteCast(
        uint256 indexed id,
        address indexed voter,
        bool support,
        uint256 weight
    );

    event ProposalExecuted(
        uint256 indexed id
    );

    event NonceUsed(
        address indexed user,
        uint256 nonce
    );

    // ===== CONSTRUCTOR =====
    constructor(
        address _labrv,
        address _treasuryExecutor,
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
            _treasuryExecutor != address(0),
            "Invalid treasury executor"
        );

        require(
            _pauseExecutor != address(0),
            "Invalid pause executor"
        );

        require(
            _verifier != address(0),
            "Invalid verifier"
        );

        LABRV =
            ILABRV(_labrv);

        treasuryExecutor =
            ITreasuryExecutor(
                _treasuryExecutor
            );

        pauseExecutor =
            IPauseExecutor(
                _pauseExecutor
            );

        verifier = _verifier;
    }

    // ===== ADMIN =====
    function setVerifier(
        address _verifier
    )
        external
        onlyOwner
    {

        require(
            _verifier != address(0),
            "Invalid verifier"
        );

        verifier = _verifier;
    }

    // ===== TREASURY PROPOSAL =====
    function proposeTreasuryTransfer(
        address payable recipient,
        uint256 amount,
        uint256 expiry,
        bytes calldata signature
    )
        external
        returns (uint256)
    {

        require(
            recipient != address(0),
            "Invalid recipient"
        );

        require(
            amount > 0,
            "Invalid amount"
        );

        _validateSignature(
            msg.sender,
            "propose",
            expiry,
            signature
        );

        proposalCount++;

        proposals[
            proposalCount
        ] = Proposal({

            proposalType:
                ProposalType
                    .TreasuryTransfer,

            recipient:
                recipient,

            amount:
                amount,

            start:
                block.timestamp,

            end:
                block.timestamp +
                VOTING_PERIOD,

            yes: 0,

            no: 0,

            executed: false
        });

        emit ProposalCreated(
            proposalCount,
            msg.sender,
            ProposalType
                .TreasuryTransfer,
            recipient,
            amount
        );

        return proposalCount;
    }

    // ===== PAUSE PROPOSAL =====
    function proposePauseTrading(
        uint256 expiry,
        bytes calldata signature
    )
        external
        returns (uint256)
    {

        _validateSignature(
            msg.sender,
            "propose",
            expiry,
            signature
        );

        proposalCount++;

        proposals[
            proposalCount
        ] = Proposal({

            proposalType:
                ProposalType
                    .PauseTrading,

            recipient:
                payable(address(0)),

            amount: 0,

            start:
                block.timestamp,

            end:
                block.timestamp +
                VOTING_PERIOD,

            yes: 0,

            no: 0,

            executed: false
        });

        emit ProposalCreated(
            proposalCount,
            msg.sender,
            ProposalType
                .PauseTrading,
            address(0),
            0
        );

        return proposalCount;
    }

    // ===== RESUME PROPOSAL =====
    function proposeResumeTrading(
        uint256 expiry,
        bytes calldata signature
    )
        external
        returns (uint256)
    {

        _validateSignature(
            msg.sender,
            "propose",
            expiry,
            signature
        );

        proposalCount++;

        proposals[
            proposalCount
        ] = Proposal({

            proposalType:
                ProposalType
                    .ResumeTrading,

            recipient:
                payable(address(0)),

            amount: 0,

            start:
                block.timestamp,

            end:
                block.timestamp +
                VOTING_PERIOD,

            yes: 0,

            no: 0,

            executed: false
        });

        emit ProposalCreated(
            proposalCount,
            msg.sender,
            ProposalType
                .ResumeTrading,
            address(0),
            0
        );

        return proposalCount;
    }

    // ===== VOTE =====
    function vote(
        uint256 id,
        bool support,
        uint256 expiry,
        bytes calldata signature
    )
        external
    {

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

        _validateSignature(
            msg.sender,
            "vote",
            expiry,
            signature
        );

        uint256 weight =
            LABRV.balanceOf(
                msg.sender
            );

        require(
            weight > 0,
            "No voting power"
        );

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

    // ===== EXECUTE =====
    function execute(
        uint256 id
    )
        external
    {

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

        uint256 participation =
            (totalVotes * 100)
            / supply;

        require(
            participation >=
            QUORUM_PERCENT,
            "Quorum not met"
        );

        uint256 approval =
            (p.yes * 100)
            / totalVotes;

        require(
            approval >=
            APPROVAL_PERCENT,
            "Approval not met"
        );

        p.executed = true;

        // ===== EXECUTION =====
        if (
            p.proposalType ==
            ProposalType
                .TreasuryTransfer
        ) {

            treasuryExecutor
                .sendPOL(
                    p.recipient,
                    p.amount
                );

        } else if (

            p.proposalType ==
            ProposalType
                .PauseTrading

        ) {

            pauseExecutor.pause();

        } else if (

            p.proposalType ==
            ProposalType
                .ResumeTrading

        ) {

            pauseExecutor.unpause();
        }

        emit ProposalExecuted(id);
    }

    // ===== INTERNAL VERIFY =====
    function _validateSignature(
        address user,
        string memory action,
        uint256 expiry,
        bytes calldata signature
    )
        internal
    {

        require(
            block.timestamp <= expiry,
            "Signature expired"
        );

        require(
            expiry <=
            block.timestamp +
            MAX_EXPIRY_WINDOW,
            "Expiry too far"
        );

        require(
            _verify(
                user,
                action,
                nonces[user],
                expiry,
                signature
            ),
            "Not verified"
        );

        require(
            LABRV.balanceOf(
                user
            ) > 0,
            "No voting power"
        );

        nonces[user]++;

        emit NonceUsed(
            user,
            nonces[user]
        );
    }

    // ===== VERIFY =====
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
            ethHash.recover(
                signature
            );

        return recovered ==
            verifier;
    }
}
