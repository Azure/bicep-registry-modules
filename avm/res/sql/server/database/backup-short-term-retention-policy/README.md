# Azure SQL Server Database Short Term Backup Retention Policies `[Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies]`

This module deploys an Azure SQL Server Database Short-Term Backup Retention Policy.

You can reference the module as follows:
```bicep
module server 'br/public:avm/res/sql/server/database/backup-short-term-retention-policy:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_servers_databases_backupshorttermretentionpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2025-01-01/servers/databases/backupShortTermRetentionPolicies)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseName`](#parameter-databasename) | string | The name of the parent database. |
| [`serverName`](#parameter-servername) | string | The name of the parent SQL Server. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diffBackupIntervalInHours`](#parameter-diffbackupintervalinhours) | int | Differential backup interval in hours. For Hyperscal tiers this value will be ignored. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
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

Differential backup interval in hours. For Hyperscal tiers this value will be ignored.

- Required: No
- Type: int
- Default: `24`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
