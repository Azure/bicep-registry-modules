@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network 1 to create.')
param virtualNetwork1Name string

@description('Required. The name of the Virtual Network 2 to create.')
param virtualNetwork2Name string

var addressPrefix1 = '10.0.0.0/16'
var addressPrefix2 = '10.1.0.0/16'

resource virtualNetwork1 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: virtualNetwork1Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix1
      ]
    }
    subnets: [
      {
        name: 'subnet-1'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix1, 24, 0)
        }
      }
    ]
  }
}

resource virtualNetwork2 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: virtualNetwork2Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix2
      ]
    }
    subnets: [
      {
        name: 'subnet-1'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix2, 24, 0)
        }
      }
    ]
  }
}

@description('The resource ID of the created Virtual Network 1.')
output vnet1ResourceId string = virtualNetwork1.id

@description('The resource ID of the created Virtual Network 2.')
output vnet2ResourceId string = virtualNetwork2.id
