targetScope = 'subscription'

metadata name = 'max'
metadata description = 'This instance deployes the module with most parameters and Private Link enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
// e.g., for a module 'network/private-endpoint' you could use 'dep-dev-network.privateendpoints-${serviceShort}-rg'
param resourceGroupName string = 'dep-${namePrefix}-deploymentscript-importimagetoacr-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
// e.g., for a module 'network/private-endpoint' you could use 'npe' as a prefix and then 'waf' as a suffix for the waf-aligned test
param serviceShort string = 'dsiitadef'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

module dependencies 'dependencies.bicep' = {
  name: 'dependencies'
  scope: resourceGroup
  params: {
    virtualNetworkName: '${uniqueString(resourceGroupName, resourceLocation)}-vnet'
    acrName: '${uniqueString(resourceGroupName, resourceLocation)}-acr'
    storageAccountName: '${uniqueString(resourceGroupName, resourceLocation)}sa'
    managedIdentityName: '${uniqueString(resourceGroupName, resourceLocation)}-mi'
  }
}

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
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
    dependsOn: [
      dependencies
    ]
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      acrName: dependencies.outputs.acrName
      location: resourceLocation
      images: ['mcr.microsoft.com/azuredocs/aks-helloworld:latest', 'mcr.microsoft.com/azuredocs/aks-helloworld:v2']
      cleanupPreference: 'OnSuccess'
      useExistingManagedIdentity: true
      managedIdentityName: dependencies.outputs.managedIdentityName
      overwriteExistingImage: true
    }
  }
]
