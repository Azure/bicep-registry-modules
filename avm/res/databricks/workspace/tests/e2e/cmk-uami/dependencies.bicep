@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The object ID of the Databricks Enterprise Application. Required for Customer-Managed-Keys.')
param databricksApplicationObjectId string

resource keyVault 'Microsoft.KeyVault/vaults@2025-05-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enablePurgeProtection: true // Required for encryption to work
    softDeleteRetentionInDays: 7
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enableRbacAuthorization: true
    accessPolicies: []
  }

  resource key 'keys@2025-05-01' = {
    name: 'keyEncryptionKey'
    properties: {
      kty: 'RSA'
    }
  }
  resource keyDisk 'keys@2025-05-01' = {
    name: 'keyEncryptionKeyDisk'
    properties: {
      kty: 'RSA'
    }
  }
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${keyVault::key.id}-${location}-${databricksApplicationObjectId}-Key-Key-Vault-Crypto-User-RoleAssignment')
  scope: keyVault::key
  properties: {
    principalId: databricksApplicationObjectId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '12338af0-0e69-4776-bea7-57ae8d297424'
    ) // Key Vault Crypto User
    principalType: 'ServicePrincipal'
  }
}

resource keyDiskPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${keyVault::keyDisk.id}-${location}-${databricksApplicationObjectId}-Key-Key-Vault-Crypto-User-RoleAssignment')
  scope: keyVault::keyDisk
  properties: {
    principalId: databricksApplicationObjectId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '12338af0-0e69-4776-bea7-57ae8d297424'
    ) // Key Vault Crypto User
    principalType: 'ServicePrincipal'
  }
}

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The name of the created Key Vault encryption key.')
output keyVaultKeyName string = keyVault::key.name

@description('The name of the created Key Vault Disk encryption key.')
output keyVaultDiskKeyName string = keyVault::keyDisk.name
