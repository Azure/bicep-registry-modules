# DocumentDB Database Account MongoDB Database Collections `[Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections]`

This module deploys a MongoDB Database Collection.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/mongodbDatabases/collections) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`indexes`](#parameter-indexes) | array | Indexes for the collection. |
| [`name`](#parameter-name) | string | Name of the collection. |
| [`shardKey`](#parameter-shardkey) | object | ShardKey for the collection. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseAccountName`](#parameter-databaseaccountname) | string | The name of the parent Cosmos DB database account. Required if the template is used in a standalone deployment. |
| [`mongodbDatabaseName`](#parameter-mongodbdatabasename) | string | The name of the parent mongodb database. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`throughput`](#parameter-throughput) | int | Request Units per second. |

### Parameter: `indexes`

Indexes for the collection.

- Required: Yes
- Type: array

### Parameter: `name`

Name of the collection.

- Required: Yes
- Type: string

### Parameter: `shardKey`

ShardKey for the collection.

- Required: Yes
- Type: object

### Parameter: `databaseAccountName`

The name of the parent Cosmos DB database account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `mongodbDatabaseName`

The name of the parent mongodb database. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `throughput`

Request Units per second.

- Required: No
- Type: int
- Default: `400`

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
