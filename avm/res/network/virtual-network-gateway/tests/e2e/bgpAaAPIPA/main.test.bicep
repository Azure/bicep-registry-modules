targetScope = 'subscription'

metadata name = 'VPN Active Active with BGP settings and Double APIPA configuration'
metadata description = 'This instance deploys the module with the VPN in Active Active configuraztion and APIPA BGP settings.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtualnetworkgateways-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvgaaa'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    localNetworkGatewayName: 'dep-${namePrefix}-lng-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      location: resourceLocation
      name: '${namePrefix}${serviceShort}001'
      vpnGatewayGeneration: 'Generation2'
      skuName: 'VpnGw2AZ'
      gatewayType: 'Vpn'
      vNetResourceId: nestedDependencies.outputs.vnetResourceId
      activeActive: true
      bgpSettings: {
        activeActive: 'true'
        customBgpIpAddresses: ['169.254.21.4','169.254.21.5']
        secondCustomBgpIpAddresses: ['169.254.22.4']
        asn: 65515
      }
      domainNameLabel: [
        '${namePrefix}-dm-${serviceShort}'
      ]
      publicIpZones: [
        1
        2
        3
      ]
      vpnType: 'RouteBased'
      enablePrivateIpAddress: true
      gatewayDefaultSiteLocalNetworkGatewayId: nestedDependencies.outputs.localNetworkGatewayResourceId
      disableIPSecReplayProtection: true
      allowRemoteVnetTraffic: true
      enableBgpRouteTranslationForNat: true
    }
    dependsOn: [
      nestedDependencies
    ]
  }
]
