// ============== //
//   Parameters   //
// ============== //

@description('Required. The name of the Key Vault to set the ecrets in.')
param keyVaultName string

@description('Required. The secrets to set in the Key Vault.')
param secretsToSet secretToSetType[]

// ============= //
//   Resources   //
// ============= //

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

// =========== //
//   Outputs   //
// =========== //

@description('The references to the secrets exported to the provided Key Vault.')
output secretsSet secretSetType[] = [
  #disable-next-line outputs-should-not-contain-secrets // Only returning the references, not a secret value
  for index in range(0, length(secretsToSet ?? [])): {
    secretResourceId: secrets[index].id
    secretUri: secrets[index].properties.secretUri
  }
]

// =============== //
//   Definitions   //
// =============== //

@export()
type secretSetType = {
  @description('The resourceId of the exported secret.')
  secretResourceId: string

  @description('The secret URI of the exported secret.')
  secretUri: string
}

type secretToSetType = {
  @description('Required. The name of the secret to set.')
  name: string

  @description('Required. The value of the secret to set.')
  @secure()
  value: string
}
