// SPDX-License-Identifier: MIT
pragma solidity 0.8.36;

import {ReentrancyGuard} from "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v5.6.1/contracts/utils/ReentrancyGuard.sol";

interface ILaborCoinV4ForGovernance {
    function launchFinalized() external view returns (bool);
    function owner() external view returns (address);
    function officialExchange() external view returns (address);
    function daoTreasury() external view returns (address);
}

interface ILaborVoteV9_1ForGovernance {
    function LABR() external view returns (address);
    function registration() external view returns (address);
    function minterFinalized() external view returns (bool);
    function owner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function MEMBERSHIP_UNIT() external view returns (uint256);

    function expectedLABRRuntimeCodeHash()
        external
        view
        returns (bytes32);

    function expectedRegistrationRuntimeCodeHash()
        external
        view
        returns (bytes32);

    function REGISTRATION_COMPATIBILITY_ID()
        external
        view
        returns (bytes32);
}

interface ILaborCoinRegistrationV6_1ForGovernance {
    function LABR() external view returns (address);
    function LABRV() external view returns (address);
    function totalMembers() external view returns (uint256);
    function totalMembersBefore(uint256 timestampExclusive) external view returns (uint256);
    function registrationReady() external view returns (bool);
    function registered(address account) external view returns (bool);
    function memberNumber(address account) external view returns (uint256);

    function registrationTimestamp(
        address account
    ) external view returns (uint256);

    function MEMBERSHIP_UNIT() external view returns (uint256);

    function expectedLABRRuntimeCodeHash()
        external
        view
        returns (bytes32);

    function expectedLABRVRuntimeCodeHash()
        external
        view
        returns (bytes32);

    function expectedRegistrationRuntimeCodeHash()
        external
        view
        returns (bytes32);

    function COMPATIBILITY_ID()
        external
        view
        returns (bytes32);
}

interface ILaborCoinProposalTextPolicyV1ForGovernance {
    function validateOrganizationName(
        string calldata organizationName
    ) external pure returns (bytes32 contentHash);

    function validateWorkerGroupOrCampaign(
        string calldata workerGroupOrCampaign
    ) external pure returns (bytes32 contentHash);

    function validateVerificationURI(
        string calldata verificationURI
    ) external pure returns (bytes32 contentHash);

    function isOrganizationNameAllowed(
        string calldata organizationName
    ) external pure returns (bool);

    function isWorkerGroupOrCampaignAllowed(
        string calldata workerGroupOrCampaign
    ) external pure returns (bool);

    function isVerificationURIAllowed(
        string calldata verificationURI
    ) external pure returns (bool);

    function MAX_ORGANIZATION_NAME_BYTES()
        external
        pure
        returns (uint256);

    function MAX_WORKER_GROUP_OR_CAMPAIGN_BYTES()
        external
        pure
        returns (uint256);

    function MAX_VERIFICATION_URI_BYTES()
        external
        pure
        returns (uint256);

    function COMPATIBILITY_ID()
        external
        pure
        returns (bytes32);

    function LEXICON_COMMITMENT()
        external
        pure
        returns (bytes32);
}

interface IAragonDAOForGovernance {
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

    function hasPermission(
        address where,
        address who,
        bytes32 permissionId,
        bytes memory data
    ) external view returns (bool);

    function EXECUTE_PERMISSION_ID()
        external
        view
        returns (bytes32);
}

/// @title LaborCoin Governance V15.2
/// @notice Immutable one-member-one-vote treasury governance with an electorate fixed at the voting deadline.
/// @dev Treasury proposals use a permanently structured schema. The two short
/// human-authored labels and the verification URI must pass the exact immutable
/// Proposal Text Policy V1 runtime committed during deployment. Purpose,
/// contact method, and distribution plan are closed on-chain enums, so direct
/// callers cannot bypass the structure enforced by the official frontend.
/// @dev
/// - Governance eligibility is possession of exactly one nontransferable LABRV
///   and a matching permanent Registration V6.1 record.
/// - Proposal creation and voting require direct registered wallets.
/// - No verifier or off-chain signature is required for governance actions.
/// - Any member registered before a proposal voting deadline may vote while
///   voting remains active, including members who join after proposal creation.
/// - Final participation uses the number of members registered strictly before
///   the voting deadline. Later registrations cannot change a closed result.
/// - Quorum and approval calculations use ceiling division rather than
///   truncating percentages downward.
/// - Successful proposals execute exactly one native-POL transfer directly
///   from the existing Aragon DAO to the approved recipient.
/// - Proposal type is permanently fixed as "Treasury Transfer"; arbitrary
///   user-supplied titles and unrestricted descriptions are not accepted or stored.
/// - Treasury recipients must be deployed contracts; direct transfers to EOAs
///   cannot be proposed.
/// - There is no owner, pause, setter, recovery, upgrade, arbitrary action,
///   arbitrary calldata, moderation administrator, or treasury-module dependency.
contract LaborCoinGovernanceV15 is ReentrancyGuard {
    /*//////////////////////////////////////////////////////////////
                                CONSTANTS
    //////////////////////////////////////////////////////////////*/

    uint256 public constant POLYGON_MAINNET_CHAIN_ID = 137;
    uint256 public constant BPS_DENOMINATOR = 10_000;

    uint256 public constant MEMBERSHIP_UNIT = 1 ether;
    uint256 public constant MINIMUM_REGISTERED_USERS = 50;

    uint256 public constant PROPOSAL_DURATION = 14 days;
    uint256 public constant EXECUTION_WINDOW = 7 days;

    uint256 public constant MINIMUM_PARTICIPATION_BPS = 2_500;
    uint256 public constant APPROVAL_BPS = 6_700;
    uint256 public constant MAX_TRANSFER_BPS = 500;

    uint256 public constant MAX_ORGANIZATION_NAME_BYTES = 96;
    uint256 public constant MAX_WORKER_GROUP_OR_CAMPAIGN_BYTES = 128;
    uint256 public constant MAX_VERIFICATION_URI_BYTES = 256;

    string public constant PROPOSAL_TITLE =
        "Treasury Transfer";

    bytes32 public constant PROPOSAL_TYPE =
        keccak256("LABORCOIN_TREASURY_TRANSFER");

    address public constant DAO =
        0x0C2e5679153593b82a84eAB5CA90895BB291Cec4;

    // Permanently obsolete LaborCoin deployments are invalid treasury
    // recipients. This prevents approved funds from being trapped in or
    // recirculated through superseded protocol contracts.
    address public constant LEGACY_LABR =
        0x460DD873A1D2a41e77410B125cD3027C5FEd2f78;
    address public constant LEGACY_EXCHANGE_V2 =
        0xD0692ec758bb852421B702B187b6439f74f8Bf3b;
    address public constant LEGACY_EXCHANGE_V3 =
        0xE57ba76AED1B7B4142E3DfaBd6cf3E94970b86eA;
    address public constant LEGACY_EXCHANGE_V4 =
        0x4Cf18cB39203B678f5C26f2338a10a79f9684749;
    address public constant LEGACY_LABRV_V6 =
        0x113579220515cd59b884Ea2379b4C369025246e2;
    address public constant LEGACY_LABRV_V7 =
        0x833242E933c675846D8f8982048FecA95B8e435A;
    address public constant LEGACY_REGISTRATION_V4 =
        0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C;
    address public constant LEGACY_GOVERNANCE_V12 =
        0x499b32e9E5a8b9865a9D69480d590252a56FA78F;
    address public constant LEGACY_GOVERNANCE_V13 =
        0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c;
    address public constant LEGACY_TREASURY_MODULE_V1 =
        0x0B018E45E4cB71E222C345a5341BdbaeE519c623;

    bytes32 public constant EXECUTE_PERMISSION_ID =
        keccak256("EXECUTE_PERMISSION");

    bytes32 public constant MEMBERSHIP_COMPATIBILITY_ID =
        keccak256(
            "LABORCOIN_REGISTRATION_V6_1_SHARED_IDENTITY_HISTORICAL_ELECTORATE_V1"
        );

    bytes32 public constant TEXT_POLICY_COMPATIBILITY_ID =
        keccak256(
            "LABORCOIN_PROPOSAL_TEXT_POLICY_V1_STRUCTURED_ASCII_HASHED_LEXICON_HTTPS_IPFS_V1"
        );

    bytes32 public constant TEXT_POLICY_LEXICON_COMMITMENT =
        0x46c24360a194d5e60f247daaee4f554032282ae90098a4b35662395bf4a3d2a6;

    bytes32 public constant PROPOSAL_SCHEMA_ID =
        keccak256(
            "LABORCOIN_STRUCTURED_TREASURY_PROPOSAL_SCHEMA_V1"
        );

    bytes32 public constant GOVERNANCE_COMPATIBILITY_ID =
        keccak256(
            "LABORCOIN_GOVERNANCE_V15_2_STRUCTURED_TREASURY_DEADLINE_ELECTORATE_DIRECT_DAO_POL_TEXT_POLICY_V1"
        );

    bytes32 private constant _CALL_ID_PREFIX =
        keccak256("LABORCOIN_GOVERNANCE_V15_2_PROPOSAL_EXECUTION");

    string public constant PROPOSAL_SCHEMA_VERSION =
        "LaborCoin Structured Treasury Proposal Schema V1";

    string public constant CONTRACT_VERSION =
        "LaborCoin Governance V15.2.0";

    /*//////////////////////////////////////////////////////////////
                                  ENUMS
    //////////////////////////////////////////////////////////////*/

    enum ProposalState {
        Nonexistent,
        Active,
        Defeated,
        Succeeded,
        Executed,
        Expired
    }

    enum Purpose {
        Unset,
        StrikeOrWorkStoppage,
        OrganizingOrUnionization,
        WorkerMutualAidOrEmergencyRelief,
        LegalDefenseOrRepresentation,
        DirectActionOrDemonstration,
        WorkerCooperativeOrWorkplaceDemocracy,
        EducationOutreachOrCommunications,
        OtherWorkerLedCollectiveAction
    }

    enum ContactMethod {
        Unset,
        OrganizationWebsite,
        Email,
        Signal,
        Matrix,
        SocialMedia,
        UnionOrWorkerOrganizationChannel,
        VerificationSourceOnly,
        OtherPublicChannel
    }

    enum DistributionPlan {
        Unset,
        DirectWorkerPayments,
        NeedsBasedWorkerRelief,
        SharedStrikeOrMutualAidFund,
        OrganizingOrCampaignOperations,
        LegalOrProfessionalExpenses,
        SuppliesEquipmentOrLogistics,
        DemocraticWorkerEnterpriseDevelopment,
        MixedUse,
        OtherCollectiveUse
    }

    /*//////////////////////////////////////////////////////////////
                                 STRUCTS
    //////////////////////////////////////////////////////////////*/

    struct ProposalInput {
        string organizationName;
        address payable recipient;
        string workerGroupOrCampaign;
        uint256 amount;
        Purpose purpose;
        string verificationURI;
        ContactMethod contactMethod;
        DistributionPlan distributionPlan;
    }

    struct Proposal {
        string organizationName;
        address payable recipient;
        string workerGroupOrCampaign;
        uint256 amount;
        Purpose purpose;
        string verificationURI;
        ContactMethod contactMethod;
        DistributionPlan distributionPlan;
        bytes32 contentHash;
        uint256 yesVotes;
        uint256 noVotes;
        uint256 startTime;
        uint256 endTime;
        bool executed;
        address creator;
        uint256 creationElectorateSize;
        uint256 treasuryBalanceSnapshot;
        uint256 executedAt;
        bytes32 callId;
    }

    struct ProposalCreationCache {
        address creator;
        uint256 memberCount;
        uint256 treasuryBalance;
        uint256 startTime;
        uint256 endTime;
        bytes32 organizationNameHash;
        bytes32 workerGroupOrCampaignHash;
        bytes32 verificationURIHash;
        bytes32 contentHash;
    }

    /*//////////////////////////////////////////////////////////////
                                 STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice Final LaborCoin V4 address, discovered from Registration V6.1.
    address public immutable LABR;

    /// @notice Final LaborVote V9.1 address.
    address public immutable LABRV;

    /// @notice Final Registration V6.1 address.
    address public immutable registration;

    /// @notice Exact immutable structured-proposal text and URI policy.
    address public immutable proposalTextPolicy;

    bytes32 public immutable expectedLABRRuntimeCodeHash;
    bytes32 public immutable expectedLABRVRuntimeCodeHash;
    bytes32 public immutable expectedRegistrationRuntimeCodeHash;
    bytes32 public immutable expectedProposalTextPolicyRuntimeCodeHash;

    uint256 public proposalCount;

    mapping(uint256 proposalId => Proposal proposal)
        private _proposals;

    mapping(uint256 proposalId => mapping(address voter => bool voted))
        public hasVoted;

    /// @notice Most recently created proposal for each member.
    mapping(address creator => uint256 proposalId)
        public latestProposalByCreator;

    /*//////////////////////////////////////////////////////////////
                                  ERRORS
    //////////////////////////////////////////////////////////////*/

    error ZeroAddress();
    error ZeroCodeHash();
    error WrongChain(uint256 actualChainId);
    error AddressHasNoCode(address account);
    error InvalidRuntimeCodeHash(
        address account,
        bytes32 actual,
        bytes32 expected
    );

    error InvalidDAOExecutePermissionId(bytes32 actual);
    error MissingDAOExecutePermission();
    error DAOExecutionFailure(uint256 failureMap);
    error InvalidDAOExecutionResults(uint256 length);

    error InvalidLABRVRegistration(address actual);
    error InvalidLABRVMinterState();
    error InvalidLABRVOwner(address actual);
    error InvalidLABRVMembershipUnit(uint256 actual);
    error InvalidLABRVCompatibility(bytes32 actual);
    error InvalidLABRVLABRCodeHash(bytes32 actual);
    error InvalidLABRVRegistrationCodeHash(bytes32 actual);

    error InvalidRegistrationLABR(address actual);
    error InvalidRegistrationLABRV(address actual);
    error InvalidRegistrationState();
    error InvalidRegistrationMembershipUnit(uint256 actual);
    error InvalidRegistrationCompatibility(bytes32 actual);
    error InvalidRegistrationLABRCodeHash(bytes32 actual);
    error InvalidRegistrationLABRVCodeHash(bytes32 actual);
    error InvalidRegistrationCommittedCodeHash(bytes32 actual);

    error InvalidLABRRuntimeCodeHash(
        bytes32 actual,
        bytes32 expected
    );
    error InvalidLABRLaunchState();
    error InvalidLABRTreasury(address actual);
    error InvalidMembershipSupply(uint256 actual, uint256 expected);

    error InvalidTextPolicyCompatibility(bytes32 actual);
    error InvalidTextPolicyLexicon(bytes32 actual);
    error InvalidTextPolicyOrganizationNameLimit(uint256 actual);
    error InvalidTextPolicyWorkerGroupLimit(uint256 actual);
    error InvalidTextPolicyVerificationURILimit(uint256 actual);

    error GovernanceNotReady();
    error GovernanceNotActivated(uint256 members, uint256 minimum);
    error OnlyDirectWallet(address account, address transactionOrigin);
    error NotRegisteredMember(address account);
    error InvalidMembershipBalance(address account, uint256 balance);
    error InvalidMemberRecord(address account);
    error InvalidHistoricalElectorate(
        uint256 historicalCount,
        uint256 totalMembers
    );

    error ProposalDoesNotExist(uint256 proposalId);
    error ActiveProposalExists(address creator, uint256 proposalId);
    error InvalidRecipient(address recipient);
    error RecipientHasNoCode(address recipient);
    error InvalidAmount();
    error PurposeRequired();
    error ContactMethodRequired();
    error DistributionPlanRequired();
    error EmptyTreasury();
    error TransferExceedsLimit(uint256 amount, uint256 maximum);

    error VotingNotActive(uint256 proposalId);
    error AlreadyVoted(uint256 proposalId, address voter);
    error VotingStillActive(uint256 proposalId, uint256 endTime);
    error ProposalDefeated(uint256 proposalId);
    error ProposalAlreadyExecuted(uint256 proposalId);
    error ExecutionWindowExpired(uint256 proposalId, uint256 deadline);
    error InsufficientTreasuryBalance(uint256 balance, uint256 amount);

    error DirectPOLDepositRejected();

    /*//////////////////////////////////////////////////////////////
                                  EVENTS
    //////////////////////////////////////////////////////////////*/

    event ProposalCreated(
        uint256 indexed proposalId,
        address indexed creator,
        address indexed recipient,
        uint256 amount,
        uint256 creationElectorateSize,
        uint256 treasuryBalanceSnapshot,
        uint256 startTime,
        uint256 endTime,
        bytes32 callId,
        bytes32 proposalType,
        bytes32 proposalSchemaId,
        bytes32 contentHash
    );

    event VoteCast(
        uint256 indexed proposalId,
        address indexed voter,
        bool support,
        uint256 yesVotes,
        uint256 noVotes
    );

    event ProposalExecuted(
        uint256 indexed proposalId,
        address indexed executor,
        address indexed recipient,
        uint256 amount,
        bytes32 callId,
        uint256 treasuryBalanceBefore,
        uint256 treasuryBalanceAfter,
        bytes32 executionResultHash
    );

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(
        address labrv_,
        address registration_,
        address proposalTextPolicy_,
        bytes32 expectedLABRVRuntimeCodeHash_,
        bytes32 expectedRegistrationRuntimeCodeHash_,
        bytes32 expectedProposalTextPolicyRuntimeCodeHash_
    ) {
        if (block.chainid != POLYGON_MAINNET_CHAIN_ID) {
            revert WrongChain(block.chainid);
        }
        if (
            labrv_ == address(0)
                || registration_ == address(0)
                || proposalTextPolicy_ == address(0)
        ) {
            revert ZeroAddress();
        }
        if (
            expectedLABRVRuntimeCodeHash_ == bytes32(0)
                || expectedRegistrationRuntimeCodeHash_ == bytes32(0)
                || expectedProposalTextPolicyRuntimeCodeHash_ == bytes32(0)
        ) {
            revert ZeroCodeHash();
        }
        if (DAO.code.length == 0) {
            revert AddressHasNoCode(DAO);
        }
        if (labrv_.code.length == 0) {
            revert AddressHasNoCode(labrv_);
        }
        if (registration_.code.length == 0) {
            revert AddressHasNoCode(registration_);
        }
        if (proposalTextPolicy_.code.length == 0) {
            revert AddressHasNoCode(proposalTextPolicy_);
        }

        bytes32 actualLABRVCodeHash = labrv_.codehash;
        if (actualLABRVCodeHash != expectedLABRVRuntimeCodeHash_) {
            revert InvalidRuntimeCodeHash(
                labrv_,
                actualLABRVCodeHash,
                expectedLABRVRuntimeCodeHash_
            );
        }

        bytes32 actualRegistrationCodeHash = registration_.codehash;
        if (
            actualRegistrationCodeHash
                != expectedRegistrationRuntimeCodeHash_
        ) {
            revert InvalidRuntimeCodeHash(
                registration_,
                actualRegistrationCodeHash,
                expectedRegistrationRuntimeCodeHash_
            );
        }

        bytes32 actualTextPolicyCodeHash =
            proposalTextPolicy_.codehash;
        if (
            actualTextPolicyCodeHash
                != expectedProposalTextPolicyRuntimeCodeHash_
        ) {
            revert InvalidRuntimeCodeHash(
                proposalTextPolicy_,
                actualTextPolicyCodeHash,
                expectedProposalTextPolicyRuntimeCodeHash_
            );
        }

        _validateTextPolicy(proposalTextPolicy_);

        bytes32 daoPermissionId =
            IAragonDAOForGovernance(DAO).EXECUTE_PERMISSION_ID();
        if (daoPermissionId != EXECUTE_PERMISSION_ID) {
            revert InvalidDAOExecutePermissionId(daoPermissionId);
        }

        _validateMembershipContracts(
            labrv_,
            registration_,
            expectedLABRVRuntimeCodeHash_,
            expectedRegistrationRuntimeCodeHash_
        );

        ILaborCoinRegistrationV6_1ForGovernance registry =
            ILaborCoinRegistrationV6_1ForGovernance(registration_);

        address labr_ = registry.LABR();
        bytes32 expectedLABRCodeHash =
            ILaborVoteV9_1ForGovernance(labrv_)
                .expectedLABRRuntimeCodeHash();
        _validateLABR(
            labr_,
            expectedLABRCodeHash
        );

        LABR = labr_;
        LABRV = labrv_;
        registration = registration_;
        proposalTextPolicy = proposalTextPolicy_;
        expectedLABRRuntimeCodeHash =
            expectedLABRCodeHash;
        expectedLABRVRuntimeCodeHash =
            expectedLABRVRuntimeCodeHash_;
        expectedRegistrationRuntimeCodeHash =
            expectedRegistrationRuntimeCodeHash_;
        expectedProposalTextPolicyRuntimeCodeHash =
            expectedProposalTextPolicyRuntimeCodeHash_;

        _assertMembershipSupply();
    }

    function _validateTextPolicy(
        address proposalTextPolicy_
    ) private pure {
        ILaborCoinProposalTextPolicyV1ForGovernance policy =
            ILaborCoinProposalTextPolicyV1ForGovernance(
                proposalTextPolicy_
            );

        bytes32 compatibility = policy.COMPATIBILITY_ID();
        if (compatibility != TEXT_POLICY_COMPATIBILITY_ID) {
            revert InvalidTextPolicyCompatibility(
                compatibility
            );
        }

        bytes32 lexicon = policy.LEXICON_COMMITMENT();
        if (lexicon != TEXT_POLICY_LEXICON_COMMITMENT) {
            revert InvalidTextPolicyLexicon(lexicon);
        }

        uint256 organizationNameLimit =
            policy.MAX_ORGANIZATION_NAME_BYTES();
        if (
            organizationNameLimit
                != MAX_ORGANIZATION_NAME_BYTES
        ) {
            revert InvalidTextPolicyOrganizationNameLimit(
                organizationNameLimit
            );
        }

        uint256 workerGroupLimit =
            policy.MAX_WORKER_GROUP_OR_CAMPAIGN_BYTES();
        if (
            workerGroupLimit
                != MAX_WORKER_GROUP_OR_CAMPAIGN_BYTES
        ) {
            revert InvalidTextPolicyWorkerGroupLimit(
                workerGroupLimit
            );
        }

        uint256 verificationURILimit =
            policy.MAX_VERIFICATION_URI_BYTES();
        if (
            verificationURILimit
                != MAX_VERIFICATION_URI_BYTES
        ) {
            revert InvalidTextPolicyVerificationURILimit(
                verificationURILimit
            );
        }
    }

    function _validateMembershipContracts(
        address labrv_,
        address registration_,
        bytes32 expectedLABRVCodeHash,
        bytes32 expectedRegistrationCodeHash
    ) private view {
        _validateMembershipToken(
            labrv_,
            registration_,
            expectedRegistrationCodeHash
        );
        _validateRegistrationContract(
            registration_,
            labrv_,
            expectedLABRVCodeHash,
            expectedRegistrationCodeHash
        );
        _validateMembershipLABRBinding(
            labrv_,
            registration_
        );
    }

    function _validateMembershipToken(
        address labrv_,
        address registration_,
        bytes32 expectedRegistrationCodeHash
    ) private view {
        ILaborVoteV9_1ForGovernance membershipToken =
            ILaborVoteV9_1ForGovernance(labrv_);

        {
            address reportedRegistration =
                membershipToken.registration();
            if (reportedRegistration != registration_) {
                revert InvalidLABRVRegistration(
                    reportedRegistration
                );
            }
        }

        if (!membershipToken.minterFinalized()) {
            revert InvalidLABRVMinterState();
        }

        {
            address voteOwner = membershipToken.owner();
            if (voteOwner != address(0)) {
                revert InvalidLABRVOwner(voteOwner);
            }
        }

        {
            uint256 voteUnit =
                membershipToken.MEMBERSHIP_UNIT();
            if (voteUnit != MEMBERSHIP_UNIT) {
                revert InvalidLABRVMembershipUnit(voteUnit);
            }
        }

        {
            bytes32 voteCompatibility =
                membershipToken.REGISTRATION_COMPATIBILITY_ID();
            if (
                voteCompatibility
                    != MEMBERSHIP_COMPATIBILITY_ID
            ) {
                revert InvalidLABRVCompatibility(
                    voteCompatibility
                );
            }
        }

        {
            bytes32 voteRegistrationCodeHash =
                membershipToken
                    .expectedRegistrationRuntimeCodeHash();
            if (
                voteRegistrationCodeHash
                    != expectedRegistrationCodeHash
            ) {
                revert InvalidLABRVRegistrationCodeHash(
                    voteRegistrationCodeHash
                );
            }
        }
    }

    function _validateRegistrationContract(
        address registration_,
        address labrv_,
        bytes32 expectedLABRVCodeHash,
        bytes32 expectedRegistrationCodeHash
    ) private view {
        ILaborCoinRegistrationV6_1ForGovernance registry =
            ILaborCoinRegistrationV6_1ForGovernance(
                registration_
            );

        {
            address reportedLABRV = registry.LABRV();
            if (reportedLABRV != labrv_) {
                revert InvalidRegistrationLABRV(
                    reportedLABRV
                );
            }
        }

        if (!registry.registrationReady()) {
            revert InvalidRegistrationState();
        }

        {
            uint256 registryMembers =
                registry.totalMembers();
            uint256 historicalMembers =
                registry.totalMembersBefore(
                    type(uint256).max
                );
            if (historicalMembers != registryMembers) {
                revert InvalidHistoricalElectorate(
                    historicalMembers,
                    registryMembers
                );
            }
        }

        {
            uint256 registryUnit =
                registry.MEMBERSHIP_UNIT();
            if (registryUnit != MEMBERSHIP_UNIT) {
                revert InvalidRegistrationMembershipUnit(
                    registryUnit
                );
            }
        }

        {
            bytes32 registryCompatibility =
                registry.COMPATIBILITY_ID();
            if (
                registryCompatibility
                    != MEMBERSHIP_COMPATIBILITY_ID
            ) {
                revert InvalidRegistrationCompatibility(
                    registryCompatibility
                );
            }
        }

        {
            bytes32 registryLABRVCodeHash =
                registry.expectedLABRVRuntimeCodeHash();
            if (
                registryLABRVCodeHash
                    != expectedLABRVCodeHash
            ) {
                revert InvalidRegistrationLABRVCodeHash(
                    registryLABRVCodeHash
                );
            }
        }

        {
            bytes32 registryCommittedCodeHash =
                registry
                    .expectedRegistrationRuntimeCodeHash();
            if (
                registryCommittedCodeHash
                    != expectedRegistrationCodeHash
            ) {
                revert InvalidRegistrationCommittedCodeHash(
                    registryCommittedCodeHash
                );
            }
        }
    }

    function _validateMembershipLABRBinding(
        address labrv_,
        address registration_
    ) private view {
        ILaborVoteV9_1ForGovernance membershipToken =
            ILaborVoteV9_1ForGovernance(labrv_);
        ILaborCoinRegistrationV6_1ForGovernance registry =
            ILaborCoinRegistrationV6_1ForGovernance(
                registration_
            );

        {
            address voteLABR = membershipToken.LABR();
            address registryLABR = registry.LABR();
            if (voteLABR != registryLABR) {
                revert InvalidRegistrationLABR(
                    registryLABR
                );
            }
        }

        {
            bytes32 voteLABRCodeHash =
                membershipToken.expectedLABRRuntimeCodeHash();
            bytes32 registryLABRCodeHash =
                registry.expectedLABRRuntimeCodeHash();
            if (
                voteLABRCodeHash
                    != registryLABRCodeHash
            ) {
                revert InvalidRegistrationLABRCodeHash(
                    registryLABRCodeHash
                );
            }
        }
    }

    function _validateLABR(
        address labr_,
        bytes32 expectedCodeHash
    ) private view {
        if (labr_ == address(0)) revert ZeroAddress();
        if (labr_.code.length == 0) {
            revert AddressHasNoCode(labr_);
        }

        bytes32 actualCodeHash = labr_.codehash;
        if (actualCodeHash != expectedCodeHash) {
            revert InvalidLABRRuntimeCodeHash(
                actualCodeHash,
                expectedCodeHash
            );
        }

        ILaborCoinV4ForGovernance token =
            ILaborCoinV4ForGovernance(labr_);

        address exchange = token.officialExchange();
        if (
            !token.launchFinalized()
                || token.owner() != address(0)
                || exchange == address(0)
                || exchange.code.length == 0
        ) {
            revert InvalidLABRLaunchState();
        }

        address reportedTreasury = token.daoTreasury();
        if (reportedTreasury != DAO) {
            revert InvalidLABRTreasury(reportedTreasury);
        }
    }

    /*//////////////////////////////////////////////////////////////
                           PROPOSAL CREATION
    //////////////////////////////////////////////////////////////*/

    function createProposal(
        ProposalInput calldata input
    ) external returns (uint256 proposalId) {
        _requireGovernanceReady();

        ProposalCreationCache memory cache =
            _prepareProposalCreation(input);

        proposalId = _storeProposal(input, cache);

        _emitProposalCreated(proposalId);
    }

    function _prepareProposalCreation(
        ProposalInput calldata input
    )
        private
        view
        returns (ProposalCreationCache memory cache)
    {
        cache.creator = msg.sender;
        _requireDirectMember(cache.creator);

        cache.memberCount =
            ILaborCoinRegistrationV6_1ForGovernance(registration)
                .totalMembers();
        if (cache.memberCount < MINIMUM_REGISTERED_USERS) {
            revert GovernanceNotActivated(
                cache.memberCount,
                MINIMUM_REGISTERED_USERS
            );
        }

        uint256 previousProposal =
            latestProposalByCreator[cache.creator];
        if (
            previousProposal != 0
                && block.timestamp
                    < _proposals[previousProposal].endTime
        ) {
            revert ActiveProposalExists(
                cache.creator,
                previousProposal
            );
        }

        ILaborCoinProposalTextPolicyV1ForGovernance policy =
            ILaborCoinProposalTextPolicyV1ForGovernance(
                proposalTextPolicy
            );

        cache.organizationNameHash =
            policy.validateOrganizationName(
                input.organizationName
            );
        cache.workerGroupOrCampaignHash =
            policy.validateWorkerGroupOrCampaign(
                input.workerGroupOrCampaign
            );
        cache.verificationURIHash =
            policy.validateVerificationURI(
                input.verificationURI
            );

        if (input.purpose == Purpose.Unset) {
            revert PurposeRequired();
        }
        if (input.contactMethod == ContactMethod.Unset) {
            revert ContactMethodRequired();
        }
        if (
            input.distributionPlan
                == DistributionPlan.Unset
        ) {
            revert DistributionPlanRequired();
        }

        _validateRecipient(input.recipient);
        if (input.amount == 0) revert InvalidAmount();

        cache.treasuryBalance = DAO.balance;
        if (cache.treasuryBalance == 0) {
            revert EmptyTreasury();
        }

        uint256 maximumAmount =
            (cache.treasuryBalance * MAX_TRANSFER_BPS)
                / BPS_DENOMINATOR;
        if (input.amount > maximumAmount) {
            revert TransferExceedsLimit(
                input.amount,
                maximumAmount
            );
        }

        _assertMembershipSupply();

        cache.contentHash = _proposalContentHash(
            input,
            cache.organizationNameHash,
            cache.workerGroupOrCampaignHash,
            cache.verificationURIHash
        );

        cache.startTime = block.timestamp;
        cache.endTime =
            cache.startTime + PROPOSAL_DURATION;
    }

    function _proposalContentHash(
        ProposalInput calldata input,
        bytes32 organizationNameHash,
        bytes32 workerGroupOrCampaignHash,
        bytes32 verificationURIHash
    ) private pure returns (bytes32) {
        return keccak256(
            abi.encode(
                PROPOSAL_SCHEMA_ID,
                organizationNameHash,
                input.recipient,
                workerGroupOrCampaignHash,
                input.amount,
                input.purpose,
                verificationURIHash,
                input.contactMethod,
                input.distributionPlan
            )
        );
    }

    function _storeProposal(
        ProposalInput calldata input,
        ProposalCreationCache memory cache
    ) private returns (uint256 proposalId) {
        proposalId = proposalCount + 1;
        proposalCount = proposalId;

        bytes32 callId = _proposalCallId(
            proposalId,
            input.recipient,
            input.amount,
            cache.contentHash
        );

        Proposal storage proposal = _proposals[proposalId];
        proposal.organizationName = input.organizationName;
        proposal.workerGroupOrCampaign =
            input.workerGroupOrCampaign;
        proposal.verificationURI = input.verificationURI;
        proposal.contentHash = cache.contentHash;
        proposal.recipient = input.recipient;
        proposal.amount = input.amount;
        proposal.purpose = input.purpose;
        proposal.contactMethod = input.contactMethod;
        proposal.distributionPlan = input.distributionPlan;
        proposal.startTime = cache.startTime;
        proposal.endTime = cache.endTime;
        proposal.creator = cache.creator;
        proposal.creationElectorateSize = cache.memberCount;
        proposal.treasuryBalanceSnapshot =
            cache.treasuryBalance;
        proposal.callId = callId;

        latestProposalByCreator[cache.creator] = proposalId;
    }

    function _emitProposalCreated(
        uint256 proposalId
    ) private {
        Proposal storage proposal = _proposals[proposalId];

        emit ProposalCreated(
            proposalId,
            proposal.creator,
            proposal.recipient,
            proposal.amount,
            proposal.creationElectorateSize,
            proposal.treasuryBalanceSnapshot,
            proposal.startTime,
            proposal.endTime,
            proposal.callId,
            PROPOSAL_TYPE,
            PROPOSAL_SCHEMA_ID,
            proposal.contentHash
        );
    }

    /*//////////////////////////////////////////////////////////////
                                  VOTING
    //////////////////////////////////////////////////////////////*/

    function vote(
        uint256 proposalId,
        bool support
    ) external {
        _requireGovernanceReady();

        Proposal storage proposal =
            _requireProposal(proposalId);

        if (block.timestamp >= proposal.endTime) {
            revert VotingNotActive(proposalId);
        }

        address voter = msg.sender;
        _requireDirectMember(voter);

        // A member registered while voting is active necessarily has a
        // registration timestamp strictly before the proposal deadline.
        // The explicit check keeps the deadline rule visible and rejects an
        // inconsistent Registration implementation.
        uint256 registeredAt =
            ILaborCoinRegistrationV6_1ForGovernance(registration)
                .registrationTimestamp(voter);
        if (registeredAt == 0 || registeredAt >= proposal.endTime) {
            revert InvalidMemberRecord(voter);
        }

        if (hasVoted[proposalId][voter]) {
            revert AlreadyVoted(proposalId, voter);
        }

        hasVoted[proposalId][voter] = true;

        if (support) {
            proposal.yesVotes += 1;
        } else {
            proposal.noVotes += 1;
        }

        emit VoteCast(
            proposalId,
            voter,
            support,
            proposal.yesVotes,
            proposal.noVotes
        );
    }

    /*//////////////////////////////////////////////////////////////
                                 EXECUTION
    //////////////////////////////////////////////////////////////*/

    function executeProposal(
        uint256 proposalId
    ) external nonReentrant {
        Proposal storage proposal =
            _requireProposal(proposalId);

        if (proposal.executed) {
            revert ProposalAlreadyExecuted(proposalId);
        }
        if (block.timestamp < proposal.endTime) {
            revert VotingStillActive(
                proposalId,
                proposal.endTime
            );
        }
        if (!proposalPassed(proposalId)) {
            revert ProposalDefeated(proposalId);
        }

        uint256 executionDeadline =
            proposal.endTime + EXECUTION_WINDOW;
        if (block.timestamp > executionDeadline) {
            revert ExecutionWindowExpired(
                proposalId,
                executionDeadline
            );
        }

        uint256 treasuryBalanceBefore = DAO.balance;
        if (treasuryBalanceBefore < proposal.amount) {
            revert InsufficientTreasuryBalance(
                treasuryBalanceBefore,
                proposal.amount
            );
        }

        uint256 currentMaximum =
            (treasuryBalanceBefore * MAX_TRANSFER_BPS)
                / BPS_DENOMINATOR;
        if (proposal.amount > currentMaximum) {
            revert TransferExceedsLimit(
                proposal.amount,
                currentMaximum
            );
        }

        IAragonDAOForGovernance.Action[] memory actions =
            new IAragonDAOForGovernance.Action[](1);

        actions[0] = IAragonDAOForGovernance.Action({
            to: proposal.recipient,
            value: proposal.amount,
            data: bytes("")
        });

        bytes memory executeCalldata = abi.encodeCall(
            IAragonDAOForGovernance.execute,
            (proposal.callId, actions, 0)
        );

        bool permitted =
            IAragonDAOForGovernance(DAO).hasPermission(
                DAO,
                address(this),
                EXECUTE_PERMISSION_ID,
                executeCalldata
            );
        if (!permitted) {
            revert MissingDAOExecutePermission();
        }

        proposal.executed = true;
        proposal.executedAt = block.timestamp;

        (
            bytes[] memory results,
            uint256 failureMap
        ) = IAragonDAOForGovernance(DAO).execute(
            proposal.callId,
            actions,
            0
        );

        if (failureMap != 0) {
            revert DAOExecutionFailure(failureMap);
        }
        if (results.length != 1) {
            revert InvalidDAOExecutionResults(
                results.length
            );
        }

        uint256 treasuryBalanceAfter = DAO.balance;

        emit ProposalExecuted(
            proposalId,
            msg.sender,
            proposal.recipient,
            proposal.amount,
            proposal.callId,
            treasuryBalanceBefore,
            treasuryBalanceAfter,
            keccak256(results[0])
        );
    }

    /*//////////////////////////////////////////////////////////////
                             PROPOSAL RESULTS
    //////////////////////////////////////////////////////////////*/

    function proposalPassed(
        uint256 proposalId
    ) public view returns (bool) {
        Proposal storage proposal = _proposals[proposalId];
        if (proposal.startTime == 0) return false;

        uint256 totalVotes =
            proposal.yesVotes + proposal.noVotes;
        if (totalVotes == 0) return false;

        uint256 participationRequired =
            _ceilDiv(
                _electorateSize(proposal)
                    * MINIMUM_PARTICIPATION_BPS,
                BPS_DENOMINATOR
            );
        if (totalVotes < participationRequired) {
            return false;
        }

        uint256 yesRequired =
            _ceilDiv(
                totalVotes * APPROVAL_BPS,
                BPS_DENOMINATOR
            );

        return proposal.yesVotes >= yesRequired;
    }

    function requiredParticipationVotes(
        uint256 proposalId
    ) external view returns (uint256) {
        Proposal storage proposal =
            _requireProposal(proposalId);

        return _ceilDiv(
            _electorateSize(proposal)
                * MINIMUM_PARTICIPATION_BPS,
            BPS_DENOMINATOR
        );
    }

    /// @notice Returns the current electorate while voting is active and the
    /// permanently fixed final electorate once the voting deadline is reached.
    function electorateSize(
        uint256 proposalId
    ) public view returns (uint256) {
        Proposal storage proposal =
            _requireProposal(proposalId);
        return _electorateSize(proposal);
    }

    /// @notice Returns the final electorate after voting closes.
    function finalElectorateSize(
        uint256 proposalId
    ) external view returns (uint256) {
        Proposal storage proposal =
            _requireProposal(proposalId);
        if (block.timestamp < proposal.endTime) {
            revert VotingStillActive(
                proposalId,
                proposal.endTime
            );
        }
        return
            ILaborCoinRegistrationV6_1ForGovernance(registration)
                .totalMembersBefore(proposal.endTime);
    }

    function requiredYesVotes(
        uint256 proposalId
    ) external view returns (uint256) {
        Proposal storage proposal =
            _requireProposal(proposalId);

        uint256 totalVotes =
            proposal.yesVotes + proposal.noVotes;
        if (totalVotes == 0) return 0;

        return _ceilDiv(
            totalVotes * APPROVAL_BPS,
            BPS_DENOMINATOR
        );
    }

    function proposalState(
        uint256 proposalId
    ) public view returns (ProposalState) {
        Proposal storage proposal = _proposals[proposalId];

        if (proposal.startTime == 0) {
            return ProposalState.Nonexistent;
        }
        if (proposal.executed) {
            return ProposalState.Executed;
        }
        if (block.timestamp < proposal.endTime) {
            return ProposalState.Active;
        }
        if (!proposalPassed(proposalId)) {
            return ProposalState.Defeated;
        }
        if (
            block.timestamp
                > proposal.endTime + EXECUTION_WINDOW
        ) {
            return ProposalState.Expired;
        }

        return ProposalState.Succeeded;
    }

    /*//////////////////////////////////////////////////////////////
                                  VIEWS
    //////////////////////////////////////////////////////////////*/

    function governanceReady() public view returns (bool) {
        if (
            LABR == address(0)
                || LABRV == address(0)
                || registration == address(0)
                || proposalTextPolicy == address(0)
                || LABR.codehash
                    != expectedLABRRuntimeCodeHash
                || LABRV.codehash
                    != expectedLABRVRuntimeCodeHash
                || registration.codehash
                    != expectedRegistrationRuntimeCodeHash
                || proposalTextPolicy.codehash
                    != expectedProposalTextPolicyRuntimeCodeHash
        ) {
            return false;
        }

        ILaborVoteV9_1ForGovernance voteToken =
            ILaborVoteV9_1ForGovernance(LABRV);
        ILaborCoinRegistrationV6_1ForGovernance registry =
            ILaborCoinRegistrationV6_1ForGovernance(registration);

        try voteToken.minterFinalized() returns (bool finalized) {
            if (!finalized) return false;
        } catch {
            return false;
        }

        try voteToken.owner() returns (address voteOwner) {
            if (voteOwner != address(0)) return false;
        } catch {
            return false;
        }

        try voteToken.registration() returns (address registryAddress) {
            if (registryAddress != registration) return false;
        } catch {
            return false;
        }

        try registry.registrationReady() returns (bool ready) {
            if (!ready) return false;
        } catch {
            return false;
        }

        try registry.LABRV() returns (address voteAddress) {
            if (voteAddress != LABRV) return false;
        } catch {
            return false;
        }

        ILaborCoinProposalTextPolicyV1ForGovernance policy =
            ILaborCoinProposalTextPolicyV1ForGovernance(
                proposalTextPolicy
            );

        try policy.COMPATIBILITY_ID() returns (
            bytes32 compatibility
        ) {
            if (compatibility != TEXT_POLICY_COMPATIBILITY_ID) {
                return false;
            }
        } catch {
            return false;
        }

        try policy.LEXICON_COMMITMENT() returns (
            bytes32 lexicon
        ) {
            if (lexicon != TEXT_POLICY_LEXICON_COMMITMENT) {
                return false;
            }
        } catch {
            return false;
        }

        try policy.MAX_ORGANIZATION_NAME_BYTES() returns (
            uint256 organizationNameLimit
        ) {
            if (
                organizationNameLimit
                    != MAX_ORGANIZATION_NAME_BYTES
            ) {
                return false;
            }
        } catch {
            return false;
        }

        try policy.MAX_WORKER_GROUP_OR_CAMPAIGN_BYTES() returns (
            uint256 workerGroupLimit
        ) {
            if (
                workerGroupLimit
                    != MAX_WORKER_GROUP_OR_CAMPAIGN_BYTES
            ) {
                return false;
            }
        } catch {
            return false;
        }

        try policy.MAX_VERIFICATION_URI_BYTES() returns (
            uint256 verificationURILimit
        ) {
            if (
                verificationURILimit
                    != MAX_VERIFICATION_URI_BYTES
            ) {
                return false;
            }
        } catch {
            return false;
        }

        ILaborCoinV4ForGovernance token =
            ILaborCoinV4ForGovernance(LABR);

        try token.launchFinalized() returns (bool finalized) {
            if (!finalized) return false;
        } catch {
            return false;
        }

        try token.owner() returns (address tokenOwner) {
            if (tokenOwner != address(0)) return false;
        } catch {
            return false;
        }

        try token.daoTreasury() returns (address treasury) {
            if (treasury != DAO) return false;
        } catch {
            return false;
        }

        uint256 members;
        uint256 supply;

        try registry.totalMembers() returns (uint256 count) {
            members = count;
        } catch {
            return false;
        }

        try registry.totalMembersBefore(type(uint256).max) returns (
            uint256 historicalCount
        ) {
            if (historicalCount != members) return false;
        } catch {
            return false;
        }

        try voteToken.totalSupply() returns (uint256 totalSupply_) {
            supply = totalSupply_;
        } catch {
            return false;
        }

        if (supply != members * MEMBERSHIP_UNIT) {
            return false;
        }

        try IAragonDAOForGovernance(DAO).hasPermission(
            DAO,
            address(this),
            EXECUTE_PERMISSION_ID,
            bytes("")
        ) returns (bool permitted) {
            return permitted;
        } catch {
            return false;
        }
    }

    function executionAllowed() public view returns (bool) {
        if (!governanceReady()) return false;

        return
            ILaborCoinRegistrationV6_1ForGovernance(registration)
                .totalMembers()
                >= MINIMUM_REGISTERED_USERS;
    }

    function maxProposalAmount()
        external
        view
        returns (uint256)
    {
        return
            (DAO.balance * MAX_TRANSFER_BPS)
                / BPS_DENOMINATOR;
    }

    function executionWindow()
        external
        pure
        returns (uint256)
    {
        return EXECUTION_WINDOW;
    }

    function eligibleToVote(
        uint256 proposalId,
        address account
    ) external view returns (bool) {
        Proposal storage proposal = _proposals[proposalId];
        if (
            proposal.startTime == 0
                || block.timestamp >= proposal.endTime
                || hasVoted[proposalId][account]
                || account.code.length != 0
        ) {
            return false;
        }

        ILaborCoinRegistrationV6_1ForGovernance registry =
            ILaborCoinRegistrationV6_1ForGovernance(registration);

        if (!registry.registered(account)) return false;
        if (
            ILaborVoteV9_1ForGovernance(LABRV)
                .balanceOf(account)
                != MEMBERSHIP_UNIT
        ) {
            return false;
        }

        uint256 number = registry.memberNumber(account);
        uint256 registeredAt =
            registry.registrationTimestamp(account);
        return
            number != 0
                && registeredAt != 0
                && registeredAt < proposal.endTime;
    }

    function isOrganizationNameAllowed(
        string calldata organizationName
    ) external view returns (bool) {
        if (
            proposalTextPolicy.codehash
                != expectedProposalTextPolicyRuntimeCodeHash
        ) {
            return false;
        }

        try
            ILaborCoinProposalTextPolicyV1ForGovernance(
                proposalTextPolicy
            ).isOrganizationNameAllowed(organizationName)
        returns (bool allowed) {
            return allowed;
        } catch {
            return false;
        }
    }

    function isWorkerGroupOrCampaignAllowed(
        string calldata workerGroupOrCampaign
    ) external view returns (bool) {
        if (
            proposalTextPolicy.codehash
                != expectedProposalTextPolicyRuntimeCodeHash
        ) {
            return false;
        }

        try
            ILaborCoinProposalTextPolicyV1ForGovernance(
                proposalTextPolicy
            ).isWorkerGroupOrCampaignAllowed(
                workerGroupOrCampaign
            )
        returns (bool allowed) {
            return allowed;
        } catch {
            return false;
        }
    }

    function isVerificationURIAllowed(
        string calldata verificationURI
    ) external view returns (bool) {
        if (
            proposalTextPolicy.codehash
                != expectedProposalTextPolicyRuntimeCodeHash
        ) {
            return false;
        }

        try
            ILaborCoinProposalTextPolicyV1ForGovernance(
                proposalTextPolicy
            ).isVerificationURIAllowed(verificationURI)
        returns (bool allowed) {
            return allowed;
        } catch {
            return false;
        }
    }

    /// @notice Returns the exact human-authored structured content and its commitment.
    function proposalContent(
        uint256 proposalId
    )
        external
        view
        returns (
            string memory organizationName,
            string memory workerGroupOrCampaign,
            string memory verificationURI,
            bytes32 contentHash
        )
    {
        Proposal storage proposal =
            _requireProposal(proposalId);

        return (
            proposal.organizationName,
            proposal.workerGroupOrCampaign,
            proposal.verificationURI,
            proposal.contentHash
        );
    }

    /// @notice Returns executable transfer terms and fixed proposal categories.
    function proposalTerms(
        uint256 proposalId
    )
        external
        view
        returns (
            address recipient,
            uint256 amount,
            Purpose purpose,
            ContactMethod contactMethod,
            DistributionPlan distributionPlan,
            address creator
        )
    {
        Proposal storage proposal =
            _requireProposal(proposalId);

        return (
            proposal.recipient,
            proposal.amount,
            proposal.purpose,
            proposal.contactMethod,
            proposal.distributionPlan,
            proposal.creator
        );
    }

    /// @notice Returns vote totals, the creation electorate, the current or
    /// final deadline electorate, and the creation-time treasury snapshot.
    function proposalVoteData(
        uint256 proposalId
    )
        external
        view
        returns (
            uint256 yesVotes,
            uint256 noVotes,
            uint256 creationElectorateSize,
            uint256 deadlineElectorateSize,
            uint256 treasuryBalanceSnapshot
        )
    {
        Proposal storage proposal =
            _requireProposal(proposalId);

        return (
            proposal.yesVotes,
            proposal.noVotes,
            proposal.creationElectorateSize,
            _electorateSize(proposal),
            proposal.treasuryBalanceSnapshot
        );
    }

    /// @notice Returns proposal timing and execution state.
    function proposalExecutionData(
        uint256 proposalId
    )
        external
        view
        returns (
            uint256 startTime,
            uint256 endTime,
            bool executed,
            uint256 executedAt,
            bytes32 callId
        )
    {
        Proposal storage proposal =
            _requireProposal(proposalId);

        return (
            proposal.startTime,
            proposal.endTime,
            proposal.executed,
            proposal.executedAt,
            proposal.callId
        );
    }

    function proposalExists(
        uint256 proposalId
    ) external view returns (bool) {
        return _proposals[proposalId].startTime != 0;
    }

    /*//////////////////////////////////////////////////////////////
                           INTERNAL VALIDATION
    //////////////////////////////////////////////////////////////*/

    function _requireGovernanceReady() private view {
        if (!governanceReady()) {
            revert GovernanceNotReady();
        }
    }

    function _electorateSize(
        Proposal storage proposal
    ) private view returns (uint256) {
        ILaborCoinRegistrationV6_1ForGovernance registry =
            ILaborCoinRegistrationV6_1ForGovernance(registration);

        if (block.timestamp < proposal.endTime) {
            return registry.totalMembers();
        }

        return registry.totalMembersBefore(proposal.endTime);
    }

    function _requireDirectMember(
        address account
    ) private view returns (uint256 number) {
        if (
            account != tx.origin
                || account.code.length != 0
        ) {
            revert OnlyDirectWallet(
                account,
                tx.origin
            );
        }

        ILaborCoinRegistrationV6_1ForGovernance registry =
            ILaborCoinRegistrationV6_1ForGovernance(registration);

        if (!registry.registered(account)) {
            revert NotRegisteredMember(account);
        }

        uint256 membershipBalance =
            ILaborVoteV9_1ForGovernance(LABRV)
                .balanceOf(account);
        if (membershipBalance != MEMBERSHIP_UNIT) {
            revert InvalidMembershipBalance(
                account,
                membershipBalance
            );
        }

        number = registry.memberNumber(account);
        uint256 timestamp =
            registry.registrationTimestamp(account);

        if (number == 0 || timestamp == 0) {
            revert InvalidMemberRecord(account);
        }
    }

    function _assertMembershipSupply() private view {
        uint256 members =
            ILaborCoinRegistrationV6_1ForGovernance(registration)
                .totalMembers();
        uint256 expected = members * MEMBERSHIP_UNIT;
        uint256 actual =
            ILaborVoteV9_1ForGovernance(LABRV)
                .totalSupply();

        if (actual != expected) {
            revert InvalidMembershipSupply(
                actual,
                expected
            );
        }
    }

    function _validateRecipient(
        address recipient
    ) private view {
        address exchange =
            ILaborCoinV4ForGovernance(LABR)
                .officialExchange();

        if (
            recipient == address(0)
                || recipient == DAO
                || recipient == address(this)
                || recipient == LABR
                || recipient == LABRV
                || recipient == registration
                || recipient == proposalTextPolicy
                || recipient == exchange
                || recipient == LEGACY_LABR
                || recipient == LEGACY_EXCHANGE_V2
                || recipient == LEGACY_EXCHANGE_V3
                || recipient == LEGACY_EXCHANGE_V4
                || recipient == LEGACY_LABRV_V6
                || recipient == LEGACY_LABRV_V7
                || recipient == LEGACY_REGISTRATION_V4
                || recipient == LEGACY_GOVERNANCE_V12
                || recipient == LEGACY_GOVERNANCE_V13
                || recipient == LEGACY_TREASURY_MODULE_V1
        ) {
            revert InvalidRecipient(recipient);
        }
        if (recipient.code.length == 0) {
            revert RecipientHasNoCode(recipient);
        }
    }

    function _requireProposal(
        uint256 proposalId
    ) private view returns (Proposal storage proposal) {
        proposal = _proposals[proposalId];
        if (proposal.startTime == 0) {
            revert ProposalDoesNotExist(proposalId);
        }
    }

    function _proposalCallId(
        uint256 proposalId,
        address recipient,
        uint256 amount,
        bytes32 contentHash
    ) private view returns (bytes32) {
        return keccak256(
            abi.encode(
                _CALL_ID_PREFIX,
                block.chainid,
                address(this),
                proposalId,
                recipient,
                amount,
                contentHash
            )
        );
    }

    function _ceilDiv(
        uint256 numerator,
        uint256 denominator
    ) private pure returns (uint256) {
        if (numerator == 0) return 0;
        return ((numerator - 1) / denominator) + 1;
    }

    /*//////////////////////////////////////////////////////////////
                              POL REJECTION
    //////////////////////////////////////////////////////////////*/

    receive() external payable {
        revert DirectPOLDepositRejected();
    }

    fallback() external payable {
        revert DirectPOLDepositRejected();
    }
}
