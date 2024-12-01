# Azure NetApp Files Capacity Pools `[Microsoft.NetApp/netAppAccounts/capacityPools]`

This module deploys an Azure NetApp Files Capacity Pool.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.NetApp/netAppAccounts/capacityPools` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/capacityPools) |
| `Microsoft.NetApp/netAppAccounts/capacityPools/volumes` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/capacityPools/volumes) |

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
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

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
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
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

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-volumesname) | string | The name of the pool volume. |
| [`replicationSchedule`](#parameter-volumesreplicationschedule) | string | The replication schedule for the volume. |
| [`subnetResourceId`](#parameter-volumessubnetresourceid) | string | The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes. |
| [`usageThreshold`](#parameter-volumesusagethreshold) | int | Maximum storage quota allowed for a file system in bytes. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupPolicyName`](#parameter-volumesbackuppolicyname) | string | The name of the backup policy to link. |
| [`backupVaultResourceId`](#parameter-volumesbackupvaultresourceid) | string | The resource Id of the Backup Vault. |
| [`coolAccess`](#parameter-volumescoolaccess) | bool | If enabled (true) the pool can contain cool Access enabled volumes. |
| [`coolAccessRetrievalPolicy`](#parameter-volumescoolaccessretrievalpolicy) | string | Determines the data retrieval behavior from the cool tier to standard storage based on the read pattern for cool access enabled volumes (Default/Never/Read). |
| [`coolnessPeriod`](#parameter-volumescoolnessperiod) | int | Specifies the number of days after which data that is not accessed by clients will be tiered. |
| [`creationToken`](#parameter-volumescreationtoken) | string | A unique file path for the volume. This is the name of the volume export. A volume is mounted using the export path. File path must start with an alphabetical character and be unique within the subscription. |
| [`encryptionKeySource`](#parameter-volumesencryptionkeysource) | string | The source of the encryption key. |
| [`endpointType`](#parameter-volumesendpointtype) | string | Indicates whether the local volume is the source or destination for the Volume Replication (src/dst). |
| [`exportPolicyRules`](#parameter-volumesexportpolicyrules) | array | Export policy rules. |
| [`keyVaultPrivateEndpointResourceId`](#parameter-volumeskeyvaultprivateendpointresourceid) | string | The resource ID of the key vault private endpoint. |
| [`location`](#parameter-volumeslocation) | string | Location of the pool volume. |
| [`networkFeatures`](#parameter-volumesnetworkfeatures) | string | Network feature for the volume. |
| [`policyEnforced`](#parameter-volumespolicyenforced) | bool | If Backup policy is enforced. |
| [`protocolTypes`](#parameter-volumesprotocoltypes) | array | Set of protocol types. |
| [`remoteVolumeRegion`](#parameter-volumesremotevolumeregion) | string | The remote region for the other end of the Volume Replication. |
| [`remoteVolumeResourceId`](#parameter-volumesremotevolumeresourceid) | string | The resource ID of the remote volume. |
| [`replicationEnabled`](#parameter-volumesreplicationenabled) | bool | Boolean to enable replication. |
| [`roleAssignments`](#parameter-volumesroleassignments) | array | Array of role assignments to create. |
| [`serviceLevel`](#parameter-volumesservicelevel) | string | The pool service level. Must match the one of the parent capacity pool. |
| [`snapshotPolicyName`](#parameter-volumessnapshotpolicyname) | string | The name of the snapshot policy to link. |
| [`volumeType`](#parameter-volumesvolumetype) | string | The type of the volume. DataProtection volumes are used for replication. |
| [`zones`](#parameter-volumeszones) | array | Zone where the volume will be placed. |

### Parameter: `volumes.name`

The name of the pool volume.

- Required: Yes
- Type: string

### Parameter: `volumes.replicationSchedule`

The replication schedule for the volume.

- Required: No
- Type: string

### Parameter: `volumes.subnetResourceId`

The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes.

- Required: Yes
- Type: string

### Parameter: `volumes.usageThreshold`

Maximum storage quota allowed for a file system in bytes.

- Required: Yes
- Type: int

### Parameter: `volumes.backupPolicyName`

The name of the backup policy to link.

- Required: No
- Type: string

### Parameter: `volumes.backupVaultResourceId`

The resource Id of the Backup Vault.

- Required: No
- Type: string

### Parameter: `volumes.coolAccess`

If enabled (true) the pool can contain cool Access enabled volumes.

- Required: No
- Type: bool

### Parameter: `volumes.coolAccessRetrievalPolicy`

Determines the data retrieval behavior from the cool tier to standard storage based on the read pattern for cool access enabled volumes (Default/Never/Read).

- Required: No
- Type: string

### Parameter: `volumes.coolnessPeriod`

Specifies the number of days after which data that is not accessed by clients will be tiered.

- Required: No
- Type: int

### Parameter: `volumes.creationToken`

A unique file path for the volume. This is the name of the volume export. A volume is mounted using the export path. File path must start with an alphabetical character and be unique within the subscription.

- Required: No
- Type: string

### Parameter: `volumes.encryptionKeySource`

The source of the encryption key.

- Required: No
- Type: string

### Parameter: `volumes.endpointType`

Indicates whether the local volume is the source or destination for the Volume Replication (src/dst).

- Required: No
- Type: string

### Parameter: `volumes.exportPolicyRules`

Export policy rules.

- Required: No
- Type: array

### Parameter: `volumes.keyVaultPrivateEndpointResourceId`

The resource ID of the key vault private endpoint.

- Required: No
- Type: string

### Parameter: `volumes.location`

Location of the pool volume.

- Required: No
- Type: string

### Parameter: `volumes.networkFeatures`

Network feature for the volume.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Basic_Standard'
    'Standard'
    'Standard_Basic'
  ]
  ```

### Parameter: `volumes.policyEnforced`

If Backup policy is enforced.

- Required: No
- Type: bool

### Parameter: `volumes.protocolTypes`

Set of protocol types.

- Required: No
- Type: array

### Parameter: `volumes.remoteVolumeRegion`

The remote region for the other end of the Volume Replication.

- Required: No
- Type: string

### Parameter: `volumes.remoteVolumeResourceId`

The resource ID of the remote volume.

- Required: No
- Type: string

### Parameter: `volumes.replicationEnabled`

Boolean to enable replication.

- Required: No
- Type: bool

### Parameter: `volumes.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-volumesroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-volumesroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-volumesroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-volumesroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-volumesroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-volumesroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-volumesroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-volumesroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `volumes.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `volumes.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `volumes.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `volumes.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `volumes.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `volumes.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `volumes.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `volumes.roleAssignments.principalType`

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

### Parameter: `volumes.serviceLevel`

The pool service level. Must match the one of the parent capacity pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Premium'
    'Standard'
    'StandardZRS'
    'Ultra'
  ]
  ```

### Parameter: `volumes.snapshotPolicyName`

The name of the snapshot policy to link.

- Required: No
- Type: string

### Parameter: `volumes.volumeType`

The type of the volume. DataProtection volumes are used for replication.

- Required: No
- Type: string

### Parameter: `volumes.zones`

Zone where the volume will be placed.

- Required: No
- Type: array

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Capacity Pool. |
| `resourceGroupName` | string | The name of the Resource Group the Capacity Pool was created in. |
| `resourceId` | string | The resource ID of the Capacity Pool. |
| `volumeResourceId` | string | The resource IDs of the volume created in the capacity pool. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.4.0` | Remote reference |
