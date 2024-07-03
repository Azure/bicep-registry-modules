@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Key Vault to create.')
param privateLinkServiceName string

var addressPrefix = '10.0.0.0/16'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'defaultSubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 16, 0)
        }
      }
    ]
  }
}

resource privateLinkService 'Microsoft.Network/privateLinkServices@2023-11-01' = {
  name: privateLinkServiceName
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the created Private Link Service.')
output privateLinkServiceResourceId string = privateLinkService.id
