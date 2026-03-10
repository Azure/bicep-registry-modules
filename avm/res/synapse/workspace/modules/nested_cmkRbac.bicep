@description('Required. The name of the key vault to assign permissions in/to.')
param keyVaultName string

@description('Required. The principal ID of the Synapse Workspace System Identity to assign permissions to.')
param workspaceIndentityPrincipalId string

@description('Required. Whether or not the referenced Key Vault uses RBAC authorization model.')
param usesRbacAuthorization bool = false

@description('Required. Name of the key to set the permissions for.')
param keyName string

// Workspace encryption - Assign Workspace System Identity Keyvault Crypto Reader at Encryption Keyvault
resource keyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = {
  name: keyVaultName

  resource key 'keys@2025-05-01' existing = {
    name: keyName
  }
}

// Assign RBAC role Key Vault Crypto User
resource workspace_cmk_rbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (usesRbacAuthorization) {
  name: guid('${keyVault.id}-${workspaceIndentityPrincipalId}-Key-Vault-Crypto-Service-Encryption-User')
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'e147488a-f6f5-4113-8e2d-b22465e65bf6'
    ) // Key Vault Crypto Service Encryption User
    principalId: workspaceIndentityPrincipalId
    principalType: 'ServicePrincipal'
  }
  scope: keyVault::key
}

// Assign Access Policy for Keys
resource workspace_cmk_accessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2024-11-01' = if (!usesRbacAuthorization) {
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
