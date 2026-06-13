# LaborCoin Registration V3

## Address

`0xa7D0C092C2391379046cACDc56BEbDe5A0CBD113`

## Purpose

Registration V3 controls entry into LaborCoin governance.

Users who hold LABR and successfully complete identity verification may register and receive LABRV governance rights.

---

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

interface ILABR {

    function balanceOf(
        address account
    )
        external
        view
        returns (uint256);
}

interface ILABRV {

    function balanceOf(
        address account
    )
        external
        view
        returns (uint256);

    function mint(
        address to
    )
        external;
}

contract LaborCoinRegistrationV3 {

    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    // =====================================================
    // TOKENS
    // =====================================================

    ILABR public LABR;

    ILABRV public LABRV;

    // =====================================================
    // CONFIG
    // =====================================================

    address public immutable verifier;

    uint256 public constant MIN_LABR =
        1 ether;

    // =====================================================
    // REGISTRATION STORAGE
    // =====================================================

    uint256 public totalMembers;

    mapping(address => bool)
        public registered;

    mapping(address => uint256)
        public memberNumber;

    mapping(address => uint256)
        public registrationTimestamp;

    // =====================================================
    // EVENTS
    // =====================================================

    event Registered(

        address indexed user,

        uint256 memberId,

        uint256 timestamp
    );

    // =====================================================
    // CONSTRUCTOR
    // =====================================================

    constructor(

        address _labr,

        address _labrv,

        address _verifier
    )
    {

        require(
            _labr != address(0),
            "Invalid LABR"
        );

        require(
            _labrv != address(0),
            "Invalid LABRV"
        );

        require(
            _verifier != address(0),
            "Invalid verifier"
        );

        LABR =
            ILABR(_labr);

        LABRV =
            ILABRV(_labrv);

        verifier =
            _verifier;
    }

    // =====================================================
    // REGISTER
    // =====================================================

    function register(
        bytes calldata signature
    )
        external
    {

        require(

            !registered[
                msg.sender
            ],

            "Already registered"
        );

        require(

            LABR.balanceOf(
                msg.sender
            ) >= MIN_LABR,

            "Requires 1 LABR"
        );

        require(

            _verify(

                msg.sender,

                signature
            ),

            "Not verified"
        );

        // =========================================
        // ASSIGN MEMBER NUMBER
        // =========================================

        totalMembers++;

        uint256 memberId =
            totalMembers;

        registered[
            msg.sender
        ] = true;

        memberNumber[
            msg.sender
        ] = memberId;

        registrationTimestamp[
            msg.sender
        ] = block.timestamp;

        // =========================================
        // CONDITIONAL LABRV MINT
        // =========================================

        if (

            LABRV.balanceOf(
                msg.sender
            ) == 0
        ) {

            LABRV.mint(
                msg.sender
            );
        }

        emit Registered(

            msg.sender,

            memberId,

            block.timestamp
        );
    }

    // =====================================================
    // VERIFY SIGNATURE
    // =====================================================

    function _verify(

        address user,

        bytes calldata signature
    )
        internal
        view
        returns (bool)
    {

        bytes32 messageHash =
            keccak256(
                abi.encode(user)
            );

        bytes32 ethSigned =
            messageHash
                .toEthSignedMessageHash();

        address recovered =
            ethSigned.recover(
                signature
            );

        return (
            recovered == verifier
        );
    }

    // =====================================================
    // HELPERS
    // =====================================================

    function isRegistered(
        address user
    )
        external
        view
        returns (bool)
    {

        return registered[user];
    }

    function getMemberData(
        address user
    )
        external
        view
        returns (

            bool isMember,

            uint256 memberId,

            uint256 registeredAt
        )
    {

        return (

            registered[user],

            memberNumber[user],

            registrationTimestamp[user]
        );
    }
}
