@description('Specifies the name of the key vault.')
param keyVaultName string

@description('Specifies the name of the secret that you want to create.')
param secretName string

@description('Specifies the value of the secret that you want to create.')
@secure()
param secretValue string

resource vault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: vault
  name: secretName
  properties: {
    value: secretValue
  }
}
