@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Shared Image Gallery to create.')
param galleryName string

@description('Required. The name of the Image Definition to create in the Shared Image Gallery.')
param sigImageDefinitionName string

@description('Required. The name of the Image Managed Identity to create.')
param imageManagedIdentityName string

@description('Required. The name of the Deployment Script Managed Identity to create.')
param deploymentScriptManagedIdentityName string

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Optional. The name of the Image Virtual Network Subnet to create.')
param imageSubnetName string = 'imageSubnet'

@description('Optional. The name of the Deployment Script Virtual Network Subnet to create.')
param deploymentScriptSubnetName string = 'deploymentScriptSubnet'

@description('Required. The name of the Assets Storage Account to create.')
param assetStorageAccountkName string

@description('Required. The name of the Deployment Script Storage Account to create.')
param deploymentScriptStorageAccountkName string

@description('Required. The name of the Deployment Script used to upload files to the Assets Storage Account.')
param storageDeploymentScriptName string

resource imageManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: imageManagedIdentityName
  location: location
}

resource deploymentScriptManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: deploymentScriptManagedIdentityName
  location: location
}

var addressPrefix = '10.0.0.0/16'

// Roles
resource contributorRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor
  scope: tenant()
}
resource managedIdentityOperatorRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'f1a07417-d97a-45cb-824c-7a7467783830' // Managed Identity Operator
  scope: tenant()
}
resource storageFileDataPrivilegedContributorRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '69566ab7-960f-475b-8e7c-b3118f30c6bd' // Storage File Data Priveleged Contributor
  scope: tenant()
}
resource storageBlobDataReaderRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1' // Storage Blob Data Reader
  scope: tenant()
}
resource storageBlobDataContributorRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' // Storage Blob Data Contributor
  scope: tenant()
}

// Resources
resource gallery 'Microsoft.Compute/galleries@2022-03-03' = {
  name: galleryName
  location: location
  properties: {}

  resource imageDefinition 'images@2022-03-03' = {
    name: sigImageDefinitionName
    location: location
    properties: {
      architecture: 'x64'
      hyperVGeneration: 'V2'
      identifier: {
        offer: 'devops_linux'
        publisher: 'devops'
        sku: 'devops_linux_az'
      }
      osState: 'Generalized'
      osType: 'Linux'
      recommended: {
        memory: {
          max: 16
          min: 4
        }
        vCPUs: {
          max: 8
          min: 2
        }
      }
    }
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: imageSubnetName
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 0)
          privateLinkServiceNetworkPolicies: 'Disabled' // Required if using Azure Image Builder with existing VNET
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
          ]
        }
      }
      {
        name: deploymentScriptSubnetName
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 1)
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
          ]
          delegations: [
            {
              name: 'Microsoft.ContainerInstance.containerGroups'
              properties: {
                serviceName: 'Microsoft.ContainerInstance/containerGroups'
              }
            }
          ]
        }
      }
    ]
  }
}

resource assetsStorageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: assetStorageAccountkName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
  }

  resource blobService 'blobServices@2023-01-01' = {
    name: 'default'
    properties: {}

    resource container 'containers@2023-01-01' = {
      name: 'assets'
      properties: {
        publicAccess: 'None'
      }
    }
  }
}

// Assign permissions to MSI to be allowed to distribute images. Ref: https://learn.microsoft.com/en-us/azure/virtual-machines/linux/image-builder-permissions-cli#allow-vm-image-builder-to-distribute-images
resource imageContributorRbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, contributorRole.id, imageManagedIdentity.id)
  properties: {
    roleDefinitionId: contributorRole.id
    principalId: imageManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Assign permission to allow AIB to assign the list of User Assigned Identities to the Build VM.
resource imageManagedIdentityOperatorRbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, managedIdentityOperatorRole.id, imageManagedIdentity.id)
  properties: {
    roleDefinitionId: managedIdentityOperatorRole.id
    principalId: imageManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Allow Deployment Script MSI to access storage account container to upload files
resource storageContributorRbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(
    assetsStorageAccount::blobService::container.id,
    storageBlobDataContributorRole.id,
    imageManagedIdentity.id
  )
  scope: assetsStorageAccount::blobService::container
  properties: {
    roleDefinitionId: storageBlobDataContributorRole.id
    principalId: deploymentScriptManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Allow image MSI to access storage account container to read files
resource storageReaderRbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(assetsStorageAccount::blobService::container.id, storageBlobDataReaderRole.id, imageManagedIdentity.id)
  scope: assetsStorageAccount::blobService::container
  properties: {
    roleDefinitionId: storageBlobDataReaderRole.id
    principalId: imageManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource dsStorageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: deploymentScriptStorageAccountkName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowSharedKeyAccess: true // May not be disabled to allow deployment script to access storage account files
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          // Allow deployment script to use storage account for private networking of container instance
          action: 'Allow'
          id: resourceId(
            subscription().subscriptionId,
            resourceGroup().name,
            'Microsoft.Network/virtualNetworks/subnets',
            virtualNetwork.name,
            deploymentScriptSubnetName
          )
        }
      ]
    }
  }
}

// Allow Deployment Script MSI to access storage account to upload files
resource storageFileContributorRbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(dsStorageAccount.id, storageFileDataPrivilegedContributorRole.id, deploymentScriptManagedIdentity.id)
  scope: dsStorageAccount
  properties: {
    roleDefinitionId: storageFileDataPrivilegedContributorRole.id
    principalId: deploymentScriptManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Upload storage account files
resource assetsStorageAccount_upload 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: storageDeploymentScriptName
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${deploymentScriptManagedIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '9.7'
    retentionInterval: 'P1D'
    scriptContent: loadTextContent('../../../../../../utilities/e2e-template-assets/scripts/Set-StorageContainerContentByEnvVar.ps1')
    environmentVariables: [
      {
        name: '__SCRIPT__Install__LinuxPowerShell_sh' // May only be alphanumeric characters & underscores. The upload will replace '_' with '.' and '__' with '-'.
        value: loadTextContent('src/Install-LinuxPowerShell.sh')
      }
      {
        name: '__SCRIPT__Initialize__LinuxSoftware_ps1' // May only be alphanumeric characters & underscores. The upload will replace '_' with '.' and '__' with '-'.
        value: loadTextContent('src/Initialize-LinuxSoftware.ps1')
      }
    ]
    arguments: ' -StorageAccountName "${assetsStorageAccount.name}" -TargetContainer "${assetsStorageAccount::blobService::container.name}"'
    timeout: 'PT30M'
    cleanupPreference: 'Always'
    storageAccountSettings: {
      storageAccountName: dsStorageAccount.name
    }
    containerSettings: {
      subnetIds: [
        {
          id: resourceId(
            subscription().subscriptionId,
            resourceGroup().name,
            'Microsoft.Network/virtualNetworks/subnets',
            virtualNetwork.name,
            deploymentScriptSubnetName
          )
        }
      ]
    }
  }
  dependsOn: [
    storageContributorRbac
    storageFileContributorRbac
  ]
}

@description('The principal ID of the created Image Managed Identity.')
output managedIdentityResourceId string = imageManagedIdentity.id

@description('The principal ID of the created Image Managed Identity.')
output managedIdentityPrincipalId string = imageManagedIdentity.properties.principalId

@description('The resource ID of the created Image Definition.')
output sigImageDefinitionId string = gallery::imageDefinition.id

@description('The subnet resource id of the defaultSubnet of the created Virtual Network.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The blob endpoint of the created Assets Storage Account.')
output assetsStorageAccountNameBlobEndpoint string = assetsStorageAccount.properties.primaryEndpoints.blob

@description('The name of the created Assets Storage Account Container.')
output assetsStorageAccountContainerName string = assetsStorageAccount::blobService::container.name
