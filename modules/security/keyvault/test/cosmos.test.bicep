param location string = resourceGroup().location

// Force creation of new resources using utcNow() to reproduce bug, running the deployment twice will not reproduce the bug
@minLength(3)
@maxLength(24)
param keyVaultName string = 'coskv${uniqueString(resourceGroup().id, location, utcNow())}'
param name string = 'cos${uniqueString(resourceGroup().id, location, utcNow())}'

module cosmos 'br/public:storage/cosmos-db:1.0.1' = {
  name: 'mystorageaccount'
  params: {
    location: location
    name: name
  }
}

module storageKeyVault '../main.bicep' = {
  name: 'myStorageKeyVault'
  dependsOn: [
    cosmos
  ]
  params: {
    location: location
    name: keyVaultName
    secretName: 'storage-secret'
    cosmosDBName: name
  }
}

// module addKey 'nestedKeyVault.test.bicep' = {
//   name: 'addKeyToKeyVault'
//   dependsOn: [
//     cosmos
//   ]
//   params: {
//     location: location
//     keyVaultName: keyVaultName
//     cosmosDBName: name
//   }
// }
