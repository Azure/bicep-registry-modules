targetScope = 'subscription'

metadata name = 'Creating a Linux image with Azure Image Builder'
metadata description = 'This instance deploy a Linux-flavored image definition and image using Linux-specific installation scripts.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resource group to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apvmiaibl'

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

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name)}-image-sbx'
  params: {
    location: resourceLocation
    deploymentsToPerform: 'All'
    assetsStorageAccountName: assetsStorageAccountName
    assetsStorageAccountContainerName: assetsStorageAccountContainerName
    computeGalleryName: 'gal${namePrefix}${serviceShort}'
    computeGalleryImageDefinitionName: computeGalleryImageDefinitionName
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
    storageAccountFilesToUpload: {
      secureList: [
        {
          name: 'script_${replace(replace(installPwshScriptName, '-', '__'), '.', '_')}' // May only be alphanumeric characters & underscores. The upload will replace '_' with '.' and '__' with '-'. E.g., Install__LinuxPowerShell_sh will be Install-LinuxPowerShell.sh
          value: loadTextContent('scripts/${installPwshScriptName}')
        }
        {
          name: 'script_${replace(replace(initializeSoftwareScriptName, '-', '__'), '.', '_')}' // May only be alphanumeric characters & underscores. The upload will replace '_' with '.' and '__' with '-'. E.g., Initialize__LinuxSoftware_ps1 will be Initialize-LinuxSoftware.ps1
          value: loadTextContent('scripts/${initializeSoftwareScriptName}')
        }
      ]
    }
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
        name: 'PowerShell installation'
        scriptUri: 'https://${assetsStorageAccountName}.blob.${az.environment().suffixes.storage}/${assetsStorageAccountContainerName}/${installPwshScriptName}'
      }
      {
        type: 'File'
        name: 'Download ${initializeSoftwareScriptName}'
        sourceUri: 'https://${assetsStorageAccountName}.blob.${az.environment().suffixes.storage}/${assetsStorageAccountContainerName}/${initializeSoftwareScriptName}'
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
