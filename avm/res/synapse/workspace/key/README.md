# Synapse Workspaces Keys `[Microsoft.Synapse/workspaces/keys]`

This module deploys a Synapse Workspaces Key.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Synapse/workspaces/keys` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/keys) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isActiveCMK`](#parameter-isactivecmk) | bool | Used to activate the workspace after a customer managed key is provided. |
| [`keyVaultResourceId`](#parameter-keyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. |
| [`name`](#parameter-name) | string | The name of the Synapse Workspaces Key. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment. |

### Parameter: `isActiveCMK`

Used to activate the workspace after a customer managed key is provided.

- Required: Yes
- Type: bool

### Parameter: `keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the Synapse Workspaces Key.

- Required: Yes
- Type: string

### Parameter: `workspaceName`

The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed key. |
| `resourceGroupName` | string | The resource group of the deployed key. |
| `resourceId` | string | The resource ID of the deployed key. |
