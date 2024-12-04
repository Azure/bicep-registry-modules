@sys.description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@sys.description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@sys.description('Required. The name of the Key Vault to create.')
param keyVaultName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
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

  resource key 'keys@2022-07-01' = {
    name: 'keyEncryptionKey'
    properties: {
      kty: 'RSA'
    }
  }
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${keyVault::key.id}-${location}-${managedIdentity.id}-Key-Crypto-RoleAssignment')
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

@sys.description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@sys.description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@sys.description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@sys.description('The name of the Key Vault Encryption Key.')
output keyVaultEncryptionKeyName string = keyVault::key.name

@sys.description('The version of the Key Vault Encryption Key.')
output keyVaultEncryptionKeyVersion string = last(split(keyVault::key.properties.keyUriWithVersion, '/'))

@sys.description('The URL of the created Key Vault.')
output keyVaultUrl string = keyVault.properties.vaultUri

@sys.description('The URL of the created Key Vault Key with Version.')
output keyVaultKeyUrl string = keyVault::key.properties.keyUriWithVersion
