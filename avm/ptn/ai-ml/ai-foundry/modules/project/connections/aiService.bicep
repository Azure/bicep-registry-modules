@description('Optional. Name of the AI Service connection. If not provided, the name will default to the AI Service name.')
param name string?

@description('Required. The name of the existing AI Foundry project to connect to the AI Service.')
param projectName string

@description('Required. The Resource ID or name of the existing AI Service to connect to.')
param resourceIdOrName string

module parsedResourceId '../../parseResourceId.bicep' = {
  name: take('${projectName}-ai-service-conn-${take(uniqueString(resourceIdOrName), 5)}-parse-resource-id', 64)
  params: {
    resourceIdOrName: resourceIdOrName
  }
}

resource project 'Microsoft.CognitiveServices/accounts/projects@2025-06-01' existing = {
  name: projectName
}

resource aiService 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = {
  #disable-next-line no-unnecessary-dependson
  dependsOn: [parsedResourceId]
  name: parsedResourceId!.outputs.name
  scope: resourceGroup(parsedResourceId!.outputs.subscriptionId, parsedResourceId!.outputs.resourceGroupName)
}

resource connection 'Microsoft.CognitiveServices/accounts/projects/connections@2025-06-01' = {
  name: !empty(name) ? name! : aiService!.name
  parent: project
  properties: {
    category: 'AIServices'
    target: aiService!.properties.endpoint
    authType: 'AAD'
    isSharedToAll: true
    metadata: {
      ApiType: 'Azure'
      ResourceId: aiService!.id
      location: aiService!.location
    }
  }
}

@description('Resource ID of the AI Service connection.')
output resourceId string = connection.id

@description('Name of the AI Service connection.')
output name string = connection.name

@description('Target endpoint of the AI Service connection.')
output target string = connection.properties.target
