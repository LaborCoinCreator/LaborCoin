# Authority and Decentralization

LaborCoin minimizes custom-contract administration after launch but does not eliminate all operational authority.

| Component | Temporary authority | Final contract authority |
|---|---|---|
| Identity Registry | Launch owner binds exact LABR | Owner zero; no revocation or setters |
| LABR | Launch owner binds exact Exchange | Owner zero; no mint, burn, pause, or setters |
| Exchange | None | No owner, pause, recovery, or setters |
| LaborVote | Launch owner binds Registration | Owner zero; Registration is sole minter |
| Registration | None | No owner or setters |
| Text Policy | None | Pure immutable rules |
| Governance | None | Fixed proposal and execution rules |
| Verifier | Operator controls private key and service | Fixed signer address in Registry; service remains off-chain |
| Aragon DAO | DAO permission registry | Existing DAO permissions remain externally administered until revoked/frozen as planned |
| Site | Repository, host, domain, RPC and CDN control | Operational infrastructure remains mutable |

The contracts can be immutable while the interface, verifier availability, domain, RPCs, and DAO permission configuration remain practical control points. Launch documentation must not describe those external systems as immutable.
