# Azure NetApp Files Capacity Pool Volumes `[Microsoft.NetApp/netAppAccounts/capacityPools/volumes]`

This module deploys an Azure NetApp Files Capacity Pool Volume.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.NetApp/netAppAccounts/capacityPools/volumes` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/capacityPools/volumes) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`coolAccess`](#parameter-coolaccess) | bool | If enabled (true) the pool can contain cool Access enabled volumes. |
| [`coolnessPeriod`](#parameter-coolnessperiod) | int | Specifies the number of days after which data that is not accessed by clients will be tiered. |
| [`encryptionKeySource`](#parameter-encryptionkeysource) | string | The source of the encryption key. |
| [`name`](#parameter-name) | string | The name of the pool volume. |
| [`replicationSchedule`](#parameter-replicationschedule) | string | The replication schedule for the volume. |
| [`subnetResourceId`](#parameter-subnetresourceid) | string | The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes. |
| [`usageThreshold`](#parameter-usagethreshold) | int | Maximum storage quota allowed for a file system in bytes. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacityPoolName`](#parameter-capacitypoolname) | string | The name of the parent capacity pool. Required if the template is used in a standalone deployment. |
| [`netAppAccountName`](#parameter-netappaccountname) | string | The name of the parent NetApp account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupPolicyName`](#parameter-backuppolicyname) | string | The name of the backup policy to link. |
| [`backupVaultResourceId`](#parameter-backupvaultresourceid) | string | The resource Id of the Backup Vault. |
| [`coolAccessRetrievalPolicy`](#parameter-coolaccessretrievalpolicy) | string | Determines the data retrieval behavior from the cool tier to standard storage based on the read pattern for cool access enabled volumes (Default/Never/Read). |
| [`creationToken`](#parameter-creationtoken) | string | A unique file path for the volume. This is the name of the volume export. A volume is mounted using the export path. File path must start with an alphabetical character and be unique within the subscription. |
| [`endpointType`](#parameter-endpointtype) | string | Indicates whether the local volume is the source or destination for the Volume Replication (src/dst). |
| [`exportPolicyRules`](#parameter-exportpolicyrules) | array | Export policy rules. |
| [`keyVaultPrivateEndpointResourceId`](#parameter-keyvaultprivateendpointresourceid) | string | The resource ID of the key vault private endpoint. |
| [`location`](#parameter-location) | string | Location of the pool volume. |
| [`networkFeatures`](#parameter-networkfeatures) | string | Network feature for the volume. |
| [`policyEnforced`](#parameter-policyenforced) | bool | If Backup policy is enforced. |
| [`protocolTypes`](#parameter-protocoltypes) | array | Set of protocol types. |
| [`replicationEnabled`](#parameter-replicationenabled) | bool | Enables replication. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`serviceLevel`](#parameter-servicelevel) | string | The pool service level. Must match the one of the parent capacity pool. |
| [`smbContinuouslyAvailable`](#parameter-smbcontinuouslyavailable) | bool | Enables continuously available share property for SMB volume. Only applicable for SMB volume. |
| [`smbEncryption`](#parameter-smbencryption) | bool | Enables SMB encryption. Only applicable for SMB/DualProtocol volume. |
| [`smbNonBrowsable`](#parameter-smbnonbrowsable) | string | Enables non-browsable property for SMB Shares. Only applicable for SMB/DualProtocol volume. |
| [`snapEnabled`](#parameter-snapenabled) | bool | Indicates whether the snapshot policy is enabled. |
| [`zones`](#parameter-zones) | array | Zone where the volume will be placed. |

### Parameter: `coolAccess`

If enabled (true) the pool can contain cool Access enabled volumes.

- Required: Yes
- Type: bool

### Parameter: `coolnessPeriod`

Specifies the number of days after which data that is not accessed by clients will be tiered.

- Required: Yes
- Type: int

### Parameter: `encryptionKeySource`

The source of the encryption key.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the pool volume.

- Required: Yes
- Type: string

### Parameter: `replicationSchedule`

The replication schedule for the volume.

- Required: No
- Type: string

### Parameter: `subnetResourceId`

The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes.

- Required: Yes
- Type: string

### Parameter: `usageThreshold`

Maximum storage quota allowed for a file system in bytes.

- Required: Yes
- Type: int

### Parameter: `capacityPoolName`

The name of the parent capacity pool. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `netAppAccountName`

The name of the parent NetApp account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `backupPolicyName`

The name of the backup policy to link.

- Required: No
- Type: string

### Parameter: `backupVaultResourceId`

The resource Id of the Backup Vault.

- Required: No
- Type: string

### Parameter: `coolAccessRetrievalPolicy`

Determines the data retrieval behavior from the cool tier to standard storage based on the read pattern for cool access enabled volumes (Default/Never/Read).

- Required: No
- Type: string
- Default: `'Default'`

### Parameter: `creationToken`

A unique file path for the volume. This is the name of the volume export. A volume is mounted using the export path. File path must start with an alphabetical character and be unique within the subscription.

- Required: No
- Type: string
- Default: `[parameters('name')]`

### Parameter: `endpointType`

Indicates whether the local volume is the source or destination for the Volume Replication (src/dst).

- Required: No
- Type: string

### Parameter: `exportPolicyRules`

Export policy rules.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `keyVaultPrivateEndpointResourceId`

The resource ID of the key vault private endpoint.

- Required: No
- Type: string

### Parameter: `location`

Location of the pool volume.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `networkFeatures`

Network feature for the volume.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Basic'
    'Basic_Standard'
    'Standard'
    'Standard_Basic'
  ]
  ```

### Parameter: `policyEnforced`

If Backup policy is enforced.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `protocolTypes`

Set of protocol types.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `remoteVolumeRegion`

The remote region for the other end of the Volume Replication.

- Required: No
- Type: string

### Parameter: `remoteVolumeResourceId`

The resource ID of the remote volume.

- Required: No
- Type: string

### Parameter: `replicationEnabled`

Enables replication.

- Required: No
- Type: bool
- Default: `True`

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

The pool service level. Must match the one of the parent capacity pool.

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

### Parameter: `smbContinuouslyAvailable`

Enables continuously available share property for SMB volume. Only applicable for SMB volume.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `smbEncryption`

Enables SMB encryption. Only applicable for SMB/DualProtocol volume.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `smbNonBrowsable`

Enables non-browsable property for SMB Shares. Only applicable for SMB/DualProtocol volume.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `snapEnabled`

The name of the snapshot policy to link.

- Required: No
- Type: string

### Parameter: `volumeType`

The type of the volume. DataProtection volumes are used for replication.

- Required: No
- Type: string

### Parameter: `zones`

Zone where the volume will be placed.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Volume. |
| `resourceGroupName` | string | The name of the Resource Group the Volume was created in. |
| `resourceId` | string | The Resource ID of the Volume. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.4.0` | Remote reference |
