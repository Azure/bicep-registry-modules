targetScope = 'subscription'

metadata name = 'Sandbox configuration with default parameter values'
metadata description = 'This instance deploys the Container Migration Solution Accelerator using only the required parameters. Optional parameters take their default values, which are designed for Sandbox environments.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'scmmin'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sa.cms-${serviceShort}-rg'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. A per-run timestamp used to break determinism of generated resource names. Prevents collisions with soft-deleted resources from prior runs (App Configuration / Cognitive Services). Both [init] and [idem] iterations share the same value, so idempotency is preserved within a single run.')
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

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      solutionName: '${namePrefix}${serviceShort}'
      solutionUniqueText: take(toLower(uniqueString(baseTime, namePrefix, serviceShort)), 5)
      location: enforcedLocation
      azureAiServiceLocation: enforcedLocation
      cosmosLocation: enforcedLocation
      aiModelCapacity: 10
      aiEmbeddingModelCapacity: 10
      enablePrivateNetworking: false
      enableMonitoring: false
      enableRedundancy: false
      enableScalability: false
      enableTelemetry: true
    }
  }
]
