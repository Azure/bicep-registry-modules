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
| `Microsoft.NetApp/netAppAccounts/capacityPools` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2025-01-01/netAppAccounts/capacityPools) |
| `Microsoft.NetApp/netAppAccounts/capacityPools/volumes` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2025-01-01/netAppAccounts/capacityPools/volumes) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the capacity pool. |
| [`size`](#parameter-size) | int | Provisioned size of the pool in Tebibytes (TiB). |

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
| [`volumes`](#parameter-volumes) | array | List of volumes to create in the capacity pool. |

### Parameter: `name`

The name of the capacity pool.

- Required: Yes
- Type: string

### Parameter: `size`

Provisioned size of the pool in Tebibytes (TiB).

- Required: Yes
- Type: int
- MinValue: 1
- MaxValue: 2048

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

List of volumes to create in the capacity pool.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-volumesname) | string | The name of the pool volume. |
| [`subnetResourceId`](#parameter-volumessubnetresourceid) | string | The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes. |
| [`usageThreshold`](#parameter-volumesusagethreshold) | int | Maximum storage quota allowed for a file system in bytes. |
| [`zone`](#parameter-volumeszone) | int | The Availability Zone to place the resource in. If set to 0, then Availability Zone is not set. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`coolAccess`](#parameter-volumescoolaccess) | bool | If enabled (true) the pool can contain cool Access enabled volumes. |
| [`coolAccessRetrievalPolicy`](#parameter-volumescoolaccessretrievalpolicy) | string | Determines the data retrieval behavior from the cool tier to standard storage based on the read pattern for cool access enabled volumes (Default/Never/Read). |
| [`coolnessPeriod`](#parameter-volumescoolnessperiod) | int | Specifies the number of days after which data that is not accessed by clients will be tiered. |
| [`creationToken`](#parameter-volumescreationtoken) | string | A unique file path for the volume. This is the name of the volume export. A volume is mounted using the export path. File path must start with an alphabetical character and be unique within the subscription. |
| [`dataProtection`](#parameter-volumesdataprotection) | object | DataProtection type volumes include an object containing details of the replication. |
| [`encryptionKeySource`](#parameter-volumesencryptionkeysource) | string | The source of the encryption key. |
| [`exportPolicy`](#parameter-volumesexportpolicy) | object | Export policy rules. |
| [`kerberosEnabled`](#parameter-volumeskerberosenabled) | bool | Define if a volume is KerberosEnabled. |
| [`keyVaultPrivateEndpointResourceId`](#parameter-volumeskeyvaultprivateendpointresourceid) | string | The resource ID of the key vault private endpoint. |
| [`location`](#parameter-volumeslocation) | string | Location of the pool volume. |
| [`networkFeatures`](#parameter-volumesnetworkfeatures) | string | Network feature for the volume. |
| [`protocolTypes`](#parameter-volumesprotocoltypes) | array | Set of protocol types. Default value is `['NFSv3']`. If you are creating a dual-stack volume, set either `['NFSv3','CIFS']` or `['NFSv4.1','CIFS']`. |
| [`roleAssignments`](#parameter-volumesroleassignments) | array | Array of role assignments to create. |
| [`serviceLevel`](#parameter-volumesservicelevel) | string | The pool service level. Must match the one of the parent capacity pool. |
| [`smbContinuouslyAvailable`](#parameter-volumessmbcontinuouslyavailable) | bool | Enables continuously available share property for SMB volume. Only applicable for SMB volume. |
| [`smbEncryption`](#parameter-volumessmbencryption) | bool | Enables SMB encryption. Only applicable for SMB/DualProtocol volume. |
| [`smbNonBrowsable`](#parameter-volumessmbnonbrowsable) | string | Enables non-browsable property for SMB Shares. Only applicable for SMB/DualProtocol volume. |
| [`throughputMibps`](#parameter-volumesthroughputmibps) | int | The throughput in MiBps for the NetApp account. |
| [`volumeType`](#parameter-volumesvolumetype) | string | The type of the volume. DataProtection volumes are used for replication. |

### Parameter: `volumes.name`

The name of the pool volume.

- Required: Yes
- Type: string

### Parameter: `volumes.subnetResourceId`

The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes.

- Required: Yes
- Type: string

### Parameter: `volumes.usageThreshold`

Maximum storage quota allowed for a file system in bytes.

- Required: Yes
- Type: int

### Parameter: `volumes.zone`

The Availability Zone to place the resource in. If set to 0, then Availability Zone is not set.

- Required: Yes
- Type: int

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

### Parameter: `volumes.dataProtection`

DataProtection type volumes include an object containing details of the replication.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backup`](#parameter-volumesdataprotectionbackup) | object | Backup properties. |
| [`replication`](#parameter-volumesdataprotectionreplication) | object | Replication properties. |
| [`snapshot`](#parameter-volumesdataprotectionsnapshot) | object | Snapshot properties. |

### Parameter: `volumes.dataProtection.backup`

Backup properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupPolicyName`](#parameter-volumesdataprotectionbackupbackuppolicyname) | string | The name of the backup policy to link. |
| [`backupVaultName`](#parameter-volumesdataprotectionbackupbackupvaultname) | string | The name of the Backup Vault. |
| [`policyEnforced`](#parameter-volumesdataprotectionbackuppolicyenforced) | bool | Enable to enforce the policy. |

### Parameter: `volumes.dataProtection.backup.backupPolicyName`

The name of the backup policy to link.

- Required: Yes
- Type: string

### Parameter: `volumes.dataProtection.backup.backupVaultName`

The name of the Backup Vault.

- Required: Yes
- Type: string

### Parameter: `volumes.dataProtection.backup.policyEnforced`

Enable to enforce the policy.

- Required: Yes
- Type: bool

### Parameter: `volumes.dataProtection.replication`

Replication properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endpointType`](#parameter-volumesdataprotectionreplicationendpointtype) | string | Indicates whether the local volume is the source or destination for the Volume Replication. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`remotePath`](#parameter-volumesdataprotectionreplicationremotepath) | object | The full path to a volume that is to be migrated into ANF. Required for Migration volumes. |
| [`remoteVolumeRegion`](#parameter-volumesdataprotectionreplicationremotevolumeregion) | string | The remote region for the other end of the Volume Replication.Required for Data Protection volumes. |
| [`remoteVolumeResourceId`](#parameter-volumesdataprotectionreplicationremotevolumeresourceid) | string | The resource ID of the remote volume. Required for Data Protection volumes. |
| [`replicationSchedule`](#parameter-volumesdataprotectionreplicationreplicationschedule) | string | The replication schedule for the volume (to only be set on the destination (dst)). |

### Parameter: `volumes.dataProtection.replication.endpointType`

Indicates whether the local volume is the source or destination for the Volume Replication.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'dst'
    'src'
  ]
  ```

### Parameter: `volumes.dataProtection.replication.remotePath`

The full path to a volume that is to be migrated into ANF. Required for Migration volumes.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`externalHostName`](#parameter-volumesdataprotectionreplicationremotepathexternalhostname) | string | The Path to a ONTAP Host. |
| [`serverName`](#parameter-volumesdataprotectionreplicationremotepathservername) | string | The name of a server on the ONTAP Host. |
| [`volumeName`](#parameter-volumesdataprotectionreplicationremotepathvolumename) | string | The name of a volume on the server. |

### Parameter: `volumes.dataProtection.replication.remotePath.externalHostName`

The Path to a ONTAP Host.

- Required: Yes
- Type: string

### Parameter: `volumes.dataProtection.replication.remotePath.serverName`

The name of a server on the ONTAP Host.

- Required: Yes
- Type: string

### Parameter: `volumes.dataProtection.replication.remotePath.volumeName`

The name of a volume on the server.

- Required: Yes
- Type: string

### Parameter: `volumes.dataProtection.replication.remoteVolumeRegion`

The remote region for the other end of the Volume Replication.Required for Data Protection volumes.

- Required: No
- Type: string

### Parameter: `volumes.dataProtection.replication.remoteVolumeResourceId`

The resource ID of the remote volume. Required for Data Protection volumes.

- Required: No
- Type: string

### Parameter: `volumes.dataProtection.replication.replicationSchedule`

The replication schedule for the volume (to only be set on the destination (dst)).

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '_10minutely'
    'daily'
    'hourly'
  ]
  ```

### Parameter: `volumes.dataProtection.snapshot`

Snapshot properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`snapshotPolicyName`](#parameter-volumesdataprotectionsnapshotsnapshotpolicyname) | string | The name of the snapshot policy to link. |

### Parameter: `volumes.dataProtection.snapshot.snapshotPolicyName`

The name of the snapshot policy to link.

- Required: Yes
- Type: string

### Parameter: `volumes.encryptionKeySource`

The source of the encryption key.

- Required: No
- Type: string

### Parameter: `volumes.exportPolicy`

Export policy rules.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`rules`](#parameter-volumesexportpolicyrules) | array | The Export policy rules. |

### Parameter: `volumes.exportPolicy.rules`

The Export policy rules.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kerberos5iReadOnly`](#parameter-volumesexportpolicyruleskerberos5ireadonly) | bool | Kerberos5i Read only access. |
| [`kerberos5iReadWrite`](#parameter-volumesexportpolicyruleskerberos5ireadwrite) | bool | Kerberos5i Read and write access. |
| [`kerberos5pReadOnly`](#parameter-volumesexportpolicyruleskerberos5preadonly) | bool | Kerberos5p Read only access. |
| [`kerberos5pReadWrite`](#parameter-volumesexportpolicyruleskerberos5preadwrite) | bool | Kerberos5p Read and write access. |
| [`kerberos5ReadOnly`](#parameter-volumesexportpolicyruleskerberos5readonly) | bool | Kerberos5 Read only access. |
| [`kerberos5ReadWrite`](#parameter-volumesexportpolicyruleskerberos5readwrite) | bool | Kerberos5 Read and write access. |
| [`nfsv3`](#parameter-volumesexportpolicyrulesnfsv3) | bool | Allows NFSv3 protocol. Enable only for NFSv3 type volumes. |
| [`nfsv41`](#parameter-volumesexportpolicyrulesnfsv41) | bool | Allows NFSv4.1 protocol. Enable only for NFSv4.1 type volumes. |
| [`ruleIndex`](#parameter-volumesexportpolicyrulesruleindex) | int | Order index. |
| [`unixReadOnly`](#parameter-volumesexportpolicyrulesunixreadonly) | bool | Read only access. |
| [`unixReadWrite`](#parameter-volumesexportpolicyrulesunixreadwrite) | bool | Read and write access. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedClients`](#parameter-volumesexportpolicyrulesallowedclients) | string | Client ingress specification as comma separated string with IPv4 CIDRs, IPv4 host addresses and host names. |
| [`chownMode`](#parameter-volumesexportpolicyruleschownmode) | string | This parameter specifies who is authorized to change the ownership of a file. restricted - Only root user can change the ownership of the file. unrestricted - Non-root users can change ownership of files that they own. |
| [`cifs`](#parameter-volumesexportpolicyrulescifs) | bool | Allows CIFS protocol. |
| [`hasRootAccess`](#parameter-volumesexportpolicyruleshasrootaccess) | bool | Has root access to volume. |

### Parameter: `volumes.exportPolicy.rules.kerberos5iReadOnly`

Kerberos5i Read only access.

- Required: Yes
- Type: bool

### Parameter: `volumes.exportPolicy.rules.kerberos5iReadWrite`

Kerberos5i Read and write access.

- Required: Yes
- Type: bool

### Parameter: `volumes.exportPolicy.rules.kerberos5pReadOnly`

Kerberos5p Read only access.

- Required: Yes
- Type: bool

### Parameter: `volumes.exportPolicy.rules.kerberos5pReadWrite`

Kerberos5p Read and write access.

- Required: Yes
- Type: bool

### Parameter: `volumes.exportPolicy.rules.kerberos5ReadOnly`

Kerberos5 Read only access.

- Required: Yes
- Type: bool

### Parameter: `volumes.exportPolicy.rules.kerberos5ReadWrite`

Kerberos5 Read and write access.

- Required: Yes
- Type: bool

### Parameter: `volumes.exportPolicy.rules.nfsv3`

Allows NFSv3 protocol. Enable only for NFSv3 type volumes.

- Required: Yes
- Type: bool

### Parameter: `volumes.exportPolicy.rules.nfsv41`

Allows NFSv4.1 protocol. Enable only for NFSv4.1 type volumes.

- Required: Yes
- Type: bool

### Parameter: `volumes.exportPolicy.rules.ruleIndex`

Order index.

- Required: Yes
- Type: int

### Parameter: `volumes.exportPolicy.rules.unixReadOnly`

Read only access.

- Required: Yes
- Type: bool

### Parameter: `volumes.exportPolicy.rules.unixReadWrite`

Read and write access.

- Required: Yes
- Type: bool

### Parameter: `volumes.exportPolicy.rules.allowedClients`

Client ingress specification as comma separated string with IPv4 CIDRs, IPv4 host addresses and host names.

- Required: No
- Type: string

### Parameter: `volumes.exportPolicy.rules.chownMode`

This parameter specifies who is authorized to change the ownership of a file. restricted - Only root user can change the ownership of the file. unrestricted - Non-root users can change ownership of files that they own.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Restricted'
    'Unrestricted'
  ]
  ```

### Parameter: `volumes.exportPolicy.rules.cifs`

Allows CIFS protocol.

- Required: No
- Type: bool

### Parameter: `volumes.exportPolicy.rules.hasRootAccess`

Has root access to volume.

- Required: No
- Type: bool

### Parameter: `volumes.kerberosEnabled`

Define if a volume is KerberosEnabled.

- Required: No
- Type: bool

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

### Parameter: `volumes.protocolTypes`

Set of protocol types. Default value is `['NFSv3']`. If you are creating a dual-stack volume, set either `['NFSv3','CIFS']` or `['NFSv4.1','CIFS']`.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'CIFS'
    'NFSv3'
    'NFSv4.1'
  ]
  ```

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

### Parameter: `volumes.smbContinuouslyAvailable`

Enables continuously available share property for SMB volume. Only applicable for SMB volume.

- Required: No
- Type: bool

### Parameter: `volumes.smbEncryption`

Enables SMB encryption. Only applicable for SMB/DualProtocol volume.

- Required: No
- Type: bool

### Parameter: `volumes.smbNonBrowsable`

Enables non-browsable property for SMB Shares. Only applicable for SMB/DualProtocol volume.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `volumes.throughputMibps`

The throughput in MiBps for the NetApp account.

- Required: No
- Type: int

### Parameter: `volumes.volumeType`

The type of the volume. DataProtection volumes are used for replication.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Capacity Pool. |
| `resourceGroupName` | string | The name of the Resource Group the Capacity Pool was created in. |
| `resourceId` | string | The resource ID of the Capacity Pool. |
| `volumeResourceIds` | array | The resource IDs of the volume created in the capacity pool. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |
