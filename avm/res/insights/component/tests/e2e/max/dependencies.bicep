@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
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

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
