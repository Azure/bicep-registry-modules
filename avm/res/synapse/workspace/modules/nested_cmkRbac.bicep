param keyvaultName string
param workspaceIndentityPrincipalId string
param usesRbacAuthorization bool = false

// Workspace encryption - Assign Workspace System Identity Keyvault Crypto Reader at Encryption Keyvault
resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyvaultName
}

// Assign RBAC role Key Vault Crypto User
resource workspace_cmk_rbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (usesRbacAuthorization) {
  name: guid('${keyVault.id}-${workspaceIndentityPrincipalId}-Key-Vault-Crypto-User')
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '12338af0-0e69-4776-bea7-57ae8d297424'
    )
    principalId: workspaceIndentityPrincipalId
    principalType: 'ServicePrincipal'
  }
  scope: keyVault
}

// Assign Access Policy for Keys
resource workspace_cmk_accessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2023-07-01' = if (!usesRbacAuthorization) {
  name: 'add'
  parent: keyVault
  properties: {
    accessPolicies: [
      {
        permissions: {
          keys: [
            'wrapKey'
            'unwrapKey'
            'get'
          ]
        }
        objectId: workspaceIndentityPrincipalId
        tenantId: tenant().tenantId
      }
    ]
  }
}
