using 'main.bicep'

param virtualWanParameters = {
  location: 'eastus2'
  allowBranchToBranchTraffic: true
  allowVnetToVnetTraffic: true
  disableVpnEncryption: true
  virtualWanName: 'erschef-virtual-wan'
  p2sVpnParameters: {
    createP2sVpnServerConfiguration: false
  }
  type: 'Standard'
  tags: {
    environment: 'test'
    project: 'VWAN-AVM-pattern'
  }
}
param virtualHubParameters = [
  {
    hubAddressPrefix: '10.10.0.0/24'
    hubLocation: 'eastus2'
    hubName: 'erschef-eus2-hub'
    allowBranchToBranchTraffic: true
    hubRoutingPreference: 'ASPath'
    hubRouteTables: [
      {
        name: 'rt1'
      }
    ]
    hubVirtualNetworkConnections: [
      {
        name: 'erschef-spokevnet-1'
        remoteVirtualNetworkResourceId: '/subscriptions/dc9a7b77-f933-44c7-bf43-3bfb4e16b806/resourceGroups/erschef1/providers/Microsoft.Network/virtualNetworks/erschef-spokevnet-1'
      }
    ]
    secureHubParameters: {
      deploySecureHub: true
      azureFirewallName: 'erschef-eus2-fw'
      azureFirewallPublicIPCount: 1
      azureFirewallSku: 'Standard'
      firewallPolicyResourceId: '/subscriptions/dc9a7b77-f933-44c7-bf43-3bfb4e16b806/resourceGroups/erschef/providers/Microsoft.Network/firewallPolicies/erschef-eus2-fwpolicy'
      enableForcedTunneling: true
    }
    /*p2sVpnParameters: {
      deployP2SVpnGateway: true
      vpnGatewayName: 'erschef-eus2-p2sgw'
      vpnClientAddressPoolAddressPrefixes: [
        '10.10.2.0/24'
      ]
      connectionConfigurationsName: 'something'
      vpnGatewayScaleUnit: 1
      vpnGatewayAssociatedRouteTable: 'noneRouteTable'
      customDnsServers: [
        '10.50.10.50'
      ]
      enableInternetSecurity: true
    }*/
    s2sVpnParameters: {
      deployS2SVpnGateway: true
      natRules: [
        {
          name: 'natRule1'
          externalMappings: [
            {
              addressSpace: '192.168.21.0/24'
            }
          ]
          internalMappings: [
            {
              addressSpace: '10.4.0.0/24'
            }
          ]
          mode: 'EgressSnat'
          type: 'Static'
        }
      ]
      vpnGatewayName: 'erschef-eus2-s2sgw'
      vpnGatewayScaleUnit: 1
    }
    expressRouteParameters: {
      deployExpressRouteGateway: true
      expressRouteGatewayName: 'erschef-eus2-ergw'
    }
  }
]
