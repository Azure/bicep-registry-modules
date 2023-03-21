@description('Specifies the name of the key vault.')
param keyVaultName string

@description('Specifies the name of the secret that you want to create.')
param secrets array

resource vault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = [for secret in secrets: {
  parent: vault
  name: secret.secretName
  properties: {
    value: secret.secretValue
  }
}]
