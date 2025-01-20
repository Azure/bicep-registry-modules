metadata name = 'Event Grid Domain Topics'
metadata description = 'This module deploys an Event Grid Domain Topic.'

@description('Required. The name of the Event Grid Domain Topic.')
param name string

@description('Conditional. The name of the parent Event Grid Domain. Required if the template is used in a standalone deployment.')
param domainName string

resource domain 'Microsoft.EventGrid/domains@2022-06-15' existing = {
  name: domainName
}

resource topic 'Microsoft.EventGrid/domains/topics@2022-06-15' = {
  name: name
  parent: domain
}

@description('The name of the event grid topic.')
output name string = topic.name

@description('The resource ID of the event grid topic.')
output resourceId string = topic.id

@description('The name of the resource group the event grid topic was deployed into.')
output resourceGroupName string = resourceGroup().name
