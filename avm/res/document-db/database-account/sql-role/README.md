# DocumentDB Database Account SQL Role. `[Microsoft.DocumentDB/databaseAccounts]`

This module deploys SQL Role Definision and Assignment in a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/sqlRoleAssignments) |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/sqlRoleDefinitions) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the SQL Role. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseAccountName`](#parameter-databaseaccountname) | string | The name of the parent Database Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataActions`](#parameter-dataactions) | array | An array of data actions that are allowed. |
| [`principalIds`](#parameter-principalids) | array | Ids needs to be granted. |
| [`roleName`](#parameter-rolename) | string | A user-friendly name for the Role Definition. Must be unique for the database account. |
| [`roleType`](#parameter-roletype) | string | Indicates whether the Role Definition was built-in or user created. |

### Parameter: `name`

Name of the SQL Role.

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

### Parameter: `principalIds`

Ids needs to be granted.

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
| `resourceGroupName` | string | The name of the resource group the SQL Role Definition and Assignment were created in. |
