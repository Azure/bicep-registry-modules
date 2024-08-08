# Azure SQL Server Audit Settings `[Microsoft.Sql/servers]`

This module deploys an Azure SQL Server Audit Settings.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Sql/servers/auditingSettings` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/auditingSettings) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the audit settings. |
| [`state`](#parameter-state) | string | The resource group of the SQL Server. Required if the template is used in a standalone deployment. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serverName`](#parameter-servername) | string | The Name of SQL Server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`auditActionsAndGroups`](#parameter-auditactionsandgroups) | array | Specifies the Actions-Groups and Actions to audit. |
| [`isAzureMonitorTargetEnabled`](#parameter-isazuremonitortargetenabled) | bool | Specifies whether audit events are sent to Azure Monitor. |
| [`isDevopsAuditEnabled`](#parameter-isdevopsauditenabled) | bool | Specifies the state of devops audit. If state is Enabled, devops logs will be sent to Azure Monitor. |
| [`isManagedIdentityInUse`](#parameter-ismanagedidentityinuse) | bool | Specifies whether Managed Identity is used to access blob storage. |
| [`isStorageSecondaryKeyInUse`](#parameter-isstoragesecondarykeyinuse) | bool | Specifies whether storageAccountAccessKey value is the storage's secondary key. |
| [`queueDelayMs`](#parameter-queuedelayms) | int | Specifies the amount of time in milliseconds that can elapse before audit actions are forced to be processed. |
| [`retentionDays`](#parameter-retentiondays) | int | Specifies the number of days to keep in the audit logs in the storage account. |
| [`storageAccountResourceId`](#parameter-storageaccountresourceid) | string | A blob storage to hold the auditing storage account. |

### Parameter: `name`

The name of the audit settings.

- Required: Yes
- Type: string

### Parameter: `state`

The resource group of the SQL Server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `serverName`

The Name of SQL Server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `auditActionsAndGroups`

Specifies the Actions-Groups and Actions to audit.

- Required: No
- Type: array

### Parameter: `isAzureMonitorTargetEnabled`

Specifies whether audit events are sent to Azure Monitor.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `isDevopsAuditEnabled`

Specifies the state of devops audit. If state is Enabled, devops logs will be sent to Azure Monitor.

- Required: No
- Type: bool

### Parameter: `isManagedIdentityInUse`

Specifies whether Managed Identity is used to access blob storage.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `isStorageSecondaryKeyInUse`

Specifies whether storageAccountAccessKey value is the storage's secondary key.

- Required: No
- Type: bool

### Parameter: `queueDelayMs`

Specifies the amount of time in milliseconds that can elapse before audit actions are forced to be processed.

- Required: No
- Type: int

### Parameter: `retentionDays`

Specifies the number of days to keep in the audit logs in the storage account.

- Required: No
- Type: int

### Parameter: `storageAccountResourceId`

A blob storage to hold the auditing storage account.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed audit settings. |
| `resourceGroupName` | string | The resource group of the deployed audit settings. |
| `resourceId` | string | The resource ID of the deployed audit settings. |
