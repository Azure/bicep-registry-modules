@description('Required. The name of the Spoke 1 Virtual Network to create.')
param virtualNetworkName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

var addressPrefix = '172.16.0.0/12'
var subnetName = 'defaultSubnet'

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
        name: subnetName
        properties: {
          addressPrefix: addressPrefix
        }
      }
    ]
  }
}

@description('The resource ID of the created Spoke 1 Virtual Network.')
output virtualNetworkResourceId string = virtualNetwork.id
