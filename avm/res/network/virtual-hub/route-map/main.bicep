metadata name = 'Virtual Hub Route Maps'
metadata description = 'This module deploys a Virtual Hub Route Map.'

@description('Required. The name of the route map.')
param name string

@description('Conditional. The name of the parent virtual hub. Required if the template is used in a standalone deployment.')
param virtualHubName string

@description('Optional. List of connections which have this route map associated for inbound traffic.')
param associatedInboundConnections string[]?

@description('Optional. List of connections which have this route map associated for outbound traffic.')
param associatedOutboundConnections string[]?

@description('Optional. List of route map rules to be applied.')
param rules resourceInput<'Microsoft.Network/virtualHubs/routeMaps@2025-05-01'>.properties.rules?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.res.network-virtualhubroutemap.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}',
    64
  )
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

resource virtualHub 'Microsoft.Network/virtualHubs@2025-05-01' existing = {
  name: virtualHubName
}

resource routeMap 'Microsoft.Network/virtualHubs/routeMaps@2025-05-01' = {
  name: name
  parent: virtualHub
  properties: {
    associatedInboundConnections: associatedInboundConnections
    associatedOutboundConnections: associatedOutboundConnections
    rules: rules
  }
}

@description('The name of the deployed route map.')
output name string = routeMap.name

@description('The resource ID of the deployed route map.')
output resourceId string = routeMap.id

@description('The resource group the route map was deployed into.')
output resourceGroupName string = resourceGroup().name
