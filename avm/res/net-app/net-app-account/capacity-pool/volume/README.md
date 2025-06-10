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
| `Microsoft.NetApp/netAppAccounts/capacityPools/volumes` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2025-01-01/netAppAccounts/capacityPools/volumes) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`coolAccess`](#parameter-coolaccess) | bool | If enabled (true) the pool can contain cool Access enabled volumes. |
| [`encryptionKeySource`](#parameter-encryptionkeysource) | string | The source of the encryption key. |
| [`name`](#parameter-name) | string | The name of the pool volume. |
| [`subnetResourceId`](#parameter-subnetresourceid) | string | The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes. |
| [`usageThreshold`](#parameter-usagethreshold) | int | Maximum storage quota allowed for a file system in bytes. |
| [`zone`](#parameter-zone) | int | The Availability Zone to place the resource in. If set to 0, then Availability Zone is not set. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacityPoolName`](#parameter-capacitypoolname) | string | The name of the parent capacity pool. Required if the template is used in a standalone deployment. |
| [`netAppAccountName`](#parameter-netappaccountname) | string | The name of the parent NetApp account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`coolAccessRetrievalPolicy`](#parameter-coolaccessretrievalpolicy) | string | Determines the data retrieval behavior from the cool tier to standard storage based on the read pattern for cool access enabled volumes (Default/Never/Read). |
| [`coolnessPeriod`](#parameter-coolnessperiod) | int | Specifies the number of days after which data that is not accessed by clients will be tiered. |
| [`creationToken`](#parameter-creationtoken) | string | A unique file path for the volume. This is the name of the volume export. A volume is mounted using the export path. File path must start with an alphabetical character and be unique within the subscription. |
| [`dataProtection`](#parameter-dataprotection) | object | DataProtection type volumes include an object containing details of the replication. |
| [`exportPolicy`](#parameter-exportpolicy) | object | The export policy rules. |
| [`kerberosEnabled`](#parameter-kerberosenabled) | bool | Define if a volume is KerberosEnabled. |
| [`keyVaultPrivateEndpointResourceId`](#parameter-keyvaultprivateendpointresourceid) | string | The resource ID of the key vault private endpoint. |
| [`location`](#parameter-location) | string | Location of the pool volume. |
| [`networkFeatures`](#parameter-networkfeatures) | string | Network feature for the volume. |
| [`protocolTypes`](#parameter-protocoltypes) | array | Set of protocol types. Default value is `['NFSv3']`. If you are creating a dual-stack volume, set either `['NFSv3','CIFS']` or `['NFSv4.1','CIFS']`. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`securityStyle`](#parameter-securitystyle) | string | Defines the security style of the Volume. |
| [`serviceLevel`](#parameter-servicelevel) | string | The pool service level. Must match the one of the parent capacity pool. |
| [`smbContinuouslyAvailable`](#parameter-smbcontinuouslyavailable) | bool | Enables continuously available share property for SMB volume. Only applicable for SMB volume. |
| [`smbEncryption`](#parameter-smbencryption) | bool | Enables SMB encryption. Only applicable for SMB/DualProtocol volume. |
| [`smbNonBrowsable`](#parameter-smbnonbrowsable) | string | Enables non-browsable property for SMB Shares. Only applicable for SMB/DualProtocol volume. |
| [`throughputMibps`](#parameter-throughputmibps) | int | The throughput in MiBps for the NetApp account. |
| [`unixPermissions`](#parameter-unixpermissions) | string | Unix Permissions for NFS volume. |
| [`volumeType`](#parameter-volumetype) | string | The type of the volume. DataProtection volumes are used for replication. |

### Parameter: `coolAccess`

If enabled (true) the pool can contain cool Access enabled volumes.

- Required: Yes
- Type: bool

### Parameter: `encryptionKeySource`

The source of the encryption key.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the pool volume.

- Required: Yes
- Type: string

### Parameter: `subnetResourceId`

The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes.

- Required: Yes
- Type: string

### Parameter: `usageThreshold`

Maximum storage quota allowed for a file system in bytes.

- Required: Yes
- Type: int

### Parameter: `zone`

The Availability Zone to place the resource in. If set to 0, then Availability Zone is not set.

- Required: Yes
- Type: int
- Allowed:
  ```Bicep
  [
    0
    1
    2
    3
  ]
  ```

### Parameter: `capacityPoolName`

The name of the parent capacity pool. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `netAppAccountName`

The name of the parent NetApp account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `coolAccessRetrievalPolicy`

Determines the data retrieval behavior from the cool tier to standard storage based on the read pattern for cool access enabled volumes (Default/Never/Read).

- Required: No
- Type: string

### Parameter: `coolnessPeriod`

Specifies the number of days after which data that is not accessed by clients will be tiered.

- Required: No
- Type: int

### Parameter: `creationToken`

A unique file path for the volume. This is the name of the volume export. A volume is mounted using the export path. File path must start with an alphabetical character and be unique within the subscription.

- Required: No
- Type: string
- Default: `[parameters('name')]`

### Parameter: `dataProtection`

DataProtection type volumes include an object containing details of the replication.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backup`](#parameter-dataprotectionbackup) | object | Backup properties. |
| [`replication`](#parameter-dataprotectionreplication) | object | Replication properties. |
| [`snapshot`](#parameter-dataprotectionsnapshot) | object | Snapshot properties. |

### Parameter: `dataProtection.backup`

Backup properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupPolicyName`](#parameter-dataprotectionbackupbackuppolicyname) | string | The name of the backup policy to link. |
| [`backupVaultName`](#parameter-dataprotectionbackupbackupvaultname) | string | The name of the Backup Vault. |
| [`policyEnforced`](#parameter-dataprotectionbackuppolicyenforced) | bool | Enable to enforce the policy. |

### Parameter: `dataProtection.backup.backupPolicyName`

The name of the backup policy to link.

- Required: Yes
- Type: string

### Parameter: `dataProtection.backup.backupVaultName`

The name of the Backup Vault.

- Required: Yes
- Type: string

### Parameter: `dataProtection.backup.policyEnforced`

Enable to enforce the policy.

- Required: Yes
- Type: bool

### Parameter: `dataProtection.replication`

Replication properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endpointType`](#parameter-dataprotectionreplicationendpointtype) | string | Indicates whether the local volume is the source or destination for the Volume Replication. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`remotePath`](#parameter-dataprotectionreplicationremotepath) | object | The full path to a volume that is to be migrated into ANF. Required for Migration volumes. |
| [`remoteVolumeRegion`](#parameter-dataprotectionreplicationremotevolumeregion) | string | The remote region for the other end of the Volume Replication.Required for Data Protection volumes. |
| [`remoteVolumeResourceId`](#parameter-dataprotectionreplicationremotevolumeresourceid) | string | The resource ID of the remote volume. Required for Data Protection volumes. |
| [`replicationSchedule`](#parameter-dataprotectionreplicationreplicationschedule) | string | The replication schedule for the volume (to only be set on the destination (dst)). |

### Parameter: `dataProtection.replication.endpointType`

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

### Parameter: `dataProtection.replication.remotePath`

The full path to a volume that is to be migrated into ANF. Required for Migration volumes.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`externalHostName`](#parameter-dataprotectionreplicationremotepathexternalhostname) | string | The Path to a ONTAP Host. |
| [`serverName`](#parameter-dataprotectionreplicationremotepathservername) | string | The name of a server on the ONTAP Host. |
| [`volumeName`](#parameter-dataprotectionreplicationremotepathvolumename) | string | The name of a volume on the server. |

### Parameter: `dataProtection.replication.remotePath.externalHostName`

The Path to a ONTAP Host.

- Required: Yes
- Type: string

### Parameter: `dataProtection.replication.remotePath.serverName`

The name of a server on the ONTAP Host.

- Required: Yes
- Type: string

### Parameter: `dataProtection.replication.remotePath.volumeName`

The name of a volume on the server.

- Required: Yes
- Type: string

### Parameter: `dataProtection.replication.remoteVolumeRegion`

The remote region for the other end of the Volume Replication.Required for Data Protection volumes.

- Required: No
- Type: string

### Parameter: `dataProtection.replication.remoteVolumeResourceId`

The resource ID of the remote volume. Required for Data Protection volumes.

- Required: No
- Type: string

### Parameter: `dataProtection.replication.replicationSchedule`

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

### Parameter: `dataProtection.snapshot`

Snapshot properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`snapshotPolicyName`](#parameter-dataprotectionsnapshotsnapshotpolicyname) | string | The name of the snapshot policy to link. |

### Parameter: `dataProtection.snapshot.snapshotPolicyName`

The name of the snapshot policy to link.

- Required: Yes
- Type: string

### Parameter: `exportPolicy`

The export policy rules.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`rules`](#parameter-exportpolicyrules) | array | The Export policy rules. |

### Parameter: `exportPolicy.rules`

The Export policy rules.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kerberos5iReadOnly`](#parameter-exportpolicyruleskerberos5ireadonly) | bool | Kerberos5i Read only access. |
| [`kerberos5iReadWrite`](#parameter-exportpolicyruleskerberos5ireadwrite) | bool | Kerberos5i Read and write access. |
| [`kerberos5pReadOnly`](#parameter-exportpolicyruleskerberos5preadonly) | bool | Kerberos5p Read only access. |
| [`kerberos5pReadWrite`](#parameter-exportpolicyruleskerberos5preadwrite) | bool | Kerberos5p Read and write access. |
| [`kerberos5ReadOnly`](#parameter-exportpolicyruleskerberos5readonly) | bool | Kerberos5 Read only access. |
| [`kerberos5ReadWrite`](#parameter-exportpolicyruleskerberos5readwrite) | bool | Kerberos5 Read and write access. |
| [`nfsv3`](#parameter-exportpolicyrulesnfsv3) | bool | Allows NFSv3 protocol. Enable only for NFSv3 type volumes. |
| [`nfsv41`](#parameter-exportpolicyrulesnfsv41) | bool | Allows NFSv4.1 protocol. Enable only for NFSv4.1 type volumes. |
| [`ruleIndex`](#parameter-exportpolicyrulesruleindex) | int | Order index. |
| [`unixReadOnly`](#parameter-exportpolicyrulesunixreadonly) | bool | Read only access. |
| [`unixReadWrite`](#parameter-exportpolicyrulesunixreadwrite) | bool | Read and write access. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedClients`](#parameter-exportpolicyrulesallowedclients) | string | Client ingress specification as comma separated string with IPv4 CIDRs, IPv4 host addresses and host names. |
| [`chownMode`](#parameter-exportpolicyruleschownmode) | string | This parameter specifies who is authorized to change the ownership of a file. restricted - Only root user can change the ownership of the file. unrestricted - Non-root users can change ownership of files that they own. |
| [`cifs`](#parameter-exportpolicyrulescifs) | bool | Allows CIFS protocol. |
| [`hasRootAccess`](#parameter-exportpolicyruleshasrootaccess) | bool | Has root access to volume. |

### Parameter: `exportPolicy.rules.kerberos5iReadOnly`

Kerberos5i Read only access.

- Required: Yes
- Type: bool

### Parameter: `exportPolicy.rules.kerberos5iReadWrite`

Kerberos5i Read and write access.

- Required: Yes
- Type: bool

### Parameter: `exportPolicy.rules.kerberos5pReadOnly`

Kerberos5p Read only access.

- Required: Yes
- Type: bool

### Parameter: `exportPolicy.rules.kerberos5pReadWrite`

Kerberos5p Read and write access.

- Required: Yes
- Type: bool

### Parameter: `exportPolicy.rules.kerberos5ReadOnly`

Kerberos5 Read only access.

- Required: Yes
- Type: bool

### Parameter: `exportPolicy.rules.kerberos5ReadWrite`

Kerberos5 Read and write access.

- Required: Yes
- Type: bool

### Parameter: `exportPolicy.rules.nfsv3`

Allows NFSv3 protocol. Enable only for NFSv3 type volumes.

- Required: Yes
- Type: bool

### Parameter: `exportPolicy.rules.nfsv41`

Allows NFSv4.1 protocol. Enable only for NFSv4.1 type volumes.

- Required: Yes
- Type: bool

### Parameter: `exportPolicy.rules.ruleIndex`

Order index.

- Required: Yes
- Type: int

### Parameter: `exportPolicy.rules.unixReadOnly`

Read only access.

- Required: Yes
- Type: bool

### Parameter: `exportPolicy.rules.unixReadWrite`

Read and write access.

- Required: Yes
- Type: bool

### Parameter: `exportPolicy.rules.allowedClients`

Client ingress specification as comma separated string with IPv4 CIDRs, IPv4 host addresses and host names.

- Required: No
- Type: string

### Parameter: `exportPolicy.rules.chownMode`

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

### Parameter: `exportPolicy.rules.cifs`

Allows CIFS protocol.

- Required: No
- Type: bool

### Parameter: `exportPolicy.rules.hasRootAccess`

Has root access to volume.

- Required: No
- Type: bool

### Parameter: `kerberosEnabled`

Define if a volume is KerberosEnabled.

- Required: No
- Type: bool
- Default: `False`

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

### Parameter: `protocolTypes`

Set of protocol types. Default value is `['NFSv3']`. If you are creating a dual-stack volume, set either `['NFSv3','CIFS']` or `['NFSv4.1','CIFS']`.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    'NFSv3'
  ]
  ```
- Allowed:
  ```Bicep
  [
    'CIFS'
    'NFSv3'
    'NFSv4.1'
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

### Parameter: `securityStyle`

Defines the security style of the Volume.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'ntfs'
    'unix'
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

### Parameter: `throughputMibps`

The throughput in MiBps for the NetApp account.

- Required: No
- Type: int

### Parameter: `unixPermissions`

Unix Permissions for NFS volume.

- Required: No
- Type: string

### Parameter: `volumeType`

The type of the volume. DataProtection volumes are used for replication.

- Required: No
- Type: string

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
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |
