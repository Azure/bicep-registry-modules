targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys a Virtual WAN with multiple Secure Hubs and most features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtual-wan-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvwanmax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

// ============== //
// Test Execution //
// ============== //

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    azureFirewallPolicyName: 'dep-${namePrefix}-fwp-${serviceShort}'
    virtualNetwork1Name: 'dep-${namePrefix}-vnet1-${serviceShort}'
    virtualNetwork1Location: 'eastus'
    virtualNetwork2Name: 'dep-${namePrefix}-vnet2-${serviceShort}'
    virtualNetwork2Location: 'westus2'
  }
}

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      virtualWanParameters: {
        virtualWanName: 'dep-${namePrefix}-vw-${serviceShort}'
        location: resourceLocation
        allowBranchToBranchTraffic: true
        allowVnetToVnetTraffic: true
        type: 'Standard'
        p2sVpnParameters: {
          createP2sVpnServerConfiguration: true
          p2sVpnServerConfigurationName: 'dep-${namePrefix}-p2svpn-${serviceShort}'
          vpnAuthenticationTypes: [
            'AAD'
          ]
          aadAudience: '11111111-1234-4321-1234-111111111111'
          aadIssuer: 'https://sts.windows.net/11111111-1111-1111-1111-111111111111/'
          aadTenant: '${environment().authentication.loginEndpoint}11111111-1111-1111-1111-111111111111'
          vpnProtocols: 'OpenVPN'
        }
      }
      virtualHubParameters: [
        {
          hubAddressPrefix: '10.0.0.0/24'
          hubLocation: 'eastus'
          hubName: 'dep-${namePrefix}-hub-eastus-${serviceShort}'
          deploySecureHub: true
          secureHubParameters: {
            firewallPolicyResourceId: nestedDependencies.outputs.azureFirewallPolicyId
            azureFirewallName: 'dep-${namePrefix}-fw-eastus-${serviceShort}'
            azureFirewallSku: 'Standard'
            azureFirewallPublicIPCount: 1
            routingIntent: {
              internetToFirewall: true
              privateToFirewall: true
            }
          }
          hubVirtualNetworkConnections: [
            {
              name: 'dep-${namePrefix}-vnet1-eastus-${serviceShort}'
              remoteVirtualNetworkResourceId: nestedDependencies.outputs.virtualNetwork1Id
            }
          ]
          hubRoutingPreference: 'ASPath'
          virtualRouterAsn: 65515
          allowBranchToBranchTraffic: true
          deployExpressRouteGateway: true
          expressRouteParameters: {
            expressRouteGatewayName: 'dep-${namePrefix}-ergw-eastus-${serviceShort}'
          }
          deployS2SVpnGateway: true
          s2sVpnParameters: {
            vpnGatewayName: 'dep-${namePrefix}-s2svpngw-eastus-${serviceShort}'
            vpnGatewayScaleUnit: 1
          }
          deployP2SVpnGateway: true
          p2sVpnParameters: {
            connectionConfigurationsName: 'P2SConnectionConfig'
            vpnClientAddressPoolAddressPrefixes: [
              '10.0.2.0/24'
            ]
            vpnGatewayName: 'dep-${namePrefix}-hub-p2svpngw-eastus-${serviceShort}'
            vpnGatewayScaleUnit: 1
            enableInternetSecurity: true
            vpnGatewayAssociatedRouteTable: 'defaultRouteTable'
            propagatedRouteTableNames: [
              'defaultRouteTable'
            ]
          }
        }
        {
          hubAddressPrefix: '10.0.1.0/24'
          hubLocation: 'westus2'
          hubName: 'dep-${namePrefix}-hub-westus2-${serviceShort}'
          deploySecureHub: true
          secureHubParameters: {
            firewallPolicyResourceId: nestedDependencies.outputs.azureFirewallPolicyId
            azureFirewallName: 'dep-${namePrefix}-fw-westus2-${serviceShort}'
            azureFirewallSku: 'Standard'
            azureFirewallPublicIPCount: 1
            routingIntent: {
              internetToFirewall: true
              privateToFirewall: true
            }
          }
          hubVirtualNetworkConnections: [
            {
              name: 'dep-${namePrefix}-vnet2-westus2-${serviceShort}'
              remoteVirtualNetworkResourceId: nestedDependencies.outputs.virtualNetwork2Id
            }
          ]
          hubRoutingPreference: 'ASPath'
          allowBranchToBranchTraffic: true
          deployExpressRouteGateway: true
          expressRouteParameters: {
            expressRouteGatewayName: 'dep-${namePrefix}-ergw-westus2-${serviceShort}'
          }
          deployS2SVpnGateway: true
          s2sVpnParameters: {
            vpnGatewayName: 'dep-${namePrefix}-s2svpngw-westus2-${serviceShort}'
            vpnGatewayScaleUnit: 1
            isRoutingPreferenceInternet: false
            bgpSettings: {
              asn: 65515
              bgpPeeringAddresses: [
                {
                  ipconfigurationId: 'Instance0'
                  customBgpIpAddresses: []
                }
                {
                  ipconfigurationId: 'Instance1'
                  customBgpIpAddresses: []
                }
              ]
            }
            natRules: [
              {
                name: 'dep-${namePrefix}-nat-rule-westus2-${serviceShort}'
                mode: 'EgressSnat'
                externalMappings: [
                  {
                    addressSpace: '172.16.20.0/24'
                    portRange: '10000-20000'
                  }
                ]
                internalMappings: [
                  {
                    addressSpace: '10.0.1.0/24'
                    portRange: '10000-20000'
                  }
                ]
                type: 'Dynamic'
              }
            ]
          }
          deployP2SVpnGateway: false
        }
      ]
    }
  }
]

module testVpnSite 'br/public:avm/res/network/vpn-site:0.3.1' = {
  scope: resourceGroup
  params: {
    name: 'dep-${namePrefix}-vpnSite-${serviceShort}'
    virtualWanId: testDeployment[0].outputs.virtualWan.resourceId
    ipAddress: '100.1.125.50'
    bgpProperties: {
      asn: 63000
      bgpPeeringAddress: '10.60.60.10'
    }
    vpnSiteLinks: [
      {
        name: '${namePrefix}-vSite-${serviceShort}'
        properties: {
          bgpProperties: {
            asn: 65010
            bgpPeeringAddress: '1.1.1.1'
          }
          ipAddress: '1.2.3.4'
          linkProperties: {
            linkProviderName: 'contoso'
            linkSpeedInMbps: 5
          }
        }
      }
      {
        name: 'Link1'
        properties: {
          bgpProperties: {
            asn: 65020
            bgpPeeringAddress: '192.168.1.0'
          }
          ipAddress: '2.2.2.2'
          linkProperties: {
            linkProviderName: 'contoso'
            linkSpeedInMbps: 5
          }
        }
      }
    ]
  }
}
