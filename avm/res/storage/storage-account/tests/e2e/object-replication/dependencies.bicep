@minLength(3)
@maxLength(24)
@description('Required. Name of the destination storage account for object replication.')
param storageAccountName string

@description('Required. The location to deploy resources to.')
param location string

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2025-01-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    isVersioningEnabled: true
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-01-01' = {
  parent: blobServices
  name: 'container01'
}

@description('Resource ID of the destination storage account.')
output storageAccountResourceId string = storageAccount.id

@description('Name of the destination storage account.')
output storageAccountName string = storageAccount.name

@description('Name of the blob container created in the destination storage account.')
output containerName string = container.name
