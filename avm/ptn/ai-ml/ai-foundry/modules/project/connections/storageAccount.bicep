@description('Optional. Name of the storage connection. If not provided, the name will default to the Storage Account name + Container Name.')
param name string?

@description('Required. The name of the existing AI Foundry Account.')
param accountName string

@description('Required. The name of the existing AI Foundry project to connect to the Storage Account.')
param projectName string

@description('Required. The Resource ID or name of the existing Storage Account to connect to.')
param resourceIdOrName string

@description('Required. The name of the container in the Storage Account to use for the connection.')
param containerName string

module parsedResourceId '../../parseResourceId.bicep' = {
  name: take('proj-storage-conn-${take(uniqueString(resourceIdOrName), 5)}-parse-rid', 64)
  params: {
    resourceIdOrName: resourceIdOrName
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
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
  : '${contains(resourceIdOrName, '/') ? last(split(resourceIdOrName, '/')) : resourceIdOrName}-${containerName}'

resource connection 'Microsoft.CognitiveServices/accounts/projects/connections@2025-06-01' = {
  name: connectionName
  parent: project
  properties: {
    category: 'AzureBlob'
    target: storageAccount!.properties.primaryEndpoints.blob
    authType: 'AAD'
    metadata: {
      ApiType: 'Azure'
      ResourceId: storageAccount.id
      location: storageAccount!.location
      accountName: storageAccount.name
      containerName: containerName
    }
  }
}

@description('Resource ID of the Storage Account connection.')
output resourceId string = connection.id

@description('Name of the Storage Account connection.')
output name string = connection.name

@description('Target endpoint of the Storage Account connection.')
output target string = connection.properties.target
