metadata name = 'CDN Profiles Origin Group'
metadata description = 'This module deploys a CDN Profile Origin Group.'

@description('Required. The name of the origin group.')
param name string

@description('Required. The name of the CDN profile.')
param profileName string

@description('Optional. Health probe settings to the origin that is used to determine the health of the origin.')
param healthProbeSettings resourceInput<'Microsoft.Cdn/profiles/originGroups@2025-04-15'>.properties.healthProbeSettings?

@description('Required. Load balancing settings for a backend pool.')
param loadBalancingSettings resourceInput<'Microsoft.Cdn/profiles/originGroups@2025-04-15'>.properties.loadBalancingSettings

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Whether to allow session affinity on this host.')
param sessionAffinityState string = 'Disabled'

@description('Optional. Time in minutes to shift the traffic to the endpoint gradually when an unhealthy endpoint comes healthy or a new endpoint is added. Default is 10 mins.')
param trafficRestorationTimeToHealedOrNewEndpointsInMinutes int = 10

@description('Required. The list of origins within the origin group.')
param origins originType[]

resource profile 'Microsoft.Cdn/profiles@2025-04-15' existing = {
  name: profileName
}

resource originGroup 'Microsoft.Cdn/profiles/originGroups@2025-04-15' = {
  name: name
  parent: profile
  properties: {
    healthProbeSettings: healthProbeSettings
    loadBalancingSettings: loadBalancingSettings
    sessionAffinityState: sessionAffinityState
    trafficRestorationTimeToHealedOrNewEndpointsInMinutes: trafficRestorationTimeToHealedOrNewEndpointsInMinutes
  }
}

module originGroup_origins 'origin/main.bicep' = [
  for (origin, index) in origins: {
    name: '${uniqueString(deployment().name)}-OriginGroup-Origin-${index}'
    params: {
      name: origin.name
      profileName: profileName
      hostName: origin.hostName
      originGroupName: originGroup.name
      enabledState: origin.?enabledState
      enforceCertificateNameCheck: origin.?enforceCertificateNameCheck
      httpPort: origin.?httpPort
      httpsPort: origin.?httpsPort
      originHostHeader: !empty(origin.?originHostHeader)
        ? origin.?originHostHeader
        : (origin.?originHostHeader == '' ? null : origin.hostName)
      priority: origin.?priority
      weight: origin.?weight
      sharedPrivateLinkResource: origin.?sharedPrivateLinkResource
    }
  }
]

@description('The name of the origin group.')
output name string = originGroup.name

@description('The resource id of the origin group.')
output resourceId string = originGroup.id

@description('The name of the resource group the origin group was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = profile.location

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type of the load balancing settings.')
type loadBalancingSettingsType = {
  @description('Required. Additional latency in milliseconds for probes to the backend. Must be between 0 and 1000.')
  additionalLatencyInMilliseconds: int

  @description('Required. Number of samples to consider for load balancing decisions.')
  sampleSize: int

  @description('Required. Number of samples within the sample window that must be successful to mark the backend as healthy.')
  successfulSamplesRequired: int
}

@export()
@description('The type of the health probe settings.')
type healthProbeSettingsType = {
  @description('Optional. The path relative to the origin that is used to determine the health of the origin.')
  probePath: string?

  @description('Optional. Protocol to use for health probe.')
  probeProtocol: 'Http' | 'Https' | 'NotSet' | null

  @description('Optional. The request type to probe.')
  probeRequestType: 'GET' | 'HEAD' | 'NotSet' | null

  @description('Optional. The number of seconds between health probes.Default is 240sec.')
  probeIntervalInSeconds: int?
}

@export()
@description('The name of the origin type.')
type originType = {
  @description('Required. The name of the origion.')
  name: string

  @description('Required. The address of the origin. Domain names, IPv4 addresses, and IPv6 addresses are supported.This should be unique across all origins in an endpoint.')
  hostName: string

  @description('Optional. Whether to enable health probes to be made against backends defined under backendPools. Health probes can only be disabled if there is a single enabled backend in single enabled backend pool.')
  enabledState: 'Enabled' | 'Disabled' | null

  @description('Optional. Whether to enable certificate name check at origin level.')
  enforceCertificateNameCheck: bool?

  @description('Optional. The value of the HTTP port. Must be between 1 and 65535.')
  httpPort: int?

  @description('Optional. The value of the HTTPS port. Must be between 1 and 65535.')
  httpsPort: int?

  @description('Optional. The host header value sent to the origin with each request. If you leave this blank, the request hostname determines this value. Azure Front Door origins, such as Web Apps, Blob Storage, and Cloud Services require this host header value to match the origin hostname by default. This overrides the host header defined at Endpoint.')
  originHostHeader: string?

  @description('Optional. Priority of origin in given origin group for load balancing. Higher priorities will not be used for load balancing if any lower priority origin is healthy.Must be between 1 and 5.')
  priority: int?

  @description('Optional. Weight of the origin in given origin group for load balancing. Must be between 1 and 1000.')
  weight: int?

  @description('Optional. The properties of the private link resource for private origin.')
  sharedPrivateLinkResource: resourceInput<'Microsoft.Cdn/profiles/originGroups/origins@2025-04-15'>.properties.sharedPrivateLinkResource?
}
