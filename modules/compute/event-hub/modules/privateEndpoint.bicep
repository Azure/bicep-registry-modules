param location string
param tags object
param manualApprovalEnabled bool
param namespaceName string
param name string
param groupIds array
param subnetId string
param privateDnsZoneId string

resource namespace 'Microsoft.EventHub/namespaces@2022-10-01-preview' existing = {
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
  }
  resource privateDnsZoneGroup 'privateDnsZoneGroups@2022-05-01' = if (!empty(privateDnsZoneId)) {
    name: 'default'
    properties: {
      privateDnsZoneConfigs: [ {
          name: 'default'
          properties: {
            privateDnsZoneId: privateDnsZoneId
          }
        } ]
    }
  }

}
