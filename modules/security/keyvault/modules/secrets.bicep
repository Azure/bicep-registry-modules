@description('Specifies the name of the key vault.')
param keyVaultName string

param storageAccountName string = ''
param cosmosDBName string = ''
param secretName string

@secure()
param secretValue string = ''

resource vault 'Microsoft.KeyVault/vaults@2022-11-01' existing = {
  name: keyVaultName
}

/***********************************************************************************************************************
                                            Add a provided secret to the key vault.
***********************************************************************************************************************/

var hasSecret = secretValue != ''

resource secret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = if (hasSecret)  {
  parent: vault
  name: secretName
  properties: {
    value: secretValue
  }
}

@description('Key Vault Name')
output name string = secretName

@description('Key Vault Id')
output id string = hasSecret ? secret.id : ''

@description('Secret URI')
output secretUri string = hasSecret ? secret.properties.secretUri : ''

@description('Secret URI with version')
output secretUriWithVersion string = hasSecret ? secret.properties.secretUriWithVersion : ''

/***********************************************************************************************************************
                                            Add a Storage Account key to the key vault.
***********************************************************************************************************************/

resource existingStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = if (storageAccountName != '') {
  name: storageAccountName
}

resource storageSecret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = if (storageAccountName != '') {
  parent: vault
  name: secretName
  properties: {
    value: existingStorageAccount.listKeys().keys[0].value
  }
}

@description('Storage Secret URI')
output storageSecretUri string = storageAccountName != '' ? storageSecret.properties.secretUri : ''

@description('Storage Secret URI with version')
output storageSecretUriWithVersion string = storageAccountName != '' ? storageSecret.properties.secretUriWithVersion : ''

/***********************************************************************************************************************
                                            Add a Cosmos DB key to the key vault.
***********************************************************************************************************************/

resource existingCosmosDB 'Microsoft.Storage/storageAccounts@2022-09-01' existing = if (cosmosDBName != '') {
  name: cosmosDBName
}

resource cosmosSecret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = if (cosmosDBName != '') {
  parent: vault
  name: secretName
  properties: {
    value: existingCosmosDB.listKeys().keys[0].value
  }
}

@description('Cosmos Secret URI')
output cosmosSecretUri string = cosmosDBName != '' ? cosmosSecret.properties.secretUri : ''

@description('Cosmos Secret URI with version')
output cosmosSecretUriWithVersion string = cosmosDBName != '' ? cosmosSecret.properties.secretUriWithVersion : ''
