# Azure Cosmos DB account tables `[Microsoft.DocumentDB/databaseAccounts/tables]`

This module deploys a table within an Azure Cosmos DB Account.

You can reference the module as follows:
```bicep
module databaseAccount 'br/public:avm/res/document-db/database-account/table:<version>' = {
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
| `Microsoft.DocumentDB/databaseAccounts/tables` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-04-15/databaseAccounts/tables)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the table. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseAccountName`](#parameter-databaseaccountname) | string | The name of the parent Azure Cosmos DB account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`maxThroughput`](#parameter-maxthroughput) | int | Represents maximum throughput, the resource can scale up to. Cannot be set together with `throughput`. If `throughput` is set to something else than -1, this autoscale setting is ignored. |
| [`tags`](#parameter-tags) | object | Tags for the table. |
| [`throughput`](#parameter-throughput) | int | Request Units per second (for example 10000). Cannot be set together with `maxThroughput`. |

### Parameter: `name`

Name of the table.

- Required: Yes
- Type: string

### Parameter: `databaseAccountName`

The name of the parent Azure Cosmos DB account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `maxThroughput`

Represents maximum throughput, the resource can scale up to. Cannot be set together with `throughput`. If `throughput` is set to something else than -1, this autoscale setting is ignored.

- Required: No
- Type: int
- Default: `4000`

### Parameter: `tags`

Tags for the table.

- Required: No
- Type: object

### Parameter: `throughput`

Request Units per second (for example 10000). Cannot be set together with `maxThroughput`.

- Required: No
- Type: int

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the table. |
| `resourceGroupName` | string | The name of the resource group the table was created in. |
| `resourceId` | string | The resource ID of the table. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
