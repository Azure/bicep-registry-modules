metadata name = 'Azure NetApp Files Capacity Pools'
metadata description = 'This module deploys an Azure NetApp Files Capacity Pool.'

@description('Conditional. The name of the parent NetApp account. Required if the template is used in a standalone deployment.')
param netAppAccountName string

@description('Required. The name of the capacity pool.')
param name string

@description('Optional. Location of the pool volume.')
param location string = resourceGroup().location

@description('Optional. Tags for all resources.')
param tags object?

@description('Optional. The pool service level.')
@allowed([
  'Premium'
  'Standard'
  'StandardZRS'
  'Ultra'
])
param serviceLevel string = 'Standard'

@description('Required. Provisioned size of the pool (in bytes). Allowed values are in 4TiB chunks (value must be multiply of 4398046511104).')
param size int

@description('Optional. The qos type of the pool.')
@allowed([
  'Auto'
  'Manual'
])
param qosType string = 'Auto'

@description('Optional. List of volumnes to create in the capacity pool.')
param volumes array = []

@description('Optional. If enabled (true) the pool can contain cool Access enabled volumes.')
param coolAccess bool = false

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Encryption type of the capacity pool, set encryption type for data at rest for this pool and all volumes in it. This value can only be set when creating new pool.')
@allowed([
  'Double'
  'Single'
])
param encryptionType string = 'Single'

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
}

resource capacityPool 'Microsoft.NetApp/netAppAccounts/capacityPools@2024-03-01' = {
  name: name
  parent: netAppAccount
  location: location
  tags: tags
  properties: {
    serviceLevel: serviceLevel
    size: size
    qosType: qosType
    coolAccess: coolAccess
    encryptionType: encryptionType
  }
}

@batchSize(1)
module capacityPool_volumes 'volume/main.bicep' = [
  for (volume, index) in volumes: {
    name: '${deployment().name}-Vol-${index}'
    params: {
      netAppAccountName: netAppAccount.name
      capacityPoolName: capacityPool.name
      name: volume.name
      location: location
      serviceLevel: serviceLevel
      creationToken: volume.?creationToken ?? volume.name
      usageThreshold: volume.usageThreshold
      protocolTypes: volume.?protocolTypes ?? []
      subnetResourceId: volume.subnetResourceId
      exportPolicyRules: volume.?exportPolicyRules ?? []
      roleAssignments: volume.?roleAssignments ?? []
      networkFeatures: volume.?networkFeatures
      zones: volume.?zones
      coolAccess: volume.?coolAccess ?? false
      coolAccessRetrievalPolicy: volume.?coolAccessRetrievalPolicy ?? 'Default'
      coolnessPeriod: volume.?coolnessPeriod ?? 0
      encryptionKeySource: volume.?encryptionKeySource ?? 'Microsoft.NetApp'
      keyVaultPrivateEndpointResourceId: volume.?keyVaultPrivateEndpointResourceId ?? ''
      endpointType: volume.?endpointType ?? ''
      remoteVolumeRegion: volume.?remoteVolumeRegion ?? ''
      remoteVolumeResourceId: volume.?remoteVolumeResourceId ?? ''
      replicationSchedule: volume.?replicationSchedule ?? ''
      snapshotPolicyName: volume.?snapshotPolicyName ?? 'snapshotPolicy'
      snapshotPolicyLocation: volume.?snapshotPolicyLocation ?? ''
      snapEnabled: volume.?snapEnabled ?? false
      dailyHour: volume.?dailyHour ?? 0
      dailyMinute: volume.?dailyMinute ?? 0
      dailySnapshotsToKeep: volume.?dailySnapshotsToKeep ?? 0
      dailyUsedBytes: volume.?dailyUsedBytes ?? 0
      hourlyMinute: volume.?hourlyMinute ?? 0
      hourlySnapshotsToKeep: volume.?hourlySnapshotsToKeep ?? 0
      hourlyUsedBytes: volume.?hourlyUsedBytes ?? 0
      daysOfMonth: volume.?daysOfMonth ?? ''
      monthlyHour: volume.?monthlyHour ?? 0
      monthlyMinute: volume.?monthlyMinute ?? 0
      monthlySnapshotsToKeep: volume.?monthlySnapshotsToKeep ?? 0
      monthlyUsedBytes: volume.?monthlyUsedBytes ?? 0
      weeklyDay: volume.?weeklyDay ?? ''
      weeklyHour: volume.?weeklyHour ?? 0
      weeklyMinute: volume.?weeklyMinute ?? 0
      weeklySnapshotsToKeep: volume.?weeklySnapshotsToKeep ?? 0
      weeklyUsedBytes: volume.?weeklyUsedBytes ?? 0
      backupPolicyName: volume.?backupPolicyName ?? 'backupPolicy'
      backupPolicyLocation: volume.?backupPolicyLocation ?? ''
      dailyBackupsToKeep: volume.?dailyBackupsToKeep ?? 0
      backupEnabled: volume.?backupEnabled ?? false
      monthlyBackupsToKeep: volume.?monthlyBackupsToKeep ?? 0
      weeklyBackupsToKeep: volume.?weeklyBackupsToKeep ?? 0
      backupVaultName: volume.?backupVaultName ?? 'vault'
      backupVaultLocation: volume.?backupVaultLocation ?? ''
      backupName: volume.?backupName ?? 'backup'
      backupLabel: volume.?backupLabel ?? ''
      snapshotName: volume.?snapshotName ?? 'snapshot'
      useExistingSnapshot: volume.?useExistingSnapshot ?? false
      volumeResourceId: volume.?volumeResourceId ?? ''
      volumeType: volume.?volumeType ?? ''
      backupVaultResourceId: volume.?backupVaultResourceId ?? ''
      replicationEnabled: volume.?replicationEnabled ?? false
    }
  }
]

resource capacityPool_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(capacityPool.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: capacityPool
  }
]

@description('The name of the Capacity Pool.')
output name string = capacityPool.name

@description('The resource ID of the Capacity Pool.')
output resourceId string = capacityPool.id

@description('The name of the Resource Group the Capacity Pool was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = capacityPool.location

@description('The resource IDs of the volume created in the capacity pool.')
output volumeResourceId string = (volumes != []) ? capacityPool_volumes[0].outputs.resourceId : ''
