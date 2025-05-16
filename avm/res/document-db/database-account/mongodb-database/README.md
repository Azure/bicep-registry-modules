# Azure Cosmos DB for MongoDB RU database `[Microsoft.DocumentDB/databaseAccounts/mongodbDatabases]`

This module deploys an Azure Cosmos DB for MongoDB RU database within an account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/mongodbDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/mongodbDatabases/collections) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the database. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`parentAccountName`](#parameter-parentaccountname) | string | The name of the parent Azure Cosmos DB for MongoDB RU account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoscaleMaxThroughput`](#parameter-autoscalemaxthroughput) | int | The maximum throughput for the database when using autoscale. |
| [`collections`](#parameter-collections) | array | The set of collections within the database. |
| [`tags`](#parameter-tags) | object | Tags for the resource. |
| [`throughput`](#parameter-throughput) | int | The provisioned throughput assigned to the database. |

### Parameter: `name`

The name of the database.

- Required: Yes
- Type: string

### Parameter: `parentAccountName`

The name of the parent Azure Cosmos DB for MongoDB RU account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `autoscaleMaxThroughput`

The maximum throughput for the database when using autoscale.

- Required: No
- Type: int

### Parameter: `collections`

The set of collections within the database.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-collectionsname) | string | The name of the collection. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoscaleMaxThroughput`](#parameter-collectionsautoscalemaxthroughput) | int | The maximum throughput for the collection when using autoscale. |
| [`indexes`](#parameter-collectionsindexes) | array | The indexes to create for the collection. |
| [`shardKeys`](#parameter-collectionsshardkeys) | array | The set of shard keys to use for the collection. |
| [`tags`](#parameter-collectionstags) | object | Tags for the resource. |
| [`throughput`](#parameter-collectionsthroughput) | int | The provisioned throughput assigned to the collection. |

### Parameter: `collections.name`

The name of the collection.

- Required: Yes
- Type: string

### Parameter: `collections.autoscaleMaxThroughput`

The maximum throughput for the collection when using autoscale.

- Required: No
- Type: int

### Parameter: `collections.indexes`

The indexes to create for the collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keys`](#parameter-collectionsindexeskeys) | array | The fields to use for the index. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ttl`](#parameter-collectionsindexesttl) | int | The time-to-live (TTL) for documents in the index, in seconds. |
| [`unique`](#parameter-collectionsindexesunique) | bool | Indicator for whether the index is unique. |

### Parameter: `collections.indexes.keys`

The fields to use for the index.

- Required: Yes
- Type: array

### Parameter: `collections.indexes.ttl`

The time-to-live (TTL) for documents in the index, in seconds.

- Required: No
- Type: int

### Parameter: `collections.indexes.unique`

Indicator for whether the index is unique.

- Required: No
- Type: bool

### Parameter: `collections.shardKeys`

The set of shard keys to use for the collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`field`](#parameter-collectionsshardkeysfield) | string | The field to use for the shard key. |
| [`type`](#parameter-collectionsshardkeystype) | string | The type of the shard key. Defaults to "Hash". Note that "Hash" is the only supported type at this time. |

### Parameter: `collections.shardKeys.field`

The field to use for the shard key.

- Required: Yes
- Type: string

### Parameter: `collections.shardKeys.type`

The type of the shard key. Defaults to "Hash". Note that "Hash" is the only supported type at this time.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Hash'
  ]
  ```

### Parameter: `collections.tags`

Tags for the resource.

- Required: No
- Type: object

### Parameter: `collections.throughput`

The provisioned throughput assigned to the collection.

- Required: No
- Type: int

### Parameter: `tags`

Tags for the resource.

- Required: No
- Type: object

### Parameter: `throughput`

The provisioned throughput assigned to the database.

- Required: No
- Type: int

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the MongoDB database. |
| `resourceGroupName` | string | The name of the resource group the MongoDB database was created in. |
| `resourceId` | string | The resource ID of the MongoDB database. |
