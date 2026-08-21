metadata name = 'Private Endpoint Private DNS Zone Groups'
metadata description = 'This module deploys a Private Endpoint Private DNS Zone Group.'

@description('Conditional. The name of the parent private endpoint. Required if the template is used in a standalone deployment.')
param privateEndpointName string

@description('Required. Array of private DNS zone configurations of the private DNS zone group. A DNS zone group can support up to 5 DNS zones.')
@minLength(1)
@maxLength(5)
param privateDnsZoneConfigs privateDnsZoneGroupConfigType[]

@description('Optional. The name of the private DNS zone group.')
param name string = 'default'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2025-05-01' existing = {
  name: privateEndpointName
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-privendpoint-privdnszonegrp.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2025-05-01' = {
  name: name
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: [
      for privateDnsZoneConfig in privateDnsZoneConfigs: {
        name: privateDnsZoneConfig.?name ?? last(split(privateDnsZoneConfig.privateDnsZoneResourceId, '/'))
        properties: {
          privateDnsZoneId: privateDnsZoneConfig.privateDnsZoneResourceId
        }
      }
    ]
  }
}

@description('The name of the private endpoint DNS zone group.')
output name string = privateDnsZoneGroup.name

@description('The resource ID of the private endpoint DNS zone group.')
output resourceId string = privateDnsZoneGroup.id

@description('The resource group the private endpoint DNS zone group was deployed into.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //

@export()
@description('The type of a private DNS zone group configuration.')
type privateDnsZoneGroupConfigType = {
  @description('Optional. The name of the private DNS zone group config.')
  name: string?

  @description('Required. The resource id of the private DNS zone.')
  privateDnsZoneResourceId: string
}
