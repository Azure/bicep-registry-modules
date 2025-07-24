@description('Optional. Name of the AI Service connection. If not provided, the name will default to the AI Service name.')
param name string?

@description('Required. The name of the existing AI Foundry Account.')
param accountName string

@description('Required. The name of the existing AI Foundry project to connect to the AI Service.')
param projectName string

@description('Required. The Resource ID or name of the existing AI Service to connect to.')
param resourceIdOrName string

module parsedResourceId '../../parseResourceId.bicep' = {
  name: take('proj-ai-search-conn-${take(uniqueString(resourceIdOrName), 5)}-parse-rid', 64)
  params: {
    resourceIdOrName: resourceIdOrName
  }
}

resource aiSearch 'Microsoft.Search/searchServices@2025-05-01' existing = {
  #disable-next-line no-unnecessary-dependson
  dependsOn: [parsedResourceId]
  name: parsedResourceId!.outputs.name
  scope: resourceGroup(parsedResourceId!.outputs.subscriptionId, parsedResourceId!.outputs.resourceGroupName)
}

resource account 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = {
  name: accountName
}

resource project 'Microsoft.CognitiveServices/accounts/projects@2025-06-01' existing = {
  name: projectName
  parent: account
}

resource connection 'Microsoft.CognitiveServices/accounts/projects/connections@2025-06-01' = {
  name: !empty(name) ? name! : aiSearch!.name
  parent: project
  properties: {
    category: 'CognitiveSearch'
    target: 'https://${aiSearch!.name}.search.windows.net/'
    authType: 'AAD'
    metadata: {
      ApiType: 'Azure'
      ResourceId: aiSearch!.id
      location: aiSearch!.location
    }
  }
}

@description('Resource ID of the AI Search connection.')
output resourceId string = connection.id

@description('Name of the AI Search connection.')
output name string = connection.name

@description('Target endpoint of the AI Search connection.')
output target string = connection.properties.target
