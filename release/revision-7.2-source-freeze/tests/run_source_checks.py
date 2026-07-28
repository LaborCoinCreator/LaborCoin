from pathlib import Path
import hashlib
import json
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parents[1]
CONTRACTS = REPO / "contracts"

COMPONENTS = [
    ("01-policy", "LaborCoinProposalTextPolicyV1"),
    ("02-identity-registry", "LaborCoinIdentityRegistryV1"),
    ("03-exchange", "LaborCoinExchangeV7"),
    ("04-token", "LaborCoinV4"),
    ("05-labrv", "LaborVoteV9"),
    ("06-registration", "LaborCoinRegistrationV6"),
    ("07-governance", "LaborCoinGovernanceV15"),
]

EXPECTED_MARKERS = {
    "LaborCoinIdentityRegistryV1.sol": ["MIN_PASSPORT_SCORE = 15_000", "verifyParticipant", "syncDividendEligibility"],
    "LaborCoinV4.sol": ["eligibleDividendHolderCount", "magnifiedDividendPerEligibleHolder", "MIN_DIVIDEND_BALANCE = 1 ether", "claimDividends"],
    "LaborCoinExchangeV7.sol": ["_requireVerified(msg.sender)", "MAX_EXCHANGE_WALLET = 10_000 ether", "MAX_EXCHANGE_TRANSACTION = 5_000 ether"],
    "LaborVoteV9.sol": ["TransfersDisabled", "MEMBERSHIP_UNIT = 1 ether"],
    "LaborCoinRegistrationV6.sol": ["IdentityVerificationRequired", "function register()"],
    "LaborCoinProposalTextPolicyV1.sol": ["MAX_DESCRIPTION_BYTES"],
    "LaborCoinGovernanceV15.sol": ["MINIMUM_REGISTERED_USERS = 50", "APPROVAL_BPS = 6_700", "MAX_TRANSFER_BPS = 500", "totalMembersBefore(proposal.endTime)", "registeredAt < proposal.endTime"],
}


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


failures = []
manifest = json.loads((ROOT / "SOURCE_MANIFEST.json").read_text(encoding="utf-8"))
profile = json.loads((ROOT / "COMPILER_PROFILE.json").read_text(encoding="utf-8"))

if manifest.get("status") != "PRECOMPILATION_SOURCE_FREEZE":
    failures.append("SOURCE_MANIFEST status is not PRECOMPILATION_SOURCE_FREEZE")

manifest_files = {entry["path"]: entry for entry in manifest.get("files", [])}
for rel, entry in manifest_files.items():
    path = ROOT / rel
    if not path.is_file():
        failures.append(f"manifest file missing: {rel}")
        continue
    if path.stat().st_size != entry.get("size"):
        failures.append(f"size mismatch: {rel}")
    if sha(path) != entry.get("sha256"):
        failures.append(f"SHA-256 mismatch: {rel}")

for folder, contract in COMPONENTS:
    release_normal = ROOT / folder / f"{contract}.sol"
    release_remix = ROOT / folder / f"{contract}_Remix.sol"
    active_normal = CONTRACTS / f"{contract}.sol"
    settings = ROOT / folder / "compiler-settings.json"

    for path in [release_normal, release_remix, active_normal, settings]:
        if not path.is_file():
            failures.append(f"missing required file: {path.relative_to(REPO)}")

    if not all(path.is_file() for path in [release_normal, release_remix, active_normal, settings]):
        continue

    if release_normal.read_bytes() != active_normal.read_bytes():
        failures.append(f"active/release source mismatch: {contract}.sol")

    normal_text = release_normal.read_text(encoding="utf-8")
    remix_text = release_remix.read_text(encoding="utf-8")
    normalized_remix = re.sub(
        r"https://raw\.githubusercontent\.com/OpenZeppelin/openzeppelin-contracts/v5\.6\.1/contracts/",
        "@openzeppelin/contracts/",
        remix_text,
    )
    if normal_text != normalized_remix:
        failures.append(f"normal/Remix mismatch: {contract}")

    if json.loads(settings.read_text(encoding="utf-8")) != profile:
        failures.append(f"compiler settings differ from COMPILER_PROFILE.json: {folder}")

    for needle in EXPECTED_MARKERS[f"{contract}.sol"]:
        if needle not in normal_text:
            failures.append(f"{contract}.sol: missing {needle}")

labr = (CONTRACTS / "LaborCoinV4.sol").read_text(encoding="utf-8")
for forbidden in ["totalDividendEligibleSupply", "magnifiedDividendPerShare * eligibleBalance", "balance-weighted dividends"]:
    if forbidden in labr:
        failures.append(f"LABR contains forbidden weighted-dividend marker: {forbidden}")

exchange = (CONTRACTS / "LaborCoinExchangeV7.sol").read_text(encoding="utf-8")
if exchange.count("_requireVerified(msg.sender);") < 2:
    failures.append("Exchange buy and sell identity gates were not both found")

for forbidden_path in [REPO / "archive", REPO / "release" / "superseded-revision-6"]:
    if forbidden_path.exists():
        failures.append(f"non-authoritative history remains in public release: {forbidden_path.relative_to(REPO)}")

if failures:
    print("REVISION 7.2 SOURCE CHECKS: FAIL")
    for failure in failures:
        print("-", failure)
    sys.exit(1)

print("REVISION 7.2 SOURCE CHECKS: PASS")
print(f"Checked {len(COMPONENTS)} active sources, release copies, Remix copies, compiler profiles, and manifest hashes.")
