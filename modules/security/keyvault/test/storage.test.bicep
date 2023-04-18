param location string = resourceGroup().location

// Force creation of new resources using utcNow() to reproduce bug, running the deployment twice will not reproduce the bug
@minLength(3)
@maxLength(24)
param keyVaultName string = 'kv${uniqueString(resourceGroup().id, location, utcNow())}'
param storageAccountName string = 'sa${uniqueString(resourceGroup().id, location, utcNow())}'

module storageAccount 'br/public:storage/storage-account:0.0.1' = {
  name: 'mystorageaccount'
  params: {
    location: location
    name: storageAccountName
  }
}

module storageKeyVault '../main.bicep' = {
  name: 'myStorageKeyVault'
  dependsOn: [
    storageAccount
  ]
  params: {
    location: location
    name: keyVaultName
    secretName: 'storage-secret'
    storageAccountName: storageAccountName
  }
}
