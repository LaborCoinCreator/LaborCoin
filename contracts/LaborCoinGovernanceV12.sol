# LaborCoin Governance Contract

**Network:** Polygon  
**Contract Address:** `0xEFbb3f8f873282a5d6789E6Ae11409B43FC18910`

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

MINIMUM_REGISTERED_USERS = 50
PROPOSAL_DURATION = 14 days
EXECUTION_WINDOW = 7 days
MAX_TRANSFER_PERCENT = 5

---

## Contract

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

interface ILABRV {

    function balanceOf(
        address account
    )
        external
        view
        returns (uint256);
}

interface IAragonDAO {

    struct Action {
        address to;
        uint256 value;
        bytes data;
    }

    function execute(
        bytes32 callId,
        Action[] calldata actions,
        uint256 allowFailureMap
    )
        external
        returns (
            bytes[] memory results,
            uint256 failureMap
        );
}

interface ITreasuryModule {

    function executeTransfer(
        address payable recipient
    )
        external
        payable;
}

interface IRegistration {
    function totalMembers()
        external
        view
        returns (uint256);
}

contract LaborCoinGovernanceV12 is
    ReentrancyGuard
{
    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    // =====================================================
    // STRUCTS
    // =====================================================

    struct Proposal {

        string title;

        string description;

        address payable recipient;

        uint256 amount;

        uint256 yesVotes;

        uint256 noVotes;

        uint256 startTime;

        uint256 endTime;

        bool executed;
    }

    // =====================================================
    // STATE
    // =====================================================

    IAragonDAO public DAO;

    ILABRV public LABRV;

    IRegistration public immutable registration;

    address public verifier;

    address public treasuryModule;

    uint256 public proposalCount;

    // =====================================================
    // PROPOSAL SETTINGS
    // =====================================================

    uint256 public constant
        MINIMUM_REGISTERED_USERS = 50;

    uint256 public constant
        PROPOSAL_DURATION = 14 days;

    uint256 public constant
        MINIMUM_PARTICIPATION_PERCENT = 25;

    uint256 public constant
        APPROVAL_PERCENT = 67;

    uint256 public constant
        MAX_TRANSFER_PERCENT = 5;

    uint256 public constant
        EXECUTION_WINDOW = 7 days;    

    // =====================================================
    // STORAGE
    // =====================================================

    mapping(uint256 => Proposal)
        public proposals;

    mapping(uint256 => mapping(address => bool))
        public hasVoted;

    mapping(address => uint256)
        public nonces;    

    // =====================================================
    // EVENTS
    // =====================================================

    event ProposalCreated(
        uint256 indexed proposalId,
        address indexed creator,
        string title,
        address recipient,
        uint256 amount
    );

    event VoteCast(
        uint256 indexed proposalId,
        address indexed voter,
        bool support
    );

    event ProposalExecuted(
        uint256 indexed proposalId
    );

    // =====================================================
    // CONSTRUCTOR
    // =====================================================

    constructor(
        address _dao,
        address _labrv,
        address _verifier,
        address _treasuryModule,
        address _registration
    ) {

        require(
            _dao != address(0),
            "Invalid DAO"
        );

        require(
            _labrv != address(0),
            "Invalid LABRV"
        );

        require(
            _verifier != address(0),
            "Invalid verifier"
        );
   
        require(
            _treasuryModule != address(0),
            "Invalid treasury module"
        );

        require(
            _registration != address(0),
            "Invalid registration"
);

        DAO =
            IAragonDAO(_dao);

        LABRV =
            ILABRV(_labrv);

        verifier =
            _verifier;

        treasuryModule =
            _treasuryModule;

        registration =
            IRegistration(_registration);        
    }

    // =====================================================
    // CREATE PROPOSAL
    // =====================================================

    function createProposal(
        string calldata title,
        string calldata description,
        address payable recipient,
        uint256 amount,
        uint256 nonce,
        uint256 expiry,
        bytes calldata signature
    )
        external
    {

        require(
            LABRV.balanceOf(msg.sender) > 0,
            "Not registered"
        );

        require(
            recipient != address(0),
            "Invalid recipient"
        );

        require(
            amount > 0,
            "Invalid amount"
        );

        require(
            block.timestamp <= expiry,
            "Signature expired"
        );

        require(
            nonce ==
            nonces[msg.sender],
            "Invalid nonce"
        );

        require(
            _verify(
                msg.sender,
                0,
                nonce,
                expiry,
                signature
            ),
            "Invalid signature"
        );

        nonces[msg.sender]++;

        proposalCount++;

        Proposal storage proposal =
            proposals[proposalCount];

        proposal.title =
            title;

        proposal.description =
            description;

        proposal.recipient =
            recipient;

        proposal.amount =
            amount;

        proposal.startTime =
            block.timestamp;

        proposal.endTime =
            block.timestamp
            + PROPOSAL_DURATION;

        emit ProposalCreated(
            proposalCount,
            msg.sender,
            title,
            recipient,
            amount
        );
    }

    // =====================================================
    // VOTE
    // =====================================================

    function vote(
        uint256 proposalId,
        bool support,
        uint256 nonce,
        uint256 expiry,
        bytes calldata signature
    )
        external
    {

        Proposal storage proposal =
            proposals[proposalId];

        require(
            LABRV.balanceOf(msg.sender) > 0,
            "Not registered"
        );

        require(
            block.timestamp <
            proposal.endTime,
            "Voting ended"
        );

        require(
            !hasVoted[
                proposalId
            ][msg.sender],
            "Already voted"
        );

        require(
            block.timestamp <= expiry,
            "Signature expired"
        );

        require(
            nonce ==
            nonces[msg.sender],
            "Invalid nonce"
        );

        require(
            _verify(
                msg.sender,
                support ? 1 : 2,
                nonce,
                expiry,
                signature
            ),
            "Invalid signature"
        );

        nonces[msg.sender]++;

        hasVoted[
            proposalId
        ][msg.sender] = true;

        if (support) {

            proposal.yesVotes++;

        } else {

            proposal.noVotes++;
        }

        emit VoteCast(
            proposalId,
            msg.sender,
            support
        );
    }

    // =====================================================
    // EXECUTE PROPOSAL
    // =====================================================

    function executeProposal(
        uint256 proposalId
    )
        external
        nonReentrant
    {

        Proposal storage proposal =
            proposals[proposalId];

        require(
            registration.totalMembers() >=
            MINIMUM_REGISTERED_USERS,
            "Not enough users"
        );

        require(
            block.timestamp >=
            proposal.endTime,
            "Voting active"
        );

        require(
            !proposal.executed,
            "Already executed"
        );

        require(
            proposalPassed(
                proposalId
            ),
            "Proposal failed"
        );

        uint256 treasuryBalance =
            address(DAO).balance;

        require(
            block.timestamp <=
            proposal.endTime +
            EXECUTION_WINDOW,
            "Execution expired"
        );
        
        require(
            proposal.amount <=
            (
                treasuryBalance
                *
                MAX_TRANSFER_PERCENT
            ) / 100,
            "Transfer exceeds limit"
        );

        proposal.executed = true;

        // =================================================
        // BUILD DAO ACTION
        // =================================================

        IAragonDAO.Action[]
            memory actions =
                new IAragonDAO.Action[](1);

        actions[0] =
            IAragonDAO.Action({
                to:
                    treasuryModule,

                value:
                    proposal.amount,

                data:
                    abi.encodeWithSignature(
                        "executeTransfer(address)",
                        proposal.recipient
                    )
            });

        // =================================================
        // EXECUTE THROUGH DAO
        // =================================================

        DAO.execute(
            bytes32(0),
            actions,
            0
        );

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

        Proposal storage proposal =
            proposals[proposalId];
 
        uint256 totalVotes =
            proposal.yesVotes +
            proposal.noVotes;

        if (
            totalVotes == 0
        ) {
            return false;
        }
  
        if (
            registration.totalMembers() == 0
        ) {
           return false;
        }

        uint256 participationPercent =
            (
                totalVotes
                * 100
            ) / registration.totalMembers();

        if (
            participationPercent <
            MINIMUM_PARTICIPATION_PERCENT
        ) {
            return false;
        }

        uint256 approvalPercent =
            (
                proposal.yesVotes
                * 100
            ) / totalVotes;

        return
            approvalPercent >=
            APPROVAL_PERCENT;
    }

    // =====================================================
    // EXECUTION ALLOWED
    // =====================================================

    function executionAllowed()
        public
        view
        returns (bool)
    {

        return
            registration.totalMembers() >=
            MINIMUM_REGISTERED_USERS;
    }

    // =====================================================
    // EXECUTION WINDOW
    // =====================================================

    function executionWindow()
        external
        pure
        returns (uint256)
    {
        return EXECUTION_WINDOW;
    }

    // =====================================================
    // VERIFY SIGNATURE
    // =====================================================

    function _verify(
        address user,
        uint256 action,
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
                    action,
                    nonce,
                    expiry,
                    address(this)
                )
            );

        bytes32 ethSignedMessageHash =
            messageHash
                .toEthSignedMessageHash();

        address recovered =
            ethSignedMessageHash
                .recover(signature);

        return
            recovered ==
            verifier;
    }

    // =====================================================
    // RECEIVE POL
    // =====================================================

    receive() external payable {}
}
