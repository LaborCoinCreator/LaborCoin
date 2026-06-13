# Security Policy

If you discover a security issue, please report it privately to:

LaborCoinCreator@proton.me

Please do not publicly disclose vulnerabilities until they have been reviewed.

Security Controls Matrix.

This appendix summarizes protocol security controls in a format commonly used by auditors and reviewers.

---

| Threat                    | Security Control                | Layer        |
| ------------------------- | ------------------------------- | ------------ |
| Duplicate Identities      | Passport Threshold              | Registration |
| Duplicate Registration    | LABRV Ownership Check           | Registration |
| Unauthorized Registration | Verifier Signature              | Registration |
| Replay Attack             | Nonce Tracking                  | Registration |
| Signature Reuse           | Expiration Validation           | Registration |
| Governance Capture        | Soulbound LABRV                 | Governance   |
| Low Participation         | 25% Threshold                   | Governance   |
| Minority Control          | 67% Approval Requirement        | Governance   |
| Treasury Extraction       | 5% Cap                          | Treasury     |
| Stale Proposal Execution  | 7-Day Window                    | Treasury     |
| Double Execution          | Execution Tracking              | Governance   |
| Flash Trading             | 12-Hour Cooldown                | Exchange     |
| Reentrancy                | ReentrancyGuard                 | Exchange     |
| Oracle Failure            | Freshness Validation            | Exchange     |
| Oracle Anomaly            | Maximum Price Validation        | Exchange     |
| Founder Abuse             | Ownership Renouncement          | Protocol     |
| Governance Overreach      | Fixed Constitutional Parameters | Protocol     |

---

## Defense-in-Depth Philosophy

LaborCoin intentionally utilizes overlapping protections.

For example:

Governance legitimacy depends simultaneously upon:

* Passport verification
* Registration
* LABRV issuance
* Participation thresholds
* Approval thresholds

No individual control is expected to provide complete security.

The protocol instead relies upon multiple independent safeguards.
