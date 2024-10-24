@description('The resource ID of the Key Vault.')
param keyVaultResourceId string

@description('The principal ID of the managed identity.')
param principalId string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: last(split(keyVaultResourceId, '/'))
}

resource secretPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: keyVault
  name: guid('msi-${principalId}-KeyVault-Secret-User-RoleAssignment')
  properties: {
    principalId: principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '4633458b-17de-408a-b874-0445c86b69e6'
    ) // Key Vault Secrets User
    principalType: 'ServicePrincipal'
  }
}
