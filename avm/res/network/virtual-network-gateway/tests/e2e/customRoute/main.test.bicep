targetScope = 'subscription'

metadata name = 'Custom Routes'
metadata description = 'This instance deploys the module with custom routes configuration for Point-to-Site VPN clients.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtualnetworkgateways-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvgcr'

@description('Optional. A token to inject into the name of each resource.')
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

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
    virtualNetworkNamePrefix: 'dep-${namePrefix}-vnet-${serviceShort}'
    localNetworkGatewayNamePrefix: 'dep-${namePrefix}-lng-${serviceShort}'
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
    params: {      name: '${namePrefix}${serviceShort}001'
      gatewayType: 'Vpn'
      virtualNetworkResourceId: nestedDependencies.outputs.vnetMainResourceId
      clusterSettings: {
        clusterMode: 'activePassiveNoBgp'
      }
      // Configure Point-to-Site VPN to enable custom routes functionality
      vpnClientAddressPoolPrefix: '172.16.0.0/24'
      // Test custom routes configuration with address prefixes
      customRoutes: {
        addressPrefixes: [
          '10.1.0.0/16'
          '10.2.0.0/16'
          '192.168.100.0/24'
          '192.168.200.0/24'
        ]
      }      // Use VPN gateway generation that supports custom routes
      vpnGatewayGeneration: 'Generation2'
      skuName: 'VpnGw2AZ'
      vpnType: 'RouteBased'
    }
  }
]


// ======= //
// Outputs //
// ======= //

// Main test outputs (with custom routes)
output activeActive bool = testDeployment[0].outputs.activeActive
output asn int? = testDeployment[0].outputs.?asn
output customBgpIpAddresses string? = testDeployment[0].outputs.?customBgpIpAddresses
output defaultBgpIpAddresses string? = testDeployment[0].outputs.?defaultBgpIpAddresses
output ipConfigurations array? = testDeployment[0].outputs.?ipConfigurations
output location string = testDeployment[0].outputs.location
output name string = testDeployment[0].outputs.name
output primaryPublicIpAddress string = testDeployment[0].outputs.primaryPublicIpAddress
output resourceGroupName string = testDeployment[0].outputs.resourceGroupName
output resourceId string = testDeployment[0].outputs.resourceId
output secondaryCustomBgpIpAddress string? = testDeployment[0].outputs.?secondaryCustomBgpIpAddress
output secondaryDefaultBgpIpAddress string? = testDeployment[0].outputs.?secondaryDefaultBgpIpAddress
output secondaryPublicIpAddress string? = testDeployment[0].outputs.?secondaryPublicIpAddress


