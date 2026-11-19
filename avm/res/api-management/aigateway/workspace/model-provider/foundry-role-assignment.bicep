metadata name = 'AI Gateway Foundry Upstream Role Assignment'
metadata description = 'Grants Azure AI User and Cognitive Services OpenAI User on an upstream Foundry account.'

@description('Required. Upstream Foundry account name.')
param foundryAccountName string

@description('Required. Principal ID to receive upstream Foundry access.')
param principalId string

@description('Required. Gateway resource ID for deterministic role assignment naming.')
param gatewayResourceId string

var foundryUserRoleDefinitionId = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '53ca6127-db72-4b80-b1b0-d745d6d5456d'
)

resource foundryAccount 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = {
  name: foundryAccountName
}

resource foundryUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(foundryAccount.id, gatewayResourceId, foundryUserRoleDefinitionId)
  scope: foundryAccount
  properties: {
    principalId: principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: foundryUserRoleDefinitionId
  }
}

@description('Role assignment name.')
output roleAssignmentName string = foundryUserRoleAssignment.name
