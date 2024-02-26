metadata name = 'CDN Profiles Origin'
metadata description = 'This module deploys a CDN Profile Origin.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the origion.')
param name string

@description('Required. The name of the CDN profile.')
param profileName string

@description('Required. The name of the group.')
param originGroupName string

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Whether to enable health probes to be made against backends defined under backendPools. Health probes can only be disabled if there is a single enabled backend in single enabled backend pool.')
param enabledState string = 'Enabled'

@description('Optional. Whether to enable certificate name check at origin level.')
param enforceCertificateNameCheck bool = true

@description('Required. The address of the origin. Domain names, IPv4 addresses, and IPv6 addresses are supported.This should be unique across all origins in an endpoint.')
param hostName string

@description('Optional. The value of the HTTP port. Must be between 1 and 65535.')
param httpPort int = 80

@description('Optional. The value of the HTTPS port. Must be between 1 and 65535.')
param httpsPort int = 443

@description('Optional. The host header value sent to the origin with each request. If you leave this blank, the request hostname determines this value. Azure Front Door origins, such as Web Apps, Blob Storage, and Cloud Services require this host header value to match the origin hostname by default. This overrides the host header defined at Endpoint.')
param originHostHeader string = ''

@description('Optional. Priority of origin in given origin group for load balancing. Higher priorities will not be used for load balancing if any lower priority origin is healthy.Must be between 1 and 5.')
param priority int = 1

@description('Optional. The properties of the private link resource for private origin.')
param sharedPrivateLinkResource object = {}

@description('Optional. Weight of the origin in given origin group for load balancing. Must be between 1 and 1000.')
param weight int = 1000

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

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

resource profile 'Microsoft.Cdn/profiles@2023-05-01' existing = {
  name: profileName

  resource originGroup 'originGroups@2023-05-01' existing = {
    name: originGroupName
  }
}

resource origin 'Microsoft.Cdn/profiles/originGroups/origins@2023-05-01' = {
  name: name
  parent: profile::originGroup
  properties: {
    enabledState: enabledState
    enforceCertificateNameCheck: enforceCertificateNameCheck
    hostName: hostName
    httpPort: httpPort
    httpsPort: httpsPort
    originHostHeader: originHostHeader
    priority: priority
    sharedPrivateLinkResource: !empty(sharedPrivateLinkResource) ? sharedPrivateLinkResource : null
    weight: weight
  }
}

@description('The name of the origin.')
output name string = origin.name

@description('The resource id of the origin.')
output resourceId string = origin.id

@description('The name of the resource group the origin was created in.')
output resourceGroupName string = resourceGroup().name
