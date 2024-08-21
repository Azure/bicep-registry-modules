# Azure NetApp Files Capacity Pool Volumes `[Microsoft.NetApp/netAppAccounts/capacityPools/volumes]`

This module deploys an Azure NetApp Files Capacity Pool Volume.

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
| `Microsoft.NetApp/netAppAccounts/backupPolicies` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2023-11-01/netAppAccounts/backupPolicies) |
| `Microsoft.NetApp/netAppAccounts/backupVaults` | [2023-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2023-05-01-preview/netAppAccounts/backupVaults) |
| `Microsoft.NetApp/netAppAccounts/backupVaults/backups` | [2023-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2023-05-01-preview/netAppAccounts/backupVaults/backups) |
| `Microsoft.NetApp/netAppAccounts/capacityPools/volumes` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2023-07-01/netAppAccounts/capacityPools/volumes) |

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
| [`endpointType`](#parameter-endpointtype) | string | Indicates whether the local volume is the source or destination for the Volume Replication (src/dst). |
| [`exportPolicyRules`](#parameter-exportpolicyrules) | array | Export policy rules. |
| [`location`](#parameter-location) | string | Location of the pool volume. |
| [`monthlyBackupsToKeep`](#parameter-monthlybackupstokeep) | int | The monthly backups to keep. |
| [`networkFeatures`](#parameter-networkfeatures) | string | Network feature for the volume. |
| [`protocolTypes`](#parameter-protocoltypes) | array | Set of protocol types. |
| [`remoteVolumeRegion`](#parameter-remotevolumeregion) | string | The remote region for the other end of the Volume Replication. |
| [`remoteVolumeResourceId`](#parameter-remotevolumeresourceid) | string | The resource ID of the remote volume. |
| [`replicationSchedule`](#parameter-replicationschedule) | string | The replication schedule for the volume. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`serviceLevel`](#parameter-servicelevel) | string | The pool service level. Must match the one of the parent capacity pool. |
| [`snapshotName`](#parameter-snapshotname) | string | The name of the snapshot. |
| [`useExistingSnapshot`](#parameter-useexistingsnapshot) | bool | Indicates whether to use an existing snapshot. |
| [`volumeResourceId`](#parameter-volumeresourceid) | string | The resource ID of the volume. |
| [`weeklyBackupsToKeep`](#parameter-weeklybackupstokeep) | int | The weekly backups to keep. |
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

### Parameter: `endpointType`

Indicates whether the local volume is the source or destination for the Volume Replication (src/dst).

- Required: Yes
- Type: string

### Parameter: `exportPolicyRules`

Export policy rules.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `location`

Location of the pool volume.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `monthlyBackupsToKeep`

The monthly backups to keep.

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

### Parameter: `snapshotName`

The name of the snapshot.

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

### Parameter: `weeklyBackupsToKeep`

The weekly backups to keep.

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
