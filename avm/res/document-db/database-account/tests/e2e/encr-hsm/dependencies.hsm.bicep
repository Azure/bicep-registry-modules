@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the HSM Vault to use.')
param managedHsmName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityResourceId string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = {
  name: last(split(managedIdentityResourceId, '/'))
  scope: resourceGroup(split(managedIdentityResourceId, '/')[2], split(managedIdentityResourceId, '/')[4])
}

resource managedHsm 'Microsoft.KeyVault/managedHSMs@2025-05-01' existing = {
  name: managedHsmName

  resource key 'keys@2025-05-01' existing = {
    name: 'rsa-hsm-4096-key-1'
  }
}

// https://mhsm-perm-avm-core-001.managedhsm.azure.net/keys/rsa-hsm-4096-key-1/providers/Microsoft.Authorization/roleAssignments/0cdd0d7f-585f-4dd2-85f1-130c6e6fc820?api-version=7.6
// {
//   properties: {
//     roleDefinitionId: 'Microsoft.KeyVault/providers/Microsoft.Authorization/roleDefinitions/21dbd100-6940-42c2-9190-5d6cb909625b'
//     principalId: '89be5ce4-5546-47bb-ab81-006425375abf'
//   }
// }
resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${managedHsm::key.id}-${location}-${managedIdentity.id}-Key-Reader-RoleAssignment')
  scope: managedHsm::key
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: 'Microsoft.KeyVault/providers/Microsoft.Authorization/roleDefinitions/0cdd0d7f-585f-4dd2-85f1-130c6e6fc820' // Managed HSM Crypto User
    // roleDefinitionId: subscriptionResourceId(
    //   'Microsoft.Authorization/roleDefinitions',
    //   '33413926-3206-4cdd-b39a-83574fe37a17'
    // ) // Managed HSM Crypto Service Encryption User
    principalType: 'ServicePrincipal'
  }
}

@description('The resource ID of the HSM Key Vault.')
output keyVaultResourceId string = managedHsm.id

@description('The name of the HSMKey Vault Encryption Key.')
output keyVaultEncryptionKeyName string = managedHsm::key.name
