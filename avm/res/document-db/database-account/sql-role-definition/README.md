# DocumentDB Database Account SQL Role Definitions. `[Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions]`

This module deploys a SQL Role Definision in a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleAssignments) |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleDefinitions) |

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
| [`assignableScopes`](#parameter-assignablescopes) | array | A set of fully qualified Scopes at or below which Role Assignments may be created using this Role Definition. This will allow application of this Role Definition on the entire database account or any underlying Database / Collection. Must have at least one element. Scopes higher than Database account are not enforceable as assignable Scopes. Note that resources referenced in assignable Scopes need not exist. Defaults to the current account. |
| [`dataActions`](#parameter-dataactions) | array | An array of data actions that are allowed. |
| [`name`](#parameter-name) | string | The unique identifier of the Role Definition. |
| [`sqlRoleAssignments`](#parameter-sqlroleassignments) | array | An array of SQL Role Assignments to be created for the SQL Role Definition. |

### Parameter: `roleName`

A user-friendly name for the Role Definition. Must be unique for the database account.

- Required: Yes
- Type: string

### Parameter: `databaseAccountName`

The name of the parent Database Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `assignableScopes`

A set of fully qualified Scopes at or below which Role Assignments may be created using this Role Definition. This will allow application of this Role Definition on the entire database account or any underlying Database / Collection. Must have at least one element. Scopes higher than Database account are not enforceable as assignable Scopes. Note that resources referenced in assignable Scopes need not exist. Defaults to the current account.

- Required: No
- Type: array

### Parameter: `dataActions`

An array of data actions that are allowed.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `name`

The unique identifier of the Role Definition.

- Required: No
- Type: string

### Parameter: `sqlRoleAssignments`

An array of SQL Role Assignments to be created for the SQL Role Definition.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-sqlroleassignmentsprincipalid) | string | The unique identifier for the associated AAD principal in the AAD graph to which access is being granted through this Role Assignment. Tenant ID for the principal is inferred using the tenant associated with the subscription. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-sqlroleassignmentsname) | string | Name unique identifier of the SQL Role Assignment. |

### Parameter: `sqlRoleAssignments.principalId`

The unique identifier for the associated AAD principal in the AAD graph to which access is being granted through this Role Assignment. Tenant ID for the principal is inferred using the tenant associated with the subscription.

- Required: Yes
- Type: string

### Parameter: `sqlRoleAssignments.name`

Name unique identifier of the SQL Role Assignment.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the SQL Role Definition. |
| `resourceGroupName` | string | The name of the resource group the SQL Role Definition was created in. |
| `resourceId` | string | The resource ID of the SQL Role Definition. |
| `roleName` | string | The role name of the SQL Role Definition. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `avm/res/document-db/database-account/sql-role-assignment` | Local reference |
