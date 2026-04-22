targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-datafactory.factories-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dffmin'

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
      managedIdentities: {
        systemAssigned: true
      }
      integrationRuntimes: [
        {
          name: 'TestRuntime'
          type: 'SelfHosted'
          typeProperties: {
            linkedInfo: {
              authorizationType: 'RBAC'
              resourceId: '/subscriptions/25e36faf-608c-46e0-a99e-f2463241028e/resourcegroups/adf-share-test/providers/Microsoft.DataFactory/factories/adf-share-test-01/integrationruntimes/integrationRuntime1'
              roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
            }
          }
        }
      ]
    }
  }
]
