metadata name = 'Event Hub Namespace Event Hub Authorization Rules'
metadata description = 'This module deploys an Event Hub Namespace Event Hub Authorization Rule.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent event hub namespace. Required if the template is used in a standalone deployment.')
param namespaceName string

@description('Conditional. The name of the parent event hub namespace event hub. Required if the template is used in a standalone deployment.')
param eventHubName string

@description('Required. The name of the authorization rule.')
param name string

@description('Optional. The rights associated with the rule.')
@allowed([
  'Listen'
  'Manage'
  'Send'
])
param rights array = []

resource namespace 'Microsoft.EventHub/namespaces@2024-01-01' existing = {
  name: namespaceName

  resource eventhub 'eventhubs@2022-10-01-preview' existing = {
    name: eventHubName
  }
}

resource authorizationRule 'Microsoft.EventHub/namespaces/eventhubs/authorizationRules@2024-01-01' = {
  name: name
  parent: namespace::eventhub
  properties: {
    rights: rights
  }
}

@description('The name of the authorization rule.')
output name string = authorizationRule.name

@description('The resource ID of the authorization rule.')
output resourceId string = authorizationRule.id

@description('The name of the resource group the authorization rule was created in.')
output resourceGroupName string = resourceGroup().name
