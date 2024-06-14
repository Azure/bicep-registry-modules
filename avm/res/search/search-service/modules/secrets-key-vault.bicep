param keyVaultName string
param keySecrets keySecret[]

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource keySecretsSecrets 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = [
  for secret in keySecrets: {
    name: secret.secretName
    parent: kv
    properties: {
      value: secret.secretValue
    }
  }
]

type keySecret = {
  secretName: string

  @secure()
  secretValue: string
}
