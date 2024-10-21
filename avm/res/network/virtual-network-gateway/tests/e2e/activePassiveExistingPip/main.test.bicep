targetScope = 'subscription'

metadata name = 'VPN Active Passive with BGP settings using existing Public IP'
metadata description = 'This instance deploys the module with the VPN Active Passive with APIPA BGP settings and existing primary public IP.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtualnetworkgateways-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvgapep'

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
    existingFirstPipName: 'dep-${namePrefix}-pip-${serviceShort}-existing1'
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
      existingFirstPipResourceId: nestedDependencies.outputs.existingFirstPipResourceId
      clusterSettings: {
        clusterMode:'activePassiveBgp'
        customBgpIpAddresses: ['169.254.21.4','169.254.21.5']
        asn: 65815
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
