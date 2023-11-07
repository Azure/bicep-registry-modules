param cosmosDBAccountId string
param location string
param endpoint object

var manualApprovalEnabled = endpoint.?isManualApproval ?? false

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-07-01' = {
  name: endpoint.name
  location: location
  tags: endpoint.?tags ?? {}
  properties: {
    privateLinkServiceConnections: manualApprovalEnabled ? null : [
      {
        name: endpoint.name
        properties: {
          privateLinkServiceId: cosmosDBAccountId
          groupIds: [ endpoint.groupId ]
        }
      }
    ]
    manualPrivateLinkServiceConnections: manualApprovalEnabled ? [
      {
        name: endpoint.name
        properties: {
          privateLinkServiceId: cosmosDBAccountId
          groupIds: [ endpoint.groupId ]
        }
      }
    ] : null
    subnet: {
      id: endpoint.subnetId
    }
  }
  resource privateDnsZoneGroup 'privateDnsZoneGroups' = if (endpoint.?privateDnsZoneId != null) {
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