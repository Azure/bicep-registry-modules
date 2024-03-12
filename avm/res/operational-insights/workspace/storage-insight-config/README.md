# Log Analytics Workspace Storage Insight Configs `[Microsoft.OperationalInsights/workspaces/storageInsightConfigs]`

This module deploys a Log Analytics Workspace Storage Insight Config.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
