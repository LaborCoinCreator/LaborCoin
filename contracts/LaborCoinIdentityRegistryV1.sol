// SPDX-License-Identifier: MIT
pragma solidity 0.8.36;

import {SignatureChecker} from "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";

interface ILaborCoinV4ForIdentityRegistry {
    function launchFinalized() external view returns (bool);
    function identityRegistry() external view returns (address);
    function expectedIdentityRegistryRuntimeCodeHash() external view returns (bytes32);
    function syncDividendEligibility(address account) external returns (bool);
}

/// @title LaborCoin Identity Registry V1
/// @notice Permanent, one-time Human Passport verification for LaborCoin.
/// @dev A verified direct wallet may use the official Exchange, accrue and claim
/// equal-holder dividends, and register for governance membership. Verification
/// cannot be revoked, transferred, administered, or changed after deployment.
contract LaborCoinIdentityRegistryV1 {
    uint256 public constant POLYGON_MAINNET_CHAIN_ID = 137;
    uint256 public constant SCORE_SCALE = 1_000;
    uint256 public constant MIN_PASSPORT_SCORE = 15_000;
    uint256 public constant MAX_AUTHORIZATION_LIFETIME = 1 hours;

    bytes32 public constant COMPATIBILITY_ID = keccak256(
        "LABORCOIN_IDENTITY_V1_SCORE15_PERMANENT_EIP712_V1"
    );
    string public constant CONTRACT_VERSION =
        "LaborCoin Identity Registry V1.0.1";

    bytes32 private constant _DOMAIN_TYPEHASH = keccak256(
        "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
    );
    bytes32 private constant _NAME_HASH = keccak256("LaborCoin Identity");
    bytes32 private constant _VERSION_HASH = keccak256("1");
    bytes32 public constant IDENTITY_TYPEHASH = keccak256(
        "Identity(address participant,uint256 passportScore,bytes32 scorerIdHash,uint256 nonce,uint256 expiry)"
    );

    address public verifier;
    bytes32 public scorerIdHash;
    bytes32 public expectedLABRRuntimeCodeHash;

    address private _launchOwner;
    address public LABR;
    bool public labrFinalized;

    mapping(address participant => bool status) public verified;
    mapping(address participant => uint256 score) public verifiedScore;
    mapping(address participant => uint256 timestamp) public verificationTimestamp;
    mapping(address participant => uint256 nonce) public nonces;

    error ZeroAddress();
    error ZeroCodeHash();
    error ZeroScorerIdHash();
    error WrongChain(uint256 actualChainId);
    error AddressHasNoCode(address account);
    error UnauthorizedLaunchOwner(address caller);
    error LABRAlreadyFinalized();
    error InvalidRuntimeCodeHash(address account, bytes32 actual, bytes32 expected);
    error InvalidLABRIdentityRegistry(address actual);
    error InvalidLABRIdentityCodeHash(bytes32 actual);
    error IdentityRegistryNotReady();
    error OnlyDirectWallet(address caller, address transactionOrigin);
    error AlreadyVerified(address participant);
    error ScoreTooLow(uint256 actual, uint256 minimum);
    error AuthorizationExpired(uint256 expiry, uint256 currentTimestamp);
    error AuthorizationTooLong(uint256 expiry, uint256 maximumExpiry);
    error InvalidSignature();

    event LABRFinalized(address indexed labr, address indexed previousOwner);
    event ParticipantVerified(
        address indexed participant,
        uint256 passportScore,
        uint256 indexed nonce,
        uint256 timestamp
    );

    constructor(
        address verifier_,
        bytes32 scorerIdHash_,
        bytes32 expectedLABRRuntimeCodeHash_
    ) {
        if (block.chainid != POLYGON_MAINNET_CHAIN_ID) {
            revert WrongChain(block.chainid);
        }
        if (verifier_ == address(0)) revert ZeroAddress();
        if (scorerIdHash_ == bytes32(0)) revert ZeroScorerIdHash();
        if (expectedLABRRuntimeCodeHash_ == bytes32(0)) revert ZeroCodeHash();
        verifier = verifier_;
        scorerIdHash = scorerIdHash_;
        expectedLABRRuntimeCodeHash = expectedLABRRuntimeCodeHash_;
        _launchOwner = msg.sender;
    }

    modifier onlyLaunchOwner() {
        if (msg.sender != _launchOwner) revert UnauthorizedLaunchOwner(msg.sender);
        _;
    }

    function owner() external view returns (address) {
        return _launchOwner;
    }

    /// @notice Permanently binds the registry to the exact LABR V4 runtime.
    function finalizeLaborCoin(address labr_) external onlyLaunchOwner {
        if (labrFinalized) revert LABRAlreadyFinalized();
        if (labr_ == address(0)) revert ZeroAddress();
        if (labr_.code.length == 0) revert AddressHasNoCode(labr_);
        if (labr_.codehash != expectedLABRRuntimeCodeHash) {
            revert InvalidRuntimeCodeHash(
                labr_,
                labr_.codehash,
                expectedLABRRuntimeCodeHash
            );
        }
        ILaborCoinV4ForIdentityRegistry token =
            ILaborCoinV4ForIdentityRegistry(labr_);
        if (token.identityRegistry() != address(this)) {
            revert InvalidLABRIdentityRegistry(token.identityRegistry());
        }
        if (token.expectedIdentityRegistryRuntimeCodeHash() != address(this).codehash) {
            revert InvalidLABRIdentityCodeHash(
                token.expectedIdentityRegistryRuntimeCodeHash()
            );
        }

        LABR = labr_;
        labrFinalized = true;
        address previousOwner = _launchOwner;
        _launchOwner = address(0);
        emit LABRFinalized(labr_, previousOwner);
    }

    function verifyParticipant(
        uint256 passportScore,
        uint256 expiry,
        bytes calldata signature
    ) external {
        _requireDirectWallet();
        if (!identityReady()) revert IdentityRegistryNotReady();
        if (verified[msg.sender]) revert AlreadyVerified(msg.sender);
        if (passportScore < MIN_PASSPORT_SCORE) {
            revert ScoreTooLow(passportScore, MIN_PASSPORT_SCORE);
        }
        if (expiry < block.timestamp) {
            revert AuthorizationExpired(expiry, block.timestamp);
        }
        uint256 maximumExpiry = block.timestamp + MAX_AUTHORIZATION_LIFETIME;
        if (expiry > maximumExpiry) {
            revert AuthorizationTooLong(expiry, maximumExpiry);
        }

        uint256 nonce = nonces[msg.sender];
        bytes32 digest = identityDigest(
            msg.sender,
            passportScore,
            nonce,
            expiry
        );
        if (!SignatureChecker.isValidSignatureNow(verifier, digest, signature)) {
            revert InvalidSignature();
        }

        nonces[msg.sender] = nonce + 1;
        verified[msg.sender] = true;
        verifiedScore[msg.sender] = passportScore;
        verificationTimestamp[msg.sender] = block.timestamp;

        // Atomic synchronization ensures a wallet that already holds at least
        // 1 LABR enters the equal-holder set in the same verification transaction.
        ILaborCoinV4ForIdentityRegistry(LABR)
            .syncDividendEligibility(msg.sender);

        emit ParticipantVerified(
            msg.sender,
            passportScore,
            nonce,
            block.timestamp
        );
    }

    function isVerified(address participant) external view returns (bool) {
        return verified[participant];
    }

    function identityReady() public view returns (bool) {
        if (!labrFinalized || LABR == address(0) || _launchOwner != address(0)) {
            return false;
        }
        ILaborCoinV4ForIdentityRegistry token =
            ILaborCoinV4ForIdentityRegistry(LABR);
        return token.launchFinalized()
            && token.identityRegistry() == address(this)
            && token.expectedIdentityRegistryRuntimeCodeHash()
                == address(this).codehash;
    }

    function domainSeparator() public view returns (bytes32) {
        return keccak256(
            abi.encode(
                _DOMAIN_TYPEHASH,
                _NAME_HASH,
                _VERSION_HASH,
                block.chainid,
                address(this)
            )
        );
    }

    function identityStructHash(
        address participant,
        uint256 passportScore,
        uint256 nonce,
        uint256 expiry
    ) public view returns (bytes32) {
        return keccak256(
            abi.encode(
                IDENTITY_TYPEHASH,
                participant,
                passportScore,
                scorerIdHash,
                nonce,
                expiry
            )
        );
    }

    function identityDigest(
        address participant,
        uint256 passportScore,
        uint256 nonce,
        uint256 expiry
    ) public view returns (bytes32) {
        return keccak256(
            abi.encodePacked(
                "\x19\x01",
                domainSeparator(),
                identityStructHash(
                    participant,
                    passportScore,
                    nonce,
                    expiry
                )
            )
        );
    }

    function _requireDirectWallet() private view {
        if (msg.sender != tx.origin || msg.sender.code.length != 0) {
            revert OnlyDirectWallet(msg.sender, tx.origin);
        }
    }
}
