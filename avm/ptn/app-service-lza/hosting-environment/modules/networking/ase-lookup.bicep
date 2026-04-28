// Helper module to look up ASE properties from within the resource group scope.
// This avoids the ARM template validation issue with conditional existing resources
// in subscription-scoped deployments.

@description('Required. The name of the ASE.')
param aseName string

resource aseExisting 'Microsoft.Web/hostingEnvironments@2025-03-01' existing = {
  name: aseName
}

@description('The internal inbound IP address of the ASE.')
#disable-next-line BCP053 // The ARM API at 2025-03-01 returns networkingConfiguration properties at the top level, not under a nested 'properties' bag
output internalInboundIpAddress string = aseExisting.properties.networkingConfiguration.internalInboundIpAddresses[0]
