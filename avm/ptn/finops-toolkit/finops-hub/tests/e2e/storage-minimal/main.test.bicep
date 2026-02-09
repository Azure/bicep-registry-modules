targetScope = 'subscription'

metadata name = 'Storage Minimal'
metadata description = 'This instance deploys the module with the minimum set of required parameters for storage-only mode.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-finops-hub-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'fhmin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// Stable suffix for idempotent deployments — must NOT depend on deployment().name
// which changes every CI run, causing orphan resources instead of in-place updates.
// Uses subscription + namePrefix + serviceShort so the name is identical across runs.
var deploymentSuffix = take(uniqueString(subscription().subscriptionId, namePrefix, serviceShort), 4)

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: resourceGroupName
  location: resourceLocation
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
      // Required parameters - include deployment suffix to avoid Key Vault naming conflicts
      hubName: '${namePrefix}${serviceShort}${deploymentSuffix}'
      // Non-required parameters
      location: resourceLocation
      deploymentConfiguration: 'minimal'
      deploymentType: 'storage-only'
      enableTelemetry: true
      tags: {
        SecurityControl: 'Ignore'
        Environment: 'Development'
        'hidden-title': 'FinOps Hub - Storage Only Test'
      }
    }
  }
]
