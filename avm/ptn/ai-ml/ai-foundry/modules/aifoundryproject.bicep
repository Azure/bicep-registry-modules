@minLength(3)
@maxLength(12)
@description('The name of the environment. Use alphanumeric characters only.')
param name string

@description('Specifies the location for all the Azure resources. Defaults to the location of the resource group.')
param location string

// CosmosDB Account
@description('Name of the customers existing CosmosDB Resource')
param cosmosDBName string

@description('Whether to include Cosmos DB in the deployment.')
param cosmosDbEnabled bool

@description('Name of the customers existing Azure Storage Account')
param storageName string

@description('Foundry Account Name')
param aiServicesName string

@description('Whether to include Azure AI Search in the deployment.')
param searchEnabled bool

@description('Azure Search Service Name')
param nameFormatted string

@description('Name of the AI Foundry project')
param defaultProjectName string = name
param defaultProjectDisplayName string = name
param defaultProjectDescription string = 'This is the default project for AI Foundry.'

// var threadConnections = ['${cosmosDBConnection}']
// var storageConnections = ['${azureStorageConnection}']
// var vectorStoreConnections = ['${aiSearchConnection}']

resource foundryAccount 'Microsoft.CognitiveServices/accounts@2025-04-01-preview' existing = {
  name: aiServicesName
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' existing = {
  name: storageName
}

resource aiSearchService 'Microsoft.Search/searchServices@2025-05-01' existing = if (searchEnabled) {
  name: nameFormatted
}

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2025-05-01-preview' existing = if (cosmosDbEnabled) {
  name: cosmosDBName
}

resource project 'Microsoft.CognitiveServices/accounts/projects@2025-04-01-preview' = {
  name: defaultProjectName
  parent: foundryAccount
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: defaultProjectDisplayName
    description: defaultProjectDescription
  }
}

resource project_connection_azure_storage 'Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview' = {
  name: storageName
  parent: project
  properties: {
    category: 'AzureBlob'
    target: storageAccount.properties.primaryEndpoints.blob
    // target: storageAccountTarget
    authType: 'AAD'
    metadata: {
      ApiType: 'Azure'
      ResourceId: storageAccount.id
      location: storageAccount.location
      accountName: storageAccount.name
      containerName: '${name}projUploads'
    }
  }
}

resource project_connection_azureai_search 'Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview' = if (searchEnabled) {
  name: searchEnabled ? aiSearchService.name : ''
  parent: project
  properties: {
    category: 'CognitiveSearch'
    target: searchEnabled ? 'https://${aiSearchService.name}.search.windows.net/' : ''
    authType: 'AAD'
    isSharedToAll: true
    metadata: {
      ApiType: 'Azure'
      ResourceId: searchEnabled ? aiSearchService.id : ''
      location: searchEnabled ? aiSearchService.location : ''
    }
  }
}

resource project_connection_cosmosdb 'Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview' = if (cosmosDbEnabled) {
  name: cosmosDBName
  parent: project
  properties: {
    category: 'CosmosDB'
    target: cosmosDbEnabled ? cosmosDBAccount.properties.documentEndpoint : ''
    authType: 'AAD'
    metadata: {
      ApiType: 'Azure'
      ResourceId: cosmosDbEnabled ? cosmosDBAccount.id : ''
      location: cosmosDbEnabled ? cosmosDBAccount.location : ''
    }
  }
}

resource accountCapabilityHost 'Microsoft.CognitiveServices/accounts/capabilityHosts@2025-04-01-preview' = {
  name: 'accountCapHost'
  parent: foundryAccount
  properties: {
    capabilityHostKind: 'Agents'
  }
}

resource projectCapabilityHost 'Microsoft.CognitiveServices/accounts/projects/capabilityHosts@2025-04-01-preview' = {
  name: 'projectCapHost'
  parent: project
  properties: {
    capabilityHostKind: 'Agents'
    vectorStoreConnections: [
      project_connection_azureai_search.name
    ]
    storageConnections: [
      storageName
    ]
    threadStorageConnections: [
      cosmosDBName
    ]
  }
  dependsOn: [
    accountCapabilityHost
  ]
}

output projectCapHost string = projectCapabilityHost.name

output projectId string = project.id
output projectName string = project.name
// BYO connection names
output cosmosDBConnection string = cosmosDBName
output azureStorageConnection string = storageName
output aiSearchConnection string = nameFormatted
