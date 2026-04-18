# DocumentDB Database Accounts Gremlin Databases Graphs `[Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs]`

This module deploys a DocumentDB Database Accounts Gremlin Database Graph.

You can reference the module as follows:
```bicep
module databaseAccount 'br/public:avm/res/document-db/database-account/gremlin-database/graph:<version>' = {
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
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_gremlindatabases_graphs.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-04-15/databaseAccounts/gremlinDatabases/graphs)</li></ul> |

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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `indexingPolicy`

Indexing policy of the graph.

- Required: No
- Type: object

### Parameter: `partitionKeyPaths`

List of paths using which data within the container can be partitioned.

- Required: No
- Type: array

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

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
