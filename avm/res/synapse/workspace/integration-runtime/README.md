# Synapse Workspace Integration Runtimes `[Microsoft.Synapse/workspaces/integrationRuntimes]`

This module deploys a Synapse Workspace Integration Runtime.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Synapse/workspaces/integrationRuntimes` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/integrationRuntimes) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Integration Runtime. |
| [`type`](#parameter-type) | string | The type of Integration Runtime. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`typeProperties`](#parameter-typeproperties) | object | Integration Runtime type properties. Required if type is "Managed". |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment. |

### Parameter: `name`

The name of the Integration Runtime.

- Required: Yes
- Type: string

### Parameter: `type`

The type of Integration Runtime.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Managed'
    'SelfHosted'
  ]
  ```

### Parameter: `typeProperties`

Integration Runtime type properties. Required if type is "Managed".

- Required: No
- Type: object
- Default: `{}`

### Parameter: `workspaceName`

The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Integration Runtime. |
| `resourceGroupName` | string | The name of the Resource Group the Integration Runtime was created in. |
| `resourceId` | string | The resource ID of the Integration Runtime. |
