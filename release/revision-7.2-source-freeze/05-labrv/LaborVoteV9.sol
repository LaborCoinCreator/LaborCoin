// SPDX-License-Identifier: MIT
pragma solidity 0.8.36;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface ILaborCoinV4ForLaborVote {
    function launchFinalized() external view returns (bool);
    function owner() external view returns (address);
    function officialExchange() external view returns (address);
    function TOTAL_SUPPLY() external view returns (uint256);
    function MAX_WALLET() external view returns (uint256);
    function MAX_TRANSACTION() external view returns (uint256);
}

interface ILaborCoinRegistrationV6_1ForLaborVote {
    function LABR() external view returns (address);
    function LABRV() external view returns (address);
    function expectedLABRRuntimeCodeHash() external view returns (bytes32);
    function expectedLABRVRuntimeCodeHash() external view returns (bytes32);
    function expectedRegistrationRuntimeCodeHash() external view returns (bytes32);
    function COMPATIBILITY_ID() external view returns (bytes32);
}

/// @title LaborVote V9.1
/// @notice One permanent, nontransferable LABRV membership unit per registered participant.
contract LaborVoteV9 is ERC20 {
    uint256 public constant POLYGON_MAINNET_CHAIN_ID = 137;
    uint256 public constant MEMBERSHIP_UNIT = 1 ether;
    bytes32 public constant REGISTRATION_COMPATIBILITY_ID = keccak256(
        "LABORCOIN_REGISTRATION_V6_1_SHARED_IDENTITY_HISTORICAL_ELECTORATE_V1"
    );
    string public constant CONTRACT_VERSION = "LaborVote V9.1.1";

    address public LABR;
    bytes32 public expectedLABRRuntimeCodeHash;
    bytes32 public expectedRegistrationRuntimeCodeHash;

    address private _launchOwner;
    address public registration;
    bool public minterFinalized;

    error ZeroAddress();
    error ZeroCodeHash();
    error WrongChain(uint256 actualChainId);
    error AddressHasNoCode(address account);
    error InvalidRuntimeCodeHash(address account, bytes32 actual, bytes32 expected);
    error InvalidLABRLaunchState();
    error UnauthorizedLaunchOwner(address caller);
    error MinterAlreadyFinalized();
    error MinterNotFinalized();
    error InvalidRegistrationToken(address actual);
    error InvalidRegistrationVoteToken(address actual);
    error InvalidRegistrationCompatibility(bytes32 actual);
    error InvalidRegistrationLABRCodeHash(bytes32 actual);
    error InvalidRegistrationLABRVCodeHash(bytes32 actual);
    error InvalidRegistrationSelfCodeHash(bytes32 actual);
    error OnlyRegistration(address caller);
    error MembershipAlreadyMinted(address participant);
    error TransfersDisabled();
    error BurningDisabled();

    event MinterFinalized(address indexed registration);
    event OwnershipRenounced(address indexed previousOwner);
    event MembershipMinted(address indexed participant, uint256 memberSupply);

    constructor(
        address labr_,
        bytes32 expectedLABRRuntimeCodeHash_,
        bytes32 expectedRegistrationRuntimeCodeHash_
    ) ERC20("LaborVote", "LABRV") {
        if (block.chainid != POLYGON_MAINNET_CHAIN_ID) revert WrongChain(block.chainid);
        if (labr_ == address(0)) revert ZeroAddress();
        if (expectedLABRRuntimeCodeHash_ == bytes32(0) || expectedRegistrationRuntimeCodeHash_ == bytes32(0)) revert ZeroCodeHash();
        if (labr_.code.length == 0) revert AddressHasNoCode(labr_);
        if (labr_.codehash != expectedLABRRuntimeCodeHash_) {
            revert InvalidRuntimeCodeHash(labr_, labr_.codehash, expectedLABRRuntimeCodeHash_);
        }
        ILaborCoinV4ForLaborVote token = ILaborCoinV4ForLaborVote(labr_);
        if (!token.launchFinalized() || token.owner() != address(0) || token.officialExchange() == address(0)) {
            revert InvalidLABRLaunchState();
        }
        LABR = labr_;
        expectedLABRRuntimeCodeHash = expectedLABRRuntimeCodeHash_;
        expectedRegistrationRuntimeCodeHash = expectedRegistrationRuntimeCodeHash_;
        _launchOwner = msg.sender;
    }

    modifier onlyLaunchOwner() {
        if (msg.sender != _launchOwner) revert UnauthorizedLaunchOwner(msg.sender);
        _;
    }

    function owner() external view returns (address) { return _launchOwner; }

    function finalizeMinter(address registration_) external onlyLaunchOwner {
        if (minterFinalized) revert MinterAlreadyFinalized();
        if (registration_ == address(0)) revert ZeroAddress();
        if (registration_.code.length == 0) revert AddressHasNoCode(registration_);
        if (registration_.codehash != expectedRegistrationRuntimeCodeHash) {
            revert InvalidRuntimeCodeHash(registration_, registration_.codehash, expectedRegistrationRuntimeCodeHash);
        }
        ILaborCoinRegistrationV6_1ForLaborVote candidate =
            ILaborCoinRegistrationV6_1ForLaborVote(registration_);
        if (candidate.LABR() != LABR) revert InvalidRegistrationToken(candidate.LABR());
        if (candidate.LABRV() != address(this)) revert InvalidRegistrationVoteToken(candidate.LABRV());
        if (candidate.COMPATIBILITY_ID() != REGISTRATION_COMPATIBILITY_ID) {
            revert InvalidRegistrationCompatibility(candidate.COMPATIBILITY_ID());
        }
        if (candidate.expectedLABRRuntimeCodeHash() != expectedLABRRuntimeCodeHash) {
            revert InvalidRegistrationLABRCodeHash(candidate.expectedLABRRuntimeCodeHash());
        }
        if (candidate.expectedLABRVRuntimeCodeHash() != address(this).codehash) {
            revert InvalidRegistrationLABRVCodeHash(candidate.expectedLABRVRuntimeCodeHash());
        }
        if (candidate.expectedRegistrationRuntimeCodeHash() != expectedRegistrationRuntimeCodeHash) {
            revert InvalidRegistrationSelfCodeHash(candidate.expectedRegistrationRuntimeCodeHash());
        }
        registration = registration_;
        minterFinalized = true;
        address previousOwner = _launchOwner;
        _launchOwner = address(0);
        emit MinterFinalized(registration_);
        emit OwnershipRenounced(previousOwner);
    }

    function mint(address participant) external {
        if (msg.sender != registration) revert OnlyRegistration(msg.sender);
        if (!minterFinalized) revert MinterNotFinalized();
        if (balanceOf(participant) != 0) revert MembershipAlreadyMinted(participant);
        _mint(participant, MEMBERSHIP_UNIT);
        emit MembershipMinted(participant, totalSupply());
    }

    function transfer(address, uint256) public pure override returns (bool) { revert TransfersDisabled(); }
    function approve(address, uint256) public pure override returns (bool) { revert TransfersDisabled(); }
    function transferFrom(address, address, uint256) public pure override returns (bool) { revert TransfersDisabled(); }

    function _update(address from, address to, uint256 value) internal override {
        if (from != address(0)) {
            if (to == address(0)) revert BurningDisabled();
            revert TransfersDisabled();
        }
        super._update(from, to, value);
    }
}
