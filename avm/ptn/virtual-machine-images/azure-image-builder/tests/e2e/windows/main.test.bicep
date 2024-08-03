targetScope = 'subscription'

metadata name = 'Creating a Windows image with Azure Image Builder'
metadata description = 'This instance deploy a Windows-flavored image definition and image using Windows-specific installation scripts.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resource group to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apvmiaibw'

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

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name)}-image-sbx'
  params: {
    location: resourceLocation
    deploymentsToPerform: 'All'
    assetsStorageAccountName: assetsStorageAccountName
    assetsStorageAccountContainerName: assetsStorageAccountContainerName
    computeGalleryName: 'gal${namePrefix}${serviceShort}'
    computeGalleryImageDefinitionName: computeGalleryImageDefinitionName
    storageAccountFilesToUpload: {
      secureList: [
        {
          name: 'script_${replace(replace(installPwshScriptName, '-', '__'), '.', '_')}' // May only be alphanumeric characters & underscores. The upload will replace '_' with '.' and '__' with '-'. E.g., Install__WindowsPowerShell_ps1 will be Install-WindowsPowerShell.ps1
          value: loadTextContent('scripts/${installPwshScriptName}')
        }
        {
          name: 'script_${replace(replace(initializeSoftwareScriptName, '-', '__'), '.', '_')}' // May only be alphanumeric characters & underscores. The upload will replace '_' with '.' and '__' with '-'. E.g., Initialize__WindowsSoftware_ps1 will be Initialize-WindowsSoftware.ps1
          value: loadTextContent('scripts/${initializeSoftwareScriptName}')
        }
      ]
    }
    computeGalleryImageDefinitions: [
      {
        name: computeGalleryImageDefinitionName
        osType: 'Windows'
        publisher: 'devops'
        offer: 'devops_windows'
        sku: 'devops_windows_az'
      }
    ]
    imageTemplateImageSource: {
      type: 'PlatformImage'
      publisher: 'MicrosoftWindowsDesktop'
      offer: 'Windows-10'
      sku: '19h2-evd'
      version: 'latest'
    }
    imageTemplateCustomizationSteps: [
      {
        type: 'PowerShell'
        name: 'PowerShell installation'
        inline: [
          'Write-Output "Download"'
          'wget \'https://${assetsStorageAccountName}.blob.${environment().suffixes.storage}/${assetsStorageAccountContainerName}/${installPwshScriptName}?\' -O \'${installPwshScriptName}\''
          'Write-Output "Invocation"'
          '. \'${installPwshScriptName}\''
        ]
        runElevated: true
      }
      {
        type: 'File'
        name: 'Download ${initializeSoftwareScriptName}'
        sourceUri: 'https://${assetsStorageAccountName}.blob.${environment().suffixes.storage}/${assetsStorageAccountContainerName}/${initializeSoftwareScriptName}'
        destination: initializeSoftwareScriptName
      }
      {
        type: 'PowerShell'
        name: 'Software installation'
        inline: [
          'wget \'https://${assetsStorageAccountName}.blob.${environment().suffixes.storage}/${assetsStorageAccountContainerName}/${initializeSoftwareScriptName}?\' -O \'${initializeSoftwareScriptName}\''
          'pwsh \'${initializeSoftwareScriptName}\''
        ]
        runElevated: true
      }
    ]
  }
}
