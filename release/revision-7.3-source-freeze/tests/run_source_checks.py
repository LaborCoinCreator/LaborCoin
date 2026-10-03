from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys


ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parents[1]
CONTRACTS = REPO / "contracts"

SOURCE_FREEZE_COMMIT = (
    "f5a1b200a6f703538b88319d5135b20f36dbae1c"
)

FINAL_DAO = "0x928Afe4a4d0978206bD7311548998f0BB1E89230"
LEGACY_DAO = "0x0C2e5679153593b82a84eAB5CA90895BB291Cec4"

COMPONENTS = [
    ("01-policy", "LaborCoinProposalTextPolicyV1"),
    ("02-identity-registry", "LaborCoinIdentityRegistryV1"),
    ("03-exchange", "LaborCoinExchangeV7"),
    ("04-token", "LaborCoinV4"),
    ("05-labrv", "LaborVoteV9"),
    ("06-registration", "LaborCoinRegistrationV6"),
    ("07-governance", "LaborCoinGovernanceV16"),
]

EXPECTED_MARKERS = {
    "LaborCoinIdentityRegistryV1.sol": [
        "MIN_PASSPORT_SCORE = 15_000",
        "verifyParticipant",
        "syncDividendEligibility",
    ],
    "LaborCoinV4.sol": [
        "eligibleDividendHolderCount",
        "magnifiedDividendPerEligibleHolder",
        "MIN_DIVIDEND_BALANCE = 1 ether",
        "claimDividends",
        "LaborCoin V4.1.0",
        FINAL_DAO,
    ],
    "LaborCoinExchangeV7.sol": [
        "_requireVerified(msg.sender)",
        "MAX_EXCHANGE_WALLET = 10_000 ether",
        "MAX_EXCHANGE_TRANSACTION = 5_000 ether",
        "LaborCoin Exchange V7.1.0",
        FINAL_DAO,
    ],
    "LaborVoteV9.sol": [
        "TransfersDisabled",
        "MEMBERSHIP_UNIT = 1 ether",
    ],
    "LaborCoinRegistrationV6.sol": [
        "IdentityVerificationRequired",
        "function register()",
    ],
    "LaborCoinProposalTextPolicyV1.sol": [
        "MAX_ORGANIZATION_NAME_BYTES = 96",
        "MAX_WORKER_GROUP_OR_CAMPAIGN_BYTES = 128",
        "MAX_VERIFICATION_URI_BYTES = 256",
        "LaborCoin Proposal Text Policy V1.1.1",
        "validateOrganizationName",
        "validateWorkerGroupOrCampaign",
        "validateVerificationURI",
    ],
    "LaborCoinGovernanceV16.sol": [
        "MINIMUM_REGISTERED_USERS = 50",
        "APPROVAL_BPS = 6_700",
        "MAX_TRANSFER_BPS = 500",
        "totalMembersBefore(proposal.endTime)",
        "registeredAt < proposal.endTime",
        "LABORCOIN_STRUCTURED_TREASURY_PROPOSAL_SCHEMA_V2_MULTI_ASSET",
        "LaborCoin Structured Treasury Proposal Schema V2",
        "LaborCoin Governance V16.0.0",
        "struct ProposalInput",
        "address asset;",
        "assetBalanceSnapshot",
        "Math.mulDiv",
        "function assetBalance(",
        "function maxProposalAmount(",
        "_ERC20_BALANCE_OF_SELECTOR",
        "_ERC20_TRANSFER_SELECTOR",
        "ERC20TransferReturnedFalse",
        "InvalidERC20TransferReturnData",
        "InvalidERC20TransferReturnValue",
        "ERC20TreasuryBalanceDeltaMismatch",
        "ERC20RecipientBalanceDeltaMismatch",
        "ERC20NativeBalanceChanged",
        "NativeTreasuryBalanceDeltaMismatch",
        "ProtectedProtocolAsset",
        "AssetEqualsRecipient",
        "return abi.decode(data, (uint256));",
        "FINAL_BOOTSTRAP_ADMIN_PLUGIN",
        FINAL_DAO,
    ],
}


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def normalized_bytes(data: bytes) -> bytes:
    return data.replace(b"\r\n", b"\n")


def git_blob(commit: str, relpath: str) -> bytes | None:
    result = subprocess.run(
        ["git", "show", f"{commit}:{relpath}"],
        cwd=REPO,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if result.returncode != 0:
        return None
    return result.stdout


failures = []

manifest_path = ROOT / "SOURCE_MANIFEST.json"
profile_path = ROOT / "COMPILER_PROFILE.json"

if not manifest_path.is_file():
    failures.append("missing SOURCE_MANIFEST.json")
    manifest = {}
else:
    manifest = json.loads(
        manifest_path.read_text(encoding="utf-8")
    )

if not profile_path.is_file():
    failures.append("missing COMPILER_PROFILE.json")
    profile = {}
else:
    profile = json.loads(
        profile_path.read_text(encoding="utf-8")
    )

if manifest.get("status") != "PRECOMPILATION_SOURCE_FREEZE":
    failures.append(
        "SOURCE_MANIFEST status is not PRECOMPILATION_SOURCE_FREEZE"
    )

if manifest.get("revision") != "7.3":
    failures.append(
        "SOURCE_MANIFEST revision is not 7.3"
    )

if manifest.get("source_freeze_commit") != SOURCE_FREEZE_COMMIT:
    failures.append(
        "SOURCE_MANIFEST source_freeze_commit does not match "
        "the authoritative Revision 7.3 source commit"
    )

manifest_files = {
    entry["path"]: entry
    for entry in manifest.get("files", [])
}

actual_release_files = {
    path.relative_to(ROOT).as_posix()
    for path in ROOT.rglob("*")
    if path.is_file()
    and path.name != "SOURCE_MANIFEST.json"
}

manifest_file_set = set(manifest_files)

if manifest_file_set != actual_release_files:
    missing_from_manifest = sorted(
        actual_release_files - manifest_file_set
    )
    missing_from_release = sorted(
        manifest_file_set - actual_release_files
    )

    for rel in missing_from_manifest:
        failures.append(
            f"release file is not listed in manifest: {rel}"
        )

    for rel in missing_from_release:
        failures.append(
            f"manifest lists nonexistent release file: {rel}"
        )

for rel, entry in manifest_files.items():
    path = ROOT / rel

    if not path.is_file():
        failures.append(f"manifest file missing: {rel}")
        continue

    if path.stat().st_size != entry.get("size"):
        failures.append(f"size mismatch: {rel}")

    if sha(path) != entry.get("sha256"):
        failures.append(f"SHA-256 mismatch: {rel}")


expected_active_sources = {
    f"{contract}.sol"
    for _, contract in COMPONENTS
}

actual_active_sources = {
    path.name
    for path in CONTRACTS.glob("*.sol")
}

if actual_active_sources != expected_active_sources:
    for name in sorted(
        expected_active_sources - actual_active_sources
    ):
        failures.append(
            f"missing active source: contracts/{name}"
        )

    for name in sorted(
        actual_active_sources - expected_active_sources
    ):
        failures.append(
            f"unexpected active source: contracts/{name}"
        )


for folder, contract in COMPONENTS:
    release_normal = ROOT / folder / f"{contract}.sol"
    release_remix = ROOT / folder / f"{contract}_Remix.sol"
    active_normal = CONTRACTS / f"{contract}.sol"
    settings = ROOT / folder / "compiler-settings.json"

    required = [
        release_normal,
        release_remix,
        active_normal,
        settings,
    ]

    for path in required:
        if not path.is_file():
            failures.append(
                f"missing required file: "
                f"{path.relative_to(REPO)}"
            )

    if not all(path.is_file() for path in required):
        continue

    if release_normal.read_bytes() != active_normal.read_bytes():
        failures.append(
            f"active/release source mismatch: {contract}.sol"
        )

    frozen_blob = git_blob(
        SOURCE_FREEZE_COMMIT,
        f"contracts/{contract}.sol",
    )

    if frozen_blob is None:
        failures.append(
            f"source-freeze commit is missing "
            f"contracts/{contract}.sol"
        )
    elif normalized_bytes(frozen_blob) != normalized_bytes(
        release_normal.read_bytes()
    ):
        failures.append(
            f"source-freeze commit/release mismatch: "
            f"{contract}.sol"
        )

    normal_text = release_normal.read_text(
        encoding="utf-8"
    )
    remix_text = release_remix.read_text(
        encoding="utf-8"
    )

    normalized_remix = re.sub(
        r"https://raw\.githubusercontent\.com/"
        r"OpenZeppelin/openzeppelin-contracts/"
        r"v5\.6\.1/contracts/",
        "@openzeppelin/contracts/",
        remix_text,
    )

    if normal_text != normalized_remix:
        failures.append(
            f"normal/Remix mismatch: {contract}"
        )

    settings_json = json.loads(
        settings.read_text(encoding="utf-8")
    )

    if settings_json != profile:
        failures.append(
            "compiler settings differ from "
            f"COMPILER_PROFILE.json: {folder}"
        )

    for needle in EXPECTED_MARKERS[f"{contract}.sol"]:
        if needle not in normal_text:
            failures.append(
                f"{contract}.sol: missing {needle}"
            )


labr = (CONTRACTS / "LaborCoinV4.sol").read_text(
    encoding="utf-8"
)

for forbidden in [
    "totalDividendEligibleSupply",
    "magnifiedDividendPerShare * eligibleBalance",
    "balance-weighted dividends",
]:
    if forbidden in labr:
        failures.append(
            "LABR contains forbidden weighted-dividend marker: "
            f"{forbidden}"
        )

if LEGACY_DAO in labr:
    failures.append(
        "LABR still contains the superseded Revision 7.2 DAO"
    )


exchange = (
    CONTRACTS / "LaborCoinExchangeV7.sol"
).read_text(encoding="utf-8")

if exchange.count("_requireVerified(msg.sender);") < 2:
    failures.append(
        "Exchange buy and sell identity gates were not both found"
    )

if LEGACY_DAO in exchange:
    failures.append(
        "Exchange still contains the superseded Revision 7.2 DAO"
    )


governance = (
    CONTRACTS / "LaborCoinGovernanceV16.sol"
).read_text(encoding="utf-8")

if LEGACY_DAO not in governance:
    failures.append(
        "Governance V16 is missing protected legacy DAO address"
    )

proposal_input_match = re.search(
    r"struct\s+ProposalInput\s*\{(.*?)\}",
    governance,
    re.DOTALL,
)

expected_proposal_fields = [
    ("string", "organizationName"),
    ("address", "asset"),
    ("address", "recipient"),
    ("string", "workerGroupOrCampaign"),
    ("uint256", "amount"),
    ("Purpose", "purpose"),
    ("string", "verificationURI"),
    ("ContactMethod", "contactMethod"),
    ("DistributionPlan", "distributionPlan"),
]

if proposal_input_match is None:
    failures.append(
        "Governance V16 ProposalInput struct not found"
    )
else:
    proposal_body = proposal_input_match.group(1)

    actual_fields = re.findall(
        r"\b("
        r"string|address|uint256|Purpose|"
        r"ContactMethod|DistributionPlan"
        r")\s+([A-Za-z_][A-Za-z0-9_]*)\s*;",
        proposal_body,
    )

    if actual_fields != expected_proposal_fields:
        failures.append(
            "Governance V16 ProposalInput does not match "
            "the fixed one-asset/one-recipient schema"
        )

    if re.search(r"\bbytes(?:\d*)?\b", proposal_body):
        failures.append(
            "Governance V16 ProposalInput contains arbitrary bytes data"
        )

    if "Action" in proposal_body:
        failures.append(
            "Governance V16 ProposalInput contains an action field"
        )


protected_names = [
    "FINAL_BOOTSTRAP_ADMIN_PLUGIN",
    "LEGACY_DAO",
    "LEGACY_LABR",
    "LEGACY_EXCHANGE_V2",
    "LEGACY_EXCHANGE_V3",
    "LEGACY_EXCHANGE_V4",
    "LEGACY_LABRV_V6",
    "LEGACY_LABRV_V7",
    "LEGACY_REGISTRATION_V4",
    "LEGACY_GOVERNANCE_V12",
    "LEGACY_GOVERNANCE_V13",
    "LEGACY_TREASURY_MODULE_V1",
    "LEGACY_TREASURY_MODULE_V1_LATER",
    "LEGACY_GOVERNANCE_A",
    "LEGACY_TREASURY_A",
    "LEGACY_GOVERNANCE_B",
    "LEGACY_TREASURY_B",
    "LEGACY_GOVERNANCE_C",
    "LEGACY_TREASURY_C",
    "LEGACY_GOVERNANCE_D",
    "LEGACY_TREASURY_D",
    "LEGACY_ADMIN_PLUGIN",
]

for name in protected_names:
    if f"account == {name}" not in governance:
        failures.append(
            f"Governance V16 protected-address guard missing {name}"
        )

for required_guard in [
    "account == DAO",
    "account == address(this)",
    "account == LABR",
    "account == LABRV",
    "account == registration",
    "account == proposalTextPolicy",
    "account == exchange",
    "account == identity",
]:
    if required_guard not in governance:
        failures.append(
            "Governance V16 protected-address guard missing "
            f"{required_guard}"
        )


if "asset == address(0)" not in governance:
    failures.append(
        "Governance V16 native POL sentinel was not found"
    )

if "asset.staticcall(" not in governance:
    failures.append(
        "Governance V16 ERC-20 balance staticcall was not found"
    )

if "abi.encodeWithSelector(" not in governance:
    failures.append(
        "Governance V16 internally constructed ERC-20 calldata "
        "was not found"
    )

if (
    "new IAragonDAOForGovernance.Action[](1)"
    not in governance
):
    failures.append(
        "Governance V16 does not construct exactly one DAO action"
    )

if "actions[0] = action;" not in governance:
    failures.append(
        "Governance V16 one-action assignment was not found"
    )

if not re.search(
    r"IAragonDAOForGovernance\(DAO\)"
    r"\.execute\(\s*callId,\s*actions,\s*0\s*\)",
    governance,
    re.DOTALL,
):
    failures.append(
        "Governance V16 DAO execute call does not visibly "
        "use allowFailureMap = 0"
    )

if not re.search(
    r"function\s+executeProposal\s*\("
    r"\s*uint256\s+proposalId\s*\)"
    r"\s*external\s+nonReentrant",
    governance,
    re.DOTALL,
):
    failures.append(
        "Governance V16 executeProposal is not nonReentrant"
    )


execute_start = governance.find(
    "function _executeDAOAction("
)
execute_end = governance.find(
    "function _validateERC20TransferResult(",
    execute_start,
)

if execute_start == -1 or execute_end == -1:
    failures.append(
        "Governance V16 DAO execution helper boundaries "
        "could not be located"
    )
else:
    execute_helper = governance[
        execute_start:execute_end
    ]

    executed_pos = execute_helper.find(
        "proposal.executed = true;"
    )
    dao_execute_pos = execute_helper.find(
        "IAragonDAOForGovernance(DAO).execute("
    )

    if executed_pos == -1:
        failures.append(
            "Governance V16 does not mark proposal executed "
            "before external DAO execution"
        )
    elif dao_execute_pos == -1:
        failures.append(
            "Governance V16 DAO execute call not found"
        )
    elif executed_pos > dao_execute_pos:
        failures.append(
            "Governance V16 marks proposal executed only "
            "after external DAO execution"
        )


for forbidden_pattern in [
    r"\bfunction\s+pause\s*\(",
    r"\bfunction\s+unpause\s*\(",
    r"\bfunction\s+upgrade[A-Za-z0-9_]*\s*\(",
    r"\bfunction\s+recover[A-Za-z0-9_]*\s*\(",
    r"\bfunction\s+withdraw[A-Za-z0-9_]*\s*\(",
    r"\.delegatecall\s*\(",
    r"\bselfdestruct\s*\(",
    r"\bcallcode\s*\(",
    r"\.approve\s*\(",
    r"\.transferFrom\s*\(",
]:
    if re.search(forbidden_pattern, governance):
        failures.append(
            "Governance V16 contains forbidden execution/"
            f"administration pattern: {forbidden_pattern}"
        )


if (
    governance.count("_maximumTransferAmount(") < 2
    and governance.count("Math.mulDiv(") < 2
):
    failures.append(
        "Governance V16 per-asset 5% cap does not appear "
        "to be checked at both creation and execution"
    )


for forbidden_path in [
    REPO / "archive",
    REPO / "release" / "superseded-revision-6",
]:
    if forbidden_path.exists():
        failures.append(
            "non-authoritative history remains in public release: "
            f"{forbidden_path.relative_to(REPO)}"
        )


if failures:
    print("REVISION 7.3 SOURCE CHECKS: FAIL")
    for failure in failures:
        print("-", failure)
    sys.exit(1)


print("REVISION 7.3 SOURCE CHECKS: PASS")
print(
    "Checked 7 active sources, the authoritative source-freeze "
    "commit, release copies, Remix copies, compiler profiles, "
    "manifest hashes, Revision 7.3 DAO/version bindings, and "
    "Governance V16 multi-asset safety markers."
)