# Event Hub Namespace Disaster Recovery Configs `[Microsoft.EventHub/namespaces/disasterRecoveryConfigs]`

This module deploys an Event Hub Namespace Disaster Recovery Config.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.EventHub/namespaces/disasterRecoveryConfigs` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2024-01-01/namespaces/disasterRecoveryConfigs) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the disaster recovery config. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent event hub namespace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`partnerNamespaceId`](#parameter-partnernamespaceid) | string | Resource ID of the Primary/Secondary event hub namespace name, which is part of GEO DR pairing. |

### Parameter: `name`

The name of the disaster recovery config.

- Required: Yes
- Type: string

### Parameter: `namespaceName`

The name of the parent event hub namespace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `partnerNamespaceId`

Resource ID of the Primary/Secondary event hub namespace name, which is part of GEO DR pairing.

- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the disaster recovery config. |
| `resourceGroupName` | string | The name of the resource group the disaster recovery config was created in. |
| `resourceId` | string | The resource ID of the disaster recovery config. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
