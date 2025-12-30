@description('Workload / application name prefix.')
param workloadName string

@description('The location to deploy the resources into.')
param location string

@description('Optional. Tags of the resources.')
param tags object = {}

// NOTE: Foundry currently requires an address space of 192.168.0.0/16 for agent vnet integration
var addressPrefix = '192.168.0.0/16'

resource vnet 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: 'vnet-${workloadName}'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [addressPrefix]
    }
    subnets: [
      {
        name: 'agents'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 23, 0)
          delegations: [
            {
              name: 'Microsoft.App/environments'
              properties: {
                serviceName: 'Microsoft.App/environments'
              }
            }
          ]
        }
      }
      {
        name: 'private-endpoints'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 23, 1)
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

module dnsZones '../../shared/privateDnsZone.bicep' = [
  for item in [
    'privatelink.blob.${environment().suffixes.storage}'
    'privatelink.documents.${toLower(environment().name) == 'azureusgovernment' ? 'azure.us' : 'azure.com'}'
    'privatelink.search.windows.net'
    'privatelink.${toLower(environment().name) == 'azureusgovernment' ? 'vaultcore.usgovcloudapi.net' : 'vaultcore.azure.net'}'
    'privatelink.openai.${toLower(environment().name) == 'azureusgovernment' ? 'azure.us' : 'azure.com'}'
    'privatelink.services.ai.${toLower(environment().name) == 'azureusgovernment' ? 'azure.us' : 'azure.com'}'
    'privatelink.cognitiveservices.${toLower(environment().name) == 'azureusgovernment' ? 'azure.us' : 'azure.com'}'
  ]: {
    params: {
      name: item
      virtualNetworkResourceId: vnet.id
      tags: tags
    }
  }
]

output vnetResourceId string = vnet.id

output subnetPrivateEndpointsResourceId string = first(filter(
  vnet.properties.subnets,
  s => s.name == 'private-endpoints'
)).?id!
output subnetAgentResourceId string = first(filter(vnet.properties.subnets, s => s.name == 'agents')).?id!

output blobDnsZoneResourceId string = dnsZones[0].outputs.resourceId
output documentsDnsZoneResourceId string = dnsZones[1].outputs.resourceId
output searchDnsZoneResourceId string = dnsZones[2].outputs.resourceId
output keyVaultDnsZoneResourceId string = dnsZones[3].outputs.resourceId
output openaiDnsZoneResourceId string = dnsZones[4].outputs.resourceId
output servicesAiDnsZoneResourceId string = dnsZones[5].outputs.resourceId
output cognitiveServicesDnsZoneResourceId string = dnsZones[6].outputs.resourceId
