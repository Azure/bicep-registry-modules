metadata name = 'AI Foundry Project'
metadata description = 'Creates an AI Foundry project and any associated Azure service connections.'

@minLength(2)
@maxLength(64)
@description('Required. The name of the AI Foundry project.')
param name string

@description('Optional. The display name of the AI Foundry project.')
param displayName string?

@description('Optional. The description of the AI Foundry project.')
param desc string?

@description('Optional. Specifies the location for all the Azure resources.')
param location string = resourceGroup().location

@description('Required. Name of the existing parent Foundry Account resource.')
param accountName string

@description('Required. Include the capability host for the Foundry project.')
param includeCapabilityHost bool

@description('Optional. Azure AI Services connections for the project.')
param aiServicesConnection azureConnectionType?

@description('Optional. Azure Cosmos DB connection for the project.')
param cosmosDbConnection azureConnectionType?

@description('Optional. Azure Cognitive Search connection for the project.')
param aiSearchConnection azureConnectionType?

@description('Optional. Azure Storage Account connection for the project.')
param storageAccountConnection storageAccountConnectionType?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Tags to be applied to the resources.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {}

resource foundryAccount 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = {
  name: accountName
}

resource project 'Microsoft.CognitiveServices/accounts/projects@2025-06-01' = {
  name: name
  parent: foundryAccount
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: !empty(displayName) ? displayName : name
    description: !empty(desc) ? desc : name
  }
  tags: tags
}

module aiServicesLookup 'resource-lookups/aiServices.bicep' = if (!empty(aiServicesConnection)) {
  name: take('${name}-ai-services-lookup-${take(uniqueString(aiServicesConnection!.resourceId), 5)}', 64)
  params: {
    resourceIdOrName: aiServicesConnection!.resourceId
  }
}

module aiSearchLookup 'resource-lookups/aiSearch.bicep' = if (!empty(aiSearchConnection)) {
  name: take('${name}-ai-search-lookup-${take(uniqueString(aiSearchConnection!.resourceId), 5)}', 64)
  params: {
    resourceIdOrName: aiSearchConnection!.resourceId
  }
}

module cosmosDbLookup 'resource-lookups/cosmosDb.bicep' = if (!empty(cosmosDbConnection)) {
  name: take('${name}-cosmos-db-lookup-${take(uniqueString(cosmosDbConnection!.resourceId), 5)}', 64)
  params: {
    resourceIdOrName: cosmosDbConnection!.resourceId
  }
}

module storageAccountLookup 'resource-lookups/storageAccount.bicep' = if (!empty(storageAccountConnection)) {
  name: take('${name}-storage-account-lookup-${take(uniqueString(storageAccountConnection!.resourceId), 5)}', 64)
  params: {
    resourceIdOrName: storageAccountConnection!.resourceId
  }
}

resource aiServicesConnResource 'Microsoft.CognitiveServices/accounts/projects/connections@2025-06-01' = if (!empty(aiServicesConnection)) {
  name: empty(aiServicesConnection.?name)
    ? (contains(aiServicesConnection!.resourceId, '/')
        ? last(split(aiServicesConnection!.resourceId, '/'))
        : aiServicesConnection!.resourceId)
    : aiServicesConnection!.name!
  parent: project
  #disable-next-line no-unnecessary-dependson
  dependsOn: [aiServicesLookup]
  properties: {
    category: 'AIServices'
    target: aiServicesLookup!.outputs.endpoint
    authType: 'AAD'
    metadata: {
      ApiType: 'Azure'
      ResourceId: aiServicesLookup!.outputs.resourceId
      location: aiServicesLookup!.outputs.location
    }
  }
}

resource aiSearchConnResource 'Microsoft.CognitiveServices/accounts/projects/connections@2025-06-01' = if (!empty(aiSearchConnection)) {
  name: empty(aiSearchConnection.?name)
    ? (contains(aiSearchConnection!.resourceId, '/')
        ? last(split(aiSearchConnection!.resourceId, '/'))
        : aiSearchConnection!.resourceId)
    : aiSearchConnection!.name!
  parent: project
  #disable-next-line no-unnecessary-dependson
  dependsOn: [aiServicesConnResource, aiSearchLookup]
  properties: {
    category: 'CognitiveSearch'
    target: aiSearchLookup!.outputs.endpoint
    authType: 'AAD'
    metadata: {
      ApiType: 'Azure'
      ResourceId: aiSearchLookup!.outputs.resourceId
      location: aiSearchLookup!.outputs.location
    }
  }
}

resource storageConnResources 'Microsoft.CognitiveServices/accounts/projects/connections@2025-06-01' = [
  for container in storageAccountConnection.?containers ?? []: {
    name: '${contains(storageAccountConnection!.resourceId, '/') ? last(split(storageAccountConnection!.resourceId, '/')) : storageAccountConnection!.resourceId}-${container}'
    parent: project
    #disable-next-line no-unnecessary-dependson
    dependsOn: [aiSearchConnResource, storageAccountLookup]
    properties: {
      category: 'AzureBlob'
      target: storageAccountLookup!.outputs.blobEndpoint
      authType: 'AAD'
      metadata: {
        ApiType: 'Azure'
        ResourceId: storageAccountLookup!.outputs.resourceId
        location: storageAccountLookup!.outputs.location
        accountName: storageAccountLookup!.outputs.name
        containerName: container
      }
    }
  }
]

resource cosmosDbConnResource 'Microsoft.CognitiveServices/accounts/projects/connections@2025-06-01' = {
  name: empty(cosmosDbConnection.?name)
    ? (contains(cosmosDbConnection!.resourceId, '/')
        ? last(split(cosmosDbConnection!.resourceId, '/'))
        : cosmosDbConnection!.resourceId)
    : cosmosDbConnection!.name!
  parent: project
  #disable-next-line no-unnecessary-dependson
  dependsOn: [storageConnResources, cosmosDbLookup]
  properties: {
    category: 'CosmosDB'
    target: cosmosDbLookup!.outputs.documentEndpoint
    authType: 'AAD'
    metadata: {
      ApiType: 'Azure'
      ResourceId: cosmosDbLookup!.outputs.resourceId
      location: cosmosDbLookup!.outputs.location
    }
  }
}

var createCapabilityHost = includeCapabilityHost && !empty(cosmosDbConnection) && !empty(aiSearchConnection) && !empty(storageAccountConnection)

resource projectCapabilityHost 'Microsoft.CognitiveServices/accounts/projects/capabilityHosts@2025-06-01' = if (createCapabilityHost) {
  name: '${name}-cap-host'
  parent: project
  #disable-next-line no-unnecessary-dependson
  dependsOn: [aiServicesConnResource, cosmosDbConnResource, aiSearchConnResource, storageConnResources]
  properties: {
    capabilityHostKind: 'Agents'
    vectorStoreConnections: [aiSearchConnResource.name]
    storageConnections: [for (conn, i) in storageAccountConnection.?containers ?? []: storageConnResources[i].name]
    threadStorageConnections: [cosmosDbConnResource.name]
    tags: tags
  }
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

@description('Resource ID of the Project.')
output resourceId string = project.id

@description('Name of the Project.')
output name string = project.name

@description('Display name of the Project.')
output displayName string = project.properties.displayName

@description('Description of the Project.')
output desc string = project.properties.description

@export()
@description('Type representing values to create an Azure connection to an AI Foundry project.')
type azureConnectionType = {
  @description('Optional. The name of the project connection. Will default to the resource name if not provided.')
  name: string?

  @description('Required. The resource ID of the Azure resource for the connection.')
  resourceId: string
}

@export()
@description('Type representing values to create an Azure Storage Account connections to an AI Foundry project.')
type storageAccountConnectionType = {
  @description('Required. The resource ID of the Azure resource for the connection.')
  resourceId: string

  @description('Required. List of containers in the Storage Account to use for the connections.')
  containers: string[]
}
