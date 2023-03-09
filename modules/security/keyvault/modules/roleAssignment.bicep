param keyVaultName string
param rbacPolicies array
param rbacRole string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource rbac_certs_reader 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [for rbacPolicy in rbacPolicies: {
  name: guid(rbacRole, rbacPolicy.objectId)
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', rbacRole)
    principalId: rbacPolicy.objectId
    principalType: 'ServicePrincipal'
  }
}]
