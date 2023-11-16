# SQL Server Database Long Term Backup Retention Policies `[Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies]`

This module deploys an Azure SQL Server Database Long-Term Backup Retention Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/databases/backupLongTermRetentionPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseName`](#parameter-databasename) | string | The name of the parent database. |
| [`serverName`](#parameter-servername) | string | The name of the parent SQL Server. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`monthlyRetention`](#parameter-monthlyretention) | string | Weekly retention in ISO 8601 duration format. |
| [`weeklyRetention`](#parameter-weeklyretention) | string | Monthly retention in ISO 8601 duration format. |
| [`weekOfYear`](#parameter-weekofyear) | int | Week of year backup to keep for yearly retention. |
| [`yearlyRetention`](#parameter-yearlyretention) | string | Yearly retention in ISO 8601 duration format. |

### Parameter: `databaseName`

The name of the parent database.
- Required: Yes
- Type: string

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `monthlyRetention`

Weekly retention in ISO 8601 duration format.
- Required: No
- Type: string
- Default: `''`

### Parameter: `serverName`

The name of the parent SQL Server.
- Required: Yes
- Type: string

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
