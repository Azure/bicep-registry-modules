# SQL Server Database Long Term Backup Retention Policies `[Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies]`

This module deploys an Azure SQL Server Database Long-Term Backup Retention Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies` | [2023-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-05-01-preview/servers/databases/backupLongTermRetentionPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseName`](#parameter-databasename) | string | The name of the parent database. |
| [`serverName`](#parameter-servername) | string | The name of the parent SQL Server. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupStorageAccessTier`](#parameter-backupstorageaccesstier) | string | The BackupStorageAccessTier for the LTR backups. |
| [`makeBackupsImmutable`](#parameter-makebackupsimmutable) | bool | The setting whether to make LTR backups immutable. |
| [`monthlyRetention`](#parameter-monthlyretention) | string | Monthly retention in ISO 8601 duration format. |
| [`weeklyRetention`](#parameter-weeklyretention) | string | Weekly retention in ISO 8601 duration format. |
| [`weekOfYear`](#parameter-weekofyear) | int | Week of year backup to keep for yearly retention. |
| [`yearlyRetention`](#parameter-yearlyretention) | string | Yearly retention in ISO 8601 duration format. |

### Parameter: `databaseName`

The name of the parent database.

- Required: Yes
- Type: string

### Parameter: `serverName`

The name of the parent SQL Server.

- Required: Yes
- Type: string

### Parameter: `backupStorageAccessTier`

The BackupStorageAccessTier for the LTR backups.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Archive'
    'Hot'
  ]
  ```

### Parameter: `makeBackupsImmutable`

The setting whether to make LTR backups immutable.

- Required: No
- Type: bool

### Parameter: `monthlyRetention`

Monthly retention in ISO 8601 duration format.

- Required: No
- Type: string

### Parameter: `weeklyRetention`

Weekly retention in ISO 8601 duration format.

- Required: No
- Type: string

### Parameter: `weekOfYear`

Week of year backup to keep for yearly retention.

- Required: No
- Type: int
- Default: `1`

### Parameter: `yearlyRetention`

Yearly retention in ISO 8601 duration format.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the long-term policy. |
| `resourceGroupName` | string | The resource group the long-term policy was deployed into. |
| `resourceId` | string | The resource ID of the long-term policy. |
