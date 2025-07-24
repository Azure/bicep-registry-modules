@description('Optional. Name of the AI Service connection. If not provided, the name will default to the AI Service name.')
param name string?

@description('Required. The name of the existing AI Foundry Account.')
param accountName string

@description('Required. The name of the existing AI Foundry project to connect to the AI Service.')
param projectName string

@description('Required. The Resource ID or name of the existing AI Service to connect to.')
param resourceIdOrName string

module parsedResourceId '../../parseResourceId.bicep' = {
  name: take('proj-ai-service-conn-${take(uniqueString(resourceIdOrName), 5)}-parse-rid', 64)
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

resource account 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = {
  name: accountName
}

resource project 'Microsoft.CognitiveServices/accounts/projects@2025-06-01' existing = {
  name: projectName
  parent: account
}

// building connection name manually based on resourceIdOrName due to bicep restrictions on module output and resource naming
var connectionName = !empty(name)
  ? name!
  : (contains(resourceIdOrName, '/') ? last(split(resourceIdOrName, '/')) : resourceIdOrName)

resource connection 'Microsoft.CognitiveServices/accounts/projects/connections@2025-06-01' = {
  name: connectionName
  parent: project
  properties: {
    category: 'AIServices'
    target: aiService!.properties.endpoint
    authType: 'AAD'

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
