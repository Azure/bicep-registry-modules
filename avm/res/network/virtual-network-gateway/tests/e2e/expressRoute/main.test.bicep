targetScope = 'subscription'

metadata name = 'ExpressRoute'
metadata description = 'This instance deploys the module with the ExpressRoute set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtualnetworkgateways-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvger'

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
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}002'
    skuName: 'ErGw1AZ'
    gatewayType: 'ExpressRoute'
    virtualNetworkResourceId: nestedDependencies.outputs.vnetResourceId
    clusterSettings: {
      clusterMode: 'activePassiveBgp'
    }
  }
}

output activeActive bool = testDeployment.outputs.activeActive
output asn int? = testDeployment.outputs.?asn
output customBgpIpAddresses string? = testDeployment.outputs.?customBgpIpAddresses
output defaultBgpIpAddresses string? = testDeployment.outputs.?defaultBgpIpAddresses
output ipConfigurations array? = testDeployment.outputs.?ipConfigurations
output location string = testDeployment.outputs.location
output name string = testDeployment.outputs.name
output primaryPublicIpAddress string? = testDeployment.outputs.?primaryPublicIpAddress
output resourceGroupName string = testDeployment.outputs.resourceGroupName
output resourceId string = testDeployment.outputs.resourceId
output secondaryCustomBgpIpAddress string? = testDeployment.outputs.?secondaryCustomBgpIpAddress
output secondaryDefaultBgpIpAddress string? = testDeployment.outputs.?secondaryDefaultBgpIpAddress
output secondaryPublicIpAddress string? = testDeployment.outputs.?secondaryPublicIpAddress
