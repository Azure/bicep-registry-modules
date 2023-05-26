param cosmosDBAccount object
param location string
param endpoint object

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-07-01' =  {
  name: endpoint.name
  location: location
  tags: endpoint.tags
  properties: {
    privateLinkServiceConnections: endpoint.manualApprovalEnabled ? null : [
      {
        name: endpoint.name
        properties: {
          privateLinkServiceId: cosmosDBAccount
          groupIds: endpoint.groupIds
        }
      }
    ]
    manualPrivateLinkServiceConnections: endpoint.manualApprovalEnabled ? [
      {
        name: endpoint.name
        properties: {
          privateLinkServiceId: cosmosDBAccount
          groupIds: endpoint.groupIds
        }
      }
    ] : null
    subnet: {
      id: endpoint.subnetId
    }
  }
  resource privateDnsZoneGroup 'privateDnsZoneGroups' = {
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
