metadata name = 'Event Hub Namespace Event Hub Consumer Groups'
metadata description = 'This module deploys an Event Hub Namespace Event Hub Consumer Group.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent event hub namespace. Required if the template is used in a standalone deployment.s.')
param namespaceName string

@description('Conditional. The name of the parent event hub namespace event hub. Required if the template is used in a standalone deployment.')
param eventHubName string

@description('Required. The name of the consumer group.')
param name string

@description('Optional. User Metadata is a placeholder to store user-defined string data with maximum length 1024. e.g. it can be used to store descriptive data, such as list of teams and their contact information also user-defined configuration settings can be stored.')
param userMetadata string = ''

resource namespace 'Microsoft.EventHub/namespaces@2024-01-01' existing = {
  name: namespaceName

  resource eventhub 'eventhubs@2022-10-01-preview' existing = {
    name: eventHubName
  }
}

resource consumerGroup 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2024-01-01' = {
  name: name
  parent: namespace::eventhub
  properties: {
    userMetadata: !empty(userMetadata) ? userMetadata : null
  }
}

@description('The name of the consumer group.')
output name string = consumerGroup.name

@description('The resource ID of the consumer group.')
output resourceId string = consumerGroup.id

@description('The name of the resource group the consumer group was created in.')
output resourceGroupName string = resourceGroup().name
