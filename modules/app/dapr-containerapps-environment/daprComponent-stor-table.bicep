param name string
param location string
param entityName string
param containerAppEnvName string

param createAzureServiceForComponent bool = true

param scopes array = []

var daprComponent = 'state.azure.tablestorage'
var storageAccountName = take(toLower('st${name}${uniqueString(resourceGroup().id, name)}'),24)

resource containerAppEnv 'Microsoft.App/managedEnvironments@2022-06-01-preview' existing = {
  name: containerAppEnvName
}

resource daprStorageAccStateStore 'Microsoft.App/managedEnvironments/daprComponents@2022-06-01-preview'  = if(daprComponent=='state.azure.blobstorage') {
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
        name: 'tableName'
        value: entityName
      }
    ]
    scopes: scopes
  }
}

resource storageaccount 'Microsoft.Storage/storageAccounts@2022-05-01' = if(createAzureServiceForComponent && daprComponent=='state.azure.blobstorage') {
  name: storageAccountName
  kind: 'StorageV2'
  location: location
  sku: {
    name: 'Standard_LRS'
  }

  resource default 'tableServices' = {
    name: 'default'
    
    resource queue 'tables' = {
      name: entityName
    }
  }
}
