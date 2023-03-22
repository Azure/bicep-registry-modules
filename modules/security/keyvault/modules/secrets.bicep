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
