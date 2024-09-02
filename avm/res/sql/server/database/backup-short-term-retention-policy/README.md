# Azure SQL Server Database Short Term Backup Retention Policies `[Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies]`

This module deploys an Azure SQL Server Database Short-Term Backup Retention Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
