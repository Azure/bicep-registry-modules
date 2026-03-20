@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Premium_LRS'
  }
  kind: 'BlockBlobStorage'
  properties: {
    allowSharedKeyAccess: true
  }
}

@description('The Storage Account connection string.')
@secure()
output storageConnectionString string = 'DefaultEndpointsProtocol=https;BlobEndpoint=https://${storageAccount.name}.blob.${environment().suffixes.storage};AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value}'

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id
