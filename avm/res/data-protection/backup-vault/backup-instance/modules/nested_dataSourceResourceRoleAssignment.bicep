param resourceId string
param principalId string

var resourceType = '${split(resourceId, '/')[6]}/${split(resourceId, '/')[7]}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' existing = if (resourceType == 'Microsoft.Storage/storageAccounts') {
  name: last(split(resourceId, '/'))
}

// Assign Storage Blob Data Contributor RBAC role
resource roleAssignment_storageAccount 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (resourceType == 'Microsoft.Storage/storageAccounts') {
  name: guid('${resourceId}-${principalId}-Storage-Blob-Data-Contributor')
  scope: storageAccount
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
    )
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}

resource disk 'Microsoft.Storage/storageAccounts@2023-04-01' existing = if (resourceType == 'Microsoft.Compute/disks') {
  name: last(split(resourceId, '/'))
}

// Assign Storage Blob Data Contributor RBAC role
resource roleAssignment_disk 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (resourceType == 'Microsoft.Compute/disks') {
  name: guid('${resourceId}-${principalId}-XXX')
  scope: disk
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '3e5e47e6-65f7-47ef-90b5-e5dd4d455f24'
    )
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}

resource roleAssignment_snapshotRG 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (resourceType == 'Microsoft.Compute/disks') {
  name: guid('${resourceId}-${principalId}-YYY')
  scope: disk
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '7efff54f-a5b4-42b5-a1c5-5411624893ce'
    )
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}

// resource roleAssignmentForDisk 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
//   name: roleNameGuidForDisk
//   properties: {
//     roleDefinitionId: roleDefinitionIdForDisk
//     principalId: reference(backupVault.id, '2021-01-01', 'Full').identity.principalId
//   }
//   dependsOn: [
//     backupPolicy
//     computeDisk
//   ]
// }

// resource roleAssignmentForSnapshotRG 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
//   name: roleNameGuidForSnapshotRG
//   properties: {
//     roleDefinitionId: roleDefinitionIdForSnapshotRG
//     principalId: reference(backupVault.id, '2021-01-01', 'Full').identity.principalId
//   }
//   dependsOn: [
//     backupPolicy
//     computeDisk
//   ]
// }

// var roleDefinitionIdForDisk = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3e5e47e6-65f7-47ef-90b5-e5dd4d455f24')
// var roleDefinitionIdForSnapshotRG = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7efff54f-a5b4-42b5-a1c5-5411624893ce')
// var roleNameGuidForDisk = guid(resourceGroup().id, roleDefinitionIdForDisk, backupVault.id)
// var roleNameGuidForSnapshotRG = guid(resourceGroup().id, roleDefinitionIdForSnapshotRG, backupVault.id)
