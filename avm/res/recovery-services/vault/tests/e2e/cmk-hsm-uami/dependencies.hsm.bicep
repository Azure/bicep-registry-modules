@description('Required. The name of the key to create in the HSM.')
param hsmKeyName string

@description('Optional. The size of the key to create in the HSM.')
param hsmKeySize int = 4096

@description('Required. The name of the managed HSM used for encryption.')
@secure()
param managedHSMName string

resource managedHsm 'Microsoft.KeyVault/managedHSMs@2025-05-01' existing = {
  name: managedHSMName

  resource key 'keys@2025-05-01' = {
    name: hsmKeyName
    properties: {
      keySize: hsmKeySize
      kty: 'RSA-HSM'
    }
  }
}

@description('The resource ID of the HSM Key Vault.')
output keyVaultResourceId string = managedHsm.id

@description('The name of the HSMKey Vault Encryption Key.')
output keyName string = managedHsm::key.name

@description('The version of the HSMKey Vault Encryption Key.')
output keyVersion string = last(split(managedHsm::key.properties.keyUriWithVersion, '/'))
