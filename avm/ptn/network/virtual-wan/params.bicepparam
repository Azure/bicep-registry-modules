using 'main.bicep'

param virtualWanParameters = {
  //location: 'eastus2'
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
    virtualRouterAsn: 65001
    allowBranchToBranchTraffic: true
    hubRoutingPreference: 'ASPath'
    secureHubParameters: {
      deploySecureHub: false
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
  }
  {
    hubAddressPrefix: '10.10.1.0/24'
    hubLocation: 'westus2'
    hubName: 'erschef-wus2-hub'
    secureHubParameters: {
      deploySecureHub: false
    }
  }
]
