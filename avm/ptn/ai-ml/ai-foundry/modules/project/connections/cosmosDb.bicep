@description('Optional. Name of the Cosmos DB connection. If not provided, the name will default to the Cosmos DB Account name.')
param name string?

@description('Required. The name of the existing AI Foundry Account.')
param accountName string

@description('Required. The name of the existing AI Foundry project to connect to the Cosmos DB Account.')
param projectName string

@description('Required. The Resource ID or name of the existing Cosmos DB Account to connect to.')
param resourceIdOrName string

module parsedResourceId '../../parseResourceId.bicep' = {
  name: take('proj-cosmos-db-conn-${take(uniqueString(resourceIdOrName), 5)}-parse-rid', 64)
  params: {
    resourceIdOrName: resourceIdOrName
  }
}

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2025-04-15' existing = {
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
    category: 'CosmosDB'
    target: cosmosDb!.properties.documentEndpoint
    authType: 'AAD'
    metadata: {
      ApiType: 'Azure'
      ResourceId: cosmosDb!.id
      location: cosmosDb!.location
    }
  }
}

@description('Resource ID of the Cosmos DB connection.')
output resourceId string = connection.id

@description('Name of the Cosmos DB connection.')
output name string = connection.name

@description('Target endpoint of the Cosmos DB connection.')
output target string = connection.properties.target
