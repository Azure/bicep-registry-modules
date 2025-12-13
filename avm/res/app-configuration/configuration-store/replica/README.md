# App Configuration Replicas `[Microsoft.AppConfiguration/configurationStores/replicas]`

This module deploys an App Configuration Replica.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.AppConfiguration/configurationStores/replicas` | 2025-02-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.appconfiguration_configurationstores_replicas.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AppConfiguration/2025-02-01-preview/configurationStores/replicas)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`replicaLocation`](#parameter-replicalocation) | string | Location of the replica. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appConfigurationName`](#parameter-appconfigurationname) | string | The name of the parent app configuration store. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the replica. |

### Parameter: `replicaLocation`

Location of the replica.

- Required: Yes
- Type: string

### Parameter: `appConfigurationName`

The name of the parent app configuration store. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the replica.

- Required: No
- Type: string
- Default: `[format('{0}replica', parameters('replicaLocation'))]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replica that was deployed. |
| `resourceGroupName` | string | The resource group the app configuration was deployed into. |
| `resourceId` | string | The resource ID of the replica that was deployed. |
