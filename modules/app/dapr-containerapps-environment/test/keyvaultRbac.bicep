param keyVaultName string
param servicePrincipalId string

var keyVaultSecretsUserRole = resourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')

resource kv 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyVaultName
}

resource rbacSecretUser 'Microsoft.Authorization/roleAssignments@2022-04-01' =  {
  scope: kv
  name: guid(kv.id, servicePrincipalId, keyVaultSecretsUserRole)
  properties: {
    roleDefinitionId: keyVaultSecretsUserRole
    principalType: 'ServicePrincipal'
    principalId: servicePrincipalId
  }
}
