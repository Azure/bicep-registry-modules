metadata name = 'Private Endpoint Private DNS Zone Groups'
metadata description = 'This module deploys a Private Endpoint Private DNS Zone Group.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent private endpoint. Required if the template is used in a standalone deployment.')
param privateEndpointName string

@description('Required. Array of private DNS zone resource IDs. A DNS zone group can support up to 5 DNS zones.')
@minLength(1)
@maxLength(5)
param privateDNSResourceIds array

@description('Optional. The name of the private DNS zone group.')
param name string = 'default'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('The current released version of the module. Used for telemetry.')
var moduleVersion = '[[moduleVersion]]' // for example '1.0.0'

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-privateendpoint.${replace(moduleVersion, '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

var privateDnsZoneConfigs = [for privateDNSResourceId in privateDNSResourceIds: {
  name: last(split(privateDNSResourceId, '/'))!
  properties: {
    privateDnsZoneId: privateDNSResourceId
  }
}]

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-04-01' existing = {
  name: privateEndpointName
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-04-01' = {
  name: name
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: privateDnsZoneConfigs
  }
}

@description('The name of the private endpoint DNS zone group.')
output name string = privateDnsZoneGroup.name

@description('The resource ID of the private endpoint DNS zone group.')
output resourceId string = privateDnsZoneGroup.id

@description('The resource group the private endpoint DNS zone group was deployed into.')
output resourceGroupName string = resourceGroup().name
