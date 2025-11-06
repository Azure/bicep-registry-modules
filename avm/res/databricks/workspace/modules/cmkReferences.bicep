@description('Optional. The resource ID of the key vault to fetch the key from.')
param keyVaultResourceId string

@description('Optional. The name of the key vault key.')
param keyName string

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = {
  name: last(split(keyVaultResourceId!, '/'))

  resource cMKKey 'keys@2024-11-01' existing = {
    name: keyName ?? 'dummyKey'
  }
}

@description('The URI of the Key Vault containing the Customer-Managed Key.')
output vaultUri string = cMKKeyVault.properties.vaultUri

@description('The URI of the Customer-Managed Key with version.')
output keyUriWithVersion string = cMKKeyVault::cMKKey.properties.keyUriWithVersion

@description('The version of the Customer-Managed Key.')
output keyVersion string = last(split(cMKKeyVault::cMKKey.properties.keyUriWithVersion, '/'))
