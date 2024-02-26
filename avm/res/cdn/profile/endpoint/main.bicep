metadata name = 'CDN Profiles Endpoints'
metadata description = 'This module deploys a CDN Profile Endpoint.'
metadata owner = 'Azure/module-maintainers'

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

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

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

module endpoint_origins 'origin/main.bicep' = [for origin in properties.origins: {
  name: '${name}-origins-${origin.name}'
  params: {
    profileName: profile.name
    endpointName: endpoint.name
    name: origin.name
    hostName: origin.properties.hostName
    httpPort: contains(origin.properties, 'httpPort') ? origin.properties.httpPort : 80
    httpsPort: contains(origin.properties, 'httpsPort') ? origin.properties.httpsPort : 443
    enabled: origin.properties.enabled
    priority: contains(origin.properties, 'priority') ? origin.properties.priority : -1
    weight: contains(origin.properties, 'weight') ? origin.properties.weight : -1
    originHostHeader: contains(origin.properties, 'originHostHeader') ? origin.properties.originHostHeader : ''
    privateLinkAlias: contains(origin.properties, 'privateLinkAlias') ? origin.properties.privateLinkAlias : ''
    privateLinkLocation: contains(origin.properties, 'privateLinkLocation') ? origin.properties.privateLinkLocation : ''
    privateLinkResourceId: contains(origin.properties, 'privateLinkResourceId') ? origin.properties.privateLinkResourceId : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

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
