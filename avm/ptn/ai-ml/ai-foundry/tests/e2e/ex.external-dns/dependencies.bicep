@description('Required. Workload name used for the virtual network.')
param workloadName string

@description('Required. Location of the virtual network.')
param location string

resource vnet 'Microsoft.Network/virtualNetworks@2025-01-01' = {
  name: 'vnet-${workloadName}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
    subnets: [
      {
        name: 'private-endpoints'
        properties: {
          addressPrefix: '10.0.0.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

output subnetPrivateEndpointsResourceId string = first(vnet.properties.subnets).?id!
