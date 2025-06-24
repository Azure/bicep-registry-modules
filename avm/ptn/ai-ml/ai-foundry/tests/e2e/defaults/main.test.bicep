targetScope = 'subscription'
metadata name = 'ai-foundry'
metadata description = 'Creates an AI Foundry account and project with Basic services.'
// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
// e.g., for a module 'network/private-endpoint' you could use 'dep-dev-network.privateendpoints-${serviceShort}-rg'
param resourceGroupName string = 'dep-${namePrefix}-bicep-${serviceShort}-rg'

// Due to AI Services capacity constraints, this region must be used in the AVM testing subscription
#disable-next-line no-hardcoded-location
var enforcedLocation = 'eastus2'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
// e.g., for a module 'network/private-endpoint' you could use 'npe' as a prefix and then 'waf' as a suffix for the waf-aligned test
param serviceShort string = 'fndrymin'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-11-01' = {
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
      name: 'basic${substring(uniqueString(subscription().id, enforcedLocation), 0, 3)}' // Use subscription for consistent naming
      location: enforcedLocation
      aiFoundryType: 'Basic' // Basic deployment - minimal resources only
      userObjectId: '00000000-0000-0000-0000-000000000000' // Using dummy GUID for test
      contentSafetyEnabled: false // Set to true or false as required
      // Note: vmAdminPasswordOrKey not needed for Basic deployment (no VM deployed)
    }
  }
]
