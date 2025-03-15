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
| [`clusterPrincipalAssignment`](#parameter-clusterprincipalassignment) | object | The principal id assigned to the Kusto Cluster principal. It can be a user email, application id, or security group name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kustoClusterName`](#parameter-kustoclustername) | string | The name of the parent Kusto Cluster. Required if the template is used in a standalone deployment. |

### Parameter: `clusterPrincipalAssignment`

The principal id assigned to the Kusto Cluster principal. It can be a user email, application id, or security group name.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-clusterprincipalassignmentprincipalid) | string | The principal id assigned to the Kusto Cluster principal. It can be a user email, application id, or security group name. |
| [`principalType`](#parameter-clusterprincipalassignmentprincipaltype) | string | The principal type of the principal id. |
| [`role`](#parameter-clusterprincipalassignmentrole) | string | The Kusto Cluster role to be assigned to the principal id. |
| [`tenantId`](#parameter-clusterprincipalassignmenttenantid) | string | The tenant id of the principal. |

### Parameter: `clusterPrincipalAssignment.principalId`

The principal id assigned to the Kusto Cluster principal. It can be a user email, application id, or security group name.

- Required: Yes
- Type: string

### Parameter: `clusterPrincipalAssignment.principalType`

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

### Parameter: `clusterPrincipalAssignment.role`

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

### Parameter: `clusterPrincipalAssignment.tenantId`

The tenant id of the principal.

- Required: Yes
- Type: string

### Parameter: `kustoClusterName`

The name of the parent Kusto Cluster. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed Kusto Cluster Principal Assignment. |
| `resourceGroupName` | string | The resource group name of the deployed Kusto Cluster Principal Assignment. |
| `resourceId` | string | The resource id of the deployed Kusto Cluster Principal Assignment. |
