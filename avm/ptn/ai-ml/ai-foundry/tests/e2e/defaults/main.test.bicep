targetScope = 'subscription'
metadata name = 'Using only defaults'
metadata description = 'Creates an AI Foundry account and project with Basic services.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-bicep-${serviceShort}-rg'

// Due to AI Services capacity constraints, this region must be used in the AVM testing subscription
#disable-next-line no-hardcoded-location
var enforcedLocation = 'eastus2'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'fndrymin'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Used to generate unique names for resources to avoid soft-delete conflicts.')
param utcValue string = utcNow()

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
      name: 'basic${substring(uniqueString(subscription().id, enforcedLocation, utcValue), 0, 3)}' // Use time-based uniqueness to avoid soft-delete conflicts
      aiFoundryType: 'Basic' // Basic deployment - minimal resources only
      userObjectId: '00000000-0000-0000-0000-000000000000' // Using dummy GUID for test
      contentSafetyEnabled: false // Set to true or false as required
      // Note: vmAdminPasswordOrKey not needed for Basic deployment (no VM deployed)
    }
  }
]
