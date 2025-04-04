using 'main.bicep'

param virtualWanParameters = {
  location: 'eastus2'
  allowBranchToBranchTraffic: true
  allowVnetToVnetTraffic: true
  disableVpnEncryption: true
  virtualWanName: 'erschef-virtual-wan'
  p2sVpnParameters: {
    createP2sVpnServerConfiguration: true
    p2sVpnServerConfigurationName: 'erschef-p2s-vpn-config'
    vpnProtocols: 'OpenVPN'
    vpnAuthenticationTypes:[
      'AAD'
    ]
    aadAudience: '41b23e61-6c1e-4545-b367-cd054e0ed4b4'
    aadIssuer: 'https://sts.windows.net/72f988bf-86f1-41af-91ab-2d7cd011db47/'
    aadTenant: 'https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47'
    p2sConfigurationPolicyGroups: [
      {
        userVPNPolicyGroupName: 'GroupName1'
        policymembers: [
          {
            name: 'P2S-VPN-01'
            attributeType: 'AADGroupId'
            attributeValue: '3e5ec8de-abef-46c1-bd9a-b3ca6e1ef337'
          }
        ]
        priority: '0'
        isDefault: 'true'
      }
    ]
  }
}

param virtualHubParameters = [
  {
    hubAddressPrefix: '10.10.0.0/24'
    hubLocation: 'eastus2'
    hubName: 'erschef-eus2-hub'
    secureHubParameters: {
      deploySecureHub: true
      azureFirewallName: 'erschef-eus2-hub-fw'
      existingFirewallPolicyResourceId:'/subscriptions/dc9a7b77-f933-44c7-bf43-3bfb4e16b806/resourceGroups/erschef2/providers/Microsoft.Network/firewallPolicies/EUS2-POLICY-PREMIUM'
      azureFirewallSku: 'Premium'
      azureFirewallPublicIPCount: 1
    }
    p2sVpnParameters: {
      deployP2SVpnGateway: true
      p2sVpnGatewayName: 'erschef-eus2-p2sgw'
      p2sVpnClientAddressPoolAddressPrefixes: [
        '10.10.2.0/24'
      ]
      p2SConnectionConfigurationsName: 'something'
      p2sVpnGatewayScaleUnit: 1
      p2sVpnGatewayAssociatedRouteTable: 'noneRouteTable'
    }
  }
  {
    hubAddressPrefix:'10.10.1.0/24'
    hubLocation: 'westus2'
    hubName: 'erschef-wus2-hub'
    secureHubParameters: {
      deploySecureHub: true
      azureFirewallName: 'erschef-wus2-hub-fw'
      azureFirewallSku: 'Standard'
      azureFirewallPublicIPCount: 2
    }
  }
]
