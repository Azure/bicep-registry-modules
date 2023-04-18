@description('Specifies the name of the key vault.')
param keyVaultName string

param secretName string

@secure()
param secretValue string

resource vault 'Microsoft.KeyVault/vaults@2022-11-01' existing = {
  name: keyVaultName
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = {
  parent: vault
  name: secretName
  properties: {
    value: secretValue
  }
}

@description('Key Vault Id')
output id string = secret.id

@description('Key Vault Name')
output name string = secret.name

@description('Secret URI')
output secretUri string = secret.properties.secretUri

@description('Secret URI with version')
output secretUriWithVersion string = secret.properties.secretUriWithVersion
