metadata name = 'Container Registry Module'
// AVM-compliant Azure Container Registry deployment

@description('The name of the Azure Container Registry')
param acrName string

@description('The location of the Azure Container Registry')
param location string

@description('SKU for the Azure Container Registry')
param acrSku string = 'Basic'

@description('Public network access setting for the Azure Container Registry')
param publicNetworkAccess string = 'Enabled'

@description('Zone redundancy setting for the Azure Container Registry')
param zoneRedundancy string = 'Disabled'

@description('Tags to be applied to the Container Registry')
param tags object = {}

module avmContainerRegistry 'br/public:avm/res/container-registry/registry:0.9.1' = {
  name: acrName
  params: {
    name: acrName
    location: location
    acrSku: acrSku
    publicNetworkAccess: publicNetworkAccess
    zoneRedundancy: zoneRedundancy
    tags: tags
  }
}

output resourceId string = avmContainerRegistry.outputs.resourceId
