@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

// resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
//   name: keyVaultName
//   location: location
//   properties: {
//     sku: {
//       family: 'A'
//       name: 'standard'
//     }
//     tenantId: tenant().tenantId
//     enablePurgeProtection: true // Required for encryption to work
//     softDeleteRetentionInDays: 7
//     enabledForTemplateDeployment: true
//     enabledForDiskEncryption: true
//     enabledForDeployment: true
//     enableRbacAuthorization: true
//     accessPolicies: []
//   }

//   resource key 'keys@2022-07-01' = {
//     name: 'keyEncryptionKey'
//     properties: {
//       kty: 'RSA'
//     }
//   }
// }

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: 'dep-avma-kv-dpbvcmk-ou5'
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  // name: guid('msi-${keyVault::key.id}-${location}-${managedIdentity.id}-Key-Reader-RoleAssignment')
  // scope: keyVault::key
  name: guid('msi-${keyVault.id}-${location}-${managedIdentity.id}-Key-Crypto-RoleAssignment')
  scope: keyVault
  properties: {
    principalId: managedIdentity.properties.principalId
    // roleDefinitionId: subscriptionResourceId(
    //   'Microsoft.Authorization/roleDefinitions',
    //   '12338af0-0e69-4776-bea7-57ae8d297424'
    // ) // Key Vault Crypto User
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'e147488a-f6f5-4113-8e2d-b22465e65bf6'
    ) // Key Vault Crypto Service Encryption User
    principalType: 'ServicePrincipal'
  }
}

// @description('The resource ID of the created Key Vault.')
// output keyVaultResourceId string = keyVault.id

// @description('The name of the Key Vault Encryption Key.')
// output keyVaultEncryptionKeyName string = keyVault::key.name

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = '/subscriptions/cfa4dc0b-3d25-4e58-a70a-7085359080c5/resourceGroups/dep-avma-dataprotection.backupvaults-dpbvcmk-rg/providers/Microsoft.KeyVault/vaults/dep-avma-kv-dpbvcmk-ou5'

@description('The name of the Key Vault Encryption Key.')
output keyVaultEncryptionKeyName string = 'keyEncryptionKey'

// @description('The resource ID of the created Managed Identity.')
// output managedIdentityResourceId string = '/subscriptions/cfa4dc0b-3d25-4e58-a70a-7085359080c5/resourcegroups/dep-avma-dataprotection.backupvaults-dpbvcmk-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/dep-avma-msi-dpbvcmk'
