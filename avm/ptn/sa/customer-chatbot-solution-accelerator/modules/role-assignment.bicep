// Parameters
param principalId string
param roleDefinitionId string
param targetResourceName string
param description string = 'Role assignment created by Bicep'

// Generate a unique name for the role assignment using known values at compile time
var uniqueName = guid(subscription().subscriptionId, resourceGroup().name, targetResourceName, principalId, roleDefinitionId)

// Role assignment resource
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: uniqueName
  properties: {
    principalId: principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalType: 'ServicePrincipal'
    description: description
  }
}

// Outputs
output roleAssignmentId string = roleAssignment.id
output roleAssignmentName string = roleAssignment.name
