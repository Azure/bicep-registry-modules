targetScope = 'subscription'

// ================ //
// Input Parameters //
// ================ //

// Resource Group Parameters
@description('Optional. The name of the Resource Group.')
param resourceGroupName string = 'rg-ado-agents'

@description('Optional. The name of the Resource Group to deploy the Image Template resources into.')
param imageTemplateResourceGroupName string = '${resourceGroupName}-image-build'

// User Assigned Identity (MSI) Parameters
@description('Optional. The name of the Managed Identity used by deployment scripts.')
param deploymentScriptManagedIdentityName string = 'msi-ds'

@description('Optional. The name of the Managed Identity used by the Azure Image Builder.')
param imageManagedIdentityName string = 'msi-aib'

// Azure Compute Gallery Parameters
@description('Required. The name of the Azure Compute Gallery.')
param computeGalleryName string

@description('Required. The Image Definitions in the Azure Compute Gallery.')
param computeGalleryImageDefinitions array

// Storage Account Parameters
@description('Required. The name of the storage account.')
param assetsStorageAccountName string

@description('Optional. The name of the storage account.')
param deploymentScriptStorageAccountName string = '${assetsStorageAccountName}ds'

@description('Optional. The name of container in the Storage Account.')
param assetsStorageAccountContainerName string = 'aibscripts'

// Virtual Network Parameters
@description('Optional. The name of the Virtual Network.')
param virtualNetworkName string = 'vnet-it'

@description('Optional. The address space of the Virtual Network.')
param virtualNetworkAddressPrefix string = '10.0.0.0/16'

@description('Optional. The name of the Image Template Virtual Network Subnet to create.')
param imageSubnetName string = 'subnet-it'

@description('Optional. The address space of the Virtual Network Subnet.')
param virtualNetworkSubnetAddressPrefix string = cidrSubnet(virtualNetworkAddressPrefix, 24, 0)

@description('Optional. The name of the Image Template Virtual Network Subnet to create.')
param deploymentScriptSubnet string = 'subnet-ds'

@description('Optional. The address space of the Virtual Network Subnet used by the deployment script.')
param virtualNetworkDeploymentScriptSubnetAddressPrefix string = cidrSubnet(virtualNetworkAddressPrefix, 24, 1)

// Deployment Script Parameters
@description('Optional. The name of the Deployment Script to trigger the Image Template baking.')
param storageDeploymentScriptName string = 'ds-triggerUpload-storage'

@description('Optional. The files to upload to the Assets Storage Account. The syntax of each item should be like: { name: \'script_Install-LinuxPowerShell_sh\' \n value: loadTextContent(\'../scripts/uploads/linux/Install-LinuxPowerShell.sh\') }')
param storageAccountFilesToUpload object = {}

@description('Optional. The name of the Deployment Script to trigger the image tempalte baking.')
param imageTemplateDeploymentScriptName string = 'ds-triggerBuild-imageTemplate'

// Image Template Parameters
@description('Optional. The name of the Image Template.')
param imageTemplateName string = 'it-aib'

@description('Required. The image source to use for the Image Template.')
param imageTemplateImageSource object

@description('Required. The customization steps to use for the Image Template.')
param imageTemplateCustomizationSteps array

@description('Required. The name of Image Definition of the Azure Compute Gallery to host the new image version.')
param computeGalleryImageDefinitionName string

// Shared Parameters
@description('Optional. The location to deploy into')
param location string = deployment().location

@description('Optional. A parameter to control which deployments should be executed')
@allowed([
  'All'
  'Only infrastructure'
  'Only storage & image'
  'Only image'
])
param deploymentsToPerform string = 'Only storage & image'

@description('Generated. Do not provide a value! This date value is used to generate a SAS token to access the modules.')
param baseTime string = utcNow()

var formattedTime = replace(replace(replace(baseTime, ':', ''), '-', ''), ' ', '')

// =========== //
// Deployments //
// =========== //

// Resource Groups
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only infrastructure') {
  name: resourceGroupName
  location: location
}

// Always deployed as both an infra element & needed as a staging resource group for image building
module imageTemplateRg 'br/public:avm/res/resources/resource-group:0.2.4' = {
  name: '${deployment().name}-image-rg'
  params: {
    name: imageTemplateResourceGroupName
    location: location
  }
}

// User Assigned Identity (MSI)
// Always deployed as both an infra element & its output is neeeded for image building
module dsMsi 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.2' = {
  name: '${deployment().name}-ds-msi'
  scope: rg
  params: {
    name: deploymentScriptManagedIdentityName
    location: location
  }
}

module imageMSI 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.2' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only infrastructure') {
  name: '${deployment().name}-image-msi'
  scope: rg
  params: {
    name: imageManagedIdentityName
    location: location
  }
}

// MSI Subscription contributor assignment
resource imageMSI_rbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only infrastructure') {
  name: guid(
    subscription().subscriptionId,
    imageManagedIdentityName,
    subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  )
  properties: {
    // TODO: Tracked issue: https://github.com/Azure/bicep/issues/2371
    //principalId: imageMSI.outputs.principalId // Results in: Deployment template validation failed: 'The template resource 'Microsoft.Resources/deployments/image.deploy-ra' reference to 'Microsoft.Resources/deployments/image.deploy-msi' requires an API version. Please see https://aka.ms/arm-template for usage details.'.
    // Default: reference(extensionResourceId(format('/subscriptions/{0}/resourceGroups/{1}', subscription().subscriptionId, parameters('rgParam').name), 'Microsoft.Resources/deployments', format('{0}-msi', deployment().name))).outputs.principalId.value
    //principalId: reference(extensionResourceId(format('/subscriptions/{0}/resourceGroups/{1}', subscription().subscriptionId, resourceGroupName), 'Microsoft.Resources/deployments', format('{0}-msi', deployment().name)),'2021-04-01').outputs.principalId.value
    principalId: (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only infrastructure')
      ? imageMSI.outputs.principalId
      : ''
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'b24988ac-6180-42a0-ab88-20f7382dd24c'
    ) // Contributor
    principalType: 'ServicePrincipal'
  }
}

// Azure Compute Gallery
module azureComputeGallery 'br/public:avm/res/compute/gallery:0.4.0' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only infrastructure') {
  name: '${deployment().name}-acg'
  scope: rg
  params: {
    name: computeGalleryName
    images: computeGalleryImageDefinitions
    location: location
  }
}

// Image Template Virtual Network
module vnet 'br/public:avm/res/network/virtual-network:0.1.6' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only infrastructure') {
  name: '${deployment().name}-vnet'
  scope: rg
  params: {
    name: virtualNetworkName
    addressPrefixes: [
      virtualNetworkAddressPrefix
    ]
    subnets: [
      {
        name: imageSubnetName
        addressPrefix: virtualNetworkSubnetAddressPrefix
        privateLinkServiceNetworkPolicies: 'Disabled' // Required if using Azure Image Builder with existing VNET
        serviceEndpoints: [
          {
            service: 'Microsoft.Storage'
          }
        ]
      }
      {
        name: deploymentScriptSubnet
        addressPrefix: virtualNetworkDeploymentScriptSubnetAddressPrefix
        privateLinkServiceNetworkPolicies: 'Disabled' // Required if using Azure Image Builder with existing VNET - temp
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
    ]
    location: location
  }
}

// Assets Storage Account
module assetsStorageAccount 'br/public:avm/res/storage/storage-account:0.9.1' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only infrastructure') {
  name: '${deployment().name}-files-sa'
  scope: rg
  params: {
    name: assetsStorageAccountName
    allowSharedKeyAccess: false // Keys not needed if MSI is granted access
    location: location
    networkAcls: {
      // NOTE: If Firewall is enabled, it causes the Image Template to not be able to connect to the storage account. It's NOT a permission issue (ref: https://github.com/danielsollondon/azvmimagebuilder/issues/31#issuecomment-1793779854)
      // defaultAction: 'Allow'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          // Allow image template to access data
          action: 'Allow'
          id: vnet.outputs.subnetResourceIds[0] // imageSubnet
        }
        {
          // Allow deployment script to access storage account to upload data
          action: 'Allow'
          id: vnet.outputs.subnetResourceIds[1] // deploymentScriptSubnet
        }
      ]
    }
    blobServices: {
      containers: [
        {
          name: assetsStorageAccountContainerName
          publicAccess: 'None'
          roleAssignments: [
            {
              // Allow Infra MSI to access storage account container to upload files - DO NOT REMOVE
              roleDefinitionIdOrName: 'Storage Blob Data Contributor'
              principalId: (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only infrastructure')
                ? dsMsi.outputs.principalId
                : '' // Requires condition als Bicep will otherwise try to resolve the null reference
              principalType: 'ServicePrincipal'
            }
            {
              // Allow image MSI to access storage account container to read files - DO NOT REMOVE
              roleDefinitionIdOrName: 'Storage Blob Data Reader' // 'Storage Blob Data Reader'
              principalId: (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only infrastructure')
                ? imageMSI.outputs.principalId
                : '' // Requires condition als Bicep will otherwise try to resolve the null reference
              principalType: 'ServicePrincipal'
            }
          ]
        }
      ]
    }
  }
}

////////////////////
// TEMP RESOURCES //
////////////////////

// Deployment scripts & their storage account
// Role required for deployment script to be able to use a storage account via private networking
resource storageFileDataPrivilegedContributor 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '69566ab7-960f-475b-8e7c-b3118f30c6bd' // Storage File Data Priveleged Contributor
  scope: tenant()
}

module dsStorageAccount 'br/public:avm/res/storage/storage-account:0.9.1' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only infrastructure') {
  name: '${deployment().name}-ds-sa'
  scope: rg
  params: {
    name: deploymentScriptStorageAccountName
    allowSharedKeyAccess: true // May not be disabled to allow deployment script to access storage account files
    roleAssignments: [
      {
        // Allow MSI to leverage the storage account for private networking of container instance
        // ref: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-bicep#access-private-virtual-network
        roleDefinitionIdOrName: storageFileDataPrivilegedContributor.id // Storage File Data Priveleged Contributor
        principalId: (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only infrastructure')
          ? dsMsi.outputs.principalId
          : '' // Requires condition als Bicep will otherwise try to resolve the null reference
        principalType: 'ServicePrincipal'
      }
    ]
    location: location
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          // Allow deployment script to use storage account for private networking of container instance
          action: 'Allow'
          id: vnet.outputs.subnetResourceIds[1] // deploymentScriptSubnet
        }
      ]
    }
  }
}

// Upload storage account files
module storageAccount_upload 'br/public:avm/res/resources/deployment-script:0.2.4' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only infrastructure' || deploymentsToPerform == 'Only storage & image') {
  name: '${deployment().name}-storage-upload-ds'
  scope: rg
  params: {
    name: '${storageDeploymentScriptName}-${formattedTime}'
    kind: 'AzurePowerShell'
    azPowerShellVersion: '12.0'
    managedIdentities: {
      userAssignedResourcesIds: [
        dsMsi.outputs.resourceId
      ]
    }
    scriptContent: loadTextContent('../../../utilities/e2e-template-assets/scripts/Set-StorageContainerContentByEnvVar.ps1')
    environmentVariables: storageAccountFilesToUpload
    arguments: ' -StorageAccountName "${assetsStorageAccount.outputs.name}" -TargetContainer "${assetsStorageAccountContainerName}"'
    timeout: 'PT30M'
    cleanupPreference: 'Always'
    location: location
    storageAccountResourceId: dsStorageAccount.outputs.resourceId
    subnetResourceIds: [
      vnet.outputs.subnetResourceIds[1] // deploymentScriptSubnet
    ]
  }
}

// Image template
module imageTemplate 'br/public:avm/res/virtual-machine-images/image-template:0.2.1' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only storage & image' || deploymentsToPerform == 'Only image') {
  name: '${deployment().name}-it'
  scope: rg
  params: {
    customizationSteps: imageTemplateCustomizationSteps
    imageSource: imageTemplateImageSource
    name: imageTemplateName
    managedIdentities: {
      userAssignedResourceIds: [
        imageMSI.outputs.resourceId
      ]
    }
    distributions: [
      {
        type: 'SharedImage'
        sharedImageGalleryImageDefinitionResourceId: az.resourceId(
          subscription().subscriptionId,
          resourceGroupName,
          'Microsoft.Compute/galleries/images',
          computeGalleryName,
          computeGalleryImageDefinitionName
        )
      }
    ]

    subnetResourceId: vnet.outputs.subnetResourceIds[0] // Image Subnet
    location: location
    stagingResourceGroup: imageTemplateRg.outputs.resourceId
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Contributor'
        principalId: dsMsi.outputs.principalId // Allow deployment script to trigger image build
        principalType: 'ServicePrincipal'
      }
    ]
  }
  dependsOn: [
    azureComputeGallery
    storageAccount_upload
    imageMSI_rbac
  ]
}

// Deployment script to trigger image build
module imageTemplate_trigger 'br/public:avm/res/resources/deployment-script:0.2.4' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only storage & image' || deploymentsToPerform == 'Only image') {
  name: '${deployment().name}-imageTemplate-trigger-ds'
  scope: rg
  params: {
    name: '${imageTemplateDeploymentScriptName}-${formattedTime}-${(deploymentsToPerform == 'All' || deploymentsToPerform == 'Only storage & image' || deploymentsToPerform == 'Only image') ? imageTemplate.outputs.name : ''}' // Requires condition als Bicep will otherwise try to resolve the null reference
    kind: 'AzurePowerShell'
    azPowerShellVersion: '12.0'
    managedIdentities: {
      userAssignedResourcesIds: [
        dsMsi.outputs.resourceId
      ]
    }
    scriptContent: (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only storage & image' || deploymentsToPerform == 'Only image')
      ? imageTemplate.outputs.runThisCommand
      : '' // Requires condition als Bicep will otherwise try to resolve the null reference
    timeout: 'PT30M'
    cleanupPreference: 'Always'
    location: location
    storageAccountResourceId: dsStorageAccount.outputs.resourceId
    subnetResourceIds: [
      vnet.outputs.subnetResourceIds[1] // deploymentScriptSubnet
    ]
  }
}

@description('The generated name of the image template.')
output imageTemplateName string = (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only storage & image' || deploymentsToPerform == 'Only image')
  ? imageTemplate.outputs.name
  : '' // Requires condition als Bicep will otherwise try to resolve the null reference
