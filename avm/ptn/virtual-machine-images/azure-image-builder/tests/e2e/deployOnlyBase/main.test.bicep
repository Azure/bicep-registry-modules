targetScope = 'subscription'

metadata name = 'Deploying only the base services'
metadata description = 'This instance deploys the module with the conditions set up to only deploy the base resources, that is everything but the image.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-virtualmachineimages.azureimagebuilder-${serviceShort}-rg'

@description('Optional. The location to deploy resource group to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apvmiaibob'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

/////////////////////////////
//   Template Deployment   //
/////////////////////////////
var computeGalleryImageDefinitionName = 'sid-linux'

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      deploymentsToPerform: 'Only base'
      resourceGroupName: resourceGroupName
      location: resourceLocation
      assetsStorageAccountName: 'st${namePrefix}${serviceShort}'
      imageManagedIdentityName: 'msi-it-${namePrefix}-${serviceShort}'
      computeGalleryName: 'gal${namePrefix}${serviceShort}'
      computeGalleryImageDefinitionName: computeGalleryImageDefinitionName
      computeGalleryImageDefinitions: [
        {
          hyperVGeneration: 'V2'
          name: computeGalleryImageDefinitionName
          osType: 'Linux'
          publisher: 'devops'
          offer: 'devops_linux'
          sku: 'devops_linux_az'
        }
      ]
      imageTemplateImageSource: {
        type: 'PlatformImage'
        publisher: 'canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
    }
  }
]
