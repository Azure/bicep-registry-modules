targetScope = 'subscription'

@description('Required. The name of the Resource Group.')
param resourceGroupName string

@description('Required. The name of the Resource Group to deploy the Image Template resources into.')
param imageTemplateResourceGroupName string

// User Assigned Identity (MSI) Parameters
@description('Required. The name of the Managed Identity used by deployment scripts.')
param deploymentScriptManagedIdentityName string

@description('Required. The name of the Managed Identity used by the Azure Image Builder.')
param imageManagedIdentityName string

// Azure Compute Gallery Parameters
@description('Required. The name of the Azure Compute Gallery.')
param computeGalleryName string

// Storage Account Parameters
@description('Required. The name of the storage account. Only needed if you want to upload scripts to be used during image baking.')
param assetsStorageAccountName string

@description('Required. The name of the storage account.')
param deploymentScriptStorageAccountName string

// Virtual Network Parameters
@description('Required. The name of the Virtual Network.')
param virtualNetworkName string

// Shared Parameters
@description('Optional. The location to deploy into.')
param location string = deployment().location

var addressPrefix = '10.0.0.0/16'

// The Image Definitions in the Azure Compute Gallery
var computeGalleryImageDefinitionsVar = [
  {
    hyperVGeneration: 'V2'
    name: 'sid-linux'
    osType: 'Linux'
    publisher: 'devops'
    offer: 'devops_linux'
    sku: 'devops_linux_az'
  }
]
var assetsStorageAccountContainerName = 'aibscripts'

// Role required for deployment script to be able to use a storage account via private networking
resource storageFileDataPrivilegedContributorRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '69566ab7-960f-475b-8e7c-b3118f30c6bd' // Storage File Data Priveleged Contributor
  scope: tenant()
}
resource contributorRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor
  scope: tenant()
}

// Resource Groups
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
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
module dsMsi 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.2' = {
  name: '${deployment().name}-ds-msi'
  scope: rg
  params: {
    name: deploymentScriptManagedIdentityName
    location: location
  }
}

module imageMSI 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.2' = {
  name: '${deployment().name}-image-msi'
  scope: rg
  params: {
    name: imageManagedIdentityName
    location: location
  }
}

// MSI Subscription contributor assignment
resource imageMSI_rbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().subscriptionId, imageManagedIdentityName, contributorRole.id)
  properties: {
    principalId: imageMSI.outputs.principalId
    roleDefinitionId: contributorRole.id
    principalType: 'ServicePrincipal'
  }
}

// Azure Compute Gallery
module azureComputeGallery 'br/public:avm/res/compute/gallery:0.4.0' = {
  name: '${deployment().name}-acg'
  scope: rg
  params: {
    name: computeGalleryName
    images: computeGalleryImageDefinitionsVar
    location: location
  }
}

// Image Template Virtual Network
module vnet 'br/public:avm/res/network/virtual-network:0.1.6' = {
  name: '${deployment().name}-vnet'
  scope: rg
  params: {
    name: virtualNetworkName
    addressPrefixes: [
      addressPrefix
    ]
    subnets: [
      {
        name: 'subnet-it'
        addressPrefix: cidrSubnet(addressPrefix, 24, 0)
        privateLinkServiceNetworkPolicies: 'Disabled' // Required if using Azure Image Builder with existing VNET
        serviceEndpoints: [
          {
            service: 'Microsoft.Storage'
          }
        ]
      }
      {
        name: 'subnet-ds'
        addressPrefix: cidrSubnet(addressPrefix, 24, 1)
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
module assetsStorageAccount 'br/public:avm/res/storage/storage-account:0.9.1' = {
  name: '${deployment().name}-files-sa'
  scope: rg
  params: {
    name: assetsStorageAccountName
    allowSharedKeyAccess: false // Keys not needed if MSI is granted access
    location: location
    networkAcls: {
      defaultAction: 'Allow'
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
              principalId: dsMsi.outputs.principalId
              principalType: 'ServicePrincipal'
            }
            {
              // Allow image MSI to access storage account container to read files - DO NOT REMOVE
              roleDefinitionIdOrName: 'Storage Blob Data Reader'
              principalId: imageMSI.outputs.principalId
              principalType: 'ServicePrincipal'
            }
          ]
        }
      ]
    }
  }
}

// Deployment scripts & their storage account
module dsStorageAccount 'br/public:avm/res/storage/storage-account:0.9.1' = {
  name: '${deployment().name}-ds-sa'
  scope: rg
  params: {
    name: deploymentScriptStorageAccountName
    allowSharedKeyAccess: true // May not be disabled to allow deployment script to access storage account files
    roleAssignments: [
      {
        // Allow MSI to leverage the storage account for private networking of container instance
        // ref: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-bicep#access-private-virtual-network
        roleDefinitionIdOrName: storageFileDataPrivilegedContributorRole.id // Storage File Data Priveleged Contributor
        principalId: dsMsi.outputs.principalId
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
          id: vnet.outputs.subnetResourceIds[1] // subnet-ds
        }
      ]
    }
  }
}

@description('The image definitions used in the Azure Compute Gallery.')
output computeGalleryImageDefinitions array = computeGalleryImageDefinitionsVar

@description('The name of the created Resource Group.')
output resourceGroupName string = rg.name

@description('The name of the created Azure Compute Gallery')
output computeGalleryName string = azureComputeGallery.outputs.name

@description('The name of the created Virtual Network')
output virtualNetworkName string = vnet.outputs.name

@description('The name of the Storage Account Container hosting the customization files used by the Azure Image Builder.')
output assetsStorageAccountContainerName string = assetsStorageAccountContainerName

@description('The name of the create Storage Account hosting the customization files used by the Azure Image Builder.')
output assetsStorageAccountName string = assetsStorageAccount.outputs.name

@description('The name of the User-Assigned-Identity used by the Deployment Scripts.')
output deploymentScriptManagedIdentityName string = dsMsi.outputs.name

@description('The name of the Storage Account used by the Deployment Scripts.')
output deploymentScriptStorageAccountName string = dsStorageAccount.outputs.name

@description('The name of the subnet used by the Azure Image Builder.')
output imageSubnetName string = last(split(vnet.outputs.subnetResourceIds[0], '/'))

@description('The name of the subnet used by the Deployment Scripts.')
output deploymentScriptSubnetName string = last(split(vnet.outputs.subnetResourceIds[1], '/'))

@description('The name of the User-Assigned-Identity used by the Azure Image Builder.')
output imageManagedIdentityName string = imageMSI.outputs.name

@description('The name of the Resource Group used by the Azure Image Builder.')
output imageTemplateResourceGroupName string = imageTemplateRg.outputs.name
