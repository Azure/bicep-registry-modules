# Sub-Placement `[Lz/SubPlacement]`

This module allows for a hierarchical configuration of subscriptions to management group placement within an Azure tenant.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Management/managementGroups/subscriptions` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Management/managementgroups/subscriptions) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/lz/sub-placement:<version>`.

- [Using only defaults.](#example-1-using-only-defaults)

### Example 1: _Using only defaults._

This instance deploys the module with the minimum set of required parameters.

<details>

<summary>via Bicep module</summary>

```bicep
module subPlacement 'br/public:avm/ptn/lz/sub-placement:<version>' = {
  name: 'subPlacementDeployment'
  params: {
    parSubscriptionPlacement: [
      {
        managementGroupId: 'Group1'
        subscriptionIds: ['SubID1', 'SubID2']
      }
      {
        managementGroupId: 'Group2'
        subscriptionIds: ['SubID3']
      }
      {
        managementGroupId: 'Group3'
        subscriptionIds: []
      }
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "parSubscriptionPlacement": {
       [
        {
          "managementGroupId": "Group1",
          "subscriptionIds": ["SUBID1", "SUBID2"]
        },
        {
          "managementGroupId": "Group2",
          "subscriptionIds": ["SUBID3"]
        },
        {
          "managementGroupId": "Group3",
          "subscriptionIds": []
        }
      ]
    }
  }
}
```


</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-placement:<version>'

param parSubscriptionPlacement typMgChild = [
  {
    managementGroupId: 'Group1'
    subscriptionIds: ['SUBID1', 'SUBID2']
  },
  {
    managementGroupId: 'Group2'
    subscriptionIds: ['SUBID3']
  },
  {
    managementGroupId: 'Group3'
    subscriptionIds: []
  }
]
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managementGroupId`](#parameter-managementGroupId) | string | The ID of management group to be used. |
| [`subscriptionIds`](#parameter-subscriptionIds) | array | An array of subscription IDs to be associated with management group ID. |

**Optional parameters**

There are no optional parameters associated with this module. 

### Parameter: `managementGroupId`

The ID of Management Group used to be associated with defined subscription IDs

- Required: yes
- Type: string
- Default: `' ' `

### Parameter: `subscriptionIds`

A singular or array of subscription IDs to be associated with a given Management Group ID. 

- Required: yes
- Type: array
- Default: `[ ]`


## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
