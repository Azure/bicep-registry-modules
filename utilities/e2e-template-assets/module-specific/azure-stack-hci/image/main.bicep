targetScope = 'subscription'

@description('Location for the HCI host image resources.')
param location string = 'southeastasia'

@description('Resource group containing the HCI host image resources.')
param resourceGroupName string = 'rg-avm-persistent-hci-image'

@description('Azure Compute Gallery name.')
param galleryName string = 'galavmpersistenthci'

@description('Gallery image definition name.')
param imageDefinitionName string = 'hci-host-image'

@description('Azure VM Image Builder template name.')
param imageTemplateName string = 'it-avm-hci-host'

@description('User-assigned identity name used by Azure VM Image Builder.')
param imageBuilderIdentityName string = 'id-avm-hci-image-builder'

@description('Deterministic gallery image version produced by the template.')
param imageVersion string = '26.1.0'

@description('Windows Server source image version used by Azure VM Image Builder.')
param sourceImageVersion string = '20348.587.211009-1609'

@description('Azure Local VHDX copied into the HCI host image.')
#disable-next-line no-hardcoded-env-urls
param payloadUri string = 'https://azlocalvhds.blob.core.windows.net/images/AzLocal2601.vhdx'

@description('Tags applied to the image resources.')
param tags object = {}

resource imageResourceGroup 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

module image 'image.bicep' = {
  name: 'hci-host-image'
  scope: imageResourceGroup
  params: {
    location: location
    galleryName: galleryName
    imageDefinitionName: imageDefinitionName
    imageTemplateName: imageTemplateName
    imageBuilderIdentityName: imageBuilderIdentityName
    imageVersion: imageVersion
    sourceImageVersion: sourceImageVersion
    payloadUri: payloadUri
    tags: tags
  }
}

output resourceGroupName string = imageResourceGroup.name
output galleryId string = image.outputs.galleryId
output imageDefinitionId string = image.outputs.imageDefinitionId
output imageTemplateId string = image.outputs.imageTemplateId
output imageTemplateName string = imageTemplateName
output imageVersion string = imageVersion
output imageVersionResourceId string = image.outputs.imageVersionResourceId
