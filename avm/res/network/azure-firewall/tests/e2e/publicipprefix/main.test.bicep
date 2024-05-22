targetScope = 'subscription'

metadata name = 'Public-IP-Prefix'
metadata description = 'This instance deploys the module and will use a public IP prefix.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.azurefirewalls-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nafpip'

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
    publicIPPrefixName: 'dep-${namePrefix}-pip-prefix-${serviceShort}'
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
      virtualNetworkResourceId: nestedDependencies.outputs.virtualNetworkResourceId
      publicIPAddressObject: {
        name: 'publicIP01'
        publicIPAllocationMethod: 'Static'
        publicIPPrefixResourceId: nestedDependencies.outputs.publicIPPrefixResourceId
        skuName: 'Standard'
        skuTier: 'Regional'
      }
      azureSkuTier: 'Basic'
      managementIPAddressObject: {
        name: 'managementIP01'
        managementIPAllocationMethod: 'Static'
        managementIPPrefixResourceId: nestedDependencies.outputs.publicIPPrefixResourceId
        skuName: 'Standard'
        skuTier: 'Regional'
      }
      zones: []
    }
  }
]
