@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Public IP to create.')
param publicIPName string

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

var addressPrefix = '10.0.0.0/16'

resource publicIP 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: publicIPName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
}

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
          addressPrefix: cidrSubnet(addressPrefix, 24, 0)
        }
      }
      {
        name: 'privateLinkSubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 1)
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

@description('The resource ID of the created Virtual Network default subnet.')
output defaultSubnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the created Public IP.')
output publicIPResourceId string = publicIP.id
