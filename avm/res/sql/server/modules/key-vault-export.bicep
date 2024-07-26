@description('Required. The name of the key vault to set the secrets in.')
param keyVaultName string

@description('Required. The secrets to set in the key vault.')
param secrets secretsType[]

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = [
  for secret in secrets: {
    name: secret.name
    parent: keyVault
    properties: {
      value: secret.value
    }
  }
]

output secretResourceIds string[] = [
#disable-next-line outputs-should-not-contain-secrets // Only returning the resource ID, not a secret value
  for index in range(0, length(secrets ?? [])): secret[index].id
]

type secretsType = {
  @description('Required. The name of the secret to set.')
  name: string

  @description('Required. The value of the secret to set.')
  @secure()
  value: string
}
