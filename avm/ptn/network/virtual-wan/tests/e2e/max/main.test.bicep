targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with a large parameter set.'

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
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
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
        type: 'Standard'
        p2sVpnParameters: {
          createP2sVpnServerConfiguration: true
          p2sVpnServerConfigurationName: 'dep-${namePrefix}-p2s-${serviceShort}'
          vpnAuthenticationTypes: ['AAD']
          aadTenant: '${environment().authentication.loginEndpoint}tenant-id'
          aadAudience: '41b23e61-6c1e-4545-b367-cd054e0ed4b4'
          aadIssuer: 'https://sts.windows.net/tenant-id/'
        }
        tags: {
          Environment: 'Test'
          CostCenter: 'IT'
        }
      }
      virtualHubParameters: [
        {
          hubAddressPrefix: '10.0.0.0/24'
          hubLocation: resourceLocation
          hubName: 'dep-${namePrefix}-hub-${resourceLocation}-${serviceShort}'
          allowBranchToBranchTraffic: true
          hubRoutingPreference: 'VpnGateway'
          p2sVpnParameters: {
            deployP2SVpnGateway: true
            vpnGatewayName: 'dep-${namePrefix}-p2s-gw-${serviceShort}'
            connectionConfigurationsName: 'default'
            vpnClientAddressPoolAddressPrefixes: ['192.168.1.0/24']
            vpnGatewayScaleUnit: 1
          }
          s2sVpnParameters: {
            deployS2SVpnGateway: true
            vpnGatewayName: 'dep-${namePrefix}-s2s-gw-${serviceShort}'
            vpnGatewayScaleUnit: 1
          }
          expressRouteParameters: {
            deployExpressRouteGateway: false
            expressRouteGatewayName: 'unused'
          }
          secureHubParameters: {
            deploySecureHub: false
            azureFirewallName: 'unused'
            azureFirewallSku: 'Standard'
            azureFirewallPublicIPCount: 1
          }
          tags: {
            HubType: 'Transit'
          }
        }
      ]
      tags: {
        Environment: 'Test'
        'hidden-title': 'This is visible in the resource name'
        Purpose: 'Maximum functionality test'
      }
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
