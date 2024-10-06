targetScope = 'subscription'

metadata name = 'VPN Active Active with BGP settings'
metadata description = 'This instance deploys the module with the VPN Active Active with BGP settings.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtualnetworkgateways-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
<<<<<<<< HEAD:avm/res/network/virtual-network-gateway/tests/e2e/activeActiveBGP/main.test.bicep
param serviceShort string = 'nvgaab'
========
param serviceShort string = 'nvgavpn'
>>>>>>>> 7ff2e41d2ea4cd91f7b3d31783b2268eb2e2f2dd:avm/res/network/virtual-network-gateway/tests/e2e/aadvpn/main.test.bicep

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
<<<<<<<< HEAD:avm/res/network/virtual-network-gateway/tests/e2e/activeActiveBGP/main.test.bicep
      clusterSettings: {
        clusterMode: 'activeActiveBgp'
      }

========
      clusterSettings:{
        clusterMode: 'activePassiveNoBgp'
      }
>>>>>>>> 7ff2e41d2ea4cd91f7b3d31783b2268eb2e2f2dd:avm/res/network/virtual-network-gateway/tests/e2e/aadvpn/main.test.bicep
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
