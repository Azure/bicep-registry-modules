# Service Bus Namespace Disaster Recovery Configs `[Microsoft.ServiceBus/namespaces/disasterRecoveryConfigs]`

This module deploys a Service Bus Namespace Disaster Recovery Config

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceBus/namespaces/disasterRecoveryConfigs` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/disasterRecoveryConfigs) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent Service Bus Namespace for the Service Bus Queue. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alternateName`](#parameter-alternatename) | string | Primary/Secondary eventhub namespace name, which is part of GEO DR pairing. |
| [`name`](#parameter-name) | string | The name of the disaster recovery config. |
| [`partnerNamespaceResourceID`](#parameter-partnernamespaceresourceid) | string | Resource ID of the Primary/Secondary event hub namespace name, which is part of GEO DR pairing. |

### Parameter: `namespaceName`

The name of the parent Service Bus Namespace for the Service Bus Queue. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `alternateName`

Primary/Secondary eventhub namespace name, which is part of GEO DR pairing.

- Required: No
- Type: string
- Default: `''`

### Parameter: `name`

The name of the disaster recovery config.

- Required: No
- Type: string
- Default: `'default'`

### Parameter: `partnerNamespaceResourceID`

Resource ID of the Primary/Secondary event hub namespace name, which is part of GEO DR pairing.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the disaster recovery config. |
| `resourceGroupName` | string | The name of the Resource Group the disaster recovery config was created in. |
| `resourceId` | string | The Resource ID of the disaster recovery config. |
