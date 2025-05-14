# DocumentDB Database Account SQL Role Assignments. `[Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments]`

This module deploys a SQL Role Assignment in a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleAssignments) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-principalid) | string | The unique identifier for the associated AAD principal in the AAD graph to which access is being granted through this Role Assignment. Tenant ID for the principal is inferred using the tenant associated with the subscription. |
| [`roleDefinitionId`](#parameter-roledefinitionid) | string | The unique identifier of the associated SQL Role Definition. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseAccountName`](#parameter-databaseaccountname) | string | The name of the parent Database Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name unique identifier of the SQL Role Assignment. |

### Parameter: `principalId`

The unique identifier for the associated AAD principal in the AAD graph to which access is being granted through this Role Assignment. Tenant ID for the principal is inferred using the tenant associated with the subscription.

- Required: Yes
- Type: string

### Parameter: `roleDefinitionId`

The unique identifier of the associated SQL Role Definition.

- Required: Yes
- Type: string

### Parameter: `databaseAccountName`

The name of the parent Database Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `name`

Name unique identifier of the SQL Role Assignment.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the SQL Role Assignment. |
| `resourceGroupName` | string | The name of the resource group the SQL Role Definition was created in. |
| `resourceId` | string | The resource ID of the SQL Role Assignment. |
