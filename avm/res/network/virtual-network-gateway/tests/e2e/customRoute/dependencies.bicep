@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name prefix for the Virtual Networks to create.')
param virtualNetworkNamePrefix string

@description('Required. The name prefix for the Local Network Gateways to create.')
param localNetworkGatewayNamePrefix string

// Create separate virtual networks for each test scenario
// Main test VNet (with custom routes)
resource virtualNetworkMain 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: '${virtualNetworkNamePrefix}-main'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

// Empty routes test VNet
resource virtualNetworkEmpty 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: '${virtualNetworkNamePrefix}-empty'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.1.0.0/24'
        }
      }
    ]
  }
}

// No routes test VNet
resource virtualNetworkNull 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: '${virtualNetworkNamePrefix}-null'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.2.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.2.0.0/24'
        }
      }
    ]
  }
}

// Create corresponding local network gateways for each test
resource localNetworkGatewayMain 'Microsoft.Network/localNetworkGateways@2024-07-01' = {
  name: '${localNetworkGatewayNamePrefix}-main'
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

resource localNetworkGatewayEmpty 'Microsoft.Network/localNetworkGateways@2024-07-01' = {
  name: '${localNetworkGatewayNamePrefix}-empty'
  location: location
  properties: {
    gatewayIpAddress: '100.100.100.101'
    localNetworkAddressSpace: {
      addressPrefixes: [
        '192.168.1.0/24'
      ]
    }
  }
}

resource localNetworkGatewayNull 'Microsoft.Network/localNetworkGateways@2024-07-01' = {
  name: '${localNetworkGatewayNamePrefix}-null'
  location: location
  properties: {
    gatewayIpAddress: '100.100.100.102'
    localNetworkAddressSpace: {
      addressPrefixes: [
        '192.168.2.0/24'
      ]
    }
  }
}

@description('The resource ID of the main test Virtual Network.')
output vnetMainResourceId string = virtualNetworkMain.id

@description('The resource ID of the empty routes test Virtual Network.')
output vnetEmptyResourceId string = virtualNetworkEmpty.id

@description('The resource ID of the null routes test Virtual Network.')
output vnetNullResourceId string = virtualNetworkNull.id

@description('The resource ID of the main test Local Network Gateway.')
output localNetworkGatewayMainResourceId string = localNetworkGatewayMain.id

@description('The resource ID of the empty routes test Local Network Gateway.')
output localNetworkGatewayEmptyResourceId string = localNetworkGatewayEmpty.id

@description('The resource ID of the null routes test Local Network Gateway.')
output localNetworkGatewayNullResourceId string = localNetworkGatewayNull.id
