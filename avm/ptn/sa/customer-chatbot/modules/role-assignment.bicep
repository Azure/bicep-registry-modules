@description('The principal ID to assign the role to.')
param principalId string

@description('The role definition ID to assign.')
param roleDefinitionId string

@description('Optional. The resource ID of the target resource for scoping the role assignment GUID.')
param targetResourceId string = resourceGroup().id

@description('Optional. A description of the role assignment.')
param roleDescription string = ''

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(principalId, roleDefinitionId, targetResourceId)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: principalId
    principalType: 'ServicePrincipal'
    description: !empty(roleDescription) ? roleDescription : null
  }
}

@description('The role assignment resource ID.')
output roleAssignmentId string = roleAssignment.id
