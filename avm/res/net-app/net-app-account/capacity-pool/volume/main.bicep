metadata name = 'Azure NetApp Files Capacity Pool Volumes'
metadata description = 'This module deploys an Azure NetApp Files Capacity Pool Volume.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent NetApp account. Required if the template is used in a standalone deployment.')
param netAppAccountName string

@description('Conditional. The name of the parent capacity pool. Required if the template is used in a standalone deployment.')
param capacityPoolName string

@description('Optional. If enabled (true) the pool can contain cool Access enabled volumes.')
param coolAccess bool

@description('Optional. Specifies the number of days after which data that is not accessed by clients will be tiered.')
param coolnessPeriod int

@description('Optional. determines the data retrieval behavior from the cool tier to standard storage based on the read pattern for cool access enabled volumes (Default/Never/Read).')
param coolAccessRetrievalPolicy string = 'Default'

@description('Optional. The source of the encryption key.')
param encryptionKeySource string

@description('Optional. The resource ID of the key vault private endpoint.')
param keyVaultPrivateEndpointResourceId string

@description('Optional. Indicates whether the local volume is the source or destination for the Volume Replication (src/dst).')
param endpointType string

@description('Optional. The remote region for the other end of the Volume Replication.')
param remoteVolumeRegion string

@description('Optional. The resource ID of the remote volume.')
param remoteVolumeResourceId string

@description('Optional. The replication schedule for the volume.')
param replicationSchedule string

@description('Optional. Indicates whether the backup policy is enabled.')
param backupEnabled bool = false

@description('Optional. The name of the backup policy.')
param backupPolicyName string = 'backupPolicy'

@description('Optional. The location of the backup policy.')
param backupPolicyLocation string = resourceGroup().location

@description('Optional. The daily backups to keep.')
param dailyBackupsToKeep int

@description('Optional. The monthly backups to keep.')
param monthlyBackupsToKeep int

@description('Optional. The weekly backups to keep.')
param weeklyBackupsToKeep int

@description('Optional. The name of the backup vault.')
param backupVaultName string = 'vault'

@description('Optional. The location of the backup vault.')
param backupVaultLocation string = resourceGroup().location

@description('Optional. The name of the backup.')
param backupName string

@description('Optional. The label of the backup.')
param backupLabel string

@description('Optional. Indicates whether to use an existing snapshot.')
param useExistingSnapshot bool

@description('Optional. The name of the snapshot.')
param snapshotName string

@description('Optional. Snapshot Policy ResourceId.')
param snapshotPolicyId string

@description('Optional. The name of the snapshot policy.')
param snapshotPolicyName string

@description('Optional. The location of the snapshot policy.')
param snapshotPolicyLocation string = resourceGroup().location

@description('Optional. The daily snapshot hour.')
param dailyHour int

@description('Optional. The daily snapshot minute.')
param dailyMinute int

@description('Optional. Daily snapshot count to keep.')
param dailySnapshotsToKeep int

@description('Optional. Daily snapshot used bytes.')
param dailyUsedBytes int

@description('Optional. The hourly snapshot minute.')
param hourlyMinute int

@description('Optional. Hourly snapshot count to keep.')
param hourlySnapshotsToKeep int

@description('Optional. Hourly snapshot used bytes.')
param hourlyUsedBytes int

@description('Optional. The monthly snapshot day.')
param daysOfMonth string

@description('Optional. The monthly snapshot hour.')
param monthlyHour int

@description('Optional. The monthly snapshot minute.')
param monthlyMinute int

@description('Optional. Monthly snapshot count to keep.')
param monthlySnapshotsToKeep int

@description('Optional. Monthly snapshot used bytes.')
param monthlyUsedBytes int

@description('Optional. The weekly snapshot day.')
param weeklyDay string

@description('Optional. The weekly snapshot hour.')
param weeklyHour int

@description('Optional. The weekly snapshot minute.')
param weeklyMinute int

@description('Optional. Weekly snapshot count to keep.')
param weeklySnapshotsToKeep int

@description('Optional. Weekly snapshot used bytes.')
param weeklyUsedBytes int

@description('Optional. Indicates whether the snapshot policy is enabled.')
param snapEnabled bool = false

@description('Optional. The resource ID of the volume.')
param volumeResourceId string

@description('Optional. The type of the volume. DataProtection volumes are used for replication.')
param volumeType string

@description('Required. The name of the pool volume.')
param name string

@description('Optional. Location of the pool volume.')
param location string = resourceGroup().location

@description('Optional. Zone where the volume will be placed.')
param zones array = ['1']

@description('Optional. The pool service level. Must match the one of the parent capacity pool.')
@allowed([
  'Premium'
  'Standard'
  'StandardZRS'
  'Ultra'
])
param serviceLevel string = 'Standard'

@description('Optional. Network feature for the volume.')
@allowed([
  'Basic'
  'Basic_Standard'
  'Standard'
  'Standard_Basic'
])
param networkFeatures string = 'Standard'

@description('Optional. A unique file path for the volume. This is the name of the volume export. A volume is mounted using the export path. File path must start with an alphabetical character and be unique within the subscription.')
param creationToken string = name

@description('Required. Maximum storage quota allowed for a file system in bytes.')
param usageThreshold int

@description('Optional. Set of protocol types.')
param protocolTypes array = []

@description('Required. The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes.')
param subnetResourceId string

@description('Optional. Export policy rules.')
param exportPolicyRules array = []

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2024-03-01' existing = {
  name: netAppAccountName

  resource capacityPool 'capacityPools@2024-03-01' existing = {
    name: capacityPoolName
  }
}

resource volume 'Microsoft.NetApp/netAppAccounts/capacityPools/volumes@2024-03-01' = {
  name: name
  parent: netAppAccount::capacityPool
  location: location
  properties: {
    coolAccess: coolAccess
    coolAccessRetrievalPolicy: coolAccessRetrievalPolicy
    coolnessPeriod: coolnessPeriod
    encryptionKeySource: encryptionKeySource
    ...(encryptionKeySource != 'Microsoft.NetApp'
      ? {
          keyVaultPrivateEndpointResourceId: keyVaultPrivateEndpointResourceId
        }
      : {})
    ...(volumeType != ''
      ? {
          volumeType: volumeType
          dataProtection: {
            replication: {
              endpointType: endpointType
              remoteVolumeRegion: remoteVolumeRegion
              remoteVolumeResourceId: remoteVolumeResourceId
              replicationSchedule: replicationSchedule
            }
            snapshot: {
              snapshotPolicyId: snapshotPolicyId
            }
          }
        }
      : {})
    networkFeatures: networkFeatures
    serviceLevel: serviceLevel
    creationToken: creationToken
    usageThreshold: usageThreshold
    protocolTypes: protocolTypes
    subnetId: subnetResourceId
    exportPolicy: !empty(exportPolicyRules)
      ? {
          rules: exportPolicyRules
        }
      : null
  }
  zones: zones
}

resource snapshotPolicies 'Microsoft.NetApp/netAppAccounts/snapshotPolicies@2024-03-01' = if (snapEnabled) {
  name: snapshotPolicyName
  parent: netAppAccount
  location: snapshotPolicyLocation
  properties: {
    enabled: snapEnabled
    dailySchedule: {
      hour: dailyHour
      minute: dailyMinute
      snapshotsToKeep: dailySnapshotsToKeep
      usedBytes: dailyUsedBytes
    }
    hourlySchedule: {
      minute: hourlyMinute
      snapshotsToKeep: hourlySnapshotsToKeep
      usedBytes: hourlyUsedBytes
    }
    monthlySchedule: {
      daysOfMonth: daysOfMonth
      hour: monthlyHour
      minute: monthlyMinute
      snapshotsToKeep: monthlySnapshotsToKeep
      usedBytes: monthlyUsedBytes
    }
    weeklySchedule: {
      day: weeklyDay
      hour: weeklyHour
      minute: weeklyMinute
      snapshotsToKeep: weeklySnapshotsToKeep
      usedBytes: weeklyUsedBytes
    }
  }
}

resource backupPolicies 'Microsoft.NetApp/netAppAccounts/backupPolicies@2024-03-01' = if (backupEnabled) {
  name: backupPolicyName
  parent: netAppAccount
  location: backupPolicyLocation
  properties: {
    dailyBackupsToKeep: dailyBackupsToKeep
    enabled: backupEnabled
    monthlyBackupsToKeep: monthlyBackupsToKeep
    weeklyBackupsToKeep: weeklyBackupsToKeep
  }
}

resource backupVaults 'Microsoft.NetApp/netAppAccounts/backupVaults@2024-03-01' = if (backupEnabled) {
  name: backupVaultName
  parent: netAppAccount
  location: backupVaultLocation
  properties: {}
}

resource backups 'Microsoft.NetApp/netAppAccounts/backupVaults/backups@2024-03-01' = if (backupEnabled) {
  name: backupName
  parent: backupVaults
  properties: backupEnabled
    ? {
        label: backupLabel
        snapshotName: snapshotName
        useExistingSnapshot: useExistingSnapshot
        volumeResourceId: volumeResourceId
      }
    : {}
}

resource volume_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(volume.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: volume
  }
]

@description('The name of the Volume.')
output name string = volume.name

@description('The Resource ID of the Volume.')
output resourceId string = volume.id

@description('The name of the Resource Group the Volume was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = volume.location

// =============== //
//   Definitions   //
// =============== //

type roleAssignmentType = {
  @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?
