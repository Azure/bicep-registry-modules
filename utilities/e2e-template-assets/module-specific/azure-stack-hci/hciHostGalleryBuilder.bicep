targetScope = 'subscription'

@description('Optional. Location for the resource group, gallery, image definition, and managed identity.')
param location string = 'southeastasia'

@description('Optional. Location for the image template and build VM. Use a new imageTemplateName when changing an existing template location.')
param buildLocation string = location

@minLength(1)
@description('Optional. Regions where the image version must be available. The image definition and build locations are always included.')
param replicationRegions string[] = [
  location
]

@description('Optional. Name of the resource group that contains the persistent HCI host image resources.')
param resourceGroupName string = 'rg-avm-persistent-hci-image'

@description('Optional. Create the resource group. Set to false when the caller manages it.')
param createResourceGroup bool = true

@description('Optional. Name of the Azure Compute Gallery.')
param galleryName string = 'galavmpersistenthci'

@description('Optional. Name of the gallery image definition.')
param imageDefinitionName string = 'hci-host-image'

@description('Optional. Deterministic gallery image version published by the image build.')
param imageVersion string = '26.1.0'

@description('Optional. Name of the user-assigned managed identity used by Azure VM Image Builder.')
param imageBuilderIdentityName string = 'id-avm-persistent-hci-image-builder'

@description('Optional. Name of the Azure VM Image Builder template. Use a new name when changing its build location.')
param imageTemplateName string = 'hci-host-image-builder'

@description('Optional. Base URI containing this asset and the authoritative HCI host scripts. Pin this URI to the same repository commit as this template.')
param assetBaseUri string = 'https://raw.githubusercontent.com/Azure/bicep-registry-modules/main/utilities/e2e-template-assets/module-specific/azure-stack-hci'

@description('Optional. Download URL for the Azure Stack HCI VHDX payload baked into the host image.')
param hciVhdxDownloadUri string = 'https://azlocalvhds.blob.${environment().suffixes.storage}/images/AzLocal2601.vhdx'

@description('Optional. Source marketplace image used by Azure VM Image Builder.')
param sourceImage object = {
  publisher: 'MicrosoftWindowsServer'
  offer: 'WindowsServer'
  sku: '2022-datacenter-azure-edition'
  version: 'latest'
}

@description('Optional. Azure VM size used for the image build.')
param buildVmSize string = 'Standard_D8s_v5'

@minValue(1)
@maxValue(960)
@description('Optional. Maximum image build duration in minutes.')
param buildTimeoutInMinutes int = 570

@description('Optional. Tags applied to image resources.')
param tags object = {}

var resourceGroupScope = resourceGroup(resourceGroupName)
var resourceGroupResourceId = subscriptionResourceId('Microsoft.Resources/resourceGroups', resourceGroupName)
var roleDefinitionName = guid(subscription().id, resourceGroupName, galleryName, 'hci-image-builder-publisher')

resource imageResourceGroup 'Microsoft.Resources/resourceGroups@2024-11-01' = if (createResourceGroup) {
  name: resourceGroupName
  location: location
  tags: tags
}

module imageAssets 'hciHostGalleryBuilder.assets.bicep' = {
  name: 'hci-host-image-assets'
  scope: resourceGroupScope
  params: {
    galleryName: galleryName
    imageBuilderIdentityName: imageBuilderIdentityName
    imageDefinitionName: imageDefinitionName
    location: location
    tags: tags
  }
  dependsOn: [
    imageResourceGroup
  ]
}

resource imageBuilderRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: roleDefinitionName
  properties: {
    roleName: 'AVM HCI Image Builder Publisher (${uniqueString(resourceGroupResourceId, galleryName)})'
    description: 'Publishes HCI host image versions to the designated Azure Compute Gallery.'
    type: 'CustomRole'
    assignableScopes: [
      resourceGroupResourceId
    ]
    permissions: [
      {
        actions: [
          'Microsoft.Compute/galleries/read'
          'Microsoft.Compute/galleries/images/read'
          'Microsoft.Compute/galleries/images/versions/read'
          'Microsoft.Compute/galleries/images/versions/write'
        ]
        notActions: []
        dataActions: []
        notDataActions: []
      }
    ]
  }
}

module imageBuilderRoleAssignment 'hciHostGalleryBuilder.rbac.bicep' = {
  name: 'hci-host-image-builder-rbac'
  scope: resourceGroupScope
  params: {
    principalId: imageAssets.outputs.imageBuilderPrincipalId
    roleDefinitionResourceId: imageBuilderRoleDefinition.id
  }
}

module imageTemplate 'hciHostGalleryBuilder.template.bicep' = {
  name: 'hci-host-image-template'
  scope: resourceGroupScope
  params: {
    assetBaseUri: assetBaseUri
    buildLocation: buildLocation
    buildTimeoutInMinutes: buildTimeoutInMinutes
    buildVmSize: buildVmSize
    galleryImageDefinitionResourceId: imageAssets.outputs.imageDefinitionResourceId
    hciVhdxDownloadUri: hciVhdxDownloadUri
    imageBuilderIdentityResourceId: imageAssets.outputs.imageBuilderIdentityResourceId
    imageTemplateName: imageTemplateName
    imageVersion: imageVersion
    location: location
    replicationRegions: replicationRegions
    sourceImage: sourceImage
    tags: tags
  }
  dependsOn: [
    imageBuilderRoleAssignment
  ]
}

@description('The resource group containing the persistent image resources.')
output resourceGroupName string = resourceGroupName

@description('The resource ID of the Azure Compute Gallery.')
output galleryResourceId string = imageAssets.outputs.galleryResourceId

@description('The resource ID of the gallery image definition.')
output imageDefinitionResourceId string = imageAssets.outputs.imageDefinitionResourceId

@description('The resource ID of the deterministic gallery image version.')
output imageVersionResourceId string = '${imageAssets.outputs.imageDefinitionResourceId}/versions/${imageVersion}'

@description('The resource ID of the image-builder user-assigned managed identity.')
output imageBuilderIdentityResourceId string = imageAssets.outputs.imageBuilderIdentityResourceId

@description('The resource ID of the Azure VM Image Builder template.')
output imageTemplateResourceId string = imageTemplate.outputs.imageTemplateResourceId

@description('The name of the Azure VM Image Builder template.')
output imageTemplateName string = imageTemplate.outputs.imageTemplateName
