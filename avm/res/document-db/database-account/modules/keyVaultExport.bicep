@description('Required. The name of the Key Vault to set the ecrets in.')
param keyVaultName string

@description('Required. The secrets to set in the Key Vault.')
param secretsToSet secretsType[]

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource secrets 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = [
  for secret in secretsToSet: {
    name: secret.name
    parent: keyVault
    properties: {
      value: secret.value
    }
  }
]

output secretsSet outputType[] = [
  #disable-next-line outputs-should-not-contain-secrets // Only returning the resource ID, not a secret value
  for index in range(0, length(secretsToSet ?? [])): {
    secretResourceId: secrets[index].id
    secretUrl: secrets[index].properties.secretUri
  }
]

@export()
type outputType = {
  secretResourceId: string
  secretUrl: string
}

type secretsType = {
  @description('Required. The name of the secret to set.')
  name: string

  @description('Required. The value of the secret to set.')
  @secure()
  value: string
}
