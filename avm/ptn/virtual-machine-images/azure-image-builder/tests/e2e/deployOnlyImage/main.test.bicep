targetScope = 'subscription'

metadata name = 'Deploying only the image'
metadata description = 'This instance deploys the module with the conditions set up to only deploy and bake the image, assuming all dependencies are setup.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-virtualmachineimages.azureimagebuilder-${serviceShort}-rg'

@description('Optional. The location to deploy resource group to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apvmiaiboi'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Generated. Do not provide a value! This date value is used to generate a SAS token to access the modules.')
param baseTime string = utcNow()

var formattedTime = replace(replace(replace(baseTime, ':', ''), '-', ''), ' ', '')

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
    storageDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}-${formattedTime}'
    assetsStorageAccountName: 'dep${namePrefix}ast${serviceShort}'
    location: resourceLocation
  }
}

/////////////////////////////
//   Template Deployment   //
/////////////////////////////

// No idempotency test as we don't want to bake 2 images
module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    deploymentsToPerform: 'Only image'
    resourceGroupName: nestedDependencies.outputs.resourceGroupName
    location: resourceLocation
    computeGalleryName: nestedDependencies.outputs.computeGalleryName
    computeGalleryImageDefinitions: nestedDependencies.outputs.computeGalleryImageDefinitions
    computeGalleryImageDefinitionName: nestedDependencies.outputs.computeGalleryImageDefinitions[0].name
    virtualNetworkName: nestedDependencies.outputs.virtualNetworkName
    deploymentScriptManagedIdentityName: nestedDependencies.outputs.deploymentScriptManagedIdentityName
    deploymentScriptStorageAccountName: nestedDependencies.outputs.deploymentScriptStorageAccountName
    deploymentScriptSubnetName: nestedDependencies.outputs.deploymentScriptSubnetName
    imageManagedIdentityName: nestedDependencies.outputs.imageManagedIdentityName
    imageSubnetName: nestedDependencies.outputs.imageSubnetName
    imageTemplateResourceGroupName: nestedDependencies.outputs.imageTemplateResourceGroupName
    imageTemplateImageSource: {
      type: 'PlatformImage'
      publisher: 'canonical'
      offer: 'ubuntu-24_04-lts'
      sku: 'server'
      version: 'latest'
    }
    imageTemplateCustomizationSteps: [
      {
        type: 'Shell'
        name: 'Example script'
        scriptUri: 'https://${nestedDependencies.outputs.assetsStorageAccountName}.blob.${az.environment().suffixes.storage}/${nestedDependencies.outputs.assetsStorageAccountContainerName}/${nestedDependencies.outputs.exampleScriptName}'
      }
    ]
  }
}
