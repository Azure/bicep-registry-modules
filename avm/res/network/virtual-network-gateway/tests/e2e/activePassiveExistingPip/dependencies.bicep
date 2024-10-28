@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Local Network Gateway to create.')
param localNetworkGatewayName string

@description('Required. The name of the Public IP to create.')
param existingFirstPipName string

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
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 16, 0)
        }
      }
    ]
  }
}

resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2023-04-01' = {
  name: localNetworkGatewayName
  location: location
  properties: {
    gatewayIpAddress: '100.100.100.100'
    localNetworkAddressSpace: {
      addressPrefixes: [
        '192.168.0.0/24'
      ]
    }
  }
}


resource existingFirstPip 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: existingFirstPipName
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

@description('The resource ID of the created Virtual Network.')
output vnetResourceId string = virtualNetwork.id

@description('The resource ID of the created Local Network Gateway.')
output localNetworkGatewayResourceId string = localNetworkGateway.id

@description('The resource ID of the existing Public IP.')
output existingFirstPipResourceId string = existingFirstPip.id

