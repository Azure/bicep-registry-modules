@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

//@description('Required. The name of the KeyVault to create.')
//param keyVaultName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

//resource keyVault 'Microsoft.KeyVault/vaults@2024-11-01' = {
//  name: keyVaultName
//  location: location
//  properties: {
//    sku: {
//      family: 'A'
//      name: 'standard'
//    }
//    tenantId: tenant().tenantId
//    enablePurgeProtection: true // Required for encryption to work
//    softDeleteRetentionInDays: 7
//    enabledForTemplateDeployment: true
//    enabledForDiskEncryption: true
//    enabledForDeployment: true
//    enableRbacAuthorization: true
//    accessPolicies: []
//  }
//
//  resource key 'keys@2024-11-01' = {
//    name: 'keyEncryptionKey'
//    properties: {
//      kty: 'RSA'
//    }
//  }
//}
//
//resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//  name: guid('msi-${keyVault::key.id}-${location}-${managedIdentity.id}-Key-Reader-RoleAssignment')
//  scope: keyVault::key
//  properties: {
//    principalId: managedIdentity.properties.principalId
//    // Key Vault Crypto User
//    roleDefinitionId: subscriptionResourceId(
//      'Microsoft.Authorization/roleDefinitions',
//      '12338af0-0e69-4776-bea7-57ae8d297424'
//    )
//    principalType: 'ServicePrincipal'
//  }
//}

// @description('The name of the created Key Vault encryption key.')
// output keyVaultKeyName string = keyVault::key.name
//
// @description('The resource ID of the created Key Vault.')
// output keyVaultResourceId string = keyVault.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id
