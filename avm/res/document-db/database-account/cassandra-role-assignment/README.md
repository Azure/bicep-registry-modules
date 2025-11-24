# DocumentDB Database Account Cassandra Role Assignments. `[Microsoft.DocumentDB/databaseAccounts/cassandraRoleAssignments]`

This module deploys a Cassandra Role Assignment in a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/cassandraRoleAssignments` | 2025-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_cassandraroleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-05-01-preview/databaseAccounts/cassandraRoleAssignments)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-principalid) | string | The unique identifier for the associated AAD principal in the AAD graph to which access is being granted through this Role Assignment. Tenant ID for the principal is inferred using the tenant associated with the subscription. |
| [`roleDefinitionId`](#parameter-roledefinitionid) | string | The unique identifier of the associated Cassandra Role Definition. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseAccountName`](#parameter-databaseaccountname) | string | The name of the parent Database Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name unique identifier of the Cassandra Role Assignment. |
| [`scope`](#parameter-scope) | string | The data plane resource path for which access is being granted through this Cassandra Role Assignment. Defaults to the current account. |

### Parameter: `principalId`

The unique identifier for the associated AAD principal in the AAD graph to which access is being granted through this Role Assignment. Tenant ID for the principal is inferred using the tenant associated with the subscription.

- Required: Yes
- Type: string

### Parameter: `roleDefinitionId`

The unique identifier of the associated Cassandra Role Definition.

- Required: Yes
- Type: string

### Parameter: `databaseAccountName`

The name of the parent Database Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `name`

Name unique identifier of the Cassandra Role Assignment.

- Required: No
- Type: string

### Parameter: `scope`

The data plane resource path for which access is being granted through this Cassandra Role Assignment. Defaults to the current account.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Cassandra Role Assignment. |
| `resourceGroupName` | string | The name of the resource group the Cassandra Role Assignment was created in. |
| `resourceId` | string | The resource ID of the Cassandra Role Assignment. |
