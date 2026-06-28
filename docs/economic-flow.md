```mermaid
graph TD

Participants[Participants]
--> Exchange[Exchange V4]

Exchange
--> Treasury[Aragon DAO Treasury]

Treasury
--> Governance[Governance V13]

Governance
--> DAO[Aragon DAO Execute]

DAO
--> Module[Treasury Module V1]

Module
--> Recipients[Recipients]

Recipients
--> Ecosystem[Ecosystem Impact]
```
