# Azure Cosmos DB for MongoDB (vCore) cluster user `[Microsoft.DocumentDB/mongoClusters]`

This module creates a user within an Azure Cosmos DB for MongoDB (vCore) cluster. These users are used to connect to the cluster and perform operations using Microsoft Entra authentication.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/mongoClusters/users` | [2025-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/mongoClusters) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`targetIdentity`](#parameter-targetidentity) | object | The principal/identity to create as a user on the cluster. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`mongoClusterName`](#parameter-mongoclustername) | string | The name of the parent Azure Cosmos DB for MongoDB (vCore) cluster. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | Default to current resource group scope location. Location for all resources. |
| [`targetRoles`](#parameter-targetroles) | array | The roles to assign to the user per database. Defaults to the "dbOwner" role on the "admin" database. |

### Parameter: `targetIdentity`

The principal/identity to create as a user on the cluster.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-targetidentityprincipalid) | string | The principal (object) ID of the identity to create as a user on the cluster. |
| [`principalType`](#parameter-targetidentityprincipaltype) | string | The type of principal to be used for the identity provider. |

### Parameter: `targetIdentity.principalId`

The principal (object) ID of the identity to create as a user on the cluster.

- Required: Yes
- Type: string

### Parameter: `targetIdentity.principalType`

The type of principal to be used for the identity provider.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `mongoClusterName`

The name of the parent Azure Cosmos DB for MongoDB (vCore) cluster. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `location`

Default to current resource group scope location. Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `targetRoles`

The roles to assign to the user per database. Defaults to the "dbOwner" role on the "admin" database.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      database: 'admin'
      role: 'dbOwner'
    }
  ]
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`database`](#parameter-targetrolesdatabase) | string | The database to assign the role to. |
| [`role`](#parameter-targetrolesrole) | string | The role to assign to the user. |

### Parameter: `targetRoles.database`

The database to assign the role to.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'admin'
  ]
  ```

### Parameter: `targetRoles.role`

The role to assign to the user.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'dbOwner'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the user. |
| `resourceGroupName` | string | The name of the resource group the Azure Cosmos DB for MongoDB (vCore) cluster was created in. |
| `resourceId` | string | The resource ID of the user. |
