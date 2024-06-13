targetScope = 'subscription'

metadata name = 'Using defaults with provided existing Azure Log Analytics Workspace'
metadata description = 'This instance deploys the module with the minimum set of required parameters and with provided existing Azure Log Analytics Workspace.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-data-privateanalyticalworkspace-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dpawminlog'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
  }
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
      // You parameters go here
      name: '${namePrefix}${serviceShort}001'
      logAnalyticsWorkspaceResourceId: nestedDependencies.outputs.logAnalyticsWorkspaceResourceId
    }
  }
]

output resourceId string = testDeployment[0].outputs.resourceId
output name string = testDeployment[0].outputs.name
output location string = testDeployment[0].outputs.location
output resourceGroupName string = testDeployment[0].outputs.resourceGroupName
output virtualNetworkResourceId string = testDeployment[0].outputs.resourceId
output virtualNetworkName string = testDeployment[0].outputs.name
output virtualNetworkLocation string = testDeployment[0].outputs.location
output virtualNetworkResourceGroupName string = testDeployment[0].outputs.resourceGroupName
output logAnalyticsWorkspaceResourceId string = testDeployment[0].outputs.resourceId
output logAnalyticsWorkspaceName string = testDeployment[0].outputs.name
output logAnalyticsWorkspaceLocation string = testDeployment[0].outputs.location
output logAnalyticsWorkspaceResourceGroupName string = testDeployment[0].outputs.resourceGroupName
output keyVaultResourceId string = testDeployment[0].outputs.resourceId
output keyVaultName string = testDeployment[0].outputs.name
output keyVaultLocation string = testDeployment[0].outputs.location
output keyVaultResourceGroupName string = testDeployment[0].outputs.resourceGroupName
