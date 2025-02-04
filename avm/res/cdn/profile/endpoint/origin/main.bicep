metadata name = 'CDN Profiles Endpoints Origins'
metadata description = 'This module deploys a CDN Profile Endpoint Origin.'

@description('Required. The name of the CDN Endpoint.')
param endpointName string

@description('Required. The name of the origin.')
param name string

@description('Optional. Whether the origin is enabled for load balancing.')
param enabled bool = true

@description('Required. The hostname of the origin.')
param hostName string

@description('Optional. The HTTP port of the origin.')
param httpPort int = 80

@description('Optional. The HTTPS port of the origin.')
param httpsPort int = 443

@description('Conditional. The priority of origin in given origin group for load balancing. Required if `weight` is provided.')
param priority int = -1

@description('Conditional. The weight of the origin used for load balancing. Required if `priority` is provided.')
param weight int = -1

@description('Conditional. The private link alias of the origin. Required if privateLinkLocation is provided.')
param privateLinkAlias string?

@description('Conditional. The private link location of the origin. Required if privateLinkAlias is provided.')
param privateLinkLocation string?

@description('Optional. The private link resource ID of the origin.')
param privateLinkResourceId string?

@description('Optional. The host header value sent to the origin.')
param originHostHeader string?

@description('Optional. The name of the CDN profile. Default to "default".')
param profileName string = 'default'

resource profile 'Microsoft.Cdn/profiles@2021-06-01' existing = {
  name: profileName
}

resource endpoint 'Microsoft.Cdn/profiles/endpoints@2021-06-01' existing = {
  parent: profile
  name: endpointName
}

resource origin 'Microsoft.Cdn/profiles/endpoints/origins@2021-06-01' = {
  parent: endpoint
  name: name
  properties: union(
    {
      hostName: hostName
      httpPort: httpPort
      enabled: enabled
      httpsPort: httpsPort
    },
    ((priority > 0 || weight > 0)
      ? {
          priority: priority
          weight: weight
        }
      : {}),
    (!empty(privateLinkAlias) && !empty(privateLinkLocation)
      ? {
          privateLinkAlias: privateLinkAlias
          privateLinkLocation: privateLinkLocation
        }
      : {}),
    (!empty(privateLinkResourceId)
      ? {
          privateLinkResourceId: privateLinkResourceId
        }
      : {}),
    (!empty(originHostHeader)
      ? {
          originHostHeader: originHostHeader
        }
      : {})
  )
}

@description('The name of the endpoint.')
output name string = origin.name

@description('The resource ID of the endpoint.')
output resourceId string = origin.id

@description('The name of the resource group the endpoint was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = endpoint.location
