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

@description('Optional. The location to deploy resources to.')
param resourceLocation string = 'eastus' // Explicitly using eastus2 which supports AIServices

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
      name: 'fn${substring(uniqueString(deployment().name), 0, 6)}' // Using uniqueString to generate a short, unique name (8 chars total)
      location: resourceLocation
      aiFoundryType: 'Basic' // Replace with the appropriate value
      userObjectId: '00000000-0000-0000-0000-000000000000' // Using dummy GUID for test
      contentSafetyEnabled: false // Set to true or false as required
      vmAdminPasswordOrKey: 'P@ssw0rd123!' // Replace with a secure password or key
    }
  }
]
