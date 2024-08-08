# Azure Container Registry (ACR) Replications `[Microsoft.ContainerRegistry/registries/replications]`

This module deploys an Azure Container Registry (ACR) Replication.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ContainerRegistry/registries/replications` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/replications) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the replication. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`registryName`](#parameter-registryname) | string | The name of the parent registry. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`regionEndpointEnabled`](#parameter-regionendpointenabled) | bool | Specifies whether the replication regional endpoint is enabled. Requests will not be routed to a replication whose regional endpoint is disabled, however its data will continue to be synced with other replications. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`zoneRedundancy`](#parameter-zoneredundancy) | string | Whether or not zone redundancy is enabled for this container registry. |

### Parameter: `name`

The name of the replication.

- Required: Yes
- Type: string

### Parameter: `registryName`

The name of the parent registry. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `regionEndpointEnabled`

Specifies whether the replication regional endpoint is enabled. Requests will not be routed to a replication whose regional endpoint is disabled, however its data will continue to be synced with other replications.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `zoneRedundancy`

Whether or not zone redundancy is enabled for this container registry.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the replication. |
| `resourceGroupName` | string | The name of the resource group the replication was created in. |
| `resourceId` | string | The resource ID of the replication. |
