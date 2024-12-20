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
| [`storageAccountIds`](#parameter-storageaccountids) | array | Linked storage accounts resources Ids. |

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

### Parameter: `storageAccountIds`

Linked storage accounts resources Ids.

- Required: Yes
- Type: array

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
