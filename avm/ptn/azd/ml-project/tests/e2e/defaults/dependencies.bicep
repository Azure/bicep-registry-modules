@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the AI Studio Hub Resource to create.')
param hubName string

@description('Required. The name of the key vault to create.')
param keyVaultName string

@description('Required. The name of the storage account to create.')
param storageAccountName string

@description('Optional. Tags of the resource.')
@metadata({
  example: '''
  {
      "key1": "value1"
      "key2": "value2"
  }
  '''
})
param tags object?

module storageAccount 'br/public:avm/res/storage/storage-account:0.9.1' = {
  name: '${uniqueString(deployment().name, location)}-storage'
  params: {
    name: storageAccountName
    tags: tags
    location: location
  }
}

module keyvault 'br/public:avm/res/key-vault/vault:0.9.0' = {
  name: '${uniqueString(deployment().name, location)}-keyvault'
  params: {
    enablePurgeProtection: false
    location: location
    name: keyVaultName
  }
}

module hub 'br/public:avm/res/machine-learning-services/workspace:0.7.0' = {
  name: '${uniqueString(deployment().name, location)}-hub'
  params: {
    name: hubName
    tags: tags
    location: location
    sku: 'Basic'
    kind: 'Hub'
    associatedKeyVaultResourceId: keyvault.outputs.resourceId
    associatedStorageAccountResourceId: storageAccount.outputs.resourceId
  }
}

@description('The resource ID of the AI Studio Hub Resource.')
output hubResourceId string = hub.outputs.resourceId

@description('The name of the key vault.')
output keyVaultName string = keyvault.outputs.name

