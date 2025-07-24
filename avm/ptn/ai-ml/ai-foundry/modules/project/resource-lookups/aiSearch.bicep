@description('Required. The Resource ID or name of the existing AI Search.')
param resourceIdOrName string

module parsedResourceId '../../parseResourceId.bicep' = {
  name: take('project-ai-search-conn-${take(uniqueString(resourceIdOrName), 5)}-parse-resource-id', 64)
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

@description('Resource ID of the AI Search.')
output resourceId string = aiSearch.id

@description('Name of the AI Search.')
output name string = aiSearch.name

@description('Endpoint of the AI Search.')
output endpoint string = 'https://${aiSearch.name}.search.windows.net/'

@description('Location of the AI Search.')
output location string = aiSearch!.location
