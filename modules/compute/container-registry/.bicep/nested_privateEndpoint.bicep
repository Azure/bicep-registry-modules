param location string
param tags object
param manualApprovalEnabled bool
param privateEndpoints array

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
  name: '${privateEndpoint[i].name}/default'
  properties: {
    privateDnsZoneConfigs: [for privateDnsZone in endpoint.privateDnsZones: {
      name: contains(privateDnsZone, 'name') ? privateDnsZone.name : 'default'
      properties: {
        privateDnsZoneId: privateDnsZone.zoneId
      }
    }]
  }
}]
