@description('Required. The name of the storage account.')
param storageAccountName string

@description('Required. The principal ID of the project identity.')
param projectIdentityPrincipalId string

@description('Required. The name of the blob container for the project.')
param containerName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  name: storageAccountName
  scope: resourceGroup()
}

resource blobStorageContributorRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' // Storage Blob Data Contributor
  scope: resourceGroup()
}

// NOTE: using resource module over AVM due to resource possibly existing out of the current scope
resource storageAccountBlobContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storageAccount
  name: guid(storageAccount.id, blobStorageContributorRole.id, storageAccountName)
  properties: {
    principalId: projectIdentityPrincipalId
    roleDefinitionId: blobStorageContributorRole.id
    principalType: 'ServicePrincipal'
  }
}

resource storageBlobDataOwnerRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'b7e6dc6d-f1e8-4753-8033-0f276bb0955b' // Storage Blob Data Owner
  scope: resourceGroup()
}

resource storageAccountDataOwnerRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storageAccount
  name: guid(storageAccount.id, storageBlobDataOwnerRoleDefinition.id, storageAccountName)
  properties: {
    principalId: projectIdentityPrincipalId
    roleDefinitionId: storageBlobDataOwnerRoleDefinition.id
    principalType: 'ServicePrincipal'
    conditionVersion: '2.0'
    condition: '((!(ActionMatches{\'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/tags/read\'})  AND  !(ActionMatches{\'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/filter/action\'}) AND  !(ActionMatches{\'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/tags/write\'}) ) OR (@Resource[Microsoft.Storage/storageAccounts/blobServices/containers:name] StringStartsWithIgnoreCase \'${containerName}\'))'
  }
}
