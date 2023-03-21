param location string
param name string
param prefix string
param blobServiceName string = 'default'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: '${prefix}${name}01'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  location: location
  properties: {
    allowBlobPublicAccess: false
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
  name: blobServiceName
  parent: storageAccount
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${prefix}${name}01'
  parent: blobService
  properties: {}
}

output storageAccountId string = storageAccount.id
output containerName string = container.name
