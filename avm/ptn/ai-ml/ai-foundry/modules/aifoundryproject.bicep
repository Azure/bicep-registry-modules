@minLength(3)
@maxLength(12)
@description('The name of the environment. Use alphanumeric characters only.')
param name string

@description('Specifies the location for all the Azure resources. Defaults to the location of the resource group.')
param location string

@allowed([
  'Basic'
  'StandardPublic'
  'StandardPrivate'
])
@description('Required. Specifies the AI Foundry deployment type. Allowed values are Basic, StandardPublic, and StandardPrivate.')
param aiFoundryType string

@description('Name of the CosmosDB Resource')
param cosmosDBName string

@description('Name of the Azure Storage Account')
param storageName string

@description('Foundry Account Name')
param aiServicesName string

@description('Azure Search Service Name')
param nameFormatted string

@description('Name of the container for project uploads')
param projUploadsContainerName string = ''

@description('Name of the container for system data')
param sysDataContainerName string = ''

@description('Name of the AI Foundry project')
param defaultProjectName string = name
param defaultProjectDisplayName string = name
param defaultProjectDescription string = 'This is the default project for AI Foundry.'

resource foundryAccount 'Microsoft.CognitiveServices/accounts@2025-04-01-preview' existing = {
  name: aiServicesName
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' existing = if (toLower(aiFoundryType) != 'basic') {
  name: storageName
}

resource aiSearchService 'Microsoft.Search/searchServices@2023-11-01' existing = if (toLower(aiFoundryType) != 'basic') {
  name: nameFormatted
}

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2024-11-15' existing = if (toLower(aiFoundryType) != 'basic') {
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

resource project_connection_azure_storage 'Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview' = if (toLower(aiFoundryType) != 'basic' && !empty(storageName)) {
  name: storageName
  parent: project
  properties: {
    category: 'AzureBlob'
    target: storageAccount.properties.primaryEndpoints.blob
    authType: 'AAD'
    metadata: {
      ApiType: 'Azure'
      ResourceId: storageAccount.id
      location: storageAccount.location
      accountName: storageAccount.name
      containerName: projUploadsContainerName
    }
  }
}

resource project_connection_azure_storage_sysdata 'Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview' = if (toLower(aiFoundryType) != 'basic' && !empty(storageName) && !empty(sysDataContainerName)) {
  name: '${storageName}-sysdata'
  parent: project
  properties: {
    category: 'AzureBlob'
    target: storageAccount.properties.primaryEndpoints.blob
    authType: 'AAD'
    metadata: {
      ApiType: 'Azure'
      ResourceId: storageAccount.id
      location: storageAccount.location
      accountName: storageAccount.name
      containerName: sysDataContainerName
    }
  }
}

resource project_connection_azureai_search 'Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview' = if (toLower(aiFoundryType) != 'basic' && !empty(nameFormatted)) {
  name: nameFormatted // Use the parameter directly instead of aiSearchService.name
  parent: project
  properties: {
    category: 'CognitiveSearch'
    target: 'https://${nameFormatted}.search.windows.net/' // Use the parameter directly
    authType: 'AAD'
    isSharedToAll: true
    metadata: {
      ApiType: 'Azure'
      ResourceId: aiSearchService.id
      location: aiSearchService.location
    }
  }
}

resource project_connection_cosmosdb 'Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview' = if (toLower(aiFoundryType) != 'basic' && !empty(cosmosDBName)) {
  name: cosmosDBName
  parent: project
  properties: {
    category: 'CosmosDB'
    target: cosmosDBAccount.properties.documentEndpoint
    authType: 'AAD'
    metadata: {
      ApiType: 'Azure'
      ResourceId: cosmosDBAccount.id
      location: cosmosDBAccount.location
    }
  }
}

resource accountCapabilityHost 'Microsoft.CognitiveServices/accounts/capabilityHosts@2025-04-01-preview' = if (toLower(aiFoundryType) != 'basic') {
  name: 'accountCapHost'
  parent: foundryAccount
  properties: {
    capabilityHostKind: 'Agents'
  }
}

resource projectCapabilityHost 'Microsoft.CognitiveServices/accounts/projects/capabilityHosts@2025-04-01-preview' = if (toLower(aiFoundryType) != 'basic') {
  name: 'projectCapHost'
  parent: project
  properties: {
    capabilityHostKind: 'Agents'
    vectorStoreConnections: [
      nameFormatted
    ]
    storageConnections: [
      storageName
      '${storageName}-sysdata'
    ]
    threadStorageConnections: [
      cosmosDBName
    ]
  }
  dependsOn: [
    accountCapabilityHost
  ]
}

output projectCapHost string = toLower(aiFoundryType) != 'basic' ? projectCapabilityHost.name : ''

output projectId string = project.id
output projectName string = project.name
// BYO connection names
output cosmosDBConnection string = cosmosDBName
output azureStorageConnection string = storageName
output aiSearchConnection string = nameFormatted
