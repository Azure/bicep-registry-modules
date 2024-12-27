targetScope = 'subscription'

metadata name = 'Deploying full solution for Linux'
metadata description = 'This instance deploys the module with the conditions set up to deploy all resource and build a Linux image.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-virtualmachineimages.azureimagebuilder-${serviceShort}-rg'

@description('Optional. The location to deploy resource group to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apvmiaibal'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

/////////////////////////////
//   Template Deployment   //
/////////////////////////////
var computeGalleryImageDefinitionName = 'sid-linux'
var assetsStorageAccountName = 'st${namePrefix}${serviceShort}'
var assetsStorageAccountContainerName = 'aibscripts'
var installPwshScriptName = 'Install-LinuxPowerShell.sh'
var initializeSoftwareScriptName = 'Initialize-LinuxSoftware.ps1'

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      deploymentsToPerform: iteration == 'init' ? 'All' : 'Only base' // Restricting to only infra on re-run as we don't want to back 2 images but only test idempotency
      resourceGroupName: resourceGroupName
      location: resourceLocation
      assetsStorageAccountName: assetsStorageAccountName
      assetsStorageAccountContainerName: assetsStorageAccountContainerName
      computeGalleryName: 'gal${namePrefix}${serviceShort}'
      computeGalleryImageDefinitionName: computeGalleryImageDefinitionName
      computeGalleryImageDefinitions: [
        {
          hyperVGeneration: 'V2'
          name: computeGalleryImageDefinitionName
          osType: 'Linux'
          osState: 'Generalized'
          identifier: {
            publisher: 'devops'
            offer: 'devops_linux'
            sku: 'devops_linux_az'
          }
        }
      ]
      storageAccountFilesToUpload: [
        {
          name: installPwshScriptName
          value: loadTextContent('scripts/${installPwshScriptName}')
        }
        {
          name: initializeSoftwareScriptName
          value: loadTextContent('scripts/${initializeSoftwareScriptName}')
        }
      ]
      imageTemplateImageSource: {
        type: 'PlatformImage'
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      imageTemplateCustomizationSteps: [
        {
          type: 'Shell'
          name: 'PowerShell Core installation'
          scriptUri: 'https://${assetsStorageAccountName}.blob.${environment().suffixes.storage}/${assetsStorageAccountContainerName}/${installPwshScriptName}'
        }
        {
          type: 'File'
          name: 'Download ${initializeSoftwareScriptName}'
          sourceUri: 'https://${assetsStorageAccountName}.blob.${environment().suffixes.storage}/${assetsStorageAccountContainerName}/${initializeSoftwareScriptName}'
          destination: initializeSoftwareScriptName
        }
        {
          type: 'Shell'
          name: 'Software installation'
          inline: [
            'pwsh \'${initializeSoftwareScriptName}\''
          ]
        }
      ]
    }
  }
]
