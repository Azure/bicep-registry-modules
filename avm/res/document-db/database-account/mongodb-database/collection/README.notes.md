
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

