param storageAccountName string = uniqueString(resourceGroup().id)
param container string = resourceGroup().location

resource storageAccountContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: '${storageAccountName}/default/${container}'
  properties: {
    publicAccess: 'None'
  }
}
