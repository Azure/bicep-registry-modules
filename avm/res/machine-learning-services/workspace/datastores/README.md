# Machine Learning Services Workspaces Datastores `[Microsoft.MachineLearningServices/workspaces/datastores]`

This module creates a datastore in a Machine Learning Services workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.MachineLearningServices/workspaces/datastores` | [2024-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-10-01/workspaces/datastores) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`machineLearningWorkspaceName`](#parameter-machinelearningworkspacename) | string | The name of the parent Machine Learning Workspace. |
| [`name`](#parameter-name) | string | Name of the datastore to create. |
| [`properties`](#parameter-properties) | object | The properties of the datastore. |

### Parameter: `machineLearningWorkspaceName`

The name of the parent Machine Learning Workspace.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the datastore to create.

- Required: Yes
- Type: string

### Parameter: `properties`

The properties of the datastore.

- Required: Yes
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the datastore. |
| `resourceGroupName` | string | The name of the resource group the datastore was created in. |
| `resourceId` | string | The resource ID of the datastore. |
