@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Public IP Prefix to create.')
param publicIPPrefixName string

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
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 20, 0)
        }
      }
      {
        name: 'AzureFirewallManagementSubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 20, 1)
        }
      }
    ]
  }
}

resource publicIPPrefix 'Microsoft.Network/publicIPPrefixes@2023-11-01' = {
  name: publicIPPrefixName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    prefixLength: 30
    publicIPAddressVersion: 'IPv4'
  }
  zones: []
}

@description('The resource ID of the created Virtual Network.')
output virtualNetworkResourceId string = virtualNetwork.id

@description('The resource ID of the created Public IP Prefix')
output publicIPPrefixResourceId string = publicIPPrefix.id
