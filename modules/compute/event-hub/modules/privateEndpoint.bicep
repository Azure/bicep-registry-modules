param location string
param tags object
param manualApprovalEnabled bool
param namespaceName string
param name string
param groupIds array
param subnetId string
param privateDnsZones array
param customNetworkInterfaceName string

resource namespace 'Microsoft.EventHub/namespaces@2021-11-01' existing = {
  name: namespaceName
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: manualApprovalEnabled ? null : [
      {
        name: name
        properties: {
          privateLinkServiceId: namespace.id
          groupIds: !empty(groupIds) ? groupIds : null
        }
      }
    ]
    manualPrivateLinkServiceConnections: manualApprovalEnabled ? [
      {
        name: name
        properties: {
          privateLinkServiceId: namespace.id
          groupIds: !empty(groupIds) ? groupIds : null
        }
      }
    ] : null
    subnet: {
      id: subnetId
    }
    customNetworkInterfaceName: customNetworkInterfaceName
  }
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-05-01' = {
  name: 'default'
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: [for privateDnsZone in privateDnsZones: {
      name: contains(privateDnsZone, 'name') ? privateDnsZone.name : 'default'
      properties: {
        privateDnsZoneId: privateDnsZone.zoneId
      }
    }]
  }
}
