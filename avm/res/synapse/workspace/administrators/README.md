# Synapse Workspaces Administrators `[Microsoft.Synapse/workspaces/administrators]`

This module deploys Synapse Workspaces Administrators.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Synapse/workspaces/administrators` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/administrators) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`administratorType`](#parameter-administratortype) | string | Workspace active directory administrator type. |
| [`login`](#parameter-login) | securestring | Login of the workspace active directory administrator. |
| [`sid`](#parameter-sid) | securestring | Object ID of the workspace active directory administrator. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`tenantId`](#parameter-tenantid) | string | Tenant ID of the workspace active directory administrator. |

### Parameter: `administratorType`

Workspace active directory administrator type.

- Required: Yes
- Type: string

### Parameter: `login`

Login of the workspace active directory administrator.

- Required: Yes
- Type: securestring

### Parameter: `sid`

Object ID of the workspace active directory administrator.

- Required: Yes
- Type: securestring

### Parameter: `workspaceName`

The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `tenantId`

Tenant ID of the workspace active directory administrator.

- Required: No
- Type: string
- Default: `[tenant().tenantId]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed administrator. |
| `resourceGroupName` | string | The resource group of the deployed administrator. |
| `resourceId` | string | The resource ID of the deployed administrator. |
