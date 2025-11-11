@description('Required. The resource ID of the key vault to fetch the key from.')
param keyVaultResourceId string

@description('Required. The name of the key vault key.')
param keyName string

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2025-05-01' existing = {
  name: last(split(keyVaultResourceId, '/'))

  resource cMKKey 'keys@2025-05-01' existing = {
    name: keyName
  }
}

@description('The URI of the Key Vault containing the Customer-Managed Key.')
output vaultUri string = cMKKeyVault.properties.vaultUri

@description('The URI of the Customer-Managed Key with version.')
output keyUriWithVersion string = cMKKeyVault::cMKKey.properties.keyUriWithVersion

@description('The version of the Customer-Managed Key.')
output keyVersion string = last(split(cMKKeyVault::cMKKey.properties.keyUriWithVersion, '/'))
