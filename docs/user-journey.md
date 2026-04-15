```mermaid
flowchart TD

    A[User] -->|Registers| B["Registration System"]

    B -->|Verifies eligibility| C[LABRV Token Issued]

    C -->|Receives 1 LABRV| D[User Gains Voting Power]

    D -->|Submits or votes on proposal| E["LABR Solidarity Proposals"]

    E -->|Proposal passes (75/75)| F["DAO Executes Decision"]

    F --> G1[Funds Distributed]
    F --> G2[Token Paused/Unpaused]
    F --> G3[System Actions Executed]

    %% Styling
    classDef user fill:#6b7280,color:#fff;
    classDef action fill:#1d4ed8,color:#fff;
    classDef result fill:#065f46,color:#fff;

    class A user;
    class B,C,D,E,F action;
    class G1,G2,G3 result;
```
