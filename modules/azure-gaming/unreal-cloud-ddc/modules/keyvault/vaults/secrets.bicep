@description('Specifies the name of the key vault.')
param keyVaultName string

@description('Specifies the name of the secret that you want to create.')
param names array

resource vault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyVaultName
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = [for name in names: {
  parent: vault
  name: name.secretName
  properties: {
    value: name.secretValue
  }
}]
