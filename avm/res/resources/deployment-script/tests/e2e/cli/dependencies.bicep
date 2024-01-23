@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the managed identity to create.')
param managedIdentityName string

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

// Role required for deployment script to be able to use a storage account via private networking
resource storageFileDataPrivilegedContributor 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '69566ab7-960f-475b-8e7c-b3118f30c6bd'
  scope: tenant()
}

resource storageFileSharePermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('storageFileDataPrivilegedContributorRole', managedIdentity.id, storageAccount.id)
  scope: storageAccount
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: storageFileDataPrivilegedContributor.id
    principalType: 'ServicePrincipal'
  }
}

// Role required for deployment script to be able to use a storage account via private networking
resource storageDataAccessContributor 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'c12c1c16-33a1-487b-954d-41c89c60f349'
  scope: tenant()
}

resource storageDataAccessPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('storageFileDataPrivilegedContributorRole', managedIdentity.id, storageAccount.id)
  scope: storageAccount
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: storageDataAccessContributor.id
    principalType: 'ServicePrincipal'
  }
}

@description('The resource ID of the created managed identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created storage account.')
output storageAccountResourceId string = storageAccount.id
