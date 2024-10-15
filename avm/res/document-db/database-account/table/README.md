# DocumentDB Database Account Gremlin Databases `[Microsoft.DocumentDB/databaseAccounts/gremlinDatabases]`

This module deploys a Table within an Azure Cosmos DB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/tables` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/tables) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the table. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseAccountName`](#parameter-databaseaccountname) | string | The name of the parent Azure Cosmos DB for Table account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`tags`](#parameter-tags) | object | Tags of the Gremlin database resource. |
| [`maxThroughput`](#parameter-maxthroughput) | int | Represents maximum throughput, the resource can scale up to. Cannot be set together with `throughput`. If `throughput` is set to something else than -1, this autoscale setting is ignored. |
| [`throughput`](#parameter-throughput) | int | Request Units per second (for example 10000). Cannot be set together with `maxThroughput`. |

### Parameter: `name`

Name of the table.

- Required: Yes
- Type: string

### Parameter: `databaseAccountName`

The name of the parent Azure Cosmos DB for Table account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `tags`

Tags of the Gremlin database resource.

- Required: No
- Type: object

### Parameter: `maxThroughput`

Represents maximum throughput, the resource can scale up to. Cannot be set together with `throughput`. If `throughput` is set to something else than -1, this autoscale setting is ignored.

- Required: No
- Type: int
- Default: `4000`

### Parameter: `throughput`

Request Units per second (for example 10000). Cannot be set together with `maxThroughput`.

- Required: No
- Type: int

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the table. |
| `resourceGroupName` | string | The name of the resource group the Azure Cosmos DB for Table account was created in. |
| `resourceId` | string | The resource ID of the table. |
