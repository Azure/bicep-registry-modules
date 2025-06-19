targetScope = 'subscription'
metadata name = 'ai-foundry'
metadata description = 'Creates an AI Foundry account and project with Standard Agent Services in a network.'
// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-bicep-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = 'eastus2' // Explicitly using eastus2 which supports AIServices

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'fndrywaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
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
      aiFoundryType: 'StandardPrivate' // Replace with the required value@allowed(['Basic''StandardPublic''StandardPrivate'])
      userObjectId: '00000000-0000-0000-0000-000000000000' // Using dummy GUID for test
      contentSafetyEnabled: true // Set to true or false as required
      vmAdminPasswordOrKey: '$tart12345' // Replace with a secure password or key
      vmSize: 'Standard_DS4_v2'
      aiModelDeployments: [
        {
          name: 'textembed'
          model: {
            name: 'text-embedding-ada-002'
            format: 'OpenAI'
            version: '2'
          }
          sku: {
            name: 'Standard'
            capacity: 10
          }
        }
        {
          name: 'gpt'
          model: {
            name: 'gpt-4o'
            version: '2024-05-13'
            format: 'OpenAI'
          }
          sku: {
            name: 'GlobalStandard'
            capacity: 10
          }
        }
      ]
    }
  }
]
