targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-deploymentscript-importimagetoacr-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dsiitamax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

module dependencies 'dependencies.bicep' = {
  name: 'dependencies'
  scope: resourceGroup
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    acrName: 'dep${namePrefix}acr${serviceShort}'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-mi-${serviceShort}'
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
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Env: 'test'
      }
      acrName: dependencies.outputs.acrName
      location: resourceLocation
      image: 'mcr.microsoft.com/k8se/quickstart-jobs:latest'
      newImageName: 'your-image-name:tag'
      cleanupPreference: 'OnExpiration'
      assignRbacRole: true
      managedIdentities: { userAssignedResourcesIds: [dependencies.outputs.managedIdentityResourceId] }
      overwriteExistingImage: true
      storageAccountResourceId: dependencies.outputs.storageAccountResourceId
      subnetResourceIds: [dependencies.outputs.deploymentScriptSubnetResourceId]
    }
  }
]
