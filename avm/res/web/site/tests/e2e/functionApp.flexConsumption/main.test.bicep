targetScope = 'subscription'

metadata name = 'Function App, using Flex Consumption plan with VNet integration'
metadata description = 'This instance deploys a Function App on Flex Consumption plan with virtual network integration to test the fix for virtualNetworkSubnetResourceId issue.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-web.sites-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'wsflex'

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
    managedEnvironmentName: 'dep-${namePrefix}-me-${serviceShort}'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
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
      location: resourceLocation
      kind: 'functionapp,linux,container,azurecontainerapps'
      serverFarmResourceId: '' // Empty for Flex Consumption
      managedEnvironmentResourceId: nestedDependencies.outputs.managedEnvironmentResourceId
      virtualNetworkSubnetResourceId: nestedDependencies.outputs.subnetResourceId // This should be ignored due to our fix
      siteConfig: {
        alwaysOn: false // Must be false for Flex Consumption
        minTlsVersion: '1.2'
        ftpsState: 'FtpsOnly'
      }
    }
  }
]