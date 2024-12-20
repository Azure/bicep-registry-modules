# Event Grid Domain Topics `[Microsoft.EventGrid/domains/topics]`

This module deploys an Event Grid Domain Topic.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.EventGrid/domains/topics` | [2022-06-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2022-06-15/domains/topics) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Event Grid Domain Topic. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`domainName`](#parameter-domainname) | string | The name of the parent Event Grid Domain. Required if the template is used in a standalone deployment. |

### Parameter: `name`

The name of the Event Grid Domain Topic.

- Required: Yes
- Type: string

### Parameter: `domainName`

The name of the parent Event Grid Domain. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the event grid topic. |
| `resourceGroupName` | string | The name of the resource group the event grid topic was deployed into. |
| `resourceId` | string | The resource ID of the event grid topic. |
