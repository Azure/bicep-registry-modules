@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Storage Account to create and to copy the VHD into.')
param storageAccountName string

@description('Required. The name prefix of the Image Template to create.')
param imageTemplateNamePrefix string

@description('Generated. Do not provide a value! This date value is used to generate a unique image template name.')
param baseTime string = utcNow('yyyy-MM-dd-HH-mm-ss')

@description('Required. The name of the Deployment Script to create for triggering the image creation.')
param triggerImageDeploymentScriptName string

@description('Required. The name of the Deployment Script to copy the VHD to a destination storage account.')
param copyVhdDeploymentScriptName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    allowBlobPublicAccess: false
  }
  resource blobServices 'blobServices@2022-09-01' = {
    name: 'default'
    resource container 'containers@2022-09-01' = {
      name: 'vhds'
      properties: {
        publicAccess: 'None'
      }
    }
  }
}

module roleAssignment 'dependencies_rbac.bicep' = {
  name: '${deployment().name}-MSI-roleAssignment'
  scope: subscription()
  params: {
    managedIdentityPrincipalId: managedIdentity.properties.principalId
    managedIdentityResourceId: managedIdentity.id
  }
}

// Deploy image template
resource imageTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2022-02-14' = {
  #disable-next-line use-stable-resource-identifiers
  name: '${imageTemplateNamePrefix}-${baseTime}'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    buildTimeoutInMinutes: 0
    vmProfile: {
      vmSize: 'Standard_D2s_v3'
      osDiskSizeGB: 127
    }
    source: {
      type: 'PlatformImage'
      publisher: 'MicrosoftWindowsDesktop'
      offer: 'Windows-11'
      sku: 'win11-21h2-avd'
      version: 'latest'
    }
    distribute: [
      {
        type: 'VHD'
        runOutputName: '${imageTemplateNamePrefix}-VHD'
        artifactTags: {}
      }
    ]
    customize: [
      {
        restartTimeout: '30m'
        type: 'WindowsRestart'
      }
    ]
  }
}

// Trigger VHD creation
resource triggerImageDeploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: triggerImageDeploymentScriptName
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '11.5' // Source: https://mcr.microsoft.com/v2/azuredeploymentscripts-powershell/tags/list
    retentionInterval: 'P1D'
    arguments: '-ImageTemplateName \\"${imageTemplate.name}\\" -ImageTemplateResourceGroup \\"${resourceGroup().name}\\"'
    scriptContent: loadTextContent('../../../../../../utilities/e2e-template-assets/scripts/Start-ImageTemplate.ps1')
    cleanupPreference: 'OnSuccess'
    forceUpdateTag: baseTime
  }
  dependsOn: [
    roleAssignment
  ]
}

// Copy VHD to destination storage account
resource copyVhdDeploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: copyVhdDeploymentScriptName
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '11.5' // Source: https://mcr.microsoft.com/v2/azuredeploymentscripts-powershell/tags/list
    retentionInterval: 'P1D'
    arguments: '-ImageTemplateName \\"${imageTemplate.name}\\" -ImageTemplateResourceGroup \\"${resourceGroup().name}\\" -DestinationStorageAccountName \\"${storageAccount.name}\\" -VhdName \\"${imageTemplateNamePrefix}\\" -WaitForComplete'
    scriptContent: loadTextContent('../../../../../../utilities/e2e-template-assets/scripts/Copy-VhdToStorageAccount.ps1')
    cleanupPreference: 'OnSuccess'
    forceUpdateTag: baseTime
  }
  dependsOn: [triggerImageDeploymentScript]
}

@description('The URI of the created VHD.')
output vhdUri string = 'https://${storageAccount.name}.blob.${environment().suffixes.storage}/vhds/${imageTemplateNamePrefix}.vhd'

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id
