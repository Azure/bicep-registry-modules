targetScope = 'resourceGroup'

@description('Location for resources.')
param location string = resourceGroup().location

@description('Name of the existing virtual hub.')
param virtualHubName string = 'local-nvhmax'

@description('Name of the VPN gateway to create.')
param vpnGatewayName string = 'local-nvhmax-vpngw'

resource virtualHub 'Microsoft.Network/virtualHubs@2025-05-01' existing = {
  name: virtualHubName
}

resource vpnGateway 'Microsoft.Network/vpnGateways@2025-05-01' = {
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

output vpnGatewayResourceId string = vpnGateway.id
