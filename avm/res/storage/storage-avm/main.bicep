metadata name = 'Storage Account'
metadata description = 'This module deploys a Storage Account.'
metadata owner = 'Azure Verified Modules'

@description('Required. Name of the Storage Account.')
param name string

@description('Required. Location for the Storage Account.')
param location string = resourceGroup().location

@description('Optional. Storage Account SKU.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
])
param sku string = 'Standard_LRS'

@description('Optional. Storage Account kind.')
@allowed([
  'Storage'
  'StorageV2'
  'BlobStorage'
  'FileStorage'
  'BlockBlobStorage'
])
param kind string = 'StorageV2'

@description('Optional. Access tier for the Storage Account.')
@allowed([
  'Hot'
  'Cool'
])
param accessTier string = 'Hot'

@description('Optional. Enable HTTPS traffic only.')
param httpsOnly bool = true

@description('Optional. Tags for the Storage Account.')
param tags object = {}

@description('Optional. Enable public network access.')
param publicNetworkAccess string = 'Enabled'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  kind: kind
  properties: {
    accessTier: accessTier
    supportsHttpsTrafficOnly: httpsOnly
    publicNetworkAccess: publicNetworkAccess
  }
  tags: tags
}

@description('Storage Account resource ID.')
output resourceId string = storageAccount.id

@description('Storage Account name.')
output name string = storageAccount.name

@description('Primary blob endpoint.')
output primaryBlobEndpoint string = storageAccount.properties.primaryEndpoints.blob

@description('Storage Account location.')
output location string = storageAccount.location
