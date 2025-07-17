@description('Workload / application name prefix.')
param workloadName string

@description('The location to deploy the resources into.')
param location string

@description('Optional. Tags of the resources.')
param tags object = {}

resource vnet 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: 'vnet-${workloadName}'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/24']
    }
    subnets: [
      {
        name: 'agents'
        properties: {
          addressPrefix: '10.0.1.0/23'
        }
      }
      {
        name: 'private-endpoints'
        properties: {
          addressPrefix: '10.0.2.0/23'
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

module blobDnsZone 'dependencies.dns.bicep' = {
  name: take('privatelink.blob.${environment().suffixes.storage}-pdns-deployment', 64)
  params: {
    name: 'privatelink.blob.${environment().suffixes.storage}'
    virtualNetworkResourceId: vnet.id
    tags: tags
  }
}

module fileDnsZone 'dependencies.dns.bicep' = {
  name: take('privatelink.file.${environment().suffixes.storage}-pdns-deployment', 64)
  params: {
    name: 'privatelink.file.${environment().suffixes.storage}'
    virtualNetworkResourceId: vnet.id
    tags: tags
  }
}

module documentsDnsZone 'dependencies.dns.bicep' = {
  name: take(
    'privatelink.documents.${toLower(environment().name) == 'azureusgovernment' ? 'azure.us' : 'azure.com'}-pdns-deployment',
    64
  )
  params: {
    name: 'privatelink.documents.${toLower(environment().name) == 'azureusgovernment' ? 'azure.us' : 'azure.com'}'
    virtualNetworkResourceId: vnet.id
    tags: tags
  }
}

module searchDnsZone 'dependencies.dns.bicep' = {
  name: take('privatelink.search.windows.net-pdns-deployment', 64)
  params: {
    name: 'privatelink.search.windows.net'
    virtualNetworkResourceId: vnet.id
    tags: tags
  }
}

module keyVaultDnsZone 'dependencies.dns.bicep' = {
  name: take(
    'privatelink.${toLower(environment().name) == 'azureusgovernment' ? 'vaultcore.usgovcloudapi.net' : 'vaultcore.azure.net'}-pdns-deployment',
    64
  )
  params: {
    name: 'privatelink.${toLower(environment().name) == 'azureusgovernment' ? 'vaultcore.usgovcloudapi.net' : 'vaultcore.azure.net'}'
    virtualNetworkResourceId: vnet.id
    tags: tags
  }
}

module openaiDnsZone 'dependencies.dns.bicep' = {
  name: take(
    'privatelink.openai.${toLower(environment().name) == 'azureusgovernment' ? 'azure.us' : 'azure.com'}-pdns-deployment',
    64
  )
  params: {
    name: 'privatelink.openai.${toLower(environment().name) == 'azureusgovernment' ? 'azure.us' : 'azure.com'}'
    virtualNetworkResourceId: vnet.id
    tags: tags
  }
}

module servicesAiDnsZone 'dependencies.dns.bicep' = {
  name: take(
    'privatelink.services.ai.${toLower(environment().name) == 'azureusgovernment' ? 'azure.us' : 'azure.com'}-pdns-deployment',
    64
  )
  params: {
    name: 'privatelink.services.ai.${toLower(environment().name) == 'azureusgovernment' ? 'azure.us' : 'azure.com'}'
    virtualNetworkResourceId: vnet.id
    tags: tags
  }
}

module cognitiveServicesDnsZone 'dependencies.dns.bicep' = {
  name: take(
    'privatelink.cognitiveservices.${toLower(environment().name) == 'azureusgovernment' ? 'azure.us' : 'azure.com'}-pdns-deployment',
    64
  )
  params: {
    name: 'privatelink.cognitiveservices.${toLower(environment().name) == 'azureusgovernment' ? 'azure.us' : 'azure.com'}'
    virtualNetworkResourceId: vnet.id
    tags: tags
  }
}

output vnetResourceId string = vnet.id

output subnetPrivateEndpointsResourceId string = first(filter(
  vnet.properties.subnets,
  s => s.name == 'private-endpoints'
)).?id!
output subnetAgentResourceId string = first(filter(vnet.properties.subnets, s => s.name == 'agents')).?id!

output blobDnsZoneResourceId string = blobDnsZone.outputs.resourceId
output fileDnsZoneResourceId string = fileDnsZone.outputs.resourceId
output documentsDnsZoneResourceId string = documentsDnsZone.outputs.resourceId
output searchDnsZoneResourceId string = searchDnsZone.outputs.resourceId
output keyVaultDnsZoneResourceId string = keyVaultDnsZone.outputs.resourceId
output openaiDnsZoneResourceId string = openaiDnsZone.outputs.resourceId
output servicesAiDnsZoneResourceId string = servicesAiDnsZone.outputs.resourceId
output cognitiveServicesDnsZoneResourceId string = cognitiveServicesDnsZone.outputs.resourceId
