# SQL Server Database Long Term Backup Retention Policies `[Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies]`

This module deploys an Azure SQL Server Database Long-Term Backup Retention Policy.

You can reference the module as follows:
```bicep
module server 'br/public:avm/res/sql/server/database/backup-long-term-retention-policy:<version>' = {
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
| `Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_servers_databases_backuplongtermretentionpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2025-01-01/servers/databases/backupLongTermRetentionPolicies)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseName`](#parameter-databasename) | string | The name of the parent database. |
| [`serverName`](#parameter-servername) | string | The name of the parent SQL Server. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
