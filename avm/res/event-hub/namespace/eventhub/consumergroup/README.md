# Event Hub Namespace Event Hub Consumer Groups `[Microsoft.EventHub/namespaces/eventhubs/consumergroups]`

This module deploys an Event Hub Namespace Event Hub Consumer Group.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.EventHub/namespaces/eventhubs/consumergroups` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2024-01-01/namespaces/eventhubs/consumergroups) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the consumer group. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubName`](#parameter-eventhubname) | string | The name of the parent event hub namespace event hub. Required if the template is used in a standalone deployment. |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent event hub namespace. Required if the template is used in a standalone deployment.s. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`userMetadata`](#parameter-usermetadata) | string | User Metadata is a placeholder to store user-defined string data with maximum length 1024. e.g. it can be used to store descriptive data, such as list of teams and their contact information also user-defined configuration settings can be stored. |

### Parameter: `name`

The name of the consumer group.

- Required: Yes
- Type: string

### Parameter: `eventHubName`

The name of the parent event hub namespace event hub. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `namespaceName`

The name of the parent event hub namespace. Required if the template is used in a standalone deployment.s.

- Required: Yes
- Type: string

### Parameter: `userMetadata`

User Metadata is a placeholder to store user-defined string data with maximum length 1024. e.g. it can be used to store descriptive data, such as list of teams and their contact information also user-defined configuration settings can be stored.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the consumer group. |
| `resourceGroupName` | string | The name of the resource group the consumer group was created in. |
| `resourceId` | string | The resource ID of the consumer group. |
