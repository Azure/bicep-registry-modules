@description('Specifies the name of the key vault.')
param keyVaultName string

@description('Specifies the name of the secret that you want to create.')
param secrets array

resource vault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyVaultName
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = [for secret in secrets: {
  parent: vault
  name: secret.secretName
  properties: {
    value: secret.secretValue
  }
}]
