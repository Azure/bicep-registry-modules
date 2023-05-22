param location string
param tags object

param privateEndpoints privateEndpointsType[]

@batchSize(1)
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-05-01' = [for endpoint in privateEndpoints: {
  name: '${endpoint.name}-${uniqueString(endpoint.name, endpoint.subnetId, endpoint.privateLinkServiceId)}'
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: endpoint.manualApprovalEnabled ? null : [
      {
        name: endpoint.name
        properties: {
          privateLinkServiceId: endpoint.privateLinkServiceId
          groupIds: endpoint.groupIds
        }
      }
    ]
    manualPrivateLinkServiceConnections: endpoint.manualApprovalEnabled ? [
      {
        name: endpoint.name
        properties: {
          privateLinkServiceId: endpoint.?privateLinkServiceId
          groupIds: endpoint.groupIds
        }
      }
    ] : null
    subnet: {
      id: endpoint.subnetId
    }
    customNetworkInterfaceName: endpoint.?customNetworkInterfaceName
  }
}]

@batchSize(1)
resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-05-01' = [for (endpoint, i) in privateEndpoints: {
  name: 'default'
  parent: privateEndpoint[i]
  properties: {
    privateDnsZoneConfigs: endpoint.privateDnsZoneConfigs
  }
}]

// user-defined types
type PrivateDnsZoneConfigType = {
  @description('The resource name')
  name: string
  @description('Properties of the private dns zone configuration.')
  properties: {
    @description('The resource id of the private dns zone.')
    privateDnsZoneId: string
  }
}

type privateEndpointsType =  {
  name: string
  privateLinkServiceId: string
  groupIds: string[]
  subnetId: string
  privateDnsZoneConfigs: PrivateDnsZoneConfigType[]?
  customNetworkInterfaceName: string?
  manualApprovalEnabled: bool
}
