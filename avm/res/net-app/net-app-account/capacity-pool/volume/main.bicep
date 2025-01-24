metadata name = 'Azure NetApp Files Capacity Pool Volumes'
metadata description = 'This module deploys an Azure NetApp Files Capacity Pool Volume.'

@description('Conditional. The name of the parent NetApp account. Required if the template is used in a standalone deployment.')
param netAppAccountName string

@description('Conditional. The name of the parent capacity pool. Required if the template is used in a standalone deployment.')
param capacityPoolName string

@description('Required. If enabled (true) the pool can contain cool Access enabled volumes.')
param coolAccess bool

@description('Required. Specifies the number of days after which data that is not accessed by clients will be tiered.')
param coolnessPeriod int

@description('Optional. determines the data retrieval behavior from the cool tier to standard storage based on the read pattern for cool access enabled volumes (Default/Never/Read).')
param coolAccessRetrievalPolicy string = 'Default'

@description('Required. The source of the encryption key.')
param encryptionKeySource string

@description('Required. The resource ID of the key vault private endpoint.')
param keyVaultPrivateEndpointResourceId string

@description('Required. Indicates whether the local volume is the source or destination for the Volume Replication (src/dst).')
param endpointType string

@description('Required. The remote region for the other end of the Volume Replication.')
param remoteVolumeRegion string

@description('Required. The resource ID of the remote volume.')
param remoteVolumeResourceId string

@description('Required. The replication schedule for the volume.')
param replicationSchedule string

@description('Optional. Indicates whether the backup policy is enabled.')
param backupEnabled bool = false

@description('Optional. The name of the backup policy.')
param backupPolicyName string = 'backupPolicy'

@description('Required. The daily snapshot hour.')
param dailyHour int

@description('Required. The daily snapshot minute.')
param dailyMinute int

@description('Required. Daily snapshot count to keep.')
param dailySnapshotsToKeep int

@description('Required. Daily snapshot used bytes.')
param dailyUsedBytes int

@description('Required. The hourly snapshot minute.')
param hourlyMinute int

@description('Required. Hourly snapshot count to keep.')
param hourlySnapshotsToKeep int

@description('Required. Hourly snapshot used bytes.')
param hourlyUsedBytes int

@description('Required. The monthly snapshot day.')
param daysOfMonth string

@description('Required. The monthly snapshot hour.')
param monthlyHour int

@description('Required. The monthly snapshot minute.')
param monthlyMinute int

@description('Required. Monthly snapshot count to keep.')
param monthlySnapshotsToKeep int

@description('Required. Monthly snapshot used bytes.')
param monthlyUsedBytes int

@description('Required. The weekly snapshot day.')
param weeklyDay string

@description('Required. The weekly snapshot hour.')
param weeklyHour int

@description('Required. The weekly snapshot minute.')
param weeklyMinute int

@description('Required. Weekly snapshot count to keep.')
param weeklySnapshotsToKeep int

@description('Required. Weekly snapshot used bytes.')
param weeklyUsedBytes int

@description('Optional. Indicates whether the snapshot policy is enabled.')
param snapEnabled bool = true

@description('Required. The name of the snapshot policy.')
param snapshotPolicyName string

@description('Required. The daily backups to keep.')
param dailyBackupsToKeep int

@description('Required. The monthly backups to keep.')
param monthlyBackupsToKeep int

@description('Required. The weekly backups to keep.')
param weeklyBackupsToKeep int

@description('Optional. The name of the backup vault.')
param backupVaultName string = 'vault'

@description('Optional. The location of the backup vault.')
param backupVaultLocation string = resourceGroup().location

@description('Required. The name of the backup.')
param backupName string

@description('Required. The label of the backup.')
param backupLabel string

@description('Required. Indicates whether to use an existing snapshot.')
param useExistingSnapshot bool

@description('Required. The name of the snapshot.')
param snapshotName string

@description('Required. The resource ID of the volume.')
param volumeResourceId string

@description('Required. The type of the volume. DataProtection volumes are used for replication.')
param volumeType string

@description('Required. The name of the pool volume.')
param name string

@description('Optional. Location of the pool volume.')
param location string = resourceGroup().location

@description('Optional. Zone where the volume will be placed.')
param zones array = ['1']

@description('Optional. If Backup policy is enforced.')
param policyEnforced bool = false

@description('Required. The backup policy location.')
param backupPolicyLocation string

@description('Required. The location of snashot policies.')
param snapshotPolicyLocation string

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

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Required. The Id of the Backup Vault.')
param backupVaultResourceId string

@description('Optional. Enables replication.')
param replicationEnabled bool = true

@description('Optional. Enables SMB encryption. Only applicable for SMB/DualProtocol volume.')
param smbEncryption bool = false

@description('Optional. Enables continuously available share property for SMB volume. Only applicable for SMB volume.')
param smbContinuouslyAvailable bool = false

@description('Optional. Enables non-browsable property for SMB Shares. Only applicable for SMB/DualProtocol volume.')
@allowed([
  'Enabled'
  'Disabled'
])
param smbNonBrowsable string = 'Disabled'

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
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
  dependsOn: [
    backupVaults
    backupPolicies
  ]
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
            replication: replicationEnabled
              ? {
                  endpointType: endpointType
                  remoteVolumeRegion: remoteVolumeRegion
                  remoteVolumeResourceId: remoteVolumeResourceId
                  replicationSchedule: replicationSchedule
                }
              : {}

            backup: backupEnabled
              ? {
                  backupPolicyId: backupPolicies.outputs.resourceId
                  policyEnforced: policyEnforced
                  backupVaultId: backupVaultResourceId
                }
              : {}
            snapshot: snapEnabled
              ? {
                  snapshotPolicyId: snapshotPolicies.outputs.resourceId
                }
              : {}
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
    smbContinuouslyAvailable: smbContinuouslyAvailable
    smbEncryption: smbEncryption
    smbNonBrowsable: smbNonBrowsable
  }
  zones: zones
}

module backupPolicies '../../backup-policies/main.bicep' = if (backupEnabled) {
  name: backupPolicyName
  params: {
    dailyBackupsToKeep: dailyBackupsToKeep
    monthlyBackupsToKeep: monthlyBackupsToKeep
    netAppAccountName: netAppAccountName
    weeklyBackupsToKeep: weeklyBackupsToKeep
    backupEnabled: backupEnabled
    backupPolicyLocation: backupPolicyLocation
  }
}

module snapshotPolicies '../../snapshot-policies/main.bicep' = if (snapEnabled) {
  name: uniqueString(snapshotPolicyName)
  params: {
    dailyHour: dailyHour
    dailyMinute: dailyMinute
    dailySnapshotsToKeep: dailySnapshotsToKeep
    dailyUsedBytes: dailyUsedBytes
    daysOfMonth: daysOfMonth
    hourlyMinute: hourlyMinute
    hourlySnapshotsToKeep: hourlySnapshotsToKeep
    hourlyUsedBytes: hourlyUsedBytes
    monthlyHour: monthlyHour
    monthlyMinute: monthlyMinute
    monthlySnapshotsToKeep: monthlySnapshotsToKeep
    monthlyUsedBytes: monthlyUsedBytes
    netAppAccountName: netAppAccountName
    snapshotPolicyName: snapshotPolicyName
    weeklyDay: weeklyDay
    weeklyHour: weeklyHour
    weeklyMinute: weeklyMinute
    weeklySnapshotsToKeep: weeklySnapshotsToKeep
    weeklyUsedBytes: weeklyUsedBytes
    snapshotPolicyLocation: snapshotPolicyLocation
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
  dependsOn: [
    volume
  ]
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
