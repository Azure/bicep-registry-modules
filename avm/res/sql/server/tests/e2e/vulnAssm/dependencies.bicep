@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
  }
}

@description('The resource ID of the created managed identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id
