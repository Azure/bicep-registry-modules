@description('Specifies the name of the key vault.')
param keyVaultName string

@description('List of secrets to create in the Key Vault [ { secretName: string, secretValue: string }]')
param secrets array = []

resource vault 'Microsoft.KeyVault/vaults@2022-11-01' existing = {
  name: keyVaultName
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = [for secret in secrets: {
  parent: vault
  name: secret.secretName
  properties: {
    value: secret.secretValue
  }
}]
