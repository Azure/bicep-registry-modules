metadata name = 'Event Grid Domain Topics'
metadata description = 'This module deploys an Event Grid Domain Topic.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the Event Grid Domain Topic.')
param name string

@description('Conditional. The name of the parent Event Grid Domain. Required if the template is used in a standalone deployment.')
param domainName string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

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
