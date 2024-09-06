# Container Registries scopeMaps `[Microsoft.ContainerRegistry/registries/scopeMaps]`

This module deploys an Azure Container Registry (ACR) scopeMap.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ContainerRegistry/registries/scopeMaps` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/scopeMaps) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-actions) | array | The list of scoped permissions for registry artifacts. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`registryName`](#parameter-registryname) | string | The name of the parent registry. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | The user friendly description of the scope map. |
| [`name`](#parameter-name) | string | The name of the scope map. |

### Parameter: `actions`

The list of scoped permissions for registry artifacts.

- Required: Yes
- Type: array

### Parameter: `registryName`

The name of the parent registry. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

The user friendly description of the scope map.

- Required: No
- Type: string

### Parameter: `name`

The name of the scope map.

- Required: No
- Type: string
- Default: `[format('{0}-scopemaps', parameters('registryName'))]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the scope map. |
| `resourceGroupName` | string | The name of the resource group the scope map was created in. |
| `resourceId` | string | The resource ID of the scope map. |
