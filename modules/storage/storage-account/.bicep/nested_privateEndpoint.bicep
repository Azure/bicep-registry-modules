param privateEndpointResourceId string
param privateEndpointVnetLocation string
param privateEndpointObj object
param tags object

var privateEndpointResourceName = last(split(privateEndpointResourceId, '/'))
var privateEndpointName = contains(privateEndpointObj, 'name') ? (empty(privateEndpointObj.name) ? '${privateEndpointResourceName}-${privateEndpointObj.service}' : privateEndpointObj.name) : '${privateEndpointResourceName}-${privateEndpointObj.service}'
var privateDnsZoneResourceIds = contains(privateEndpointObj, 'privateDnsZoneResourceIds') ? ((empty(privateEndpointObj.privateDnsZoneResourceIds) ? [] : privateEndpointObj.privateDnsZoneResourceIds)) : []

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: privateEndpointName
  location: privateEndpointVnetLocation
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: privateEndpointResourceId
          groupIds: [
            privateEndpointObj.service
          ]
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: privateEndpointObj.subnetResourceId
    }
    customDnsConfigs: contains(privateEndpointObj, 'customDnsConfigs') ? (empty(privateEndpointObj.customDnsConfigs) ? null : privateEndpointObj.customDnsConfigs) : null
  }

  resource privateDnsZoneGroups 'privateDnsZoneGroups@2021-02-01' = {
    name: 'default'
    properties: {
      privateDnsZoneConfigs: [for privateDnsZoneResourceId in privateDnsZoneResourceIds: {
        name: last(split(privateDnsZoneResourceId, '/'))
        properties: {
          privateDnsZoneId: privateDnsZoneResourceId
        }
      }]
    }
  }
}
