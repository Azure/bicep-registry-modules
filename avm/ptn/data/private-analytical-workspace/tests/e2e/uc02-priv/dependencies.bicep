@description('Optional. The location to deploy to.')
param location string

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the subnet 01.')
param subnetName01 string

@description('Required. The name of the subnet 02.')
param subnetName02 string

@description('Required. The name of the subnet 03.')
param subnetName03 string

var subnets = [
  {
    name: subnetName01
    addressPrefix: '10.0.0.0/24'
  }
  {
    name: subnetName02
    addressPrefix: '10.0.1.0/24'
  }
  {
    name: subnetName03
    addressPrefix: '10.0.2.0/24'
  }
]

module vnet 'br/public:avm/res/network/virtual-network:0.2.0' = {
  name: virtualNetworkName
  params: {
    // Required parameters
    addressPrefixes: [
      '10.0.0.0/20'
    ]
    name: virtualNetworkName
    // Non-required parameters
    diagnosticSettings: []
    dnsServers: []
    location: location
    subnets: subnets
  }
}

@description('The resource ID of the created Virtual Network.')
output virtualNetworkResourceId string = vnet.outputs.resourceId
