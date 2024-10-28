# Azure SQL Server Database Short Term Backup Retention Policies `[Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies]`

This module deploys an Azure SQL Server Database Short-Term Backup Retention Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseName`](#parameter-databasename) | string | The name of the parent database. |
| [`serverName`](#parameter-servername) | string | The name of the parent SQL Server. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diffBackupIntervalInHours`](#parameter-diffbackupintervalinhours) | int | Differential backup interval in hours. |
| [`retentionDays`](#parameter-retentiondays) | int | Poin-in-time retention in days. |

### Parameter: `databaseName`

The name of the parent database.

- Required: Yes
- Type: string

### Parameter: `serverName`

The name of the parent SQL Server.

- Required: Yes
- Type: string

### Parameter: `diffBackupIntervalInHours`

Differential backup interval in hours.

- Required: No
- Type: int
- Default: `24`

### Parameter: `retentionDays`

Poin-in-time retention in days.

- Required: No
- Type: int
- Default: `7`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the short-term policy. |
| `resourceGroupName` | string | The resource group the short-term policy was deployed into. |
| `resourceId` | string | The resource ID of the short-term policy. |
