# subscription-placement `[MgmtGroups/SubscriptionPlacement]`

This module allows for placement of subscriptions to management groups 

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Management/managementGroups/subscriptions` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Management/2023-04-01/managementGroups/subscriptions) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/mgmt-groups/subscription-placement:<version>`.

- [Using only defaults.](#example-1-using-only-defaults)

### Example 1: _Using only defaults._

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module subscriptionPlacement 'br/public:avm/ptn/mgmt-groups/subscription-placement:<version>' = {
  name: 'subscriptionPlacementDeployment'
  params: {
    parSubscriptionPlacement: [
      {
        managementGroupId: '<managementGroupId>'
        subscriptionIds: [
          '<subVendingSubscriptionId>'
        ]
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
      "value": [
        {
          "managementGroupId": "<managementGroupId>",
          "subscriptionIds": [
            "<subVendingSubscriptionId>"
          ]
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
using 'br/public:avm/ptn/mgmt-groups/subscription-placement:<version>'

param parSubscriptionPlacement = [
  {
    managementGroupId: '<managementGroupId>'
    subscriptionIds: [
      '<subVendingSubscriptionId>'
    ]
  }
]
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`parSubscriptionPlacement`](#parameter-parsubscriptionplacement) | array | The management group IDs along with the subscriptions to be placed underneath them. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |

### Parameter: `parSubscriptionPlacement`

The management group IDs along with the subscriptions to be placed underneath them.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managementGroupId`](#parameter-parsubscriptionplacementmanagementgroupid) | string | The ID of the management group. |
| [`subscriptionIds`](#parameter-parsubscriptionplacementsubscriptionids) | array | The list of subscription IDs to be placed underneath the management group. |

### Parameter: `parSubscriptionPlacement.managementGroupId`

The ID of the management group.

- Required: Yes
- Type: string

### Parameter: `parSubscriptionPlacement.subscriptionIds`

The list of subscription IDs to be placed underneath the management group.

- Required: Yes
- Type: array

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[deployment().location]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `subscriptionPlacementSummary` | string | Output of number of management groups that have been configured with subscription placements. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
