# DocumentDB Database Account Cassandra Keyspaces Views `[Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces/views]`

This module deploys a Cassandra View (Materialized View) within a Cassandra Keyspace in a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces/views` | 2025-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_cassandrakeyspaces_views.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-05-01-preview/databaseAccounts/cassandraKeyspaces/views)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Cassandra view. |
| [`viewDefinition`](#parameter-viewdefinition) | string | View definition of the Cassandra view. This is the CQL statement that defines the materialized view. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cassandraKeyspaceName`](#parameter-cassandrakeyspacename) | string | The name of the parent Cassandra Keyspace. Required if the template is used in a standalone deployment. |
| [`databaseAccountName`](#parameter-databaseaccountname) | string | The name of the parent Database Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoscaleSettingsMaxThroughput`](#parameter-autoscalesettingsmaxthroughput) | int | Maximum autoscale throughput for the view. Cannot be used with throughput. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`tags`](#parameter-tags) | object | Tags of the Cassandra view resource. |
| [`throughput`](#parameter-throughput) | int | Request units per second. Cannot be used with autoscaleSettingsMaxThroughput. |

### Parameter: `name`

Name of the Cassandra view.

- Required: Yes
- Type: string

### Parameter: `viewDefinition`

View definition of the Cassandra view. This is the CQL statement that defines the materialized view.

- Required: Yes
- Type: string

### Parameter: `cassandraKeyspaceName`

The name of the parent Cassandra Keyspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `databaseAccountName`

The name of the parent Database Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `autoscaleSettingsMaxThroughput`

Maximum autoscale throughput for the view. Cannot be used with throughput.

- Required: No
- Type: int

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `tags`

Tags of the Cassandra view resource.

- Required: No
- Type: object

### Parameter: `throughput`

Request units per second. Cannot be used with autoscaleSettingsMaxThroughput.

- Required: No
- Type: int

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Cassandra view. |
| `resourceGroupName` | string | The name of the resource group the Cassandra view was created in. |
| `resourceId` | string | The resource ID of the Cassandra view. |
