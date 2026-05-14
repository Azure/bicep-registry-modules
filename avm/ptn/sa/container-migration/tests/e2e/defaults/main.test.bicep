targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sa.cms-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
// e.g., for a module 'network/private-endpoint' you could use 'npe' as a prefix and then 'waf' as a suffix for the waf-aligned test
param serviceShort string = 'scmdmin'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. A per-run timestamp used to break determinism of generated resource names. Prevents collisions with soft-deleted resources from prior runs (App Configuration / Cognitive Services).')
param baseTime string = utcNow('yyMMddHHmm')

// ============ //
// Dependencies //
// ============ //

#disable-next-line no-hardcoded-location // A value to avoid ongoing capacity challenges in AVM Azure testing subscription
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

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-init'
  params: {
    solutionName: '${namePrefix}${serviceShort}'
    solutionUniqueText: take(toLower(uniqueString(baseTime, namePrefix, serviceShort)), 5)
    location: enforcedLocation
    azureAiServiceLocation: enforcedLocation
    cosmosLocation: enforcedLocation
    enablePrivateNetworking: false
    enableMonitoring: false
    enableRedundancy: true
    enableScalability: true
  }
}
