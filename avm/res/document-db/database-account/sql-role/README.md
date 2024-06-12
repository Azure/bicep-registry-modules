# DocumentDB Database Account SQL Role. `[Microsoft.DocumentDB/databaseAccounts]`

This module deploys SQL Role Definision and Assignment in a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
