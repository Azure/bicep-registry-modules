# Log Analytics Workspace Linked Services `[Microsoft.OperationalInsights/workspaces/linkedServices]`

This module deploys a Log Analytics Workspace Linked Service.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedServices) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the link. |
| [`resourceId`](#parameter-resourceid) | string | The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require read access. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logAnalyticsWorkspaceName`](#parameter-loganalyticsworkspacename) | string | The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`tags`](#parameter-tags) | object | Tags to configure in the resource. |
| [`writeAccessResourceId`](#parameter-writeaccessresourceid) | string | The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require write access. |

### Parameter: `name`

Name of the link.

- Required: Yes
- Type: string

### Parameter: `resourceId`

The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require read access.

- Required: No
- Type: string
- Default: `''`

### Parameter: `logAnalyticsWorkspaceName`

The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `tags`

Tags to configure in the resource.

- Required: No
- Type: object

### Parameter: `writeAccessResourceId`

The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require write access.

- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed linked service. |
| `resourceGroupName` | string | The resource group where the linked service is deployed. |
| `resourceId` | string | The resource ID of the deployed linked service. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
