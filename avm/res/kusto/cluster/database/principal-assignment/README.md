# Kusto Cluster Database Principal Assignments `[Microsoft.Kusto/clusters/databases/principalAssignments]`

This module deploys a Kusto Cluster Database Principal Assignment.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Kusto/clusters/databases/principalAssignments` | [2024-04-13](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2024-04-13/clusters/databases/principalAssignments) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databasePrincipalAssignment`](#parameter-databaseprincipalassignment) | object | The principal assignement for the Kusto Cluster Database. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clusterName`](#parameter-clustername) | string | The name of the Kusto cluster. |
| [`databaseName`](#parameter-databasename) | string | The name of the parent Kusto Cluster Database. Required if the template is used in a standalone deployment. |

### Parameter: `databasePrincipalAssignment`

The principal assignement for the Kusto Cluster Database.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-databaseprincipalassignmentprincipalid) | string | The principal id assigned to the Kusto Cluster database principal. It can be a user email, application id, or security group name. |
| [`principalType`](#parameter-databaseprincipalassignmentprincipaltype) | string | The principal type of the principal id. |
| [`role`](#parameter-databaseprincipalassignmentrole) | string | The Kusto Cluster database role to be assigned to the principal id. |
| [`tenantId`](#parameter-databaseprincipalassignmenttenantid) | string | The tenant id of the principal. |

### Parameter: `databasePrincipalAssignment.principalId`

The principal id assigned to the Kusto Cluster database principal. It can be a user email, application id, or security group name.

- Required: Yes
- Type: string

### Parameter: `databasePrincipalAssignment.principalType`

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

### Parameter: `databasePrincipalAssignment.role`

The Kusto Cluster database role to be assigned to the principal id.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Admin'
    'Ingestor'
    'Monitor'
    'UnrestrictedViewer'
    'User'
    'Viewer'
  ]
  ```

### Parameter: `databasePrincipalAssignment.tenantId`

The tenant id of the principal.

- Required: Yes
- Type: string

### Parameter: `clusterName`

The name of the Kusto cluster.

- Required: Yes
- Type: string

### Parameter: `databaseName`

The name of the parent Kusto Cluster Database. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed Kusto Cluster Database Principal Assignment. |
| `resourceGroupName` | string | The resource group name of the deployed Kusto Cluster Database Principal Assignment. |
| `resourceId` | string | The resource id of the deployed Kusto Cluster Database Principal Assignment. |
