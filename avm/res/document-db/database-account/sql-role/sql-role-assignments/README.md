# DocumentDB Database Account SQL Role Assignments. `[Microsoft.DocumentDB/databaseaccount/sqlrole/sqlroleassignments]`

This module deploys a SQL Role Assignment in a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/sqlRoleAssignments) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the SQL Role Assignment. |
| [`principalId`](#parameter-principalid) | string | Id needs to be granted. |
| [`roleDefinitionId`](#parameter-roledefinitionid) | string | Id of the SQL Role Definition. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseAccountName`](#parameter-databaseaccountname) | string | The name of the parent Database Account. Required if the template is used in a standalone deployment. |

### Parameter: `name`

Name of the SQL Role Assignment.

- Required: Yes
- Type: string

### Parameter: `principalId`

Id needs to be granted.

- Required: No
- Type: string
- Default: `''`

### Parameter: `roleDefinitionId`

Id of the SQL Role Definition.

- Required: Yes
- Type: string

### Parameter: `databaseAccountName`

The name of the parent Database Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `resourceGroupName` | string | The name of the resource group the SQL Role Assignment was created in. |
