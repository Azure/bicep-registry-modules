param location string

// Force creation of new resources using utcNow() to test race condition, running the deployment twice will not reproduce this bug
param storageAccountName string = 'sa${uniqueString(resourceGroup().id, location, utcNow())}'

module keyVault 'br/public:security/keyvault:1.0.1' = {
  name: 'myKeyVault'
  params: {
    location: location
  }
}

module storageAccount 'br/public:storage/storage-account:0.0.1' = {
  name: 'mystorageaccount'
  params: {
    location: location
    name: storageAccountName
  }
}

@minLength(3)
@maxLength(24)
output name string = keyVault.outputs.name

output storageAccountName string = storageAccountName
