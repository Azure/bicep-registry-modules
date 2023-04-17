param location string = resourceGroup().location
@minLength(3)
@maxLength(24)
param keyVaultName string = 'kv${uniqueString(resourceGroup().id, location)}'
param storageAccountName string = 'sa${uniqueString(resourceGroup().id, location)}'

module storageAccount 'br/public:storage/storage-account:0.0.1' = {
  name: 'mystorageaccount'
  params: {
    location: location
    name: storageAccountName
  }
}

resource existingStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName
}

module keyVault '../main.bicep' = {
  name: 'myKeyVault'
  dependsOn: [
    storageAccount
  ]
  params: {
    location: location
    name: keyVaultName
    secretName: 'storage-secret'
    secretValue: existingStorageAccount.listKeys().keys[0].value
  }
}
