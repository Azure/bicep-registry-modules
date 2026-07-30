@description('Required. The name of the Virtual WAN to create.')
param virtualWANName string

@description('Required. The name of the Virtual Hub to create.')
param virtualHubName string

@description('Required. The name of the VPN Gateway to create.')
param vpnGatewayName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource virtualWan 'Microsoft.Network/virtualWans@2025-01-01' = {
  name: virtualWANName
  location: location
}

resource virtualHub 'Microsoft.Network/virtualHubs@2025-01-01' = {
  name: virtualHubName
  location: location
  properties: {
    addressPrefix: '10.10.0.0/23'
    virtualWan: {
      id: virtualWan.id
    }
  }
}

// A gateway-based connection (S2S VPN, P2S VPN, or ExpressRoute) is a prerequisite for Route-maps.
// Deploying a VPN gateway makes the virtual hub Route-map capable.
resource vpnGateway 'Microsoft.Network/vpnGateways@2025-01-01' = {
  name: vpnGatewayName
  location: location
  properties: {
    virtualHub: {
      id: virtualHub.id
    }
    bgpSettings: {
      asn: 65515
    }
    vpnGatewayScaleUnit: 1
  }
}

@description('The resource ID of the created Virtual WAN.')
output virtualWANResourceId string = virtualWan.id

@description('The resource ID of the created VPN Gateway.')
output vpnGatewayResourceId string = vpnGateway.id
