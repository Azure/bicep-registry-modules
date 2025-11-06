@description('Optional. The resource ID of the key vault to fetch the key from.')
param keyVaultResourceId string

@description('Optional. The name of the key vault key.')
param keyName string

var isHSMManagedCMK = split(keyVaultResourceId ?? '', '/')[?7] == 'managedHSMs'
resource cMKKeyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = if (!isHSMManagedCMK) {
  name: last(split(keyVaultResourceId!, '/'))

  resource cMKKey 'keys@2024-11-01' existing = if (!isHSMManagedCMK) {
    name: keyName ?? 'dummyKey'
  }
}

@description('The URI of the Key Vault containing the Customer-Managed Key.')
output vaultUri string = !isHSMManagedCMK
  ? cMKKeyVault!.properties.vaultUri
  : 'https://${last(split(keyVaultResourceId, '/'))}.managedhsm.azure.net/'

@description('The URI of the Customer-Managed Key with version.')
output keyUriWithVersion string = !isHSMManagedCMK
  ? cMKKeyVault::cMKKey!.properties.keyUriWithVersion
  : fail('Managed HSM CMK encryption requires either specifying the \'keyVersion\' or omitting the \'autoRotationEnabled\' property. Setting \'autoRotationEnabled\' to false without a \'keyVersion\' is not allowed.')

@description('The version of the Customer-Managed Key.')
output keyVersion string = !isHSMManagedCMK
  ? last(split(cMKKeyVault::cMKKey!.properties.keyUriWithVersion, '/'))
  : fail('Managed HSM CMK encryption requires either specifying the \'keyVersion\' or omitting the \'autoRotationEnabled\' property. Setting \'autoRotationEnabled\' to false without a \'keyVersion\' is not allowed.')
