@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the geo backup Key Vault to create.')
param geoBackupKeyVaultName string

@description('Required. The name of the geo backup Managed Identity to create.')
param geoBackupManagedIdentityName string

@description('Required. The location to deploy geo backup resources to.')
param geoBackupLocation string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    softDeleteRetentionInDays: 90 // The resource provider requires a 90 day retention period for encryption. Anything less will cause the deployment to fail. Ref: https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-customer-managed-key#requirements-for-configuring-data-encryption-for-azure-database-for-mysql-flexible-server
    enablePurgeProtection: true // Required for encryption to work
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enableRbacAuthorization: true
    accessPolicies: []
  }

  resource key 'keys@2023-07-01' = {
    name: 'keyEncryptionKey'
    properties: {
      kty: 'RSA'
    }
  }
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${keyVault::key.id}-${location}-${managedIdentity.id}-Key-Reader-RoleAssignment')
  scope: keyVault::key
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '12338af0-0e69-4776-bea7-57ae8d297424'
    ) // Key Vault Crypto User
    principalType: 'ServicePrincipal'
  }
}

resource geoBackupManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: geoBackupManagedIdentityName
  location: geoBackupLocation
}

resource geoBackupKeyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: geoBackupKeyVaultName
  location: geoBackupLocation
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    softDeleteRetentionInDays: 90 // The resource provider requires a 90 day retention period for encryption. Anything less will cause the deployment to fail. Ref: https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-customer-managed-key#requirements-for-configuring-data-encryption-for-azure-database-for-mysql-flexible-server
    enablePurgeProtection: true // Required for encryption to work
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enableRbacAuthorization: true
    accessPolicies: []
  }

  resource key 'keys@2023-07-01' = {
    name: 'keyEncryptionKey'
    properties: {
      kty: 'RSA'
    }
  }
}

resource geoBackupKeyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${geoBackupKeyVault::key.id}-${geoBackupLocation}-${geoBackupManagedIdentity.id}-Key-Reader-RoleAssignment')
  scope: geoBackupKeyVault::key
  properties: {
    principalId: geoBackupManagedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '12338af0-0e69-4776-bea7-57ae8d297424'
    ) // Key Vault Crypto User
    principalType: 'ServicePrincipal'
  }
}

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The name of the created encryption key.')
output keyName string = keyVault::key.name

@description('The resource ID of the created geo backup Managed Identity.')
output geoBackupManagedIdentityResourceId string = geoBackupManagedIdentity.id

@description('The resource ID of the created geo backup Key Vault.')
output geoBackupKeyVaultResourceId string = geoBackupKeyVault.id

@description('The name of the created geo backup encryption key.')
output geoBackupKeyName string = geoBackupKeyVault::key.name
