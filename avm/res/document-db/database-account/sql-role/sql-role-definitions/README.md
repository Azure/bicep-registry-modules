# DocumentDB Database Account SQL Role Definitions. `[Microsoft.DocumentDB/databaseaccount/sqlrole/sqlroledefinitions]`

This module deploys a SQL Role Definision in a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/sqlRoleDefinitions) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseAccountName`](#parameter-databaseaccountname) | string | The name of the parent Database Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataActions`](#parameter-dataactions) | array | An array of data actions that are allowed. |
| [`roleName`](#parameter-rolename) | string | A user-friendly name for the Role Definition. Must be unique for the database account. |
| [`roleType`](#parameter-roletype) | string | Indicates whether the Role Definition was built-in or user created. |

### Parameter: `databaseAccountName`

The name of the parent Database Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `dataActions`

An array of data actions that are allowed.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `roleName`

A user-friendly name for the Role Definition. Must be unique for the database account.

- Required: No
- Type: string
- Default: `'Reader Writer'`

### Parameter: `roleType`

Indicates whether the Role Definition was built-in or user created.

- Required: No
- Type: string
- Default: `'CustomRole'`
- Allowed:
  ```Bicep
  [
    'BuiltInRole'
    'CustomRole'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the SQL database. |
| `resourceGroupName` | string | The name of the resource group the SQL database was created in. |
| `resourceId` | string | The resource ID of the SQL database. |
