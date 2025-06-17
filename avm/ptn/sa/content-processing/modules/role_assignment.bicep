// All parameters are already basic types (string). No type imports or custom types present.

@description('Required. The resource ID of the managed identity to grant the Owner RBAC role.')
param managedIdentityResourceId string

@description('Required. The principal ID of the managed identity to grant the Owner RBAC role.')
param managedIdentityPrincipalId string

@description('Required. The role definition ID of the role to assign. If not provided, the Owner role will be assigned.')
param roleDefinitionId string

resource resRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, managedIdentityResourceId, roleDefinitionId)
  properties: {
    principalId: managedIdentityPrincipalId
    roleDefinitionId: roleDefinitionId
    principalType: 'ServicePrincipal'
  }
}
