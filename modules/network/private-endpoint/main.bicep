@description('The name of the Private Endpoint.')
@minLength(2)
@maxLength(64)
param name string

@description('Location for the Private Endpoint.')
param location string = resourceGroup().location

@description('The ID of the Private Link Service.')
param privateLinkServiceId string

@description('The ID of the Subnet to associate with the Private Endpoint.')
param subnetId string

@description('The group IDs to associate with the Private Endpoint.')
param groupIds array = []

@description('The Private DNS Zones to associate with the Private Endpoint.')
param privateDnsZones array = []

@description('Flag to enable manual approval for the Private Endpoint.')
param manualApprovalEnabled bool = false

@description('The name of the custom Network Interface to associate with the Private Endpoint.')
param customNetworkInterfaceName string = ''

@description('Tags to assign too the Private Endpoint.')
param tags {*:string} = {}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-11-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: manualApprovalEnabled ? null : [
      {
        name: name
        properties: {
          privateLinkServiceId: privateLinkServiceId
          groupIds: !empty(groupIds) ? groupIds : null
        }
      }
    ]
    manualPrivateLinkServiceConnections: manualApprovalEnabled ? [
      {
        name: name
        properties: {
          privateLinkServiceId: privateLinkServiceId
          groupIds: !empty(groupIds) ? groupIds : null
        }
      }
    ] : null
    subnet: {
      id: subnetId
    }
    customNetworkInterfaceName: !empty(customNetworkInterfaceName) ? customNetworkInterfaceName : null
  }
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-11-01' = if (!empty(privateDnsZones)) {
  name: 'default'
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: [for privateDnsZone in privateDnsZones: {
      name: privateDnsZone.?name ?? 'default'
      properties: {
        privateDnsZoneId: privateDnsZone.zoneId
      }
    }]
  }
}

@description('Output. The name of the Private Endpoint.')
output name string = privateEndpoint.name

@description('Output. The ID of the Private Endpoint.')
output id string = privateEndpoint.id

@description('Output. The Network Interfaces of the Private Endpoint.')
output networkInterfaces array = privateEndpoint.properties.networkInterfaces
