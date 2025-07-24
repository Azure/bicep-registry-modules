@description('Required. The Resource ID or name of the existing Cosmos DB Account to connect to.')
param resourceIdOrName string

module parsedResourceId '../../parseResourceId.bicep' = {
  name: take('project-cosmos-db-conn-${take(uniqueString(resourceIdOrName), 5)}-parse-resource-id', 64)
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

@description('Resource ID of the Cosmos DB.')
output resourceId string = cosmosDb.id

@description('Name of the Cosmos DB connection.')
output name string = cosmosDb.name

@description('Document endpoint of the Cosmos DB.')
output documentEndpoint string = cosmosDb!.properties.documentEndpoint

@description('Location of the Cosmos DB.')
output location string = cosmosDb!.location
