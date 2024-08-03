metadata name = 'Azure NetApp Files Capacity Pools'
metadata description = 'This module deploys an Azure NetApp Files Capacity Pool.'
metadata owner = 'Azure/module-maintainers'

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

@description('Required. Network features available to the volume, or current state of update (Basic/Standard).')
param networkFeatures string = 'Standard'

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

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

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

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2023-07-01' existing = {
  name: netAppAccountName
}

resource capacityPool 'Microsoft.NetApp/netAppAccounts/capacityPools@2023-07-01' = {
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
      creationToken: contains(volume, 'creationToken') ? volume.creationToken : volume.name
      usageThreshold: volume.usageThreshold
      protocolTypes: contains(volume, 'protocolTypes') ? volume.protocolTypes : []
      subnetResourceId: volume.subnetResourceId
      exportPolicyRules: contains(volume, 'exportPolicyRules') ? volume.exportPolicyRules : []
      roleAssignments: contains(volume, 'roleAssignments') ? volume.roleAssignments : []
      networkFeatures: volume.?networkFeatures
      zones: volume.?zones
      coolAccess: contains(volume, 'coolAccess') ? volume.coolAccess : false
      coolAccessRetrievalPolicy: contains(volume, 'coolAccessRetrievalPolicy')
        ? volume.coolAccessRetrievalPolicy
        : 'Default'
      coolnessPeriod: contains(volume, 'coolnessPeriod') ? volume.coolnessPeriod : 0
      endpointType: contains(volume, 'endpointType') ? volume.endpointType : ''
      remoteVolumeRegion: contains(volume, 'remoteVolumeRegion') ? volume.remoteVolumeRegion : ''
      remoteVolumeResourceId: contains(volume, 'remoteVolumeResourceId') ? volume.remoteVolumeResourceId : ''
      replicationSchedule: contains(volume, 'replicationSchedule') ? volume.replicationSchedule : ''
      backupPolicyName: contains(volume, 'backupPolicyName') ? volume.backupPolicyName : 'backupPolicy'
      backupPolicyLocation: contains(volume, 'backupPolicyLocation') ? volume.backupPolicyLocation : ''
      dailyBackupsToKeep: contains(volume, 'dailyBackupsToKeep') ? volume.dailyBackupsToKeep : 0
      backupEnabled: contains(volume, 'backupEnabled') ? volume.backupEnabled : false
      monthlyBackupsToKeep: contains(volume, 'monthlyBackupsToKeep') ? volume.monthlyBackupsToKeep : 0
      weeklyBackupsToKeep: contains(volume, 'weeklyBackupsToKeep') ? volume.weeklyBackupsToKeep : 0
      backupVaultName: contains(volume, 'backupVaultName') ? volume.backupVaultName : 'vault'
      backupVaultLocation: contains(volume, 'backupVaultLocation') ? volume.backupVaultLocation : ''
      backupName: contains(volume, 'backupName') ? volume.backupName : 'backup'
      backupLabel: contains(volume, 'backupLabel') ? volume.backupLabel : ''
      snapshotName: contains(volume, 'snapshotName') ? volume.snapshotName : 'snapshot'
      useExistingSnapshot: contains(volume, 'useExistingSnapshot') ? volume.useExistingSnapshot : false
      volumeResourceId: contains(volume, 'volumeResourceId') ? volume.volumeResourceId : ''
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
