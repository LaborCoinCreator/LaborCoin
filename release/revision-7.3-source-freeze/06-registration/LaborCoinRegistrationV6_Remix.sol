// SPDX-License-Identifier: MIT
pragma solidity 0.8.36;

import {ReentrancyGuard} from "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v5.6.1/contracts/utils/ReentrancyGuard.sol";

interface ILaborCoinV4ForRegistration {
    function balanceOf(address account) external view returns (uint256);
    function launchFinalized() external view returns (bool);
    function owner() external view returns (address);
    function officialExchange() external view returns (address);
}
interface ILaborVoteV9ForRegistration {
    function LABR() external view returns (address);
    function registration() external view returns (address);
    function minterFinalized() external view returns (bool);
    function owner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function mint(address participant) external;
    function expectedLABRRuntimeCodeHash() external view returns (bytes32);
    function expectedRegistrationRuntimeCodeHash() external view returns (bytes32);
    function REGISTRATION_COMPATIBILITY_ID() external view returns (bytes32);
}
interface ILaborCoinIdentityRegistryV1ForRegistration {
    function isVerified(address participant) external view returns (bool);
    function COMPATIBILITY_ID() external view returns (bytes32);
    function MIN_PASSPORT_SCORE() external view returns (uint256);
}

/// @title LaborCoin Registration V6.1
/// @notice Permanent one-member-one-vote registration with historical electorate checkpoints.
contract LaborCoinRegistrationV6 is ReentrancyGuard {
    uint256 public constant POLYGON_MAINNET_CHAIN_ID = 137;
    uint256 public constant MIN_LABR = 1 ether;
    uint256 public constant MEMBERSHIP_UNIT = 1 ether;
    bytes32 public constant COMPATIBILITY_ID = keccak256(
        "LABORCOIN_REGISTRATION_V6_1_SHARED_IDENTITY_HISTORICAL_ELECTORATE_V1"
    );
    bytes32 public constant IDENTITY_COMPATIBILITY_ID = keccak256(
        "LABORCOIN_IDENTITY_V1_SCORE15_PERMANENT_EIP712_V1"
    );
    string public constant CONTRACT_VERSION = "LaborCoin Registration V6.1.1";

    address public LABR;
    address public LABRV;
    address public identityRegistry;
    bytes32 public expectedLABRRuntimeCodeHash;
    bytes32 public expectedLABRVRuntimeCodeHash;
    bytes32 public expectedIdentityRegistryRuntimeCodeHash;
    bytes32 public expectedRegistrationRuntimeCodeHash;

    uint256 public totalMembers;
    mapping(address account => bool status) public registered;
    mapping(address account => uint256 number) public memberNumber;
    mapping(address account => uint256 timestamp) public registrationTimestamp;
    mapping(uint256 number => uint256 timestamp) public registrationTimestampByMemberNumber;

    error ZeroAddress();
    error ZeroCodeHash();
    error WrongChain(uint256 actualChainId);
    error AddressHasNoCode(address account);
    error InvalidRuntimeCodeHash(address account, bytes32 actual, bytes32 expected);
    error InvalidIdentityCompatibility(bytes32 actual);
    error InvalidIdentityThreshold(uint256 actual);
    error InvalidLABRLaunchState();
    error InvalidLABRVToken(address actual);
    error InvalidLABRVLABRCodeHash(bytes32 actual);
    error InvalidLABRVRegistrationCodeHash(bytes32 actual);
    error InvalidLABRVCompatibility(bytes32 actual);
    error RegistrationNotReady();
    error OnlyDirectWallet(address caller, address transactionOrigin);
    error IdentityVerificationRequired(address account);
    error InsufficientLABR(uint256 balance, uint256 minimum);
    error AlreadyRegistered(address account);
    error ExistingMembershipBalance(address account, uint256 balance);
    error MembershipMintFailed(address account, uint256 balance);

    event Registered(address indexed participant, uint256 indexed memberNumber, uint256 timestamp);

    constructor(
        address labr_,
        address labrv_,
        address identityRegistry_,
        bytes32 expectedLABRRuntimeCodeHash_,
        bytes32 expectedLABRVRuntimeCodeHash_,
        bytes32 expectedIdentityRegistryRuntimeCodeHash_,
        bytes32 expectedRegistrationRuntimeCodeHash_
    ) {
        if (block.chainid != POLYGON_MAINNET_CHAIN_ID) revert WrongChain(block.chainid);
        if (labr_ == address(0) || labrv_ == address(0) || identityRegistry_ == address(0)) revert ZeroAddress();
        if (expectedLABRRuntimeCodeHash_ == bytes32(0) || expectedLABRVRuntimeCodeHash_ == bytes32(0) || expectedIdentityRegistryRuntimeCodeHash_ == bytes32(0) || expectedRegistrationRuntimeCodeHash_ == bytes32(0)) revert ZeroCodeHash();
        _validateCode(labr_, expectedLABRRuntimeCodeHash_);
        _validateCode(labrv_, expectedLABRVRuntimeCodeHash_);
        _validateCode(identityRegistry_, expectedIdentityRegistryRuntimeCodeHash_);

        ILaborCoinV4ForRegistration token = ILaborCoinV4ForRegistration(labr_);
        if (!token.launchFinalized() || token.owner() != address(0) || token.officialExchange() == address(0)) {
            revert InvalidLABRLaunchState();
        }
        ILaborVoteV9ForRegistration vote = ILaborVoteV9ForRegistration(labrv_);
        if (vote.LABR() != labr_) revert InvalidLABRVToken(vote.LABR());
        if (vote.expectedLABRRuntimeCodeHash() != expectedLABRRuntimeCodeHash_) {
            revert InvalidLABRVLABRCodeHash(vote.expectedLABRRuntimeCodeHash());
        }
        if (vote.expectedRegistrationRuntimeCodeHash() != expectedRegistrationRuntimeCodeHash_) {
            revert InvalidLABRVRegistrationCodeHash(vote.expectedRegistrationRuntimeCodeHash());
        }
        if (vote.REGISTRATION_COMPATIBILITY_ID() != COMPATIBILITY_ID) {
            revert InvalidLABRVCompatibility(vote.REGISTRATION_COMPATIBILITY_ID());
        }
        ILaborCoinIdentityRegistryV1ForRegistration identity =
            ILaborCoinIdentityRegistryV1ForRegistration(identityRegistry_);
        if (identity.COMPATIBILITY_ID() != IDENTITY_COMPATIBILITY_ID) {
            revert InvalidIdentityCompatibility(identity.COMPATIBILITY_ID());
        }
        if (identity.MIN_PASSPORT_SCORE() != 15_000) {
            revert InvalidIdentityThreshold(identity.MIN_PASSPORT_SCORE());
        }

        LABR = labr_;
        LABRV = labrv_;
        identityRegistry = identityRegistry_;
        expectedLABRRuntimeCodeHash = expectedLABRRuntimeCodeHash_;
        expectedLABRVRuntimeCodeHash = expectedLABRVRuntimeCodeHash_;
        expectedIdentityRegistryRuntimeCodeHash = expectedIdentityRegistryRuntimeCodeHash_;
        expectedRegistrationRuntimeCodeHash = expectedRegistrationRuntimeCodeHash_;
    }

    function register() external nonReentrant {
        _requireDirectWallet();
        if (!registrationReady()) revert RegistrationNotReady();
        if (registered[msg.sender]) revert AlreadyRegistered(msg.sender);
        if (!ILaborCoinIdentityRegistryV1ForRegistration(identityRegistry).isVerified(msg.sender)) {
            revert IdentityVerificationRequired(msg.sender);
        }
        uint256 labrBalance = ILaborCoinV4ForRegistration(LABR).balanceOf(msg.sender);
        if (labrBalance < MIN_LABR) revert InsufficientLABR(labrBalance, MIN_LABR);
        uint256 existingVoteBalance = ILaborVoteV9ForRegistration(LABRV).balanceOf(msg.sender);
        if (existingVoteBalance != 0) revert ExistingMembershipBalance(msg.sender, existingVoteBalance);

        uint256 number = totalMembers + 1;
        registered[msg.sender] = true;
        memberNumber[msg.sender] = number;
        registrationTimestamp[msg.sender] = block.timestamp;
        registrationTimestampByMemberNumber[number] = block.timestamp;
        totalMembers = number;

        ILaborVoteV9ForRegistration(LABRV).mint(msg.sender);
        uint256 mintedBalance = ILaborVoteV9ForRegistration(LABRV).balanceOf(msg.sender);
        if (mintedBalance != MEMBERSHIP_UNIT) revert MembershipMintFailed(msg.sender, mintedBalance);
        emit Registered(msg.sender, number, block.timestamp);
    }

    function registrationReady() public view returns (bool) {
        ILaborVoteV9ForRegistration vote = ILaborVoteV9ForRegistration(LABRV);
        return vote.minterFinalized()
            && vote.registration() == address(this)
            && vote.owner() == address(0)
            && address(this).codehash == expectedRegistrationRuntimeCodeHash;
    }

    function isRegistered(address account) external view returns (bool) {
        return registered[account];
    }

    /// @notice Returns the number of members registered strictly before a timestamp.
    /// @dev Registration numbers and timestamps are monotonic. Binary search keeps
    /// historical electorate lookup bounded even if membership grows substantially.
    function totalMembersBefore(uint256 timestampExclusive) public view returns (uint256) {
        uint256 low = 0;
        uint256 high = totalMembers;

        while (low < high) {
            uint256 mid = low + ((high - low + 1) / 2);
            if (registrationTimestampByMemberNumber[mid] < timestampExclusive) {
                low = mid;
            } else {
                high = mid - 1;
            }
        }

        return low;
    }

    function getMemberData(address account) external view returns (bool, uint256, uint256) {
        return (registered[account], memberNumber[account], registrationTimestamp[account]);
    }

    function _requireDirectWallet() private view {
        if (msg.sender != tx.origin || msg.sender.code.length != 0) {
            revert OnlyDirectWallet(msg.sender, tx.origin);
        }
    }

    function _validateCode(address account, bytes32 expected) private view {
        if (account.code.length == 0) revert AddressHasNoCode(account);
        if (account.codehash != expected) revert InvalidRuntimeCodeHash(account, account.codehash, expected);
    }
}
