[SECURITY (1).md](https://github.com/user-attachments/files/29432761/SECURITY.1.md)
# LaborCoin Vulnerability Reporting Policy

## Reporting a Security Issue

Please report suspected security vulnerabilities privately to:

**[LaborCoinCreator@proton.me](mailto:LaborCoinCreator@proton.me)**

Do not open a public GitHub issue for an unmitigated vulnerability.

Do not publicly disclose exploit details before the report has been reviewed and a coordinated disclosure plan has been discussed.

---

## What to Include

A useful report should include:

* A clear description of the issue
* The affected contract, address, file, page, or service
* The expected behavior
* The observed behavior
* Security impact
* Reproduction steps
* Relevant transaction hashes, blocks, logs, screenshots, or calldata
* A minimal proof of concept where safe
* Any assumptions required for exploitation
* Suggested mitigation, where available
* Your preferred name or handle for public credit

Never send:

* Seed phrases
* Private keys
* Passwords
* Unnecessary personal information
* Funds as proof of an issue

---

## In-Scope Components

Security reports are welcomed for:

### Final Smart Contracts

| Component | Address |
|---|---|
| LABR Token | `0x460DD873A1D2a41e77410B125cD3027C5FEd2f78` |
| LaborVote V7 | `0x833242E933c675846D8f8982048FecA95B8e435A` |
| Registration V4 | `0xd1CD6C0B6f1F709A52908B40C07D3C54649e323C` |
| Governance V13 | `0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c` |
| Treasury Module V1 | `0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C` |
| Exchange V4 | `0x4Cf18cB39203B678f5C26f2338a10a79f9684749` |
| Aragon DAO | `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4` |

### Project-Controlled Infrastructure

* Official LaborCoin website and frontend
* Verifier service
* Transaction-construction logic
* Contract-address configuration
* Service-worker and PWA behavior
* Repository deployment and permission records
* Aragon DAO permission configuration
* Documentation errors that could cause unsafe transactions

### Examples of Relevant Findings

* Unauthorized asset transfer
* Incorrect exchange settlement
* Reentrancy or callback exploitation
* Oracle-validation bypass
* Transaction-limit bypass with direct security impact
* Unauthorized or duplicate LABRV issuance
* Registration authorization bypass
* Governance signature replay
* Duplicate voting
* Proposal-threshold bypass
* Treasury-cap bypass
* Double execution
* Arbitrary DAO execution
* Unauthorized LABR owner action
* Incorrect contract-address substitution
* Malicious transaction construction
* Verifier key or authorization exposure
* Frontend supply-chain compromise

---

## Testing Rules

Researchers should:

* Prefer local testing or a Polygon mainnet fork.
* Use the minimum activity needed to demonstrate impact.
* Avoid moving or placing real user or treasury funds at risk.
* Avoid accessing another person's wallet, account, or private data.
* Avoid denial-of-service or traffic-volume testing against production services.
* Avoid social engineering, phishing, or impersonation.
* Avoid testing third-party systems without their permission.
* Stop immediately if testing may affect real participants.
* Preserve evidence and report privately.

The policy does not authorize violation of law, third-party terms, or access controls.

---

## Severity Guidance

### Critical

Examples:

* Unauthorized transfer of DAO or Exchange V4 assets
* Arbitrary DAO execution
* Permanent unauthorized LABRV minting at scale
* Bypass of governance execution constraints leading to material treasury loss
* Remote compromise of the verifier signing key

### High

Examples:

* Repeatable governance authorization replay
* Duplicate voting with material governance impact
* Registration bypass allowing unauthorized LABRV issuance
* Oracle-validation bypass causing material exchange loss
* Frontend compromise that reliably redirects signed transactions or assets

### Medium

Examples:

* Denial of service affecting a major protocol workflow
* Incorrect security-sensitive state display
* Transaction construction that causes predictable user loss under limited conditions
* Permission or deployment-record mismatch that could conceal authority

### Low

Examples:

* Minor information leakage without secret exposure
* Non-security UI defects
* Documentation inconsistencies without a practical unsafe outcome
* Best-practice recommendations without demonstrated impact

Final severity depends on exploitability, affected assets, required access, persistence, and real-world impact.

---

## Coordinated Disclosure

After receiving a report, the project will make a best-effort attempt to:

1. Confirm receipt.
2. Reproduce and classify the issue.
3. Determine whether it affects a mutable operational layer or an immutable contract.
4. Preserve relevant evidence.
5. Develop the safest available mitigation.
6. Coordinate public disclosure with the reporter where practical.
7. Credit the reporter if requested and appropriate.

Immutable smart contracts cannot be patched in place.

A critical immutable-contract issue may require:

* Public warnings
* Removal of the affected official interface
* Verifier-side containment where applicable
* DAO permission changes where authorized
* Migration to replacement contracts
* Clear disclosure that the original deployment remains active

Exchange V4 has no administrative pause function. Removing the official interface does not prevent direct contract interaction.

---

## Public Disclosure

Please allow reasonable time for review and mitigation before publishing technical details.

Immediate public disclosure may be appropriate when:

* Active exploitation is already public
* Users face immediate continuing harm
* The issue has already been independently disclosed
* No confidential exploit detail remains to protect

Researchers are asked to communicate before disclosure whenever practical.

---

## Bounty and Compensation

No bug bounty, reward, reimbursement, or compensation is promised unless separately announced in writing.

Submitting a report does not create a contract for payment.

---

## Security Architecture

The full protocol security model, trust boundaries, controls, and residual risks are documented in:

[`docs/security.md`](../docs/security.md)

Source verification, internal testing, and public review do not by themselves constitute an independent security audit.
