targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters in a consumption plan.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-app-containerjob-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'acjmin'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

module dependencies './dependencies.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-dependencies'
  scope: resourceGroup
  params: {
    lawName: 'dep${namePrefix}law${serviceShort}'
  }
}

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: location
      containerImageSource: 'mcr.microsoft.com/k8se/quickstart-jobs:latest'
      logAnalyticsWorkspaceResourceId: dependencies.outputs.logAnalyticsResourceId
      // needed for idempotency testing
      overwriteExistingImage: true
    }
  }
]
