// NOTE: This assignment should take place in the AVM module that deploys the AI project
// Current implementation of CKM forces to use cross references between function and AI project, which is not ideal and will be fixed in future releases
@description('Required. The name of the AI Project resource to assign the AI Developer RBAC role.')
param aiServicesProjectResourceName string
@description('Required. The resource ID of the Rag Function resource to grant the AI Developer RBAC role.')
param ragFunctionResourceId string
@description('Required. The principal ID of the Rag Function resource to assign the AI Developer role.')
param ragFunctionPrincipalId string

resource existingAIFoundryAIServicesProject 'Microsoft.MachineLearningServices/workspaces@2021-04-01' existing = {
  name: aiServicesProjectResourceName
}

resource resRoleDefinitionAIDeveloper 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '64702f94-c441-49e6-a78b-ef80e0188fee' //NOTE: Built-in role 'AI Developer'
}

resource resRoleAssignmentAIDeveloperManagedIDAIWorkspaceProject 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(ragFunctionResourceId, existingAIFoundryAIServicesProject.id, resRoleDefinitionAIDeveloper.id)
  scope: existingAIFoundryAIServicesProject
  properties: {
    roleDefinitionId: resRoleDefinitionAIDeveloper.id
    principalId: ragFunctionPrincipalId
  }
}
