# App Configuration Replicas `[Microsoft.AppConfiguration/configurationStores/replicas]`

This module deploys an App Configuration Replica.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.AppConfiguration/configurationStores/replicas` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AppConfiguration/2024-05-01/configurationStores/replicas) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the replica. |
| [`replicaLocation`](#parameter-replicalocation) | string | Location of the replica. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appConfigurationName`](#parameter-appconfigurationname) | string | The name of the parent app configuration store. Required if the template is used in a standalone deployment. |

### Parameter: `name`

Name of the replica.

- Required: Yes
- Type: string

### Parameter: `replicaLocation`

Location of the replica.

- Required: Yes
- Type: string

### Parameter: `appConfigurationName`

The name of the parent app configuration store. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replica that was deployed. |
| `resourceGroupName` | string | The resource group the app configuration was deployed into. |
| `resourceId` | string | The resource ID of the replica that was deployed. |
