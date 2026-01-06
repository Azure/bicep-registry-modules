targetScope = 'subscription'

metadata name = 'Using maximum parameters'
metadata description = 'This instance deploys the module with the maximum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-alz.ama-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'alzamamax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============== //
// Dependencies //
// ============== //

module dependencies './dependencies.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-dependencies'
  scope: resourceGroup
  params: {
    lawName: 'dep${namePrefix}law${serviceShort}'
  }
}

// ============== //
// General resources
// ============== //

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
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    scope: resourceGroup
    params: {
      dataCollectionRuleChangeTrackingName: 'alz-ama-dcr-ct-${namePrefix}${serviceShort}'
      dataCollectionRuleMDFCSQLName: 'alz-ama-dcr-mdfc-sql-${namePrefix}${serviceShort}'
      dataCollectionRuleVMInsightsName: 'alz-ama-dcr-vm-insights-${namePrefix}${serviceShort}'
      userAssignedIdentityName: 'alz-ama-identity-${namePrefix}${serviceShort}'
      logAnalyticsWorkspaceResourceId: dependencies.outputs.logAnalyticsResourceId
      location: resourceLocation
      lockConfig:{
        kind: 'CanNotDelete'
        name: 'lock-${namePrefix}${serviceShort}'
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Env: 'test'
      }
    }
  }
]
