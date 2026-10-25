@description('Required. Principal ID of the image-builder user-assigned managed identity.')
param principalId string

@description('Required. Resource ID of the image-builder custom role definition.')
param roleDefinitionResourceId string

resource imageBuilderRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, principalId, roleDefinitionResourceId)
  properties: {
    principalId: principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: roleDefinitionResourceId
  }
}

@description('The resource ID of the image-builder role assignment.')
output roleAssignmentResourceId string = imageBuilderRoleAssignment.id
