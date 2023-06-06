param cosmosDBAccountId string
param location string
param endpoint object

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-07-01' = {
  name: endpoint.name
  location: location
  tags: endpoint.?tags ?? {}
  properties: {
    privateLinkServiceConnections: endpoint.manualApprovalEnabled ? null : [
      {
        name: endpoint.name
        properties: {
          privateLinkServiceId: cosmosDBAccountId
          groupIds: endpoint.groupIds
        }
      }
    ]
    manualPrivateLinkServiceConnections: endpoint.manualApprovalEnabled ? [
      {
        name: endpoint.name
        properties: {
          privateLinkServiceId: cosmosDBAccountId
          groupIds: endpoint.groupIds
        }
      }
    ] : null
    subnet: {
      id: endpoint.subnetId
    }
  }
  resource privateDnsZoneGroup 'privateDnsZoneGroups' = if (endpoint.privateDnsZoneId != null) {
    name: 'default'
    properties: {
      privateDnsZoneConfigs: [ {
          name: 'default'
          properties: {
            privateDnsZoneId: endpoint.privateDnsZoneId
          }
        } ]
    }
  }
}