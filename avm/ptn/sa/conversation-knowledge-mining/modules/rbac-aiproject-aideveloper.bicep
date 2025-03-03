// NOTE: This assignment should take place in the AVM module that deploys the AI project
// Current implementation of CKM forces to use cross references between function and AI project, which is not ideal and will be fixed in future releases

param aiServicesProjectResourceName string
param ragFunctionResourceId string
param aiServicesProjectResourceId string
param identityPrincipalId string

resource existingAIFoundryAIServicesProject 'Microsoft.MachineLearningServices/workspaces@2021-04-01' existing = {
  name: aiServicesProjectResourceName
}

resource resRoleDefinitionAIDeveloper 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '64702f94-c441-49e6-a78b-ef80e0188fee' //NOTE: Built-in role 'AI Developer'
}

resource resRoleAssignmentAIDeveloperManagedIDAIWorkspaceProject 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(ragFunctionResourceId, aiServicesProjectResourceId, resRoleDefinitionAIDeveloper.id)
  scope: existingAIFoundryAIServicesProject
  properties: {
    roleDefinitionId: resRoleDefinitionAIDeveloper.id
    principalId: identityPrincipalId
  }
}
