targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-azd-aks-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'paamin'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// Enforced location als not all regions have quota available
#disable-next-line no-hardcoded-location
var enforcedLocation = 'northeurope'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-dependencies'
  scope: resourceGroup
  params: {
    location: enforcedLocation
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
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: 'mc${uniqueString(deployment().name)}-${serviceShort}'
      containerRegistryName: '${uniqueString(deployment().name, enforcedLocation)}testcontainerregistry${serviceShort}'
      keyVaultName: 'kv${uniqueString(deployment().name)}-${serviceShort}'
      location: enforcedLocation
      principalId: nestedDependencies.outputs.identityPrincipalId
      monitoringWorkspaceResourceId: nestedDependencies.outputs.logAnalyticsResourceId
      principalType: 'ServicePrincipal'
      aadProfile: {
        aadProfileEnableAzureRBAC: true
        aadProfileManaged: true
      }
    }
  }
]
