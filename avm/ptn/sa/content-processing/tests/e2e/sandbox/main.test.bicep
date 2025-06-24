targetScope = 'subscription'

metadata name = 'Sandbox configuration with default parameter values'
metadata description = 'This instance deploys the [Content Processing Solution Accelerator] using only the required parameters. Optional parameters will take the default values, which are designed for Sandbox environments.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
// e.g., for a module 'network/private-endpoint' you could use 'npe' as a prefix and then 'waf' as a suffix for the waf-aligned test
param serviceShort string = 'scpmin'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
// e.g., for a module 'network/private-endpoint' you could use 'dep-dev-network.privateendpoints-${serviceShort}-rg'
//param resourceGroupName string = 'dep-${namePrefix}-sa.cps-${serviceShort}-rg'
param resourceGroupName string = 'dep-${namePrefix}-bk-sa.cps-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Timestamp for environment name uniqueness.')
param environmentTimestamp string = take(uniqueString(utcNow()), 5)

// ============ //
// Dependencies //
// ============ //
#disable-next-line no-hardcoded-location // A value to avoid ongoing capacity challenges with Server Farm for frontend webapp in AVM Azure testing subscription
var enforcedLocation = 'australiaeast'

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      // You parameters go here
      //environmentName: 'test-${environmentTimestamp}-${iteration}'
      environmentName: '${namePrefix}${serviceShort}'
      // location: resourceGroupLocation
      enablePrivateNetworking: false
      contentUnderstandingLocation: enforcedLocation
      gptDeploymentCapacity: 80
    }
  }
]
