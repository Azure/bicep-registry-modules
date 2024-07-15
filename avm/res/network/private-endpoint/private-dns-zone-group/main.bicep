metadata name = 'Private Endpoint Private DNS Zone Groups'
metadata description = 'This module deploys a Private Endpoint Private DNS Zone Group.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent private endpoint. Required if the template is used in a standalone deployment.')
param privateEndpointName string

@description('Required. Array of private DNS zone resource IDs. A DNS zone group can support up to 5 DNS zones.')
@minLength(1)
@maxLength(5)
param privateDNSResourceIds array

@description('Optional. Array of names for each private private DNS zone configuration, in the same order as `privateDNSResourceIds`. Individual values can be set to `null` to use the default name.')
param privateDNSConfigurationNames array?

@description('Optional. The name of the private DNS zone group.')
param name string = 'default'

var privateDnsZoneConfigs = [
  for (privateDNSResourceId, index) in privateDNSResourceIds: {
    name: privateDNSConfigurationNames[?index] ?? last(split(privateDNSResourceId, '/'))!
    properties: {
      privateDnsZoneId: privateDNSResourceId
    }
  }
]

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-11-01' existing = {
  name: privateEndpointName
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = {
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
