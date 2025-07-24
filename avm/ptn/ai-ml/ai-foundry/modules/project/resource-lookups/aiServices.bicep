@description('Required. The Resource ID or name of the existing AI Service.')
param resourceIdOrName string

module parsedResourceId '../../parseResourceId.bicep' = {
  name: take('project-ai-service-conn-${take(uniqueString(resourceIdOrName), 5)}-parse-resource-id', 64)
  params: {
    resourceIdOrName: resourceIdOrName
  }
}

resource aiService 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = {
  #disable-next-line no-unnecessary-dependson
  dependsOn: [parsedResourceId]
  name: parsedResourceId!.outputs.name
  scope: resourceGroup(parsedResourceId!.outputs.subscriptionId, parsedResourceId!.outputs.resourceGroupName)
}

@description('Resource ID of the AI Service.')
output resourceId string = aiService.id

@description('Name of the AI Service.')
output name string = aiService.name

@description('Endpoint of the AI Service.')
output endpoint string = aiService!.properties.endpoint

@description('Location of the AI Service.')
output location string = aiService!.location
