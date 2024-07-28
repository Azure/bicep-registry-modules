# Log Analytics Workspace Storage Insight Configs `[Microsoft.OperationalInsights/workspaces/storageInsightConfigs]`

This module deploys a Log Analytics Workspace Storage Insight Config.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/storageInsightConfigs) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`storageAccountResourceId`](#parameter-storageaccountresourceid) | string | The Azure Resource Manager ID of the storage account resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logAnalyticsWorkspaceName`](#parameter-loganalyticsworkspacename) | string | The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containers`](#parameter-containers) | array | The names of the blob containers that the workspace should read. |
| [`name`](#parameter-name) | string | The name of the storage insights config. |
| [`tables`](#parameter-tables) | array | The names of the Azure tables that the workspace should read. |
| [`tags`](#parameter-tags) | object | Tags to configure in the resource. |

### Parameter: `storageAccountResourceId`

The Azure Resource Manager ID of the storage account resource.

- Required: Yes
- Type: string

### Parameter: `logAnalyticsWorkspaceName`

The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `containers`

The names of the blob containers that the workspace should read.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `name`

The name of the storage insights config.

- Required: No
- Type: string
- Default: `[format('{0}-stinsconfig', last(split(parameters('storageAccountResourceId'), '/')))]`

### Parameter: `tables`

The names of the Azure tables that the workspace should read.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags to configure in the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the storage insights configuration. |
| `resourceGroupName` | string | The resource group where the storage insight configuration is deployed. |
| `resourceId` | string | The resource ID of the deployed storage insights configuration. |
