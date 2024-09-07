targetScope = 'subscription'

metadata name = 'Using small parameter set'
metadata description = 'This instance deploys the module with min features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-virtualmachineimages.azureimagebuilder-${serviceShort}-rg'

@description('Optional. The location to deploy resource group to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apvmiaibmin'

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
      deploymentsToPerform: iteration == 'init' ? 'All' : 'Only base' // Restricting to only infra on re-run as we don't want to back 2 images but only test idempotency
      resourceGroupName: resourceGroupName
      location: resourceLocation
      computeGalleryName: 'gal${namePrefix}${serviceShort}'
      computeGalleryImageDefinitionName: computeGalleryImageDefinitionName
      assetsStorageAccountName: 'st${namePrefix}${serviceShort}'
      computeGalleryImageDefinitions: [
        {
          hyperVGeneration: 'V2'
          name: 'sid-linux'
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
