from pathlib import Path
import unittest
ROOT = Path(__file__).resolve().parents[3]
C = ROOT / "contracts"

class SourceGuards(unittest.TestCase):
    def test_equal_holder_not_balance_weighted(self):
        source = (C / "LaborCoinV4.sol").read_text()
        for marker in [
            "eligibleDividendHolderCount",
            "magnifiedDividendPerEligibleHolder",
            "dividendEligible",
            "claimDividends",
            "MIN_DIVIDEND_BALANCE",
        ]:
            self.assertIn(marker, source)
        for forbidden in [
            "totalDividendEligibleSupply",
            "magnifiedDividendPerShare * eligibleBalance",
        ]:
            self.assertNotIn(forbidden, source)

    def test_identity_gates_all_approved_economic_paths(self):
        token = (C / "LaborCoinV4.sol").read_text()
        exchange = (C / "LaborCoinExchangeV7.sol").read_text()
        self.assertGreaterEqual(exchange.count("_requireVerified(msg.sender);"), 2)
        self.assertIn(
            "if (!_isVerified(msg.sender)) revert IdentityVerificationRequired(msg.sender);",
            token,
        )
        self.assertIn("&& _isVerified(account)", token)


    def test_protocol_only_transfer_policy(self):
        token = (C / "LaborCoinV4.sol").read_text()
        self.assertIn("error PeerTransfersDisabled();", token)
        self.assertIn("if (msg.sender != officialExchange) revert UnauthorizedTransferOperator(msg.sender);", token)
        self.assertIn("if (msg.sender != exchange) revert DirectExchangeTransferForbidden();", token)
        self.assertIn("revert PeerTransfersDisabled();", token)
        self.assertNotIn("_requireStrictWallet", token)

    def test_fixed_rules(self):
        identity = (C / "LaborCoinIdentityRegistryV1.sol").read_text()
        token = (C / "LaborCoinV4.sol").read_text()
        exchange = (C / "LaborCoinExchangeV7.sol").read_text()
        self.assertIn("MIN_PASSPORT_SCORE = 15_000", identity)
        for marker in [
            "MAX_WALLET = 10_000 ether",
            "MAX_TRANSACTION = 5_000 ether",
            "TRADE_COOLDOWN = 12 hours",
        ]:
            self.assertIn(marker, token)
        self.assertIn("MAX_EXCHANGE_WALLET = 10_000 ether", exchange)
        self.assertIn("MAX_EXCHANGE_TRANSACTION = 5_000 ether", exchange)

    def test_deadline_electorate_policy(self):
        registration = (C / "LaborCoinRegistrationV6.sol").read_text()
        governance = (C / "LaborCoinGovernanceV15.sol").read_text()
        for marker in [
            "registrationTimestampByMemberNumber",
            "totalMembersBefore(uint256 timestampExclusive)",
            "registrationTimestampByMemberNumber[mid] < timestampExclusive",
        ]:
            self.assertIn(marker, registration)
        for marker in [
            "registeredAt >= proposal.endTime",
            "totalMembersBefore(proposal.endTime)",
            "creationElectorateSize",
            "finalElectorateSize",
        ]:
            self.assertIn(marker, governance)
        self.assertNotIn("MemberJoinedAfterSnapshot", governance)


    def test_structured_treasury_proposal_policy(self):
        policy = (C / "LaborCoinProposalTextPolicyV1.sol").read_text()
        governance = (C / "LaborCoinGovernanceV15.sol").read_text()
        for marker in [
            "MAX_ORGANIZATION_NAME_BYTES = 96",
            "MAX_WORKER_GROUP_OR_CAMPAIGN_BYTES = 128",
            "MAX_VERIFICATION_URI_BYTES = 256",
            "validateOrganizationName",
            "validateWorkerGroupOrCampaign",
            "validateVerificationURI",
            "TOKEN_HASH_COUNT = 143",
            "PHRASE_HASH_COUNT = 18",
        ]:
            self.assertIn(marker, policy)
        for forbidden in [
            "MAX_DESCRIPTION_BYTES",
            "validateDescription",
            "isDescriptionAllowed",
        ]:
            self.assertNotIn(forbidden, policy)
        for marker in [
            "LABORCOIN_STRUCTURED_TREASURY_PROPOSAL_SCHEMA_V1",
            "struct ProposalInput",
            "enum Purpose",
            "enum ContactMethod",
            "enum DistributionPlan",
            "DemocraticWorkerEnterpriseDevelopment",
            "bytes32 contentHash",
            "RecipientHasNoCode",
            "recipient.code.length == 0",
            "validateOrganizationName",
            "validateWorkerGroupOrCampaign",
            "validateVerificationURI",
        ]:
            self.assertIn(marker, governance)
        for forbidden in [
            "string description",
            "descriptionHash",
            "validateProposalDescription",
        ]:
            self.assertNotIn(forbidden, governance)


    def test_proposal_text_policy_canonical_ipfs_roots(self):
        policy = (C / "LaborCoinProposalTextPolicyV1.sol").read_text()
        for marker in [
            "_CID_V0_LENGTH = 46",
            "_MIN_CANONICAL_CID_V1_LENGTH = 32",
            "_MAX_CID_ROOT_LENGTH = 128",
            "_validCIDv0Root",
            "_validCIDv1Base32Root",
            "_validCIDv1Base36Root",
            "raw[rootStart] == 0x51",
            "raw[rootStart] == 0x62",
            "raw[rootStart] == 0x6b",
        ]:
            self.assertIn(marker, policy)
        self.assertNotIn("first != 0x2f", policy)

    def test_versions(self):
        expected = {
            "LaborCoinIdentityRegistryV1.sol": "V1.0.1",
            "LaborCoinV4.sol": "V4.0.0",
            "LaborCoinExchangeV7.sol": "V7.0.0",
            "LaborVoteV9.sol": "V9.1.1",
            "LaborCoinRegistrationV6.sol": "V6.1.1",
            "LaborCoinProposalTextPolicyV1.sol": "V1.1.1",
            "LaborCoinGovernanceV15.sol": "V15.2.0",
        }
        for filename, version in expected.items():
            self.assertIn(version, (C / filename).read_text())
