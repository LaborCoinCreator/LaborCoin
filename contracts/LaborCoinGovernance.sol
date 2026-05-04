# LaborCoin Governance Contract

**Network:** Polygon  
**Contract Address:** `0x1C01BD6ccC2C9aCfb59f37f7877A7a2718167aBe`

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
- **Quorum:** 25% participation  
- **Approval:** 67% yes votes  

---

## Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface ILABRV {
    function balanceOf(address account) external view returns (uint256);
    function totalSupply() external view returns (uint256);
}

contract LaborCoinGovernance is Ownable {

    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    ILABRV public LABRV;
    address public verifier;

    uint256 public proposalCount;

    uint256 public constant VOTING_PERIOD = 5 days;
    uint256 public constant EXEC_DELAY = 1 days;

    uint256 public constant QUORUM_PERCENT = 25;
    uint256 public constant APPROVAL_PERCENT = 67;

    struct Proposal {
        address target;
        uint256 value;
        bytes data;

        uint256 start;
        uint256 end;

        uint256 yes;
        uint256 no;

        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public voted;

    constructor(address _labrv, address _verifier)
        Ownable(msg.sender)
    {
        require(_labrv != address(0), "Invalid LABRV");
        require(_verifier != address(0), "Invalid verifier");

        LABRV = ILABRV(_labrv);
        verifier = _verifier;
    }

    // ===== ADMIN =====
    function setVerifier(address _verifier) external onlyOwner {
        require(_verifier != address(0), "Invalid verifier");
        verifier = _verifier;
    }

    // ===== PROPOSE =====
    function propose(
        address target,
        uint256 value,
        bytes calldata data,
        bytes calldata signature
    ) external returns (uint256) {

        require(_verify(msg.sender, signature), "Not verified");
        require(LABRV.balanceOf(msg.sender) > 0, "No voting power");

        proposalCount++;

        proposals[proposalCount] = Proposal({
            target: target,
            value: value,
            data: data,
            start: block.timestamp,
            end: block.timestamp + VOTING_PERIOD,
            yes: 0,
            no: 0,
            executed: false
        });

        return proposalCount;
    }

    // ===== VOTE =====
    function vote(uint256 id, bool support, bytes calldata signature) external {
        Proposal storage p = proposals[id];

        require(block.timestamp < p.end, "Voting ended");
        require(!voted[id][msg.sender], "Already voted");

        require(_verify(msg.sender, signature), "Not verified");

        uint256 weight = LABRV.balanceOf(msg.sender);
        require(weight > 0, "No voting power");

        voted[id][msg.sender] = true;

        if (support) {
            p.yes += weight;
        } else {
            p.no += weight;
        }
    }

    // ===== EXECUTE =====
    function execute(uint256 id) external {
        Proposal storage p = proposals[id];

        require(block.timestamp >= p.end + EXEC_DELAY, "Delay not passed");
        require(!p.executed, "Already executed");

        uint256 totalVotes = p.yes + p.no;
        require(totalVotes > 0, "No votes");

        uint256 supply = LABRV.totalSupply();

        uint256 participation = (totalVotes * 100) / supply;
        require(participation >= QUORUM_PERCENT, "Quorum not met");

        uint256 approval = (p.yes * 100) / totalVotes;
        require(approval >= APPROVAL_PERCENT, "Approval not met");

        p.executed = true;

        (bool success, ) = p.target.call{value: p.value}(p.data);
        require(success, "Execution failed");
    }

    // ===== VERIFY =====
    function _verify(address user, bytes calldata signature) internal view returns (bool) {
        bytes32 messageHash = keccak256(
            abi.encode(user, address(this))
        );

        bytes32 ethHash = messageHash.toEthSignedMessageHash();

        address recovered = ethHash.recover(signature);

        return recovered == verifier;
    }
}
Notes
LABRV must be non-transferable (1 per user)
Registration contract must be set as LABRV minter
Verifier signs user approvals off-chain
Governance execution is fully on-chain and permissionless after thresholds are met

Flow
User → Signature Verification → Proposal/Vote → DAO → Execution
Status

✔ Deployed
✔ Thresholds aligned with whitepaper
✔ Replay-safe verification
✔ Ownership-controlled verifier
