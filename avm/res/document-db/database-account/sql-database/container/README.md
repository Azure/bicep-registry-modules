# DocumentDB Database Account SQL Database Containers `[Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers]`

This module deploys a SQL Database Container in a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/sqlDatabases/containers) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the container. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseAccountName`](#parameter-databaseaccountname) | string | The name of the parent Database Account. Required if the template is used in a standalone deployment. |
| [`sqlDatabaseName`](#parameter-sqldatabasename) | string | The name of the parent SQL Database. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`analyticalStorageTtl`](#parameter-analyticalstoragettl) | int | Indicates how long data should be retained in the analytical store, for a container. Analytical store is enabled when ATTL is set with a value other than 0. If the value is set to -1, the analytical store retains all historical data, irrespective of the retention of the data in the transactional store. |
| [`autoscaleSettingsMaxThroughput`](#parameter-autoscalesettingsmaxthroughput) | int | Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to -1, then the property will be set to null and autoscale will be disabled. |
| [`conflictResolutionPolicy`](#parameter-conflictresolutionpolicy) | object | The conflict resolution policy for the container. Conflicts and conflict resolution policies are applicable if the Azure Cosmos DB account is configured with multiple write regions. |
| [`defaultTtl`](#parameter-defaultttl) | int | Default time to live (in seconds). With Time to Live or TTL, Azure Cosmos DB provides the ability to delete items automatically from a container after a certain time period. If the value is set to "-1", it is equal to infinity, and items dont expire by default. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`indexingPolicy`](#parameter-indexingpolicy) | object | Indexing policy of the container. |
| [`kind`](#parameter-kind) | string | Indicates the kind of algorithm used for partitioning. |
| [`paths`](#parameter-paths) | array | List of paths using which data within the container can be partitioned. |
| [`tags`](#parameter-tags) | object | Tags of the SQL Database resource. |
| [`throughput`](#parameter-throughput) | int | Request Units per second. Will be set to null if autoscaleSettingsMaxThroughput is used. |
| [`uniqueKeyPolicyKeys`](#parameter-uniquekeypolicykeys) | array | The unique key policy configuration containing a list of unique keys that enforces uniqueness constraint on documents in the collection in the Azure Cosmos DB service. |

### Parameter: `analyticalStorageTtl`

Indicates how long data should be retained in the analytical store, for a container. Analytical store is enabled when ATTL is set with a value other than 0. If the value is set to -1, the analytical store retains all historical data, irrespective of the retention of the data in the transactional store.
- Required: No
- Type: int
- Default: `0`

### Parameter: `autoscaleSettingsMaxThroughput`

Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to -1, then the property will be set to null and autoscale will be disabled.
- Required: No
- Type: int
- Default: `-1`

### Parameter: `conflictResolutionPolicy`

The conflict resolution policy for the container. Conflicts and conflict resolution policies are applicable if the Azure Cosmos DB account is configured with multiple write regions.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `databaseAccountName`

The name of the parent Database Account. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string

### Parameter: `defaultTtl`

Default time to live (in seconds). With Time to Live or TTL, Azure Cosmos DB provides the ability to delete items automatically from a container after a certain time period. If the value is set to "-1", it is equal to infinity, and items dont expire by default.
- Required: No
- Type: int
- Default: `-1`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `indexingPolicy`

Indexing policy of the container.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `kind`

Indicates the kind of algorithm used for partitioning.
- Required: No
- Type: string
- Default: `'Hash'`
- Allowed:
  ```Bicep
  [
    'Hash'
    'MultiHash'
    'Range'
  ]
  ```

### Parameter: `name`

Name of the container.
- Required: Yes
- Type: string

### Parameter: `paths`

List of paths using which data within the container can be partitioned.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `sqlDatabaseName`

The name of the parent SQL Database. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string

### Parameter: `tags`

Tags of the SQL Database resource.
- Required: No
- Type: object

### Parameter: `throughput`

Request Units per second. Will be set to null if autoscaleSettingsMaxThroughput is used.
- Required: No
- Type: int
- Default: `400`

### Parameter: `uniqueKeyPolicyKeys`

The unique key policy configuration containing a list of unique keys that enforces uniqueness constraint on documents in the collection in the Azure Cosmos DB service.
- Required: No
- Type: array
- Default: `[]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the container. |
| `resourceGroupName` | string | The name of the resource group the container was created in. |
| `resourceId` | string | The resource ID of the container. |

## Cross-referenced modules

_None_

## Notes

### Parameter Usage: `indexingPolicy`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

```json
"indexingPolicy": {
    "indexingMode": "consistent",
    "includedPaths": [
        {
            "path": "/*"
        }
    ],
    "excludedPaths": [
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
indexingPolicy: {
    indexingMode: 'consistent'
    includedPaths: [
    {
        path: '/*'
    }
    ]
    excludedPaths: []
}
```

</details>
<p>
