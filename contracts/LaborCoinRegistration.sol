# LaborCoin Registration Contract

This contract handles permissionless voter registration for the LaborCoin DAO.

## Overview

Users can register if they:
- Hold at least **1 LABR token**
- Have not registered before

Upon registration:
- The user is marked as registered
- A **LABRV voting token** is minted to their wallet
- This grants them DAO voting rights

---

## Solidity Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ILABR {
    function balanceOf(address account) external view returns (uint256);
}

interface ILABRV {
    function mint(address to) external;
}

contract LaborCoinRegistration {

    ILABR public LABR;
    ILABRV public LABRV;

    mapping(address => bool) public registered;

    uint256 public constant MIN_LABR = 1 ether;

    event Registered(address indexed user);

    constructor(address _labr, address _labrv) {
        require(_labr != address(0));
        require(_labrv != address(0));

        LABR = ILABR(_labr);
        LABRV = ILABRV(_labrv);
    }

    function register() external {
        require(!registered[msg.sender], "Already registered");

        require(
            LABR.balanceOf(msg.sender) >= MIN_LABR,
            "Requires 1 LABR"
        );

        registered[msg.sender] = true;

        LABRV.mint(msg.sender);

        emit Registered(msg.sender);
    }
}
