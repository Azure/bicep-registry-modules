# Log Analytics Workspace Linked Storage Accounts `[Microsoft.OperationalInsights/workspaces/linkedStorageAccounts]`

This module deploys a Log Analytics Workspace Linked Storage Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedStorageAccounts) |

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

### Parameter: `name`

Name of the link.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Alerts'
    'AzureWatson'
    'CustomLogs'
    'Query'
  ]
  ```

### Parameter: `resourceId`

The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require read access.

- Required: Yes
- Type: string

### Parameter: `logAnalyticsWorkspaceName`

The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed linked storage account. |
| `resourceGroupName` | string | The resource group where the linked storage account is deployed. |
| `resourceId` | string | The resource ID of the deployed linked storage account. |
