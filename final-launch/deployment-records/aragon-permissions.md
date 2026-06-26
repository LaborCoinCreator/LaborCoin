# Aragon Permission Records

Network: Polygon Mainnet
Chain ID: 137
DAO Treasury / DAO Address: `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4`
Admin Plugin: `0xB51Bf5812Fd8FF0c3F1A1AB1e8F24426d497D5CF`
Permission ID: `EXECUTE_PERMISSION_ID`
Permission ID Hash: `0xbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d`

## Purpose

These records document the Aragon DAO permission grants used to authorize LaborCoin system contracts to execute approved DAO treasury actions.

The permission grants were executed through the Aragon Admin Plugin using `executeProposal(bytes _metadata, tuple[] _actions, uint256 _allowFailureMap)`.

## Permission Grant: Governance Contract

Authorized Contract: `0x8238105d31F6Bb26897d8Ab270a0A521FEF03E8c`
Target DAO: `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4`
Permission: `EXECUTE_PERMISSION_ID`

Transaction Hash:
`0x1e9bc8d427a417ad84b1d52fd08a3592fa682c9ebf51213096ea38e2a6e591fd`

Block: `89086830`
Status: Success
Value: `0 POL`

### Tuple

```text
[
  [
    "0x0C2e5679153593b82a84eAB5CA90895BB291Cec4",
    0,
    "0xd68bad2c0000000000000000000000000c2e5679153593b82a84eab5ca90895bb291cec40000000000000000000000008238105d31f6bb26897d8ab270a0a521fef03e8cbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d"
  ]
]
```

## Permission Grant: Treasury Module

Authorized Contract: `0x10F2798ef055950B897AF4B3A8ae90dE34f6C56C`
Target DAO: `0x0C2e5679153593b82a84eAB5CA90895BB291Cec4`
Permission: `EXECUTE_PERMISSION_ID`

Transaction Hash:
`0x2e34480efe13043df5318d77242b11c078a02dc0bba3a5aa7cf61f91fc45b0`

Block: `89086849`
Status: Success
Value: `0 POL`

### Tuple

```text
[
  [
    "0x0C2e5679153593b82a84eAB5CA90895BB291Cec4",
    0,
    "0xd68bad2c0000000000000000000000000c2e5679153593b82a84eab5ca90895bb291cec400000000000000000000000010f2798ef055950b897af4b3a8ae90de34f6c56cbf04b4486c9663d805744005c3da000eda93de6e3308a4a7a812eb565327b78d"
  ]
]
```

## Final Permission State

The LaborCoin DAO grants execution authority only to the system contracts required for governance-approved treasury execution.

The permission records above should be reviewed together with:

* `deployment-records/deployments.md`
* `deployment-records/constructor-args.md`
* `deployment-records/verification.md`
* `deployment-records/ownership-transfer.md`
* `contracts/contract-map.md`
