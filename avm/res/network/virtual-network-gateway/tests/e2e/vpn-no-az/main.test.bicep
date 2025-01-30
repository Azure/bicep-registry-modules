targetScope = 'subscription'

metadata name = 'Using SKU without Availability Zones'
metadata description = 'This instance deploys the module with a SKU that does not support Availability Zones.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtualnetworkgateways-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvgnaz'

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
      name: '${namePrefix}${serviceShort}001'
      skuName: 'VpnGw1'
      gatewayType: 'Vpn'
      publicIpZones: []
      virtualNetworkResourceId: nestedDependencies.outputs.vnetResourceId
      clusterSettings: {
        clusterMode: 'activePassiveNoBgp'
      }
    }
  }
]

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
