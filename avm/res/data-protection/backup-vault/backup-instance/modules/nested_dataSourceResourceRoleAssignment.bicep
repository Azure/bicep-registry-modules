@description('Required. The resource ID of the backup instance data source.')
param resourceId string

@description('Required. The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity).')
param principalId string

var resourceType = '${split(resourceId, '/')[6]}/${split(resourceId, '/')[7]}'

// Azure Blob Storage Backup

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' existing = if (resourceType == 'Microsoft.Storage/storageAccounts') {
  name: last(split(resourceId, '/'))
}

// Assign Storage Account Backup Contributor RBAC role
resource roleAssignment_storageAccount 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (resourceType == 'Microsoft.Storage/storageAccounts') {
  name: guid('${resourceId}-${principalId}-Storage-Account-Backup-Contributor')
  scope: storageAccount
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'e5e2a7ff-d759-4cd2-bb51-3152d37e2eb1' // Storage Account Backup Contributor
    )
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}

// Azure Disk Backup

// Assign Disk Backup Reader RBAC role
resource roleAssignment_disk 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (resourceType == 'Microsoft.Compute/disks') {
  name: guid('${resourceId}-${principalId}-Disk-Backup-Reader')
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '3e5e47e6-65f7-47ef-90b5-e5dd4d455f24' // Disk Backup Reader
    )
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}

// Assign Disk Snapshot Contributor RBAC role
resource roleAssignment_snapshotRG 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (resourceType == 'Microsoft.Compute/disks') {
  name: guid('${resourceId}-${principalId}-Disk-Snapshot-Contributor')
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '7efff54f-a5b4-42b5-a1c5-5411624893ce' // Disk Snapshot Contributor
    )
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
  dependsOn: [
    roleAssignment_disk
  ]
}
