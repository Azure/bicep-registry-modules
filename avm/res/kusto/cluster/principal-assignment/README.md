# Kusto Cluster Principal Assignments `[Microsoft.Kusto/clusters/principalAssignments]`

This module deploys a Kusto Cluster Principal Assignment.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Kusto/clusters/principalAssignments` | [2023-08-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2023-08-15/clusters/principalAssignments) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-principalid) | string | The principal id assigned to the Kusto Cluster principal. It can be a user email, application id, or security group name. |
| [`principalType`](#parameter-principaltype) | string | The principal type of the principal id. |
| [`role`](#parameter-role) | string | The Kusto Cluster role to be assigned to the principal id. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kustoClusterName`](#parameter-kustoclustername) | string | The name of the parent Kusto Cluster. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`tenantId`](#parameter-tenantid) | string | The tenant id of the principal id. |

### Parameter: `principalId`

The principal id assigned to the Kusto Cluster principal. It can be a user email, application id, or security group name.

- Required: Yes
- Type: string

### Parameter: `principalType`

The principal type of the principal id.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'App'
    'Group'
    'User'
  ]
  ```

### Parameter: `role`

The Kusto Cluster role to be assigned to the principal id.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AllDatabasesAdmin'
    'AllDatabasesViewer'
  ]
  ```

### Parameter: `kustoClusterName`

The name of the parent Kusto Cluster. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `tenantId`

The tenant id of the principal id.

- Required: No
- Type: string
- Default: `[tenant().tenantId]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed Kusto Cluster Principal Assignment. |
| `resourceGroupName` | string | The resource group name of the deployed Kusto Cluster Principal Assignment. |
| `resourceId` | string | The resource id of the deployed Kusto Cluster Principal Assignment. |
