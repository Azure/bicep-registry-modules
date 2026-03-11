@description('Required. The name of the primary key to create in the HSM.')
param primaryHSMKeyName string

@description('Optional. The name of the secondary key to create in the HSM.')
param secondaryHSMKeyName string?

@description('Optional. The size of the key(s) to create in the HSM.')
param hsmKeySize int = 4096

@description('Required. The name of the managed HSM used for encryption.')
@secure()
param managedHSMName string

resource managedHsm 'Microsoft.KeyVault/managedHSMs@2025-05-01' existing = {
  name: managedHSMName

  resource primaryKey 'keys@2025-05-01' = {
    name: primaryHSMKeyName
    properties: {
      keySize: hsmKeySize
      kty: 'RSA-HSM'
    }
  }

  resource secondaryKey 'keys@2025-05-01' = if (!empty(secondaryHSMKeyName)) {
    name: secondaryHSMKeyName!
    properties: {
      keySize: hsmKeySize
      kty: 'RSA-HSM'
    }
  }
}

@description('The resource ID of the HSM Key Vault.')
output keyVaultResourceId string = managedHsm.id

@description('The name of the primary HSMKey Vault Encryption Key.')
output primaryKeyName string = managedHsm::primaryKey.name

@description('The version of the primary HSMKey Vault Encryption Key.')
output primaryKeyVersion string = last(split(managedHsm::primaryKey.properties.keyUriWithVersion, '/'))

@description('The name of the secondary HSMKey Vault Encryption Key.')
output secondaryKeyName string? = managedHsm::secondaryKey.?name

@description('The version of the secondary HSMKey Vault Encryption Key.')
output secondaryKeyVersion string? = last(split(managedHsm::secondaryKey.?properties.?keyUriWithVersion ?? '', '/'))
