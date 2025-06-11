@description('Required. The name of the key vault.')
param keyVaultName string

@description('Required. The name of the secret in the key vault.')
param secretName string

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}
