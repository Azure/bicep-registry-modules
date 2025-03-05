// NOTE: This is a role assignment at RG level and requires Owner permissions at subscription level
// It is important to fine grain permissions
param managedIdentityResourceId string
param managedIdentityPrincipalId string

@description('This is the built-in owner role. See https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#owner')
resource resOwnerRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: resourceGroup()
  name: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635' //NOTE: Built-in role 'Owner'
}

// Assign Owner role to the managed identity in the resource group
resource resRoleAssignmentOwnerManagedIdResourceGroup 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, managedIdentityResourceId, resOwnerRoleDefinition.id)
  properties: {
    principalId: managedIdentityPrincipalId
    roleDefinitionId: resOwnerRoleDefinition.id
    principalType: 'ServicePrincipal'
  }
}
