# LaborCoin DAO Registration V2

**Network:** Polygon  
**Contract Address:** `0xFFc3499A71b806C3919f4B54D236b151cFdCB453`

---

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

interface ILABR {
    function balanceOf(address account) external view returns (uint256);
}

interface ILABRV {
    function mint(address to) external;
}

contract LaborCoinRegistration {

    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    ILABR public LABR;
    ILABRV public LABRV;

    address public verifier;

    mapping(address => bool) public registered;

    uint256 public constant MIN_LABR = 1 ether;

    event Registered(address indexed user);

    constructor(address _labr, address _labrv, address _verifier) {
        require(_labr != address(0), "Invalid LABR");
        require(_labrv != address(0), "Invalid LABRV");
        require(_verifier != address(0), "Invalid verifier");

        LABR = ILABR(_labr);
        LABRV = ILABRV(_labrv);
        verifier = _verifier;
    }

    function register(bytes calldata signature) external {
        require(!registered[msg.sender], "Already registered");

        require(
            LABR.balanceOf(msg.sender) >= MIN_LABR,
            "Requires 1 LABR"
        );

        require(_verify(msg.sender, signature), "Not verified");

        registered[msg.sender] = true;

        LABRV.mint(msg.sender);

        emit Registered(msg.sender);
    }

    function _verify(address user, bytes calldata signature) internal view returns (bool) {
        bytes32 messageHash = keccak256(abi.encode(user));

        bytes32 ethSignedMessageHash = messageHash.toEthSignedMessageHash();

        address recovered = ethSignedMessageHash.recover(signature);

        return recovered == verifier;
    }
}
