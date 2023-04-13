@description('Name of the function app.')
param functionAppName string

@description('Resource name of the function app.')
param functionAppRg string

@description('Name of the keyvault. This is used in the event subscription.')
param keyvaultName string

@description('Name of the keyvault secret.')
param secretName string

@description('Name of the rotate function, used to subscript to the keyvault event.')
param functionName string

resource function 'Microsoft.Web/sites/functions@2022-03-01' existing = {
  name: '${functionAppName}/${functionName}'
  scope: resourceGroup(functionAppRg)
}

resource keyvault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyvaultName
}

resource eventSubscription 'Microsoft.EventGrid/eventSubscriptions@2022-06-15' = {
  name: '${functionAppName}-${keyvaultName}-${secretName}'
  scope: keyvault
  properties: {
    destination: {
      endpointType: 'AzureFunction'
      properties: {
        maxEventsPerBatch: 1
        preferredBatchSizeInKilobytes: 64
        resourceId: function.id
      }
    }
    filter: {
      subjectBeginsWith: secretName
      subjectEndsWith: secretName
      includedEventTypes: [
        'Microsoft.KeyVault.SecretNearExpiry'
      ]
    }
  }
}
