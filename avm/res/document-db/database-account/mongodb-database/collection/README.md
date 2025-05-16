# Azure Cosmos DB for MongoDB RU collection `[Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections]`

This module deploys an Azure Cosmos DB for MongoDB RU collection within a database.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/mongodbDatabases/collections) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the collection. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ancestorAccountName`](#parameter-ancestoraccountname) | string | The name of the parent Azure Cosmos DB for MongoDB RU account. Required if the template is used in a standalone deployment. |
| [`parentDatabaseName`](#parameter-parentdatabasename) | string | The name of the parent database. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoscaleMaxThroughput`](#parameter-autoscalemaxthroughput) | int | The maximum throughput for the collection when using autoscale. |
| [`indexes`](#parameter-indexes) | array | The indexes to create for the collection. |
| [`manualThroughput`](#parameter-manualthroughput) | int | The provisioned standard throughput assigned to the collection. |
| [`shardKeys`](#parameter-shardkeys) | array | The set of shard keys to use for the collection. |
| [`tags`](#parameter-tags) | object | Tags for the resource. |

### Parameter: `name`

The name of the collection.

- Required: Yes
- Type: string

### Parameter: `ancestorAccountName`

The name of the parent Azure Cosmos DB for MongoDB RU account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `parentDatabaseName`

The name of the parent database. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `autoscaleMaxThroughput`

The maximum throughput for the collection when using autoscale.

- Required: No
- Type: int

### Parameter: `indexes`

The indexes to create for the collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keys`](#parameter-indexeskeys) | array | The fields to use for the index. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ttl`](#parameter-indexesttl) | int | The time-to-live (TTL) for documents in the index, in seconds. |
| [`unique`](#parameter-indexesunique) | bool | Indicator for whether the index is unique. |

### Parameter: `indexes.keys`

The fields to use for the index.

- Required: Yes
- Type: array

### Parameter: `indexes.ttl`

The time-to-live (TTL) for documents in the index, in seconds.

- Required: No
- Type: int

### Parameter: `indexes.unique`

Indicator for whether the index is unique.

- Required: No
- Type: bool

### Parameter: `manualThroughput`

The provisioned standard throughput assigned to the collection.

- Required: No
- Type: int

### Parameter: `shardKeys`

The set of shard keys to use for the collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`field`](#parameter-shardkeysfield) | string | The field to use for the shard key. |
| [`type`](#parameter-shardkeystype) | string | The type of the shard key. Defaults to "Hash". Note that "Hash" is the only supported type at this time. |

### Parameter: `shardKeys.field`

The field to use for the shard key.

- Required: Yes
- Type: string

### Parameter: `shardKeys.type`

The type of the shard key. Defaults to "Hash". Note that "Hash" is the only supported type at this time.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Hash'
  ]
  ```

### Parameter: `tags`

Tags for the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the mongodb database collection. |
| `resourceGroupName` | string | The name of the resource group the mongodb database collection was created in. |
| `resourceId` | string | The resource ID of the mongodb database collection. |

## Notes

### Parameter Usage: `indexes`

Array of index keys as MongoIndex. The array contains keys for each MongoDB collection in the Azure Cosmos DB service with a collection resource object (as `key`) and collection index options (as `options`).

<details>

<summary>Parameter JSON format</summary>

```json
"indexes": {
    "value": [
        {
            "key": {
                "keys": [
                    "_id"
                ]
            }
        },
        {
            "key": {
                "keys": [
                    "$**"
                ]
            }
        },
        {
            "key": {
                "keys": [
                    "estate_id",
                    "estate_address"
                ]
            },
            "options": {
                "unique": true
            }
        },
        {
            "key": {
                "keys": [
                    "_ts"
                ]
            },
            "options": {
                "expireAfterSeconds": 2629746
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
indexes: [
    {
        key: {
            keys: [
                '_id'
            ]
        }
    }
    {
        key: {
            keys: [
                '$**'
            ]
        }
    }
    {
        key: {
            keys: [
                'estate_id'
                'estate_address'
            ]
        }
        options: {
            unique: true
        }
    }
    {
        key: {
            keys: [
                '_ts'
            ]
        }
        options: {
            expireAfterSeconds: 2629746
        }
    }
]
```

</details>
<p>

### Parameter Usage: `shardKey`

The shard key and partition kind pair, only support "Hash" partition kind.

<details>

<summary>Parameter JSON format</summary>

```json
"shardKey": {
    "value": {
        "estate_id": "Hash"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
shardKey: {
    estate_id: 'Hash'
}
```

</details>
<p>
