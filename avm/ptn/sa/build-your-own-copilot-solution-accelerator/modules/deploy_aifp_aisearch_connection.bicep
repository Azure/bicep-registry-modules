@description('Required. Existing AI Project Name')
param existingAIProjectName string

@description('Required. Existing AI Foundry Name')
param existingAIFoundryName string

@description('Required. AI Search Name')
param aiSearchName string

@description('Required. AI Search Resource ID')
param aiSearchResourceId string

@description('Required. AI Search Location')
param aiSearchLocation string

@description('Required. AI Search Connection Name')
param aiSearchConnectionName string

resource projectAISearchConnection 'Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview' = {
  name: '${existingAIFoundryName}/${existingAIProjectName}/${aiSearchConnectionName}'
  properties: {
    category: 'CognitiveSearch'
    target: 'https://${aiSearchName}.search.windows.net'
    authType: 'AAD'
    isSharedToAll: true
    metadata: {
      ApiType: 'Azure'
      ResourceId: aiSearchResourceId
      location: aiSearchLocation
    }
  }
}
