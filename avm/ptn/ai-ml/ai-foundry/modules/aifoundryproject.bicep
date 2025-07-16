@minLength(3)
@maxLength(12)
@description('The name of the environment. Use alphanumeric characters only.')
param name string

@description('Specifies the location for all the Azure resources. Defaults to the location of the resource group.')
param location string

@description('Required. Whether associated resources are being included in the deployment.')
param includeAssociatedResources bool

@description('Name of the CosmosDB Resource')
param cosmosDBName string

@description('Name of the Azure Storage Account')
param storageName string

@description('Foundry Account Name')
param aiServicesName string

@description('Azure Search Service Name')
param aiSearchName string

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Name of the container for project uploads')
param projUploadsContainerName string = ''

@description('Name of the container for system data')
param sysDataContainerName string = ''

@description('Name of the AI Foundry project')
param defaultProjectName string = name
param defaultProjectDisplayName string = name
param defaultProjectDescription string = 'This is the default project for AI Foundry.'

resource foundryAccount 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = {
  name: aiServicesName
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' existing = if (includeAssociatedResources && !empty(storageName)) {
  name: storageName
}

resource aiSearchService 'Microsoft.Search/searchServices@2023-11-01' existing = if (includeAssociatedResources && !empty(aiSearchName)) {
  name: aiSearchName
}

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2024-11-15' existing = if (includeAssociatedResources && !empty(cosmosDBName)) {
  name: cosmosDBName
}

resource project 'Microsoft.CognitiveServices/accounts/projects@2025-06-01' = {
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

resource project_connection_azure_storage 'Microsoft.CognitiveServices/accounts/projects/connections@2025-06-01' = if (includeAssociatedResources && !empty(storageName)) {
  name: storageName
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
      containerName: projUploadsContainerName
    }
  }
}

resource project_connection_azure_storage_sysdata 'Microsoft.CognitiveServices/accounts/projects/connections@2025-06-01' = if (includeAssociatedResources && !empty(storageName) && !empty(sysDataContainerName)) {
  name: '${storageName}-sysdata'
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
      containerName: sysDataContainerName
    }
  }
}

resource project_connection_azureai_search 'Microsoft.CognitiveServices/accounts/projects/connections@2025-06-01' = if (includeAssociatedResources && !empty(aiSearchName)) {
  name: aiSearchName // Use the parameter directly instead of aiSearchService.name
  parent: project
  properties: {
    category: 'CognitiveSearch'
    target: 'https://${aiSearchName}.search.windows.net/' // Use the parameter directly
    authType: 'AAD'
    isSharedToAll: true
    metadata: {
      ApiType: 'Azure'
      ResourceId: aiSearchService.id
      location: aiSearchService!.location
    }
  }
}

resource project_connection_cosmosdb 'Microsoft.CognitiveServices/accounts/projects/connections@2025-06-01' = if (includeAssociatedResources && !empty(cosmosDBName)) {
  name: cosmosDBName
  parent: project
  properties: {
    category: 'CosmosDB'
    target: cosmosDBAccount!.properties.documentEndpoint
    authType: 'AAD'
    metadata: {
      ApiType: 'Azure'
      ResourceId: cosmosDBAccount.id
      location: cosmosDBAccount!.location
    }
  }
}

resource accountCapabilityHost 'Microsoft.CognitiveServices/accounts/capabilityHosts@2025-06-01' = if (includeAssociatedResources) {
  name: 'accountCapHost'
  parent: foundryAccount
  properties: {
    capabilityHostKind: 'Agents'
  }
}

// Project capability host with enhanced dependency management
resource projectCapabilityHost 'Microsoft.CognitiveServices/accounts/projects/capabilityHosts@2025-06-01' = if (includeAssociatedResources) {
  name: 'projectCapHost'
  parent: project
  properties: {
    capabilityHostKind: 'Agents'
    vectorStoreConnections: [
      aiSearchService.name
    ]
    storageConnections: [
      storageAccount.name
    ]
    threadStorageConnections: [
      cosmosDBAccount.name
    ]
  }
  dependsOn: [
    // Ensure account capability host is created first
    accountCapabilityHost
    // Wait for ALL connections to be fully created and ready
    project_connection_azureai_search
    project_connection_azure_storage
    project_connection_azure_storage_sysdata
    project_connection_cosmosdb
  ]
}

resource projectLock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: project
}

@description('Name of the Project Capability Host.')
output projectCapHostName string = includeAssociatedResources ? projectCapabilityHost.name : ''

@description('Resource ID of the Project.')
output resourceId string = project.id

@description('Name of the Project.')
output name string = project.name

@description('Name of the Cosmos DB connection.')
output cosmosDBConnectionName string = cosmosDBName

@description('Name of the Azure Storage connection.')
output azureStorageConnectionName string = storageName

@description('Name of the AI Search connection.')
output aiSearchConnectionName string = aiSearchName
