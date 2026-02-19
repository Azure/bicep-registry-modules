# Storage Account Management Policies `[Microsoft.Storage/storageAccounts/managementPolicies]`

This module deploys a Storage Account Management Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Storage/storageAccounts/managementPolicies` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_managementpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/managementPolicies)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`rules`](#parameter-rules) | array | The Storage Account ManagementPolicies Rules. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`storageAccountName`](#parameter-storageaccountname) | string | The name of the parent Storage Account. Required if the template is used in a standalone deployment. |

### Parameter: `rules`

The Storage Account ManagementPolicies Rules.

- Required: Yes
- Type: array

### Parameter: `storageAccountName`

The name of the parent Storage Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed management policy. |
| `resourceGroupName` | string | The resource group of the deployed management policy. |
| `resourceId` | string | The resource ID of the deployed management policy. |
