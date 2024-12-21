targetScope = 'subscription'

metadata name = 'Deploying all resources'
metadata description = 'This instance deploys the module with the conditions set up to deploy all resource and build a Windows image.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-virtualmachineimages.azureimagebuilder-${serviceShort}-rg'

@description('Optional. The location to deploy resource group to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apvmiaiba'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

/////////////////////////////
//   Template Deployment   //
/////////////////////////////
var computeGalleryImageDefinitionName = 'sid-windows'
var assetsStorageAccountName = 'st${namePrefix}${serviceShort}'
var assetsStorageAccountContainerName = 'aibscripts'
var installPwshScriptName = 'Install-WindowsPowerShell.ps1'
var initializeSoftwareScriptName = 'Initialize-WindowsSoftware.ps1'

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
          osType: 'Windows'
          publisher: 'devops'
          offer: 'devops_windows'
          sku: 'devops_windows_az'
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
        publisher: 'microsoftwindowsdesktop'
        offer: 'windows-11'
        sku: 'win11-23h2-pro'
        version: 'latest'
      }
      imageTemplateCustomizationSteps: [
        {
          type: 'Shell'
          name: 'PowerShell installation'
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
