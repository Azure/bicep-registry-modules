@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Managed Identity for the database to create.')
param databaseIdentityName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource dbManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: databaseIdentityName
  location: location
}

resource keyVault 'Microsoft.KeyVault/vaults@2024-11-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enablePurgeProtection: true // Required for encryption to work
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enableRbacAuthorization: true
    accessPolicies: []
  }

  resource key 'keys@2024-11-01' = {
    name: 'keyServerEncryptionKey'
    properties: {
      kty: 'RSA'
    }
  }

  resource dbKey 'keys@2024-11-01' = {
    name: 'keyDatabaseEncryptionKey'
    properties: {
      kty: 'RSA'
    }
  }
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${keyVault::key.id}-${location}-${managedIdentity.id}-Key-Vault-Crypto-Service-Encryption-User-RoleAssignment')
  scope: keyVault::key
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'e147488a-f6f5-4113-8e2d-b22465e65bf6'
    ) // Key Vault Crypto Service Encryption User
    principalType: 'ServicePrincipal'
  }
}

resource dbKeyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${keyVault::dbKey.id}-${location}-${dbManagedIdentity.id}-Key-Vault-Crypto-Service-Encryption-User-RoleAssignment')
  scope: keyVault::dbKey
  properties: {
    principalId: dbManagedIdentity.properties.principalId
    // Key Vault Crypto Service Encryption User
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'e147488a-f6f5-4113-8e2d-b22465e65bf6'
    )
    principalType: 'ServicePrincipal'
  }
}

@description('The principal ID of the created managed identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created managed identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The principal ID of the created database managed identity.')
output databaseIdentityPrincipalId string = dbManagedIdentity.properties.principalId

@description('The resource ID of the created database managed identity.')
output databaseIdentityResourceId string = dbManagedIdentity.id

@description('The URL of the created Server Encryption Key.')
output keyVaultEncryptionKeyUrl string = keyVault::key.properties.keyUriWithVersion

@description('The URL of the created Database Encryption Key.')
output keyVaultDatabaseEncryptionKeyUrl string = keyVault::dbKey.properties.keyUriWithVersion

@description('The name of the created Server Encryption Key.')
output keyVaultKeyName string = keyVault::key.name

@description('The name of the created Database Encryption Key.')
output keyVaultDatabaseKeyName string = keyVault::dbKey.name

@description('The name of the created Key Vault.')
output keyVaultName string = keyVault.name

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id
