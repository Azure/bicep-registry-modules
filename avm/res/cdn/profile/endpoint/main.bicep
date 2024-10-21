metadata name = 'CDN Profiles Endpoints'
metadata description = 'This module deploys a CDN Profile Endpoint.'

@description('Conditional. The name of the parent CDN profile. Required if the template is used in a standalone deployment.')
param profileName string

@description('Required. Name of the endpoint under the profile which is unique globally.')
param name string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@description('Required. Endpoint properties (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/endpoints?pivots=deployment-language-bicep#endpointproperties for details).')
param properties object

@description('Optional. Endpoint tags.')
param tags object?

resource profile 'Microsoft.Cdn/profiles@2021-06-01' existing = {
  name: profileName
}

resource endpoint 'microsoft.cdn/profiles/endpoints@2021-06-01' = {
  parent: profile
  name: name
  location: location
  properties: properties
  tags: tags
}

module endpoint_origins 'origin/main.bicep' = [
  for origin in properties.origins: {
    name: '${name}-origins-${origin.name}'
    params: {
      profileName: profile.name
      endpointName: endpoint.name
      name: origin.name
      hostName: origin.properties.hostName
      httpPort: origin.properties.?httpPort
      httpsPort: origin.properties.?httpsPort
      enabled: origin.properties.enabled
      priority: origin.properties.?priority
      weight: origin.properties.?weight
      originHostHeader: origin.properties.?originHostHeader
      privateLinkAlias: origin.properties.?privateLinkAlias
      privateLinkLocation: origin.properties.?privateLinkLocation
      privateLinkResourceId: origin.properties.?privateLinkResourceId
    }
  }
]

@description('The name of the endpoint.')
output name string = endpoint.name

@description('The resource ID of the endpoint.')
output resourceId string = endpoint.id

@description('The name of the resource group the endpoint was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = endpoint.location

@description('The properties of the endpoint.')
output endpointProperties object = endpoint.properties

@description('The uri of the endpoint.')
output uri string = 'https://${endpoint.properties.hostName}'
