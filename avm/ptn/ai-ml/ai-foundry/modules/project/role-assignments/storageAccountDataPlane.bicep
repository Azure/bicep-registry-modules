@description('Required. The name of the storage account.')
param storageAccountName string

@description('Required. The principal ID of the project identity.')
param projectIdentityPrincipalId string

@description('Required. The name of the blob container for the project.')
param containerName string

@description('Required. The project workspace ID.')
param projectWorkspaceId string

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  name: storageAccountName
  scope: resourceGroup()
}

resource storageBlobDataOwnerRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'b7e6dc6d-f1e8-4753-8033-0f276bb0955b' // Storage Blob Data Owner
  scope: resourceGroup()
}

// NOTE: (obsolete, see next NOTE) it is unsure if the project workspace id container name is required here
// The latest version of the storage account connection requires specifying a container name
// while it was not required in previous versions.
// To be safe, this is adding role assignments for both the provided container name and the
// project workspace id as a container name (in the condition statement).

// NOTE: assigning role to the entire storage account for now to get around condition formatting issues
resource storageAccountCustomContainerDataOwnerRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storageAccount
  name: guid(storageAccount.id, storageBlobDataOwnerRoleDefinition.id, storageAccountName)
  properties: {
    principalId: projectIdentityPrincipalId
    roleDefinitionId: storageBlobDataOwnerRoleDefinition.id
    principalType: 'ServicePrincipal'
  }
}
