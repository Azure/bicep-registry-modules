param location string = resourceGroup().location

@minLength(3)
@maxLength(24)
param keyVaultName string
param storageAccountName string

resource existingStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName
}

module keyVault '../main.bicep' = {
  name: 'myKeyVault'
  params: {
    location: location
    name: keyVaultName
    secretName: 'storage-secret'
    secretValue: existingStorageAccount.listKeys().keys[0].value
  }
}
