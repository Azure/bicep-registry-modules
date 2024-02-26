metadata name = 'CDN Profiles AFD Endpoints'
metadata description = 'This module deploys a CDN Profile AFD Endpoint.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the AFD Endpoint.')
param name string

@description('Conditional. The name of the parent CDN profile. Required if the template is used in a standalone deployment.')
param profileName string

@description('Optional. The location of the AFD Endpoint.')
param location string = resourceGroup().location

@description('Optional. The tags of the AFD Endpoint.')
param tags object?

@description('Optional. Indicates the endpoint name reuse scope. The default value is TenantReuse.')
@allowed([
  'NoReuse'
  'ResourceGroupReuse'
  'SubscriptionReuse'
  'TenantReuse'
])
param autoGeneratedDomainNameLabelScope string = 'TenantReuse'

@description('Optional. Indicates whether the AFD Endpoint is enabled. The default value is Enabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param enabledState string = 'Enabled'

@description('Optional. The list of routes for this AFD Endpoint.')
param routes array = []

resource profile 'Microsoft.Cdn/profiles@2023-05-01' existing = {
  name: profileName
}

resource afd_endpoint 'Microsoft.Cdn/profiles/afdEndpoints@2023-05-01' = {
  name: name
  parent: profile
  location: location
  tags: tags
  properties: {
    autoGeneratedDomainNameLabelScope: autoGeneratedDomainNameLabelScope
    enabledState: enabledState
  }
}

module afd_endpoint_route 'route/main.bicep' = [for route in routes: {
  name: '${uniqueString(deployment().name, route.name)}-Profile-AfdEndpoint-Route'
  params: {
    name: route.name
    profileName: profile.name
    afdEndpointName: afd_endpoint.name
    cacheConfiguration: contains(route, 'cacheConfiguration') ? route.cacheConfiguration : null
    customDomainName: contains(route, 'customDomainName') ? route.customDomainName : ''
    enabledState: contains(route, 'enabledState') ? route.enabledState : 'Enabled'
    forwardingProtocol: contains(route, 'forwardingProtocol') ? route.forwardingProtocol : 'MatchRequest'
    httpsRedirect: contains(route, 'httpsRedirect') ? route.httpsRedirect : 'Enabled'
    linkToDefaultDomain: contains(route, 'linkToDefaultDomain') ? route.linkToDefaultDomain : 'Enabled'
    originGroupName: contains(route, 'originGroupName') ? route.originGroupName : ''
    originPath: contains(route, 'originPath') ? route.originPath : ''
    patternsToMatch: contains(route, 'patternsToMatch') ? route.patternsToMatch : []
    ruleSets: contains(route, 'ruleSets') ? route.ruleSets : []
    supportedProtocols: contains(route, 'supportedProtocols') ? route.supportedProtocols : []
  }
}]

@description('The name of the AFD Endpoint.')
output name string = afd_endpoint.name

@description('The resource id of the AFD Endpoint.')
output resourceId string = afd_endpoint.id

@description('The name of the resource group the endpoint was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = afd_endpoint.location
