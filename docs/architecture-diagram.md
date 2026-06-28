```mermaid
flowchart TD
    Exchange[Exchange V4] --> LABR[LABR Token]
    LABR --> Registration[Registration V4]
    Passport[Passport + Verifier Service] --> Registration
    Registration --> LABRV[LaborVote V7 / LABRV]
    LABRV --> Governance[Governance V13]
    Governance --> DAO[Aragon DAO Treasury]
    DAO --> TreasuryModule[Treasury Module V1]
    TreasuryModule --> Recipients[Approved Recipients]
```
