metadata name = 'CDN Profiles Origin Group'
metadata description = 'This module deploys a CDN Profile Origin Group.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the origin group.')
param name string

@description('Required. The name of the CDN profile.')
param profileName string

@description('Optional. Health probe settings to the origin that is used to determine the health of the origin.')
param healthProbeSettings object = {}

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
param origins array = []

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

resource profile 'Microsoft.Cdn/profiles@2023-05-01' existing = {
  name: profileName
}

resource originGroup 'Microsoft.Cdn/profiles/originGroups@2023-05-01' = {
  name: name
  parent: profile
  properties: {
    healthProbeSettings: !empty(healthProbeSettings) ? healthProbeSettings : null
    loadBalancingSettings: loadBalancingSettings
    sessionAffinityState: sessionAffinityState
    trafficRestorationTimeToHealedOrNewEndpointsInMinutes: trafficRestorationTimeToHealedOrNewEndpointsInMinutes
  }
}

module origin 'origin/main.bicep' = [for (origion, index) in origins: {
  name: '${uniqueString(deployment().name)}-OriginGroup-Origin-${index}'
  params: {
    name: origion.name
    profileName: profileName
    hostName: origion.hostName
    originGroupName: originGroup.name
    enabledState: contains(origion, 'enabledState') ? origion.enabledState : 'Enabled'
    enforceCertificateNameCheck: contains(origion, 'enforceCertificateNameCheck') ? origion.enforceCertificateNameCheck : true
    httpPort: contains(origion, 'httpPort') ? origion.httpPort : 80
    httpsPort: contains(origion, 'httpsPort') ? origion.httpsPort : 443
    originHostHeader: contains(origion, 'originHostHeader') ? origion.originHostHeader : origion.hostName
    priority: contains(origion, 'priority') ? origion.priority : 1
    weight: contains(origion, 'weight') ? origion.weight : 1000
    sharedPrivateLinkResource: contains(origion, 'sharedPrivateLinkResource') ? origion.sharedPrivateLinkResource : null
    enableDefaultTelemetry: enableReferencedModulesTelemetry
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
