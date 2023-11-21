# DocumentDB Database Account SQL Databases `[Microsoft.DocumentDB/databaseAccounts/sqlDatabases]`

This module deploys a SQL Database in a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/sqlDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/sqlDatabases/containers) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the SQL database . |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseAccountName`](#parameter-databaseaccountname) | string | The name of the parent Database Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoscaleSettingsMaxThroughput`](#parameter-autoscalesettingsmaxthroughput) | int | Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to.  The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to -1, then the property will be set to null and autoscale will be disabled. |
| [`containers`](#parameter-containers) | array | Array of containers to deploy in the SQL database. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`tags`](#parameter-tags) | object | Tags of the SQL database resource. |
| [`throughput`](#parameter-throughput) | int | Request units per second. Will be set to null if autoscaleSettingsMaxThroughput is used. |

### Parameter: `autoscaleSettingsMaxThroughput`

Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to.  The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to -1, then the property will be set to null and autoscale will be disabled.
- Required: No
- Type: int
- Default: `-1`

### Parameter: `containers`

Array of containers to deploy in the SQL database.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `databaseAccountName`

The name of the parent Database Account. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `name`

Name of the SQL database .
- Required: Yes
- Type: string

### Parameter: `tags`

Tags of the SQL database resource.
- Required: No
- Type: object

### Parameter: `throughput`

Request units per second. Will be set to null if autoscaleSettingsMaxThroughput is used.
- Required: No
- Type: int
- Default: `400`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the SQL database. |
| `resourceGroupName` | string | The name of the resource group the SQL database was created in. |
| `resourceId` | string | The resource ID of the SQL database. |

## Cross-referenced modules

_None_
