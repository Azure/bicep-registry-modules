metadata name = 'Test Foundry access'
metadata description = 'Grants the test user-assigned identity access to an existing Foundry account before gateway configuration.'

@description('Required. Name of an existing Cognitive Services account.')
param accountName string
@description('Required. User-assigned identity principal ID.')
param principalId string

resource account 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = {
  name: accountName
}
resource assignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(account.id, principalId, 'Cognitive Services OpenAI User')
  scope: account
  properties: {
    principalId: principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd'
    )
  }
}

@description('The test role assignment resource ID.')
output resourceId string = assignment.id
