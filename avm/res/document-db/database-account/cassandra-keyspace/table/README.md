# DocumentDB Database Account Cassandra Keyspaces Tables `[Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces/tables]`

This module deploys a Cassandra Table within a Cassandra Keyspace in a CosmosDB Account.

You can reference the module as follows:
```bicep
module databaseAccount 'br/public:avm/res/document-db/database-account/cassandra-keyspace/table:<version>' = {
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
| `Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces/tables` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_cassandrakeyspaces_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/cassandraKeyspaces/tables)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Cassandra table. |
| [`schema`](#parameter-schema) | object | Schema definition for the Cassandra table. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cassandraKeyspaceName`](#parameter-cassandrakeyspacename) | string | The name of the parent Cassandra Keyspace. Required if the template is used in a standalone deployment. |
| [`databaseAccountName`](#parameter-databaseaccountname) | string | The name of the parent Database Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`analyticalStorageTtl`](#parameter-analyticalstoragettl) | int | Analytical TTL for the table. Default to 0 (disabled). Analytical store is enabled when set to a value other than 0. If set to -1, analytical store retains all historical data. |
| [`autoscaleSettingsMaxThroughput`](#parameter-autoscalesettingsmaxthroughput) | int | Maximum autoscale throughput for the table. Cannot be used with throughput. If not specified, the table will inherit throughput from the keyspace. |
| [`defaultTtl`](#parameter-defaultttl) | int | Default time to live in seconds. Default to 0 (disabled). If set to -1, items do not expire. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`tags`](#parameter-tags) | object | Tags of the Cassandra table resource. |
| [`throughput`](#parameter-throughput) | int | Request units per second. Cannot be used with autoscaleSettingsMaxThroughput. If not specified, the table will inherit throughput from the keyspace. |

### Parameter: `name`

Name of the Cassandra table.

- Required: Yes
- Type: string

### Parameter: `schema`

Schema definition for the Cassandra table.

- Required: Yes
- Type: object

### Parameter: `cassandraKeyspaceName`

The name of the parent Cassandra Keyspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `databaseAccountName`

The name of the parent Database Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `analyticalStorageTtl`

Analytical TTL for the table. Default to 0 (disabled). Analytical store is enabled when set to a value other than 0. If set to -1, analytical store retains all historical data.

- Required: No
- Type: int
- Default: `0`

### Parameter: `autoscaleSettingsMaxThroughput`

Maximum autoscale throughput for the table. Cannot be used with throughput. If not specified, the table will inherit throughput from the keyspace.

- Required: No
- Type: int

### Parameter: `defaultTtl`

Default time to live in seconds. Default to 0 (disabled). If set to -1, items do not expire.

- Required: No
- Type: int
- Default: `0`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `tags`

Tags of the Cassandra table resource.

- Required: No
- Type: object

### Parameter: `throughput`

Request units per second. Cannot be used with autoscaleSettingsMaxThroughput. If not specified, the table will inherit throughput from the keyspace.

- Required: No
- Type: int

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Cassandra table. |
| `resourceGroupName` | string | The name of the resource group the Cassandra table was created in. |
| `resourceId` | string | The resource ID of the Cassandra table. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
