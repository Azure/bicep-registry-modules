# Log Analytics Workspace Linked Services `[Microsoft.OperationalInsights/workspaces/linkedServices]`

This module deploys a Log Analytics Workspace Linked Service.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

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
