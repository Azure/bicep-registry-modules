@description('Location for all Private Endpoint(s).')
param location string

@description('Array of Private Endpoint(s) to create.')
param privateEndpoints array = []

@description('Tags to assign for all Private Endpoint(s).')
param tags object = {}

@description('Flag to enable manual approval for all Private Endpoint(s).')
param manualApprovalEnabled bool = false

var varPrivateEndpoints = [for (p, i) in privateEndpoints: {
  name: p.name
  privateLinkServiceId: p.privateLinkServiceId
  groupIds: p.groupIds
  subnetId: p.subnetId
  privateDnsZones: contains(p, 'privateDnsZones') ? p.privateDnsZones : []
  customNetworkInterfaceName: contains(p, 'customNetworkInterfaceName') ? p.customNetworkInterfaceName : null
}]

@batchSize(1)
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-05-01' = [for endpoint in varPrivateEndpoints: {
  name: '${endpoint.name}-${uniqueString(endpoint.name, endpoint.subnetId, endpoint.privateLinkServiceId)}'
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: manualApprovalEnabled ? null : [
      {
        name: endpoint.name
        properties: {
          privateLinkServiceId: endpoint.privateLinkServiceId
          groupIds: !empty(endpoint.groupIds) ? endpoint.groupIds : null
        }
      }
    ]
    manualPrivateLinkServiceConnections: manualApprovalEnabled ? [
      {
        name: endpoint.name
        properties: {
          privateLinkServiceId: endpoint.privateLinkServiceId
          groupIds: !empty(endpoint.groupIds) ? endpoint.groupIds : null
        }
      }
    ] : null
    subnet: {
      id: endpoint.subnetId
    }
    customNetworkInterfaceName: endpoint.customNetworkInterfaceName
  }
}]

@batchSize(1)
resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-05-01' = [for (endpoint, i) in varPrivateEndpoints: {
  name: 'default'
  parent: privateEndpoint[i]
  properties: {
    privateDnsZoneConfigs: [for privateDnsZone in endpoint.privateDnsZones: {
      name: contains(privateDnsZone, 'name') ? privateDnsZone.name : 'default'
      properties: {
        privateDnsZoneId: privateDnsZone.zoneId
      }
    }]
  }
}]
