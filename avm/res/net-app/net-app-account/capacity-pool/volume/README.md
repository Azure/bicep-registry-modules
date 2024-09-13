# Azure NetApp Files Capacity Pool Volumes `[Microsoft.NetApp/netAppAccounts/capacityPools/volumes]`

This module deploys an Azure NetApp Files Capacity Pool Volume.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.NetApp/netAppAccounts/backupPolicies` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/backupPolicies) |
| `Microsoft.NetApp/netAppAccounts/backupVaults` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/backupVaults) |
| `Microsoft.NetApp/netAppAccounts/backupVaults/backups` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/backupVaults/backups) |
| `Microsoft.NetApp/netAppAccounts/capacityPools/volumes` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/capacityPools/volumes) |
| `Microsoft.NetApp/netAppAccounts/snapshotPolicies` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/snapshotPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the pool volume. |
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
| [`backupEnabled`](#parameter-backupenabled) | bool | Indicates whether the backup policy is enabled. |
| [`backupLabel`](#parameter-backuplabel) | string | The label of the backup. |
| [`backupName`](#parameter-backupname) | string | The name of the backup. |
| [`backupPolicyLocation`](#parameter-backuppolicylocation) | string | The location of the backup policy. |
| [`backupPolicyName`](#parameter-backuppolicyname) | string | The name of the backup policy. |
| [`backupVaultLocation`](#parameter-backupvaultlocation) | string | The location of the backup vault. |
| [`backupVaultName`](#parameter-backupvaultname) | string | The name of the backup vault. |
| [`coolAccess`](#parameter-coolaccess) | bool | If enabled (true) the pool can contain cool Access enabled volumes. |
| [`coolAccessRetrievalPolicy`](#parameter-coolaccessretrievalpolicy) | string | determines the data retrieval behavior from the cool tier to standard storage based on the read pattern for cool access enabled volumes (Default/Never/Read). |
| [`coolnessPeriod`](#parameter-coolnessperiod) | int | Specifies the number of days after which data that is not accessed by clients will be tiered. |
| [`creationToken`](#parameter-creationtoken) | string | A unique file path for the volume. This is the name of the volume export. A volume is mounted using the export path. File path must start with an alphabetical character and be unique within the subscription. |
| [`dailyBackupsToKeep`](#parameter-dailybackupstokeep) | int | The daily backups to keep. |
| [`dailyHour`](#parameter-dailyhour) | int | The daily snapshot hour. |
| [`dailyMinute`](#parameter-dailyminute) | int | The daily snapshot minute. |
| [`dailySnapshotsToKeep`](#parameter-dailysnapshotstokeep) | int | Daily snapshot count to keep. |
| [`dailyUsedBytes`](#parameter-dailyusedbytes) | int | Daily snapshot used bytes. |
| [`daysOfMonth`](#parameter-daysofmonth) | string | The monthly snapshot day. |
| [`encryptionKeySource`](#parameter-encryptionkeysource) | string | The source of the encryption key. |
| [`endpointType`](#parameter-endpointtype) | string | Indicates whether the local volume is the source or destination for the Volume Replication (src/dst). |
| [`exportPolicyRules`](#parameter-exportpolicyrules) | array | Export policy rules. |
| [`hourlyMinute`](#parameter-hourlyminute) | int | The hourly snapshot minute. |
| [`hourlySnapshotsToKeep`](#parameter-hourlysnapshotstokeep) | int | Hourly snapshot count to keep. |
| [`hourlyUsedBytes`](#parameter-hourlyusedbytes) | int | Hourly snapshot used bytes. |
| [`keyVaultPrivateEndpointResourceId`](#parameter-keyvaultprivateendpointresourceid) | string | The resource ID of the key vault private endpoint. |
| [`location`](#parameter-location) | string | Location of the pool volume. |
| [`monthlyBackupsToKeep`](#parameter-monthlybackupstokeep) | int | The monthly backups to keep. |
| [`monthlyHour`](#parameter-monthlyhour) | int | The monthly snapshot hour. |
| [`monthlyMinute`](#parameter-monthlyminute) | int | The monthly snapshot minute. |
| [`monthlySnapshotsToKeep`](#parameter-monthlysnapshotstokeep) | int | Monthly snapshot count to keep. |
| [`monthlyUsedBytes`](#parameter-monthlyusedbytes) | int | Monthly snapshot used bytes. |
| [`networkFeatures`](#parameter-networkfeatures) | string | Network feature for the volume. |
| [`protocolTypes`](#parameter-protocoltypes) | array | Set of protocol types. |
| [`remoteVolumeRegion`](#parameter-remotevolumeregion) | string | The remote region for the other end of the Volume Replication. |
| [`remoteVolumeResourceId`](#parameter-remotevolumeresourceid) | string | The resource ID of the remote volume. |
| [`replicationSchedule`](#parameter-replicationschedule) | string | The replication schedule for the volume. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`serviceLevel`](#parameter-servicelevel) | string | The pool service level. Must match the one of the parent capacity pool. |
| [`snapEnabled`](#parameter-snapenabled) | bool | Indicates whether the snapshot policy is enabled. |
| [`snapshotName`](#parameter-snapshotname) | string | The name of the snapshot. |
| [`snapshotPolicyId`](#parameter-snapshotpolicyid) | string | Snapshot Policy ResourceId. |
| [`snapshotPolicyLocation`](#parameter-snapshotpolicylocation) | string | The location of the snapshot policy. |
| [`snapshotPolicyName`](#parameter-snapshotpolicyname) | string | The name of the snapshot policy. |
| [`useExistingSnapshot`](#parameter-useexistingsnapshot) | bool | Indicates whether to use an existing snapshot. |
| [`volumeResourceId`](#parameter-volumeresourceid) | string | The resource ID of the volume. |
| [`volumeType`](#parameter-volumetype) | string | The type of the volume. DataProtection volumes are used for replication. |
| [`weeklyBackupsToKeep`](#parameter-weeklybackupstokeep) | int | The weekly backups to keep. |
| [`weeklyDay`](#parameter-weeklyday) | string | The weekly snapshot day. |
| [`weeklyHour`](#parameter-weeklyhour) | int | The weekly snapshot hour. |
| [`weeklyMinute`](#parameter-weeklyminute) | int | The weekly snapshot minute. |
| [`weeklySnapshotsToKeep`](#parameter-weeklysnapshotstokeep) | int | Weekly snapshot count to keep. |
| [`weeklyUsedBytes`](#parameter-weeklyusedbytes) | int | Weekly snapshot used bytes. |
| [`zones`](#parameter-zones) | array | Zone where the volume will be placed. |

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

### Parameter: `capacityPoolName`

The name of the parent capacity pool. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `netAppAccountName`

The name of the parent NetApp account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `backupEnabled`

Indicates whether the backup policy is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `backupLabel`

The label of the backup.

- Required: Yes
- Type: string

### Parameter: `backupName`

The name of the backup.

- Required: Yes
- Type: string

### Parameter: `backupPolicyLocation`

The location of the backup policy.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `backupPolicyName`

The name of the backup policy.

- Required: No
- Type: string
- Default: `'backupPolicy'`

### Parameter: `backupVaultLocation`

The location of the backup vault.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `backupVaultName`

The name of the backup vault.

- Required: No
- Type: string
- Default: `'vault'`

### Parameter: `coolAccess`

If enabled (true) the pool can contain cool Access enabled volumes.

- Required: Yes
- Type: bool

### Parameter: `coolAccessRetrievalPolicy`

determines the data retrieval behavior from the cool tier to standard storage based on the read pattern for cool access enabled volumes (Default/Never/Read).

- Required: No
- Type: string
- Default: `'Default'`

### Parameter: `coolnessPeriod`

Specifies the number of days after which data that is not accessed by clients will be tiered.

- Required: Yes
- Type: int

### Parameter: `creationToken`

A unique file path for the volume. This is the name of the volume export. A volume is mounted using the export path. File path must start with an alphabetical character and be unique within the subscription.

- Required: No
- Type: string
- Default: `[parameters('name')]`

### Parameter: `dailyBackupsToKeep`

The daily backups to keep.

- Required: Yes
- Type: int

### Parameter: `dailyHour`

The daily snapshot hour.

- Required: Yes
- Type: int

### Parameter: `dailyMinute`

The daily snapshot minute.

- Required: Yes
- Type: int

### Parameter: `dailySnapshotsToKeep`

Daily snapshot count to keep.

- Required: Yes
- Type: int

### Parameter: `dailyUsedBytes`

Daily snapshot used bytes.

- Required: Yes
- Type: int

### Parameter: `daysOfMonth`

The monthly snapshot day.

- Required: Yes
- Type: string

### Parameter: `encryptionKeySource`

The source of the encryption key.

- Required: Yes
- Type: string

### Parameter: `endpointType`

Indicates whether the local volume is the source or destination for the Volume Replication (src/dst).

- Required: Yes
- Type: string

### Parameter: `exportPolicyRules`

Export policy rules.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `hourlyMinute`

The hourly snapshot minute.

- Required: Yes
- Type: int

### Parameter: `hourlySnapshotsToKeep`

Hourly snapshot count to keep.

- Required: Yes
- Type: int

### Parameter: `hourlyUsedBytes`

Hourly snapshot used bytes.

- Required: Yes
- Type: int

### Parameter: `keyVaultPrivateEndpointResourceId`

The resource ID of the key vault private endpoint.

- Required: Yes
- Type: string

### Parameter: `location`

Location of the pool volume.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `monthlyBackupsToKeep`

The monthly backups to keep.

- Required: Yes
- Type: int

### Parameter: `monthlyHour`

The monthly snapshot hour.

- Required: Yes
- Type: int

### Parameter: `monthlyMinute`

The monthly snapshot minute.

- Required: Yes
- Type: int

### Parameter: `monthlySnapshotsToKeep`

Monthly snapshot count to keep.

- Required: Yes
- Type: int

### Parameter: `monthlyUsedBytes`

Monthly snapshot used bytes.

- Required: Yes
- Type: int

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

Set of protocol types.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `remoteVolumeRegion`

The remote region for the other end of the Volume Replication.

- Required: Yes
- Type: string

### Parameter: `remoteVolumeResourceId`

The resource ID of the remote volume.

- Required: Yes
- Type: string

### Parameter: `replicationSchedule`

The replication schedule for the volume.

- Required: Yes
- Type: string

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

### Parameter: `snapEnabled`

Indicates whether the snapshot policy is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `snapshotName`

The name of the snapshot.

- Required: Yes
- Type: string

### Parameter: `snapshotPolicyId`

Snapshot Policy ResourceId.

- Required: Yes
- Type: string

### Parameter: `snapshotPolicyLocation`

The location of the snapshot policy.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `snapshotPolicyName`

The name of the snapshot policy.

- Required: Yes
- Type: string

### Parameter: `useExistingSnapshot`

Indicates whether to use an existing snapshot.

- Required: Yes
- Type: bool

### Parameter: `volumeResourceId`

The resource ID of the volume.

- Required: Yes
- Type: string

### Parameter: `volumeType`

The type of the volume. DataProtection volumes are used for replication.

- Required: Yes
- Type: string

### Parameter: `weeklyBackupsToKeep`

The weekly backups to keep.

- Required: Yes
- Type: int

### Parameter: `weeklyDay`

The weekly snapshot day.

- Required: Yes
- Type: string

### Parameter: `weeklyHour`

The weekly snapshot hour.

- Required: Yes
- Type: int

### Parameter: `weeklyMinute`

The weekly snapshot minute.

- Required: Yes
- Type: int

### Parameter: `weeklySnapshotsToKeep`

Weekly snapshot count to keep.

- Required: Yes
- Type: int

### Parameter: `weeklyUsedBytes`

Weekly snapshot used bytes.

- Required: Yes
- Type: int

### Parameter: `zones`

Zone where the volume will be placed.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    '1'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Volume. |
| `resourceGroupName` | string | The name of the Resource Group the Volume was created in. |
| `resourceId` | string | The Resource ID of the Volume. |
