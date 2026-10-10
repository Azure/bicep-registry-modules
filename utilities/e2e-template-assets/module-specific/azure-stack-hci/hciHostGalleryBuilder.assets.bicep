@description('Required. Location for the image resources.')
param location string

@description('Required. Name of the Azure Compute Gallery.')
param galleryName string

@description('Required. Name of the gallery image definition.')
param imageDefinitionName string

@description('Required. Name of the image-builder user-assigned managed identity.')
param imageBuilderIdentityName string

@description('Optional. Tags applied to image resources.')
param tags object = {}

resource gallery 'Microsoft.Compute/galleries@2025-03-03' = {
  name: galleryName
  location: location
  tags: tags
  properties: {
    description: 'Persistent Azure Stack HCI host images for AVM validation.'
  }
}

resource imageDefinition 'Microsoft.Compute/galleries/images@2025-03-03' = {
  parent: gallery
  name: imageDefinitionName
  location: location
  tags: tags
  properties: {
    architecture: 'x64'
    identifier: {
      publisher: 'AVM'
      offer: 'azure-stack-hci-host'
      sku: 'hci-host'
    }
    hyperVGeneration: 'V2'
    osState: 'Generalized'
    osType: 'Windows'
  }
}

resource imageBuilderIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: imageBuilderIdentityName
  location: location
  tags: tags
}

@description('The resource ID of the Azure Compute Gallery.')
output galleryResourceId string = gallery.id

@description('The resource ID of the gallery image definition.')
output imageDefinitionResourceId string = imageDefinition.id

@description('The resource ID of the image-builder user-assigned managed identity.')
output imageBuilderIdentityResourceId string = imageBuilderIdentity.id

@description('The principal ID of the image-builder user-assigned managed identity.')
output imageBuilderPrincipalId string = imageBuilderIdentity.properties.principalId
