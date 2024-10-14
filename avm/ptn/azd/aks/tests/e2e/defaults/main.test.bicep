targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-azd-aks-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'paamin'

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
  name: '${uniqueString(deployment().name, resourceLocation)}-test-dependencies'
  scope: resourceGroup
  params: {
    location: resourceLocation
    appName: 'dep-${namePrefix}-app-${serviceShort}'
    appServicePlanName: 'dep-${namePrefix}-apps-${serviceShort}'
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
      name: 'mc${uniqueString(deployment().name)}-${serviceShort}'
      containerRegistryName: '${uniqueString(deployment().name, resourceLocation)}testcontainerregistry${serviceShort}'
      logAnalyticsName: nestedDependencies.outputs.logAnalyticsWorkspaceResourceId
      keyVaultName: 'kv${uniqueString(deployment().name)}-${serviceShort}'
      location: resourceLocation
      principalId: nestedDependencies.outputs.identityPrincipalId
      principalType: 'ServicePrincipal'
    }
  }
]
