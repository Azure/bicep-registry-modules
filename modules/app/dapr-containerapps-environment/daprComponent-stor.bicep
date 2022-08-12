param name string
param location string
param entityName string
param containerAppEnvName string

param createAzureServiceForComponent bool = true

param scopes array = []

var daprComponent = 'state.azure.blobstorage'
var rawStorageAccountName='st${name}${uniqueString(resourceGroup().id, name)}'
var storageAccountName = length(rawStorageAccountName) > 24 ? substring(rawStorageAccountName, 0, 24) : rawStorageAccountName

resource containerAppEnv 'Microsoft.App/managedEnvironments@2022-01-01-preview' existing = {
  name: containerAppEnvName
}

resource daprStorageAccStateStore 'Microsoft.App/managedEnvironments/daprComponents@2022-03-01'  = if(daprComponent=='state.azure.blobstorage') {
  name: '${name}-state'
  parent: containerAppEnv
  properties: {
    componentType: daprComponent
    version: 'v1'
    secrets: [
      {
        name: 'storageaccountkey'
        value: listKeys(storageaccount.id, storageaccount.apiVersion).keys[0].value
      }
    ]
    metadata: [
      {
        name: 'accountKey'
        secretRef: 'storageaccountkey'
      }
      {
        name: 'accountName'
        value: storageaccount.name
      }
      {
        name: 'containerName'
        value: entityName
      }
    ]
    scopes: scopes
  }
}

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-09-01' = if(createAzureServiceForComponent && daprComponent=='state.azure.blobstorage') {
  name: storageAccountName
  kind: 'StorageV2'
  location: location
  sku: {
    name: 'Standard_LRS'
  }

  resource stateb 'blobServices' = {
    name: 'default'
    
    resource statec 'containers' = {
      name: entityName
      properties: {
        publicAccess: 'None'
      }
    }
  }
}
