using './main.bicep'

@description('Name of the Storage Account')
param name = 'mystgaccount${uniqueString(resourceGroup().id)}'

@description('Location for the Storage Account')
param location = 'centralsweden'

@description('Storage Account SKU')
param sku = 'Standard_LRS'

@description('Storage Account kind')
param kind = 'StorageV2'

@description('Access tier')
param accessTier = 'Hot'

@description('HTTPS only')
param httpsOnly = true

@description('Public network access')
param publicNetworkAccess = 'Enabled'

@description('Tags for the resource')
param tags = {
  environment: 'test'
  owner: 'avm-team'
}
