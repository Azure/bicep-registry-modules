metadata name = 'Event Grid Domain Topics'
metadata description = 'This module deploys an Event Grid Domain Topic.'

@description('Required. The name of the Event Grid Domain Topic.')
param name string

@description('Conditional. The name of the parent Event Grid Domain. Required if the template is used in a standalone deployment.')
param domainName string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.eventgrid-domain-topic.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
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
