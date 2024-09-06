# DocumentDB Database Account Gremlin Databases `[Microsoft.DocumentDB/databaseAccounts/gremlinDatabases]`

This module deploys a Gremlin Database within a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/gremlinDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/gremlinDatabases/graphs) |

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
| [`graphs`](#parameter-graphs) | array | Array of graphs to deploy in the Gremlin database. |
| [`maxThroughput`](#parameter-maxthroughput) | int | Represents maximum throughput, the resource can scale up to. Cannot be set together with `throughput`. If `throughput` is set to something else than -1, this autoscale setting is ignored. |
| [`tags`](#parameter-tags) | object | Tags of the Gremlin database resource. |
| [`throughput`](#parameter-throughput) | int | Request Units per second (for example 10000). Cannot be set together with `maxThroughput`. |

### Parameter: `name`

Name of the Gremlin database.

- Required: Yes
- Type: string

### Parameter: `databaseAccountName`

The name of the parent Gremlin database. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `graphs`

Array of graphs to deploy in the Gremlin database.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `maxThroughput`

Represents maximum throughput, the resource can scale up to. Cannot be set together with `throughput`. If `throughput` is set to something else than -1, this autoscale setting is ignored.

- Required: No
- Type: int
- Default: `4000`

### Parameter: `tags`

Tags of the Gremlin database resource.

- Required: No
- Type: object

### Parameter: `throughput`

Request Units per second (for example 10000). Cannot be set together with `maxThroughput`.

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
