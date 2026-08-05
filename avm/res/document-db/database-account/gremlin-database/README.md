# DocumentDB Database Account Gremlin Databases `[Microsoft.DocumentDB/databaseAccounts/gremlinDatabases]`

This module deploys a Gremlin Database within a CosmosDB Account.

You can reference the module as follows:
```bicep
module databaseAccount 'br/public:avm/res/document-db/database-account/gremlin-database:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_gremlindatabases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-04-15/databaseAccounts/gremlinDatabases)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_gremlindatabases_graphs.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-04-15/databaseAccounts/gremlinDatabases/graphs)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Gremlin database. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseAccountName`](#parameter-databaseaccountname) | string | The name of the parent Gremlin database. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`graphs`](#parameter-graphs) | array | Array of graphs to deploy in the Gremlin database. |
| [`maxThroughput`](#parameter-maxthroughput) | int | Represents maximum throughput, the resource can scale up to. Cannot be set together with `throughput`. If `throughput` is set to something else than -1, this autoscale setting is ignored. Setting throughput at the database level is only recommended for development/test or when workload across all graphs in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the graph level and not at the database level. |
| [`tags`](#parameter-tags) | object | Tags of the Gremlin database resource. |
| [`throughput`](#parameter-throughput) | int | Request Units per second (for example 10000). Cannot be set together with `maxThroughput`. Setting throughput at the database level is only recommended for development/test or when workload across all graphs in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the graph level and not at the database level. |

### Parameter: `name`

Name of the Gremlin database.

- Required: Yes
- Type: string

### Parameter: `databaseAccountName`

The name of the parent Gremlin database. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `graphs`

Array of graphs to deploy in the Gremlin database.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-graphsname) | string | Name of the graph. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`indexingPolicy`](#parameter-graphsindexingpolicy) | object | Indexing policy of the graph. |
| [`partitionKeyPaths`](#parameter-graphspartitionkeypaths) | array | List of paths using which data within the container can be partitioned. |
| [`tags`](#parameter-graphstags) | object | Tags of the Gremlin graph resource. |

### Parameter: `graphs.name`

Name of the graph.

- Required: Yes
- Type: string

### Parameter: `graphs.indexingPolicy`

Indexing policy of the graph.

- Required: No
- Type: object

### Parameter: `graphs.partitionKeyPaths`

List of paths using which data within the container can be partitioned.

- Required: No
- Type: array

### Parameter: `graphs.tags`

Tags of the Gremlin graph resource.

- Required: No
- Type: object

### Parameter: `maxThroughput`

Represents maximum throughput, the resource can scale up to. Cannot be set together with `throughput`. If `throughput` is set to something else than -1, this autoscale setting is ignored. Setting throughput at the database level is only recommended for development/test or when workload across all graphs in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the graph level and not at the database level.

- Required: No
- Type: int
- Default: `4000`

### Parameter: `tags`

Tags of the Gremlin database resource.

- Required: No
- Type: object

### Parameter: `throughput`

Request Units per second (for example 10000). Cannot be set together with `maxThroughput`. Setting throughput at the database level is only recommended for development/test or when workload across all graphs in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the graph level and not at the database level.

- Required: No
- Type: int

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Gremlin database. |
| `resourceGroupName` | string | The name of the resource group the Gremlin database was created in. |
| `resourceId` | string | The resource ID of the Gremlin database. |

## Notes

### Parameter Usage: `graphs`

List of graph databaseAccounts.

<details>

<summary>Parameter JSON format</summary>

```json
"graphs": {
  "value": [
    {
      "name": "graph01",
      "automaticIndexing": true,
      "partitionKeyPaths": [
        "/name"
      ]
    },
    {
      "name": "graph02",
      "automaticIndexing": true,
      "partitionKeyPaths": [
        "/name"
      ]
    }
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
graphs: [
  {
    name: 'graph01'
    automaticIndexing: true
    partitionKeyPaths: [
      '/name'
    ]
  }
  {
    name: 'graph02'
    automaticIndexing: true
    partitionKeyPaths: [
      '/name'
    ]
  }
]
```

</details>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
