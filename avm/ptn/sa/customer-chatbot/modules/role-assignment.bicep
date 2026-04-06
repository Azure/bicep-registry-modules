@description('Principal ID of the managed identity or service principal to assign the role to')
param principalId string

@description('Role definition ID (GUID) of the Azure RBAC role to assign')
param roleDefinitionId string

@description('Optional. The resource ID of the target resource for scoping the role assignment GUID.')
param targetResourceId string = resourceGroup().id

@description('Optional. A description of the role assignment.')
param roleDescription string = ''

var isProjectScoped = targetResourceId != resourceGroup().id

// Parse AI project resource ID: /subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.CognitiveServices/accounts/{account}/projects/{project}
var resourceParts = split(isProjectScoped ? targetResourceId : '///////////', '/')
var parentAccountName = resourceParts[8]
var projectName = resourceParts[10]

var uniqueName = isProjectScoped
  ? guid(targetResourceId, principalId, roleDefinitionId)
  : guid(subscription().subscriptionId, resourceGroup().id, principalId, roleDefinitionId)

resource cognitiveServicesAccount 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = if (isProjectScoped) {
  name: parentAccountName
}

resource aiProject 'Microsoft.CognitiveServices/accounts/projects@2025-06-01' existing = if (isProjectScoped) {
  parent: cognitiveServicesAccount
  name: projectName
}

// Role assignment at resource group scope
resource roleAssignmentRG 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!isProjectScoped) {
  name: uniqueName
  properties: {
    principalId: principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalType: 'ServicePrincipal'
    description: roleDescription
  }
}

// Role assignment scoped to AI project resource
resource roleAssignmentProject 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (isProjectScoped) {
  scope: aiProject
  name: uniqueName
  properties: {
    principalId: principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalType: 'ServicePrincipal'
    description: roleDescription
  }
}

@description('Resource ID of the created role assignment')
output roleAssignmentId string = isProjectScoped ? roleAssignmentProject.id : roleAssignmentRG.id
