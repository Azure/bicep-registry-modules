metadata name = 'Digital Twins Instance Event Grid Endpoints'
metadata description = 'This module deploys a Digital Twins Instance Event Grid Endpoint.'

@description('Optional. The name of the Digital Twin Endpoint.')
param name string = 'EventGridEndpoint'

@description('Conditional. The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment.')
param digitalTwinInstanceName string

@description('Required. EventGrid Topic Endpoint.')
param topicEndpoint string

@description('Required. The resource ID of the Event Grid to get access keys from.')
param eventGridDomainResourceId string

@description('Optional. Dead letter storage secret for key-based authentication. Will be obfuscated during read.')
@secure()
param deadLetterSecret string = ''

@description('Optional. Dead letter storage URL for identity-based authentication.')
param deadLetterUri string = ''

resource digitalTwinsInstance 'Microsoft.DigitalTwins/digitalTwinsInstances@2023-01-31' existing = {
  name: digitalTwinInstanceName
}

resource endpoint 'Microsoft.DigitalTwins/digitalTwinsInstances/endpoints@2023-01-31' = {
  name: name
  parent: digitalTwinsInstance
  properties: {
    endpointType: 'EventGrid'
    authenticationType: 'KeyBased'
    TopicEndpoint: topicEndpoint
    accessKey1: listkeys(eventGridDomainResourceId, '2022-06-15').key1
    accessKey2: listkeys(eventGridDomainResourceId, '2022-06-15').key2
    deadLetterSecret: deadLetterSecret
    deadLetterUri: deadLetterUri
  }
}

@description('The resource ID of the Endpoint.')
output resourceId string = endpoint.id

@description('The name of the resource group the resource was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Endpoint.')
output name string = endpoint.name
