metadata name = 'CDN Profiles Origin Group'
metadata description = 'This module deploys a CDN Profile Origin Group.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the origin group.')
param name string

@description('Required. The name of the CDN profile.')
param profileName string

@description('Optional. Health probe settings to the origin that is used to determine the health of the origin.')
param healthProbeSettings object?

@description('Required. Load balancing settings for a backend pool.')
param loadBalancingSettings object

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Whether to allow session affinity on this host.')
param sessionAffinityState string = 'Disabled'

@description('Optional. Time in minutes to shift the traffic to the endpoint gradually when an unhealthy endpoint comes healthy or a new endpoint is added. Default is 10 mins.')
param trafficRestorationTimeToHealedOrNewEndpointsInMinutes int = 10

@description('Required. The list of origins within the origin group.')
param origins array

resource profile 'Microsoft.Cdn/profiles@2023-05-01' existing = {
  name: profileName
}

resource originGroup 'Microsoft.Cdn/profiles/originGroups@2023-05-01' = {
  name: name
  parent: profile
  properties: {
    healthProbeSettings: healthProbeSettings
    loadBalancingSettings: loadBalancingSettings
    sessionAffinityState: sessionAffinityState
    trafficRestorationTimeToHealedOrNewEndpointsInMinutes: trafficRestorationTimeToHealedOrNewEndpointsInMinutes
  }
}

module originGroup_origins 'origin/main.bicep' = [for (origin, index) in origins: {
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
    originHostHeader: origin.?originHostHeader ?? origin.hostName
    priority: origin.?priority
    weight: origin.?weight
    sharedPrivateLinkResource: origin.?sharedPrivateLinkResource
  }
}]

@description('The name of the origin group.')
output name string = originGroup.name

@description('The resource id of the origin group.')
output resourceId string = originGroup.id

@description('The name of the resource group the origin group was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = profile.location
