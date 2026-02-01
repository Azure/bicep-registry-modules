# DocumentDB Database Account Cassandra Role Definitions. `[Microsoft.DocumentDB/databaseAccounts/cassandraRoleDefinitions]`

This module deploys a Cassandra Role Definition in a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/cassandraRoleAssignments` | 2025-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_cassandraroleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-05-01-preview/databaseAccounts/cassandraRoleAssignments)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/cassandraRoleDefinitions` | 2025-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_cassandraroledefinitions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-05-01-preview/databaseAccounts/cassandraRoleDefinitions)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`roleName`](#parameter-rolename) | string | A user-friendly name for the Role Definition. Must be unique for the database account. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseAccountName`](#parameter-databaseaccountname) | string | The name of the parent Database Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`assignableScopes`](#parameter-assignablescopes) | array | A set of fully qualified Scopes at or below which Role Assignments may be created using this Role Definition. This will allow application of this Role Definition on the entire database account or any underlying Database / Keyspace. Must have at least one element. Scopes higher than Database account are not enforceable as assignable Scopes. Note that resources referenced in assignable Scopes need not exist. Defaults to the current account. |
| [`cassandraRoleAssignments`](#parameter-cassandraroleassignments) | array | An array of Cassandra Role Assignments to be created for the Cassandra Role Definition. |
| [`dataActions`](#parameter-dataactions) | array | An array of data actions that are allowed. Note: Valid data action strings for Cassandra API are currently undocumented (as of API version 2025-05-01-preview). Please refer to official Azure documentation once available. |
| [`name`](#parameter-name) | string | The unique identifier of the Role Definition. |
| [`notDataActions`](#parameter-notdataactions) | array | An array of data actions that are denied. Note: Unlike SQL RBAC, Cassandra RBAC supports deny rules (notDataActions) for granular access control. Valid data action strings are currently undocumented (as of API version 2025-05-01-preview). |

### Parameter: `roleName`

A user-friendly name for the Role Definition. Must be unique for the database account.

- Required: Yes
- Type: string

### Parameter: `databaseAccountName`

The name of the parent Database Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `assignableScopes`

A set of fully qualified Scopes at or below which Role Assignments may be created using this Role Definition. This will allow application of this Role Definition on the entire database account or any underlying Database / Keyspace. Must have at least one element. Scopes higher than Database account are not enforceable as assignable Scopes. Note that resources referenced in assignable Scopes need not exist. Defaults to the current account.

- Required: No
- Type: array

### Parameter: `cassandraRoleAssignments`

An array of Cassandra Role Assignments to be created for the Cassandra Role Definition.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-cassandraroleassignmentsprincipalid) | string | The unique identifier for the associated AAD principal. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-cassandraroleassignmentsname) | string | The unique identifier of the role assignment. |
| [`scope`](#parameter-cassandraroleassignmentsscope) | string | The data plane resource path for which access is being granted. Defaults to the current account. |

### Parameter: `cassandraRoleAssignments.principalId`

The unique identifier for the associated AAD principal.

- Required: Yes
- Type: string

### Parameter: `cassandraRoleAssignments.name`

The unique identifier of the role assignment.

- Required: No
- Type: string

### Parameter: `cassandraRoleAssignments.scope`

The data plane resource path for which access is being granted. Defaults to the current account.

- Required: No
- Type: string

### Parameter: `dataActions`

An array of data actions that are allowed. Note: Valid data action strings for Cassandra API are currently undocumented (as of API version 2025-05-01-preview). Please refer to official Azure documentation once available.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `name`

The unique identifier of the Role Definition.

- Required: No
- Type: string

### Parameter: `notDataActions`

An array of data actions that are denied. Note: Unlike SQL RBAC, Cassandra RBAC supports deny rules (notDataActions) for granular access control. Valid data action strings are currently undocumented (as of API version 2025-05-01-preview).

- Required: No
- Type: array
- Default: `[]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the cassandra role definition. |
| `resourceGroupName` | string | The name of the resource group the cassandra role definition was created in. |
| `resourceId` | string | The resource ID of the cassandra role definition. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `avm/res/document-db/database-account/cassandra-role-assignment` | Local reference |
