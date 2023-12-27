@description('Required. A boolean to specify whether or not the used Key Vault has RBAC authentication enabled or not.')
param rbacAuthorizationEnabled bool = true

@description('Required. The resourceID of the User Assigned Identity to assign permissions to.')
param userAssignedIdentityResourceId string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@description('Required. Resource ID of the KeyVault containing the key or secret.')
param keyVaultResourceId string

@description('Required. Key URL (with version) pointing to a key or secret in KeyVault.')
param keyName string

resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: last(split(keyVaultResourceId, '/'))!

  resource key 'keys@2021-10-01' existing = {
    name: keyName
  }
}

module userAssignedIdentity 'nested_managedIdentityReference.bicep' = {
  name: '${uniqueString(deployment().name, location)}-MSI-Reference'
  params: {
    userAssignedIdentityName: last(split(userAssignedIdentityResourceId, '/'))!
  }
  scope: resourceGroup(split(userAssignedIdentityResourceId, '/')[2], split(userAssignedIdentityResourceId, '/')[4])
}

// =============== //
// Role Assignment //
// =============== //

resource keyVaultKeyRBAC 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (rbacAuthorizationEnabled == true) {
  name: guid('msi-${keyVault::key.id}-${location}-${userAssignedIdentityResourceId}-Key-Reader-RoleAssignment')
  scope: keyVault::key
  properties: {
    principalId: userAssignedIdentity.outputs.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '12338af0-0e69-4776-bea7-57ae8d297424') // Key Vault Crypto User
    principalType: 'ServicePrincipal'
  }
}

// ============= //
// Access Policy //
// ============= //

module keyVaultAccessPolicies '../../../key-vault/vault/access-policy/main.bicep' = if (rbacAuthorizationEnabled != true) {
  name: '${uniqueString(deployment().name, location)}-DiskEncrSet-KVAccessPolicies'
  params: {
    keyVaultName: last(split(keyVaultResourceId, '/'))!
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: userAssignedIdentity.outputs.principalId
        permissions: {
          keys: [
            'get'
            'wrapKey'
            'unwrapKey'
          ]
        }
      }
    ]
  }
}
