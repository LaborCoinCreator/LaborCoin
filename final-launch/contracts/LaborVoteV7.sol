// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LaborVoteV7 is ERC20Votes, Ownable {

    address public minter;
    bool public minterLocked;

    constructor()
        ERC20("LaborVote", "LABRV")
        EIP712("LaborVote", "1")
        Ownable(msg.sender)
    {}

    // ===== SET MINTER =====
    function setMinter(address _minter) external onlyOwner {
        require(!minterLocked, "Minter locked");
        require(_minter != address(0), "Invalid address");

        minter = _minter;
    }

    // ===== LOCK MINTER =====
    function lockMinter() external onlyOwner {
        require(minter != address(0), "Minter not set");

        minterLocked = true;

        renounceOwnership();
    }

    // ===== MINT =====
    function mint(address to) external {
        require(msg.sender == minter, "Not authorized");
        require(to != address(0), "Invalid address");
        require(balanceOf(to) == 0, "Already registered");

        _mint(to, 1 ether);
    }

    // ===== SOULBOUND =====
    function _update(address from, address to, uint256 value)
        internal
        override
    {
        if (from != address(0) && to != address(0)) {
            revert("Non-transferable");
        }
        super._update(from, to, value);
    }
}
