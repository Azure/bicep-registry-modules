# DocumentDB Database Accounts Gremlin Databases Graphs `[Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs]`

This module deploys a DocumentDB Database Accounts Gremlin Database Graph.

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
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/gremlinDatabases/graphs) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the graph. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseAccountName`](#parameter-databaseaccountname) | string | The name of the parent Database Account. Required if the template is used in a standalone deployment. |
| [`gremlinDatabaseName`](#parameter-gremlindatabasename) | string | The name of the parent Gremlin Database. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`indexingPolicy`](#parameter-indexingpolicy) | object | Indexing policy of the graph. |
| [`partitionKeyPaths`](#parameter-partitionkeypaths) | array | List of paths using which data within the container can be partitioned. |
| [`tags`](#parameter-tags) | object | Tags of the Gremlin graph resource. |

### Parameter: `name`

Name of the graph.

- Required: Yes
- Type: string

### Parameter: `databaseAccountName`

The name of the parent Database Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `gremlinDatabaseName`

The name of the parent Gremlin Database. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `indexingPolicy`

Indexing policy of the graph.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `partitionKeyPaths`

List of paths using which data within the container can be partitioned.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags of the Gremlin graph resource.

- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the graph. |
| `resourceGroupName` | string | The name of the resource group the graph was created in. |
| `resourceId` | string | The resource ID of the graph. |

## Cross-referenced modules

_None_

## Notes

### Parameter Usage: `partitionKeyPaths`, `uniqueKeyPaths`

Different kinds of paths can be provided as array of strings:

<details>

<summary>Bicep format</summary>

```bicep
graphs: [
  {
    name: 'graph01'
    automaticIndexing: true
    partitionKeyPaths: [
      '/name'
    ],

  }
  {
    name: 'graph02'
    automaticIndexing: true
    partitionKeyPaths: [
      '/address'
    ]
  }
]
```

</details>
<p>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
