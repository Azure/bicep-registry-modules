# Azure NetApp Files Capacity Pools `[Microsoft.NetApp/netAppAccounts/capacityPools]`

This module deploys an Azure NetApp Files Capacity Pool.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.NetApp/netAppAccounts/capacityPools` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2022-11-01/netAppAccounts/capacityPools) |
| `Microsoft.NetApp/netAppAccounts/capacityPools/volumes` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2022-11-01/netAppAccounts/capacityPools/volumes) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the capacity pool. |
| [`size`](#parameter-size) | int | Provisioned size of the pool (in bytes). Allowed values are in 4TiB chunks (value must be multiply of 4398046511104). |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`netAppAccountName`](#parameter-netappaccountname) | string | The name of the parent NetApp account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`coolAccess`](#parameter-coolaccess) | bool | If enabled (true) the pool can contain cool Access enabled volumes. |
| [`encryptionType`](#parameter-encryptiontype) | string | Encryption type of the capacity pool, set encryption type for data at rest for this pool and all volumes in it. This value can only be set when creating new pool. |
| [`location`](#parameter-location) | string | Location of the pool volume. |
| [`qosType`](#parameter-qostype) | string | The qos type of the pool. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`serviceLevel`](#parameter-servicelevel) | string | The pool service level. |
| [`tags`](#parameter-tags) | object | Tags for all resources. |
| [`volumes`](#parameter-volumes) | array | List of volumnes to create in the capacity pool. |

### Parameter: `name`

The name of the capacity pool.

- Required: Yes
- Type: string

### Parameter: `size`

Provisioned size of the pool (in bytes). Allowed values are in 4TiB chunks (value must be multiply of 4398046511104).

- Required: Yes
- Type: int

### Parameter: `netAppAccountName`

The name of the parent NetApp account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `coolAccess`

If enabled (true) the pool can contain cool Access enabled volumes.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `encryptionType`

Encryption type of the capacity pool, set encryption type for data at rest for this pool and all volumes in it. This value can only be set when creating new pool.

- Required: No
- Type: string
- Default: `'Single'`
- Allowed:
  ```Bicep
  [
    'Double'
    'Single'
  ]
  ```

### Parameter: `location`

Location of the pool volume.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `qosType`

The qos type of the pool.

- Required: No
- Type: string
- Default: `'Auto'`
- Allowed:
  ```Bicep
  [
    'Auto'
    'Manual'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `serviceLevel`

The pool service level.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Premium'
    'Standard'
    'StandardZRS'
    'Ultra'
  ]
  ```

### Parameter: `tags`

Tags for all resources.

- Required: No
- Type: object

### Parameter: `volumes`

List of volumnes to create in the capacity pool.

- Required: No
- Type: array
- Default: `[]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Capacity Pool. |
| `resourceGroupName` | string | The name of the Resource Group the Capacity Pool was created in. |
| `resourceId` | string | The resource ID of the Capacity Pool. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
