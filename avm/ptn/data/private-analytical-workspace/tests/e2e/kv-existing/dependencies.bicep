@description('Optional. The location to deploy to.')
param location string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableSoftDelete: false
    enableRbacAuthorization: true
    enablePurgeProtection: null
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    sku: {
      family: 'A'
      name: 'standard'
    }
    softDeleteRetentionInDays: 7
    tenantId: subscription().tenantId
  }
}

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id
