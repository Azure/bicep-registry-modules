# Log Analytics Workspace Linked Storage Accounts `[Microsoft.OperationalInsights/workspaces/linkedStorageAccounts]`

This module deploys a Log Analytics Workspace Linked Storage Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | 2025-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_linkedstorageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-02-01/workspaces/linkedStorageAccounts)</li></ul> |

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
