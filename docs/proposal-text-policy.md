# Proposal Text Policy V1.1.1

Proposal Text Policy V1.1.1 is a pure, immutable validation contract for the human-entered portions of Structured Treasury Proposal Schema V1. It has no administrator or update path. Governance V15.2 commits to its exact runtime code hash, compatibility ID, lexicon commitment, and field limits.

## Short-text fields

The policy independently validates:

- `organizationName`: required, maximum 96 ASCII bytes;
- `workerGroupOrCampaign`: required, maximum 128 ASCII bytes.

Both fields must be single-line printable ASCII, may not begin or end with spaces, may not contain HTML-style angle-bracket markup or URL markers, must contain readable alphanumeric content, and are screened by the fixed hashed lexicon and obfuscation rules. The substantive lexicon remains the same 143 blocked-token hashes, 18 blocked-phrase hashes, and lexicon commitment used by the preceding candidate.

## Verification URI

`verificationURI` is validated through a separate URI path rather than weakening the short-text policy. It is required, limited to 256 ASCII bytes, and accepts only constrained `https://` or `ipfs://` references. Unsafe/control characters and unsupported schemes are rejected.

For `https://`, the hostname must be a normal dotted hostname with no embedded credentials or explicit port.

For `ipfs://`, the first component after the scheme must be a canonical CID root before any path, query, or fragment. The immutable on-chain validator accepts:

- CIDv0: exactly 46 base58btc characters beginning with `Qm`;
- CIDv1 base32: lowercase multibase form beginning with `b`, using only `a-z` and `2-7`, with a root length of 32 to 128 characters;
- CIDv1 base36: lowercase multibase form beginning with `k`, using only `0-9` and `a-z`, with a root length of 32 to 128 characters.

The CIDv1 constraints intentionally favor the case-insensitive base32/base36 representations recommended for interoperable IPFS addressing while avoiding an expensive full CID decoder in Governance's immutable lexical policy. The rule is a structural safety boundary, not a cryptographic proof that every accepted string decodes to a valid CID.

An accepted URI is only a syntactically constrained reference. The contract cannot determine whether external material is truthful, appropriate, reachable forever, or unchanged at a mutable HTTPS location.

## Compatibility

Governance V15.2 requires the structured-policy compatibility ID:

```text
LABORCOIN_PROPOSAL_TEXT_POLICY_V1_STRUCTURED_ASCII_HASHED_LEXICON_HTTPS_IPFS_V1
```

The compatibility ID remains the same policy-family identifier because the structured ABI, field limits, schemes, and Governance interface are unchanged. Governance additionally binds the exact deployed Proposal Text Policy runtime hash, so V1.1.1 cannot be substituted with a different implementation at deployment.

The old description-based ABI (`validateDescription`, `isDescriptionAllowed`, and `MAX_DESCRIPTION_BYTES`) is intentionally absent so Governance V15.1 cannot be accidentally paired with this policy.

See `contracts/LaborCoinProposalTextPolicyV1.sol` for the canonical implementation.
