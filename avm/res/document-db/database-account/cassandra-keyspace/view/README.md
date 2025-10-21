# DocumentDB Database Account Cassandra Keyspaces Views `[Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces/views]`

This module deploys a Cassandra View (Materialized View) within a Cassandra Keyspace in a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
