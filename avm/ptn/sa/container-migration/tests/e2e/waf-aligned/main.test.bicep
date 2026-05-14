targetScope = 'subscription'

metadata name = 'Waf-aligned configuration with default parameter values'
metadata description = 'This instance deploys the Container Migration Solution Accelerator with WAF-aligned options enabled (private networking, monitoring, redundancy and scalability).'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-waf-${namePrefix}-sa.cms-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'scmwaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. A per-run timestamp used to break determinism of generated resource names. Prevents collisions with soft-deleted resources from prior runs (App Configuration / Cognitive Services). Both [init] and [idem] iterations share the same value, so idempotency is preserved within a single run.')
param baseTime string = utcNow('yyMMddHHmm')

@description('Optional. The password to set for the jumpbox virtual machine.')
@secure()
param virtualMachineAdminPassword string = newGuid()

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
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      solutionName: '${namePrefix}${serviceShort}'
      solutionUniqueText: take(toLower(uniqueString(baseTime, namePrefix, serviceShort)), 5)
      location: enforcedLocation
      azureAiServiceLocation: enforcedLocation
      cosmosLocation: enforcedLocation
      aiModelCapacity: 10
      aiEmbeddingModelCapacity: 10
      enableScalability: true
      enableTelemetry: true
      enablePrivateNetworking: true
      enableMonitoring: true
      enableRedundancy: true
      vmAdminUsername: 'adminuser'
      vmAdminPassword: virtualMachineAdminPassword
    }
  }
]
