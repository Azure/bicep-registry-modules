# DocumentDB Database Account MongoDB Databases `[Microsoft.DocumentDB/databaseAccounts/mongodbDatabases]`

This module deploys a MongoDB Database within a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/mongodbDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/mongodbDatabases/collections) |

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
| [`collections`](#parameter-collections) | array | Collections in the mongodb database. |
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

### Parameter: `collections`

Collections in the mongodb database.

- Required: No
- Type: array
- Default: `[]`

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
