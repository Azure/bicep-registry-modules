@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Public IP for the Virtual Network Gateway.')
param primaryPublicIPName string

@description('Required. The name of the Virtual Network.')
param primaryVirtualNetworkName string

@description('Required. The name of the Virtual Network Gateway.')
param primaryVirtualNetworkGatewayName string

@description('Required. The name of the Local Network Gateway.')
param localNetworkGatewayName string

resource primaryVirtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: primaryVirtualNetworkName
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
          addressPrefix: '10.0.255.0/27'
        }
      }
    ]
  }
}

resource primaryPublicIP 'Microsoft.Network/publicIPAddresses@2024-05-01' = {
  name: primaryPublicIPName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource primaryVirtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2024-05-01' = {
  name: primaryVirtualNetworkGatewayName
  location: location
  properties: {
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: true
    enablePrivateIpAddress: true
    bgpSettings: {
      asn: 65515
      bgpPeeringAddresses: [
        {
          ipconfigurationId: resourceId('Microsoft.Network/virtualNetworkGateways/ipConfigurations', primaryVirtualNetworkGatewayName, 'default')
          customBgpIpAddresses: ['169.254.21.1']
        }
      ]
    }
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
    ipConfigurations: [
      {
        name: 'default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: primaryVirtualNetwork.properties.subnets[0].id
          }
          publicIPAddress: {
            id: primaryPublicIP.id
          }
        }
      }
    ]
  }
}

resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2024-05-01' = {
  name: localNetworkGatewayName
  location: location
  properties: {
    localNetworkAddressSpace: {
      addressPrefixes: [
        '192.168.0.0/16'
      ]
    }
    gatewayIpAddress: '203.0.113.100'
    bgpSettings: {
      asn: 65001
      bgpPeeringAddress: '192.168.255.1'
    }
  }
}

@description('The resource ID of the created Virtual Network Gateway.')
output primaryVNETGatewayResourceID string = primaryVirtualNetworkGateway.id

@description('The resource ID of the created Local Network Gateway.')
output localNetworkGatewayResourceID string = localNetworkGateway.id
