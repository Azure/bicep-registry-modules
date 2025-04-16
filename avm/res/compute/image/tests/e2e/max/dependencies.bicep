@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Storage Account to create and to copy the VHD into.')
param storageAccountName string

@description('Required. The name of the Disk Encryption Set to create.')
param diskEncryptionSetName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name prefix of the Image Template to create.')
param imageTemplateNamePrefix string

@description('Generated. Do not provide a value! This date value is used to generate a unique image template name.')
param baseTime string = utcNow('yyyy-MM-dd-HH-mm-ss')

@description('Required. The name of the Deployment Script to create for triggering the image creation.')
param triggerImageDeploymentScriptName string

@description('Required. The name of the Deployment Script to copy the VHD to a destination storage account.')
param copyVhdDeploymentScriptName string

@description('Required. The name of the deployment script that waits for a role assignment to propagate.')
param waitDeploymentScriptName string

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

resource resourceGroupContributorRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().subscriptionId, 'Contributor', managedIdentity.id)
  scope: resourceGroup()
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'b24988ac-6180-42a0-ab88-20f7382dd24c'
    ) // Contributor
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
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
    scriptContent: loadTextContent('../../../../../../../utilities/e2e-template-assets/scripts/Start-ImageTemplate.ps1')
    cleanupPreference: 'OnSuccess'
    forceUpdateTag: baseTime
  }
  dependsOn: [
    resourceGroupContributorRole
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
    scriptContent: loadTextContent('../../../../../../../utilities/e2e-template-assets/scripts/Copy-VhdToStorageAccount.ps1')
    cleanupPreference: 'OnSuccess'
    forceUpdateTag: baseTime
  }
  dependsOn: [
    triggerImageDeploymentScript
  ]
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enablePurgeProtection: true // Required for encryption to work
    softDeleteRetentionInDays: 7
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enableRbacAuthorization: true
    accessPolicies: []
  }

  resource key 'keys@2022-07-01' = {
    name: 'encryptionKey'
    properties: {
      kty: 'RSA'
    }
  }
}

resource keyVaultKeyCryptoRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${keyVault::key.id}-${location}-${managedIdentity.id}-Key-RoleAssignment')
  scope: keyVault::key
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '12338af0-0e69-4776-bea7-57ae8d297424'
    ) // Key Vault Crypto User
    principalType: 'ServicePrincipal'
  }
}

// Waiting for the role assignment to propagate
resource waitForDeployment 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  dependsOn: [keyVaultKeyCryptoRole]
  name: waitDeploymentScriptName
  location: location
  kind: 'AzurePowerShell'
  properties: {
    retentionInterval: 'PT1H'
    azPowerShellVersion: '11.0'
    cleanupPreference: 'Always'
    scriptContent: 'write-output "Sleeping for 15"; start-sleep -Seconds 15'
  }
}

resource diskEncryptionSet 'Microsoft.Compute/diskEncryptionSets@2023-10-02' = {
  dependsOn: [waitForDeployment]
  name: diskEncryptionSetName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    activeKey: {
      sourceVault: {
        id: keyVault.id
      }
      keyUrl: keyVault::key.properties.keyUriWithVersion
    }
    encryptionType: 'EncryptionAtRestWithCustomerKey'
  }
}

@description('The URI of the created VHD.')
output vhdUri string = 'https://${storageAccount.name}.blob.${environment().suffixes.storage}/vhds/${imageTemplateNamePrefix}.vhd'

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Disk Encryption Set.')
output diskEncryptionSetResourceId string = diskEncryptionSet.id
