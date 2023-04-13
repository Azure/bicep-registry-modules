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

@description('Name of the system topic for keyvault event subscription')
param systemTopicName string

resource function 'Microsoft.Web/sites/functions@2022-03-01' existing = {
  name: '${functionAppName}/${functionName}'
  scope: resourceGroup(functionAppRg)
}

resource systemTopic 'Microsoft.EventGrid/systemTopics@2022-06-15' existing = {
  name: systemTopicName
}

resource topicSubscription 'Microsoft.EventGrid/systemTopics/eventSubscriptions@2022-06-15' = {
  name: '${functionAppName}-${keyvaultName}-${secretName}'
  parent: systemTopic
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
