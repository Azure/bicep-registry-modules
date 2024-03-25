metadata name = 'DocumentDB Database Account Key vault secrets'
metadata description = 'This module deploys a the connection strings and keys into a key vault specified by the consumer'
metadata owner = 'Azure/module-maintainers'

@description('Required. The key vault name where to store the keys and connection strings generated by the modules.')
param keyVaultName string

@description('Required. The name of the secret that will store the primary write key.')
param keySecrets keySecret[]

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource keySecretsSecrets 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = [for (secret, index) in keySecrets: {
  name: secret.secretName
  parent: kv
  properties: {
    value: secret.secretValue
  }
}]

type keySecret = {
  secretName: string
  secretValue: string
}

@description('The resource ID of the secrets created.')
output resourceId array = [for (secret, index) in keySecrets: {
  id: keySecretsSecrets[index].id
}]
