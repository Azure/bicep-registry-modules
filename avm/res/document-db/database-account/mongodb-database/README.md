# DocumentDB Database Account MongoDB Databases `[Microsoft.DocumentDB/databaseAccounts/mongodbDatabases]`

This module deploys a MongoDB Database within a CosmosDB Account.

You can reference the module as follows:
```bicep
module databaseAccount 'br/public:avm/res/document-db/database-account/mongodb-database:<version>' = {
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
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_mongodbdatabases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-04-15/databaseAccounts/mongodbDatabases)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_mongodbdatabases_collections.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-04-15/databaseAccounts/mongodbDatabases/collections)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the mongodb database. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseAccountName`](#parameter-databaseaccountname) | string | The name of the parent Cosmos DB database account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoscaleSettings`](#parameter-autoscalesettings) | object | Specifies the Autoscale settings. Note: Either throughput or autoscaleSettings is required, but not both. |
| [`collections`](#parameter-collections) | array | Collections in the mongodb database. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`throughput`](#parameter-throughput) | int | Request Units per second. Setting throughput at the database level is only recommended for development/test or when workload across all collections in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the collection level and not at the database level. |

### Parameter: `name`

Name of the mongodb database.

- Required: Yes
- Type: string

### Parameter: `databaseAccountName`

The name of the parent Cosmos DB database account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `autoscaleSettings`

Specifies the Autoscale settings. Note: Either throughput or autoscaleSettings is required, but not both.

- Required: No
- Type: object

### Parameter: `collections`

Collections in the mongodb database.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`indexes`](#parameter-collectionsindexes) | array | Indexes for the collection. |
| [`name`](#parameter-collectionsname) | string | Name of the collection. |
| [`shardKey`](#parameter-collectionsshardkey) | object | ShardKey for the collection. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`throughput`](#parameter-collectionsthroughput) | int | Request Units per second. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the collection level and not at the database level. |

### Parameter: `collections.indexes`

Indexes for the collection.

- Required: Yes
- Type: array

### Parameter: `collections.name`

Name of the collection.

- Required: Yes
- Type: string

### Parameter: `collections.shardKey`

ShardKey for the collection.

- Required: Yes
- Type: object

### Parameter: `collections.throughput`

Request Units per second. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the collection level and not at the database level.

- Required: No
- Type: int

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `throughput`

Request Units per second. Setting throughput at the database level is only recommended for development/test or when workload across all collections in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the collection level and not at the database level.

- Required: No
- Type: int
- Default: `400`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the mongodb database. |
| `resourceGroupName` | string | The name of the resource group the mongodb database was created in. |
| `resourceId` | string | The resource ID of the mongodb database. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
