param description string = ''
param principalIds array
param principalType string = ''
param roleDefinitionIdOrName string
param speechServiceName string

var builtInRoleNames = {
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Cognitive Services Speech User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f2dc8367-1007-4938-bd23-fe263f013447')
  'Cognitive Services Speech Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0e75ca1e-0464-4b4d-8b93-68208a576181')
}

resource speechService 'Microsoft.CognitiveServices/accounts@2021-10-01' existing = {
  name: speechServiceName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for principalId in principalIds: {
  name: guid(speechService.name, principalId, roleDefinitionIdOrName)
  properties: {
    description: description
    roleDefinitionId: contains(builtInRoleNames, roleDefinitionIdOrName) ? builtInRoleNames[roleDefinitionIdOrName] : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionIdOrName)
    principalId: principalId
    principalType: !empty(principalType) ? principalType : null
  }
  scope: speechService
}]
