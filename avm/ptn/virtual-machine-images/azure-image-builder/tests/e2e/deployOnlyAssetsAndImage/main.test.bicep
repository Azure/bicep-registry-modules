targetScope = 'subscription'

metadata name = 'Deploying only the assets & image'
metadata description = 'This instance deploys the module with the conditions set up to only update the assets on the assets storage account and build the image, assuming all dependencies are setup.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-virtualmachineimages.azureimagebuilder-${serviceShort}-rg'

@description('Optional. The location to deploy resource group to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apvmiaiboaai'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
module nestedDependencies 'dependencies.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    // managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    computeGalleryName: 'dep${namePrefix}gal${serviceShort}'
    deploymentScriptManagedIdentityName: 'dep-${namePrefix}-ds-msi-${serviceShort}'
    imageManagedIdentityName: 'dep-${namePrefix}-it-msi-${serviceShort}'
    resourceGroupName: resourceGroupName
    imageTemplateResourceGroupName: '${resourceGroupName}-image-build'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    deploymentScriptStorageAccountName: 'dep${namePrefix}dsst${serviceShort}'
    assetsStorageAccountName: 'dep${namePrefix}ast${serviceShort}'
    location: resourceLocation
  }
}

/////////////////////////////
//   Template Deployment   //
/////////////////////////////
var exampleScriptName = 'exampleScript.sh'

// No idempotency test as we don't want to bake 2 images
module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    deploymentsToPerform: 'Only assets & image'
    resourceGroupName: nestedDependencies.outputs.resourceGroupName
    location: resourceLocation
    computeGalleryName: nestedDependencies.outputs.computeGalleryName
    computeGalleryImageDefinitionName: nestedDependencies.outputs.computeGalleryImageDefinitions[0].name
    computeGalleryImageDefinitions: nestedDependencies.outputs.computeGalleryImageDefinitions
    virtualNetworkName: nestedDependencies.outputs.virtualNetworkName
    assetsStorageAccountContainerName: nestedDependencies.outputs.assetsStorageAccountContainerName
    assetsStorageAccountName: nestedDependencies.outputs.assetsStorageAccountName
    deploymentScriptManagedIdentityName: nestedDependencies.outputs.deploymentScriptManagedIdentityName
    deploymentScriptStorageAccountName: nestedDependencies.outputs.deploymentScriptStorageAccountName
    deploymentScriptSubnetName: nestedDependencies.outputs.deploymentScriptSubnetName
    imageManagedIdentityName: nestedDependencies.outputs.imageManagedIdentityName
    imageSubnetName: nestedDependencies.outputs.imageSubnetName
    imageTemplateResourceGroupName: nestedDependencies.outputs.imageTemplateResourceGroupName
    imageTemplateCustomizationSteps: [
      {
        type: 'Shell'
        name: 'Example script'
        scriptUri: 'https://${nestedDependencies.outputs.assetsStorageAccountName}.blob.${az.environment().suffixes.storage}/${nestedDependencies.outputs.assetsStorageAccountContainerName}/${exampleScriptName}'
      }
    ]
    imageTemplateImageSource: {
      type: 'PlatformImage'
      publisher: 'canonical'
      offer: 'ubuntu-24_04-lts'
      sku: 'server'
      version: 'latest'
    }
    storageAccountFilesToUpload: [
      {
        name: exampleScriptName
        value: loadTextContent('scripts/${exampleScriptName}')
      }
    ]
  }
}
