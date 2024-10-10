@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the keyVault to create.')
param keyVaultName string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enableRbacAuthorization: true
  }
}

@description('The id of the Key Vault created.')
output keyVaultResourceId string = keyVault.id
