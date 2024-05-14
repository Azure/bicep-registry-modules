# DocumentDB Database Account MongoDB Database Collections `[Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections]`

This module deploys a MongoDB Database Collection.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

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

## Cross-referenced modules

_None_

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
