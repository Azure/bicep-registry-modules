# DocumentDB Database Account Cassandra Keyspaces `[Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces]`

This module deploys a Cassandra Keyspace within a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_cassandrakeyspaces.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/cassandraKeyspaces)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces/tables` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_cassandrakeyspaces_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/cassandraKeyspaces/tables)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces/views` | 2025-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_cassandrakeyspaces_views.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-05-01-preview/databaseAccounts/cassandraKeyspaces/views)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Cassandra keyspace. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseAccountName`](#parameter-databaseaccountname) | string | The name of the parent Cosmos DB account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoscaleSettingsMaxThroughput`](#parameter-autoscalesettingsmaxthroughput) | int | Maximum autoscale throughput for the keyspace. If not set, autoscale will be disabled. Setting throughput at the keyspace level is only recommended for development/test or when workload across all tables in the shared throughput keyspace is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the table level. |
| [`tables`](#parameter-tables) | array | Array of Cassandra tables to deploy in the keyspace. |
| [`tags`](#parameter-tags) | object | Tags of the Cassandra keyspace resource. |
| [`throughput`](#parameter-throughput) | int | Request units per second. Cannot be used with autoscaleSettingsMaxThroughput. Setting throughput at the keyspace level is only recommended for development/test or when workload across all tables in the shared throughput keyspace is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the table level. |
| [`views`](#parameter-views) | array | Array of Cassandra views (materialized views) to deploy in the keyspace. |

### Parameter: `name`

Name of the Cassandra keyspace.

- Required: Yes
- Type: string

### Parameter: `databaseAccountName`

The name of the parent Cosmos DB account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `autoscaleSettingsMaxThroughput`

Maximum autoscale throughput for the keyspace. If not set, autoscale will be disabled. Setting throughput at the keyspace level is only recommended for development/test or when workload across all tables in the shared throughput keyspace is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the table level.

- Required: No
- Type: int
- Default: `4000`

### Parameter: `tables`

Array of Cassandra tables to deploy in the keyspace.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-tablesname) | string | Name of the table. |
| [`schema`](#parameter-tablesschema) | object | Schema definition for the table. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`analyticalStorageTtl`](#parameter-tablesanalyticalstoragettl) | int | Analytical TTL for the table. |
| [`autoscaleSettingsMaxThroughput`](#parameter-tablesautoscalesettingsmaxthroughput) | int | Maximum autoscale throughput for the table. Cannot be used with throughput. |
| [`defaultTtl`](#parameter-tablesdefaultttl) | int | Default TTL (Time To Live) in seconds for data in the table. |
| [`tags`](#parameter-tablestags) | object | Tags for the table. |
| [`throughput`](#parameter-tablesthroughput) | int | Request units per second. Cannot be used with autoscaleSettingsMaxThroughput. |

### Parameter: `tables.name`

Name of the table.

- Required: Yes
- Type: string

### Parameter: `tables.schema`

Schema definition for the table.

- Required: Yes
- Type: object

### Parameter: `tables.analyticalStorageTtl`

Analytical TTL for the table.

- Required: No
- Type: int

### Parameter: `tables.autoscaleSettingsMaxThroughput`

Maximum autoscale throughput for the table. Cannot be used with throughput.

- Required: No
- Type: int

### Parameter: `tables.defaultTtl`

Default TTL (Time To Live) in seconds for data in the table.

- Required: No
- Type: int

### Parameter: `tables.tags`

Tags for the table.

- Required: No
- Type: object

### Parameter: `tables.throughput`

Request units per second. Cannot be used with autoscaleSettingsMaxThroughput.

- Required: No
- Type: int

### Parameter: `tags`

Tags of the Cassandra keyspace resource.

- Required: No
- Type: object

### Parameter: `throughput`

Request units per second. Cannot be used with autoscaleSettingsMaxThroughput. Setting throughput at the keyspace level is only recommended for development/test or when workload across all tables in the shared throughput keyspace is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the table level.

- Required: No
- Type: int

### Parameter: `views`

Array of Cassandra views (materialized views) to deploy in the keyspace.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-viewsname) | string | Name of the view. |
| [`viewDefinition`](#parameter-viewsviewdefinition) | string | View definition (CQL statement). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoscaleSettingsMaxThroughput`](#parameter-viewsautoscalesettingsmaxthroughput) | int | Maximum autoscale throughput for the view. Cannot be used with throughput. |
| [`tags`](#parameter-viewstags) | object | Tags for the view. |
| [`throughput`](#parameter-viewsthroughput) | int | Request units per second. Cannot be used with autoscaleSettingsMaxThroughput. |

### Parameter: `views.name`

Name of the view.

- Required: Yes
- Type: string

### Parameter: `views.viewDefinition`

View definition (CQL statement).

- Required: Yes
- Type: string

### Parameter: `views.autoscaleSettingsMaxThroughput`

Maximum autoscale throughput for the view. Cannot be used with throughput.

- Required: No
- Type: int

### Parameter: `views.tags`

Tags for the view.

- Required: No
- Type: object

### Parameter: `views.throughput`

Request units per second. Cannot be used with autoscaleSettingsMaxThroughput.

- Required: No
- Type: int

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Cassandra keyspace. |
| `resourceGroupName` | string | The name of the resource group the Cassandra keyspace was created in. |
| `resourceId` | string | The resource ID of the Cassandra keyspace. |
