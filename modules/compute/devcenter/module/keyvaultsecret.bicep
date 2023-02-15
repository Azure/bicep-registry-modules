param keyVaultName string
param secretName string

@secure()
param secretValue string

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource kvSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: secretName
  parent: kv
  properties: {
    value: secretValue
  }
}

output secretUri string =  kvSecret.properties.secretUri
