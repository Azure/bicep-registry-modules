metadata name = 'Dev Center DevBox Definition'
metadata description = 'This module deploys a Dev Center DevBox Definition.'

// ================ //
// Parameters       //
// ================ //

@description('Conditional. The name of the parent dev center. Required if the template is used in a standalone deployment.')
param devcenterName string

@description('Required. The name of the DevBox definition.')
@minLength(3)
@maxLength(63)
param name string

@description('Required. The Image ID, or Image version ID. When Image ID is provided, its latest version will be used. When using custom images from a compute gallery, Microsoft Dev Box supports only images that are compatible with Dev Box and use the security type Trusted Launch enabled. See "https://learn.microsoft.com/en-us/azure/dev-box/how-to-configure-azure-compute-gallery#compute-gallery-image-requirements" for more information about image requirements.')
param imageResourceId string

@description('Required. The SKU configuration for the dev box definition. See "https://learn.microsoft.com/en-us/rest/api/devcenter/administrator/skus/list-by-subscription?view=rest-devcenter-administrator-2024-02-01" for more information about SKUs.')
param sku skuType

@description('Optional. Settings for hibernation support.')
param hibernateSupport 'Enabled' | 'Disabled' = 'Disabled'

@description('Optional. Tags for the DevBox definition.')
param tags object?

@description('Optional. Location for the DevBox definition. Defaults to resource group location.')
param location string = resourceGroup().location

// ============== //
// Resources      //
// ============== //

resource devcenter 'Microsoft.DevCenter/devcenters@2025-02-01' existing = {
  name: devcenterName
}

resource devboxDefinition 'Microsoft.DevCenter/devcenters/devboxdefinitions@2025-02-01' = {
  parent: devcenter
  name: name
  location: location
  tags: tags
  properties: {
    imageReference: {
      id: imageResourceId
    }
    sku: sku
    hibernateSupport: hibernateSupport
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the resource group the DevBox Definition was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the DevBox Definition.')
output name string = devboxDefinition.name

@description('The resource ID of the DevBox Definition.')
output resourceId string = devboxDefinition.id

@description('The location the DevBox Definition was deployed into.')
output location string = devboxDefinition.location

// ================ //
// Definitions      //
// ================ //

@export()
@description('The type for the SKU configuration of the DevBox definition.')
type skuType = {
  @description('Optional. If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted.')
  capacity: int?

  @description('Optional. If the service has different generations of hardware, for the same SKU, then that can be captured here. For example, "general_i_v2".')
  family: string?

  @description('Required. The name of the SKU. E.g. P3. It is typically a letter+number code. E.g. "general_i_8c32gb256ssd_v2" or "general_i_8c32gb512ssd_v2". See "https://learn.microsoft.com/en-us/python/api/azure-developer-devcenter/azure.developer.devcenter.models.hardwareprofile" for more information about acceptable SKU names.')
  name: string

  @description('Optional. The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code.')
  size: string?
}
