param location string = resourceGroup().location

@minLength(3)
@maxLength(24)
param keyVaultName string
param storageAccountName string = ''
param cosmosDBName string = ''

resource existingStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = if (storageAccountName != '') {
  name: storageAccountName
}

// module storageKeyVault '../main.bicep' = if (storageAccountName != ''){
//   name: 'myStorageKeyVault'
//   params: {
//     location: location
//     name: keyVaultName
//     secretName: 'storage-secret'
//     secretValue: existingStorageAccount.listKeys().keys[0].value
//   }
// }

resource existingCosmosDB 'Microsoft.Storage/storageAccounts@2022-09-01' existing = if (cosmosDBName != '') {
  name: cosmosDBName
}

// module cosmosKeyVault '../main.bicep' = if (storageAccountName != ''){
//   name: 'myCosmosKeyVault'
//   params: {
//     location: location
//     name: keyVaultName
//     secretName: 'cosmos-secret'
//     secretValue: existingCosmosDB.listKeys().keys[0].value
//   }
// }

var secretValue = storageAccountName != '' ? existingStorageAccount.listKeys().keys[0].value : cosmosDBName != '' ? existingCosmosDB.listKeys().keys[0].value : ''

module keyVault '../main.bicep' = {
  name: 'myKeyVault'
  params: {
    location: location
    name: keyVaultName
    secretName: 'secret'
    secretValue: secretValue
  }
}
