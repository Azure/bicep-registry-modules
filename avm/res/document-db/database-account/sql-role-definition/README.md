# DocumentDB Database Account SQL Role Definitions. `[Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions]`

This module deploys a SQL Role Definision in a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
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
| [`dataActions`](#parameter-dataactions) | array | An array of data actions that are allowed. |
| [`name`](#parameter-name) | string | The unique identifier of the Role Definition. |
| [`roleType`](#parameter-roletype) | string | Indicates whether the Role Definition was built-in or user created. |

### Parameter: `roleName`

A user-friendly name for the Role Definition. Must be unique for the database account.

- Required: Yes
- Type: string

### Parameter: `databaseAccountName`

The name of the parent Database Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `dataActions`

An array of data actions that are allowed.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    'Microsoft.DocumentDB/databaseAccounts/readMetadata'
    'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
    'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
  ]
  ```

### Parameter: `name`

The unique identifier of the Role Definition.

- Required: No
- Type: string

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
| `name` | string | The name of the SQL Role Definition. |
| `resourceGroupName` | string | The name of the resource group the SQL Role Definition was created in. |
| `resourceId` | string | The resource ID of the SQL Role Definition. |
