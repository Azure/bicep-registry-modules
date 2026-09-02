// ============================================================================
// cross-scope-role-assignment.bicep
// Description: Reusable helper that creates a single role assignment scoped
//              to an existing AI Services resource. Used for cross-resource-
//              group RBAC where the AI Services lives in a different RG.
// ============================================================================

@description('The principal ID to assign the role to.')
param principalId string

@description('The resource ID of the role definition to assign.')
param roleDefinitionId string

@description('A unique name for the role assignment.')
param roleAssignmentName string

@description('The principal type of the identity being assigned.')
@allowed(['ServicePrincipal', 'User', 'Group'])
param principalType string = 'ServicePrincipal'

@description('The type of target resource to scope the role assignment to.')
@allowed(['AIServices', 'ContainerRegistry'])
param targetResourceType string = 'AIServices'

@description('Name of the target AI Foundry (Cognitive Services) account. Required when targetResourceType is AIServices.')
param aiFoundryName string = ''

@description('Name of the target Azure Container Registry. Required when targetResourceType is ContainerRegistry.')
param containerRegistryName string = ''

// Reference the existing target resource in this resource group
resource aiFoundryAccount 'Microsoft.CognitiveServices/accounts@2025-12-01' existing = if (targetResourceType == 'AIServices') {
  name: aiFoundryName
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2025-04-01' existing = if (targetResourceType == 'ContainerRegistry') {
  name: containerRegistryName
}

resource aiRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (targetResourceType == 'AIServices') {
  name: roleAssignmentName
  scope: aiFoundryAccount
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalId
    principalType: principalType
  }
}

resource acrRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (targetResourceType == 'ContainerRegistry') {
  name: roleAssignmentName
  scope: containerRegistry
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalId
    principalType: principalType
  }
}
