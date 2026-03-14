targetScope = 'subscription'

metadata name = 'Custom Images using Azure Image Builder'
metadata description = 'This module provides you with a packaged solution to create custom images using the Azure Image Builder service publishing to an Azure Compute Gallery.'

// ================ //
// Input Parameters //
// ================ //

@description('Optional. A parameter to control which deployments should be executed.')
@allowed([
  'All'
  'Only base'
  'Only assets & image'
  'Only image'
])
param deploymentsToPerform string = 'Only assets & image'

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

import { imageType } from 'br/public:avm/res/compute/gallery:0.9.3'
@description('Required. The Image Definitions in the Azure Compute Gallery.')
param computeGalleryImageDefinitions imageType[]

// Storage Account Parameters
@description('Optional. The name of the storage account. Only needed if you want to upload scripts to be used during image baking.')
param assetsStorageAccountName string?

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

@description('Optional. The name of the Virtual Network Subnet to create and use for Azure Container Instances for isolated builds. For more information please refer to [docs](https://learn.microsoft.com/en-us/azure/virtual-machines/security-isolated-image-builds-image-builder#bring-your-own-build-vm-subnet-and-bring-your-own-aci-subnet).')
param imageContainerInstanceSubnetName string = 'subnet-it-container'

@description('Optional. The address space of the Virtual Network Subnet.')
param virtualNetworkSubnetAddressPrefix string = cidrSubnet(virtualNetworkAddressPrefix, 24, 0)

@description('Optional. The address space of the Virtual Network Subnet used by the Azure Container Instances for isolated builds. Only relevant if `imageContainerInstanceSubnetName` is not empty.')
param imagecontainerInstanceSubnetAddressPrefix string = cidrSubnet(virtualNetworkAddressPrefix, 24, 2)

@description('Optional. The name of the Image Template Virtual Network Subnet to create.')
param deploymentScriptSubnetName string = 'subnet-ds'

@description('Optional. The address space of the Virtual Network Subnet used by the deployment script.')
param virtualNetworkDeploymentScriptSubnetAddressPrefix string = cidrSubnet(virtualNetworkAddressPrefix, 24, 1)

// Deployment Script Parameters
@description('Optional. The name of the Deployment Script to upload files to the assets storage account.')
param storageDeploymentScriptName string = 'ds-triggerUpload-storage'

@description('Optional. The files to upload to the Assets Storage Account. Note, the file you\'re uploading should not contain emojis as they may cause problems when loaded into the environment of the uploading deployment script.')
param storageAccountFilesToUpload storageAccountFilesToUploadType[]?

@description('Optional. The name of the Deployment Script to trigger the image template baking.')
param imageTemplateDeploymentScriptName string = 'ds-triggerBuild-imageTemplate'

@description('Optional. The name of the Deployment Script to wait for for the image baking to conclude.')
param waitDeploymentScriptName string = 'ds-wait-imageTemplate-build'

// Image Template Parameters
@description('Optional. The name of the Image Template.')
param imageTemplateName string = 'it-aib'

@description('Required. The image source to use for the Image Template.')
param imageTemplateImageSource resourceInput<'Microsoft.VirtualMachineImages/imageTemplates@2024-02-01'>.properties.source

@description('Optional. The customization steps to use for the Image Template.')
@minLength(1)
param imageTemplateCustomizationSteps array?

@description('Required. The name of Image Definition of the Azure Compute Gallery to host the new image version.')
param computeGalleryImageDefinitionName string

@description('Optional. A parameter to control if the deployment should wait for the image build to complete.')
param waitForImageBuild bool = true

@description('Optional. A parameter to control the timeout of the deployment script waiting for the image build.')
param waitForImageBuildTimeout string = 'PT3H'

// Shared Parameters
@description('Optional. The location to deploy into.')
param location string = deployment().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Generated. Do not provide a value! This date value is used to generate a SAS token to access the modules.')
param baseTime string = utcNow()

var formattedTime = replace(replace(replace(baseTime, ':', ''), '-', ''), ' ', '')

// =========== //
// Deployments //
// =========== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.vmimages-azureimagebuilder.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

//////////////////////////
//   START: ALL         //
//   START: ONLY BASE   //
// ==================== //

// Primary Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only base') {
  name: resourceGroupName
  location: location
}

// Optional Image Staging RG
resource imageTemplateRg 'Microsoft.Resources/resourceGroups@2025-04-01' = if ((deploymentsToPerform == 'All' || deploymentsToPerform == 'Only base') && !empty(imageTemplateResourceGroupName)) {
  name: imageTemplateResourceGroupName
  location: location
}

// User Assigned Identity (MSI)
module dsMsi 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only base') {
  name: '${deployment().name}-ds-msi'
  scope: rg
  params: {
    name: deploymentScriptManagedIdentityName
    location: location
    enableTelemetry: enableTelemetry
  }
}

module imageMSI 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only base') {
  name: '${deployment().name}-image-msi'
  scope: rg
  params: {
    name: imageManagedIdentityName
    location: location
    enableTelemetry: enableTelemetry
  }
}

// MSI RG contributor assignment
module imageMSI_build_rg_rbac 'br/public:avm/res/authorization/role-assignment/rg-scope:0.1.0' = if ((deploymentsToPerform == 'All' || deploymentsToPerform == 'Only base') && !empty(imageTemplateResourceGroupName)) {
  scope: imageTemplateRg
  name: '${deployment().name}-image-msi-rbac-build-rg'
  params: {
    principalId: imageMSI!.outputs.principalId
    roleDefinitionIdOrName: 'Contributor' // Required to build the image in the build-rg
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
}

// Azure Compute Gallery
module azureComputeGallery 'br/public:avm/res/compute/gallery:0.9.3' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only base') {
  name: '${deployment().name}-acg'
  scope: rg
  params: {
    name: computeGalleryName
    images: computeGalleryImageDefinitions
    location: location
    enableTelemetry: enableTelemetry
    roleAssignments: [
      {
        principalId: imageMSI!.outputs.principalId
        roleDefinitionIdOrName: 'Contributor' // Required to publish images to the Azure Compute Gallery (ref: https://learn.microsoft.com/en-us/azure/virtual-machines/linux/image-builder-permissions-cli#allow-vm-image-builder-to-distribute-images)
        principalType: 'ServicePrincipal'
      }
    ]
  }
}

// Image Template Virtual Network
module vnet 'br/public:avm/res/network/virtual-network:0.7.0' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only base') {
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
          'Microsoft.Storage'
        ]
      }
      ...(!empty(imageContainerInstanceSubnetName)
        ? [
            {
              name: imageContainerInstanceSubnetName
              addressPrefix: imagecontainerInstanceSubnetAddressPrefix
              privateLinkServiceNetworkPolicies: 'Disabled' // Required if using Azure Image Builder with existing VNET
              delegation: 'Microsoft.ContainerInstance/containerGroups'
            }
          ]
        : [])
      {
        name: deploymentScriptSubnetName
        addressPrefix: virtualNetworkDeploymentScriptSubnetAddressPrefix
        privateLinkServiceNetworkPolicies: 'Disabled' // Required if using Azure Image Builder with existing VNET - temp
        serviceEndpoints: [
          'Microsoft.Storage'
        ]
        delegation: 'Microsoft.ContainerInstance/containerGroups'
      }
    ]
    location: location
    enableTelemetry: enableTelemetry
    roleAssignments: [
      {
        principalId: imageMSI!.outputs.principalId
        roleDefinitionIdOrName: 'Network Contributor' // Required to use private networking (ref: https://learn.microsoft.com/en-us/azure/virtual-machines/linux/image-builder-permissions-cli#permission-to-customize-images-on-your-virtual-networks)
        principalType: 'ServicePrincipal'
      }
    ]
  }
}

// Assets Storage Account
module assetsStorageAccount 'br/public:avm/res/storage/storage-account:0.25.1' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only base') {
  name: '${deployment().name}-files-sa'
  scope: rg
  params: {
    name: assetsStorageAccountName!
    allowSharedKeyAccess: false // Keys not needed if MSI is granted access
    enableTelemetry: enableTelemetry
    location: location
    networkAcls: {
      // NOTE: If Firewall is enabled, it causes the Image Template to not be able to connect to the storage account. It's NOT a permission issue (ref: https://github.com/danielsollondon/azvmimagebuilder/issues/31#issuecomment-1793779854)
      defaultAction: 'Allow'
      // defaultAction: 'Deny'
      // virtualNetworkRules: [
      //   {
      //     // Allow image template to access data
      //     action: 'Allow'
      //     id: filter(vnet.outputs.subnetResourceIds, resourceId => last(split(resourceId, '/')) == imageSubnetName)[0]
      //   }
      //   {
      //     // Allow deployment script to access storage account to upload data
      //     action: 'Allow'
      //     id: filter(vnet.outputs.subnetResourceIds, resourceId => last(split(resourceId, '/')) == deploymentScriptSubnetName)[0]
      //   }
      // ]
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
              principalId: dsMsi!.outputs.principalId
              principalType: 'ServicePrincipal'
            }
            {
              // Allow image MSI to access storage account container to read files - DO NOT REMOVE
              roleDefinitionIdOrName: 'Storage Blob Data Reader' // 'Storage Blob Data Reader'
              principalId: imageMSI!.outputs.principalId
              principalType: 'ServicePrincipal'
            }
          ]
        }
      ]
      containerDeleteRetentionPolicyEnabled: true
      containerDeleteRetentionPolicyDays: 10
    }
  }
}

// Deployment scripts & their storage account
module dsStorageAccount 'br/public:avm/res/storage/storage-account:0.25.1' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only base') {
  name: '${deployment().name}-ds-sa'
  scope: rg
  params: {
    name: deploymentScriptStorageAccountName
    allowSharedKeyAccess: true // May not be disabled to allow deployment script to access storage account files
    enableTelemetry: enableTelemetry
    roleAssignments: [
      {
        // Allow MSI to leverage the storage account for private networking of container instance
        // ref: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-bicep#access-private-virtual-network
        roleDefinitionIdOrName: 'Storage File Data Privileged Contributor'
        principalId: dsMsi!.outputs.principalId
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
          id: resourceId(
            subscription().subscriptionId,
            resourceGroupName,
            'Microsoft.Network/virtualNetworks/subnets',
            virtualNetworkName,
            deploymentScriptSubnetName
          )
        }
      ]
    }
  }
  dependsOn: [
    vnet
  ]
}

////////////////////////////////////
//   START: ONLY ASSETS & IMAGE   //
// ============================== //

// Upload storage account files
module storageAccount_upload 'br/public:avm/res/resources/deployment-script:0.5.1' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only base' || deploymentsToPerform == 'Only assets & image') {
  name: '${deployment().name}-storage-upload-ds'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: '${storageDeploymentScriptName}-${formattedTime}'
    kind: 'AzurePowerShell'
    azPowerShellVersion: '12.0'
    enableTelemetry: enableTelemetry
    managedIdentities: {
      userAssignedResourceIds: [
        resourceId(
          subscription().subscriptionId,
          resourceGroupName,
          'Microsoft.ManagedIdentity/userAssignedIdentities',
          deploymentScriptManagedIdentityName
        )
      ]
    }
    scriptContent: loadTextContent('../../../../utilities/e2e-template-assets/scripts/Set-StorageContainerContentByEnvVar.ps1')
    environmentVariables: map(storageAccountFilesToUpload ?? [], file => {
      name: '__SCRIPT__${replace(replace(file.name, '-', '__'), '.', '_') }' // May only be alphanumeric characters & underscores. The upload will replace '_' with '.' and '__' with '-'. E.g., Install__LinuxPowerShell_sh will be Install-LinuxPowerShell.sh
      value: file.?value
      secureValue: file.?secureValue
    })
    arguments: ' -StorageAccountName "${assetsStorageAccountName}" -TargetContainer "${assetsStorageAccountContainerName}" -SubscriptionId "${subscription().subscriptionId}"'
    timeout: 'PT30M'
    cleanupPreference: 'Always'
    location: location
    storageAccountResourceId: resourceId(
      subscription().subscriptionId,
      resourceGroupName,
      'Microsoft.Storage/storageAccounts',
      deploymentScriptStorageAccountName
    )
    subnetResourceIds: [
      resourceId(
        subscription().subscriptionId,
        resourceGroupName,
        'Microsoft.Network/virtualNetworks/subnets',
        virtualNetworkName,
        deploymentScriptSubnetName
      )
    ]
  }
  dependsOn: [
    // Conditionally required
    rg
    assetsStorageAccount
    dsMsi
    dsStorageAccount
    vnet
  ]
}

// ================== //
//   END: ONLY BASE   //
////////////////////////

///////////////////////////
//   START: ONLY IMAGE   //
// ===================== //

// Image template
resource dsMsi_existing 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = if (deploymentsToPerform == 'Only assets & image' || deploymentsToPerform == 'Only image') {
  name: deploymentScriptManagedIdentityName
  scope: resourceGroup(resourceGroupName)
}

module imageTemplate 'br/public:avm/res/virtual-machine-images/image-template:0.6.0' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only assets & image' || deploymentsToPerform == 'Only image') {
  name: '${deployment().name}-it'
  scope: resourceGroup(resourceGroupName)
  params: {
    customizationSteps: imageTemplateCustomizationSteps
    imageSource: imageTemplateImageSource
    name: imageTemplateName
    enableTelemetry: enableTelemetry
    managedIdentities: {
      userAssignedResourceIds: [
        resourceId(
          subscription().subscriptionId,
          resourceGroupName,
          'Microsoft.ManagedIdentity/userAssignedIdentities',
          imageManagedIdentityName
        )
      ]
    }
    distributions: [
      {
        type: 'SharedImage'
        sharedImageGalleryImageDefinitionResourceId: resourceId(
          subscription().subscriptionId,
          resourceGroupName,
          'Microsoft.Compute/galleries/images',
          computeGalleryName,
          computeGalleryImageDefinitionName
        )
      }
    ]
    vnetConfig: {
      subnetResourceId: resourceId(
        subscription().subscriptionId,
        resourceGroupName,
        'Microsoft.Network/virtualNetworks/subnets',
        virtualNetworkName,
        imageSubnetName
      )
      ...(!empty(imageContainerInstanceSubnetName)
        ? {
            containerInstanceSubnetResourceId: resourceId(
              subscription().subscriptionId,
              resourceGroupName,
              'Microsoft.Network/virtualNetworks/subnets',
              virtualNetworkName,
              imageContainerInstanceSubnetName
            )
          }
        : {})
    }
    location: location
    stagingResourceGroupResourceId: !empty(imageTemplateResourceGroupName)
      ? subscriptionResourceId(
          subscription().subscriptionId,
          'Microsoft.Resources/resourceGroups',
          imageTemplateResourceGroupName
        )
      : null
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Contributor'
        // Allow deployment script to trigger image build. Use 'existing' reference if only part of solution is deployed
        principalId: (deploymentsToPerform == 'Only assets & image' || deploymentsToPerform == 'Only image')
          ? dsMsi_existing!.properties.principalId
          : dsMsi!.outputs.principalId
        principalType: 'ServicePrincipal'
      }
    ]
  }
  dependsOn: [
    storageAccount_upload
    imageMSI_build_rg_rbac
    imageMSI
    azureComputeGallery
    vnet
  ]
}

// Deployment script to trigger image build
module imageTemplate_trigger 'br/public:avm/res/resources/deployment-script:0.5.1' = if (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only assets & image' || deploymentsToPerform == 'Only image') {
  name: '${deployment().name}-imageTemplate-trigger-ds'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: '${imageTemplateDeploymentScriptName}-${formattedTime}-${imageTemplate!.outputs.name}'
    kind: 'AzurePowerShell'
    azPowerShellVersion: '12.0'
    managedIdentities: {
      userAssignedResourceIds: [
        resourceId(
          subscription().subscriptionId,
          resourceGroupName,
          'Microsoft.ManagedIdentity/userAssignedIdentities',
          deploymentScriptManagedIdentityName
        )
      ]
    }
    enableTelemetry: enableTelemetry
    scriptContent: 'Set-AzContext -Subscription ${subscription().subscriptionId }; ${imageTemplate!.outputs.runThisCommand}'
    timeout: 'PT30M'
    cleanupPreference: 'Always'
    location: location
    storageAccountResourceId: resourceId(
      subscription().subscriptionId,
      resourceGroupName,
      'Microsoft.Storage/storageAccounts',
      deploymentScriptStorageAccountName
    )
    subnetResourceIds: [
      resourceId(
        subscription().subscriptionId,
        resourceGroupName,
        'Microsoft.Network/virtualNetworks/subnets',
        virtualNetworkName,
        deploymentScriptSubnetName
      )
    ]
  }
  dependsOn: [
    // Always required
    // imageTemplate
    // Conditionally required
    // rg
    // dsMsi
    dsStorageAccount
    storageAccount_upload
    vnet
  ]
}

module imageTemplate_wait 'br/public:avm/res/resources/deployment-script:0.5.1' = if (waitForImageBuild && (deploymentsToPerform == 'All' || deploymentsToPerform == 'Only assets & image' || deploymentsToPerform == 'Only image')) {
  name: '${deployment().name}-imageTemplate-wait-ds'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: '${waitDeploymentScriptName}-${formattedTime}'
    kind: 'AzurePowerShell'
    azPowerShellVersion: '12.0'
    managedIdentities: {
      userAssignedResourceIds: [
        resourceId(
          subscription().subscriptionId,
          resourceGroupName,
          'Microsoft.ManagedIdentity/userAssignedIdentities',
          deploymentScriptManagedIdentityName
        )
      ]
    }
    scriptContent: loadTextContent('../../../../utilities/e2e-template-assets/scripts/Wait-ForImageBuild.ps1')
    arguments: ' -ImageTemplateName "${imageTemplate!.outputs.name}" -ResourceGroupName "${resourceGroupName}" -SubscriptionId "${subscription().subscriptionId}"'
    timeout: waitForImageBuildTimeout
    cleanupPreference: 'Always'
    location: location
    storageAccountResourceId: resourceId(
      subscription().subscriptionId,
      resourceGroupName,
      'Microsoft.Storage/storageAccounts',
      deploymentScriptStorageAccountName
    )
    subnetResourceIds: [
      resourceId(
        subscription().subscriptionId,
        resourceGroupName,
        'Microsoft.Network/virtualNetworks/subnets',
        virtualNetworkName,
        deploymentScriptSubnetName
      )
    ]
    enableTelemetry: enableTelemetry
  }
  dependsOn: [
    imageTemplate_trigger
    // rg
    vnet
    dsStorageAccount
    // dsMsi
  ]
}

// ============================= //
//   END: ALL                    //
//   END: ONLY ASSETS  & IMAGE   //
//   END: ONLY IMAGE             //
///////////////////////////////////

// =============== //
//   Definitions   //
// =============== //
@export()
@description('The type for specifying the storage account files to upload.')
type storageAccountFilesToUploadType = {
  @description('Required. The name of the environment variable.')
  name: string

  @description('Optional. The value of the secure environment variable.')
  @secure()
  secureValue: string?

  @description('Optional. The value of the environment variable.')
  value: string?
}
