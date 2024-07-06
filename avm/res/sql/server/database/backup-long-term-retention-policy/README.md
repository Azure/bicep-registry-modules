# SQL Server Database Long Term Backup Retention Policies `[Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies]`

This module deploys an Azure SQL Server Database Long-Term Backup Retention Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseName`](#parameter-databasename) | string | The name of the parent database. |
| [`serverName`](#parameter-servername) | string | The name of the parent SQL Server. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`monthlyRetention`](#parameter-monthlyretention) | string | Weekly retention in ISO 8601 duration format. |
| [`weeklyRetention`](#parameter-weeklyretention) | string | Monthly retention in ISO 8601 duration format. |
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

### Parameter: `monthlyRetention`

Weekly retention in ISO 8601 duration format.

- Required: No
- Type: string
- Default: `''`

### Parameter: `weeklyRetention`

Monthly retention in ISO 8601 duration format.

- Required: No
- Type: string
- Default: `''`

### Parameter: `weekOfYear`

Week of year backup to keep for yearly retention.

- Required: No
- Type: int
- Default: `1`

### Parameter: `yearlyRetention`

Yearly retention in ISO 8601 duration format.

- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the long-term policy. |
| `resourceGroupName` | string | The resource group the long-term policy was deployed into. |
| `resourceId` | string | The resource ID of the long-term policy. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
