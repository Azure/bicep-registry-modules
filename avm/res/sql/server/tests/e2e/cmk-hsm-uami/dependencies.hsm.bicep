// @description('Required. The name of the key to create in the HSM.')
// param hSMKeyNameList string[]

// @description('Required. The name of the key to create in the HSM.')
// param hsmKeySize int = 4096

param hsmKeys object

@description('Required. The name of the managed HSM used for encryption.')
@secure()
param managedHSMName string

resource managedHsm 'Microsoft.KeyVault/managedHSMs@2025-05-01' existing = {
  name: managedHSMName

  resource keys 'keys@2025-05-01' = [
    for item in items(hsmKeys): {
      name: item.value.name
      properties: {
        keySize: item.value.size
        kty: 'RSA-HSM'
      }
    }
  ]
}

@description('The resource ID of the HSM Key Vault.')
output keyVaultResourceId string = managedHsm.id

@description('The key details of the HSM Key Vault Key.')
output keyDetails object = toObject(managedHsm::keys, item => item.name, item => {
  name: item.name
  version: last(split(item.properties.keyUriWithVersion, '/'))
})

@description('The name of the HSMKey Vault Encryption Key.')
output keyName string = hsmKeys.srv.name

// @description('The version of the HSMKey Vault Encryption Key.')
// output keyVersion string = last(split(managedHsm::key.properties.keyUriWithVersion, '/'))
