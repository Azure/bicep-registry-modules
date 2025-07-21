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

@description('Optional. List of Azure AI Services connections for the project.')
param aiServicesConnections azureConnectionType[]?

@description('Optional. List of Azure Cosmos DB connections for the project.')
param cosmosDbConnections azureConnectionType[]?

@description('Optional. List of Azure Cognitive Search connections for the project.')
param aiSearchConnections azureConnectionType[]?

@description('Optional. List of Azure Storage Account connections for the project.')
param storageAccountConnections storageAccountConnectionType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

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

resource aiServiceConnResources 'Microsoft.CognitiveServices/accounts/projects/connections@2025-06-01' = [
  for (connection, i) in aiServicesConnections ?? []: {
    name: connection.name
    parent: project
    properties: {
      category: 'AIServices'
      target: connection.target
      authType: 'AAD'
      isSharedToAll: true
      metadata: {
        ApiType: 'Azure'
        ResourceId: connection.resourceId
        location: connection.location
      }
    }
  }
]

resource aiSearchConnResources 'Microsoft.CognitiveServices/accounts/projects/connections@2025-06-01' = [
  for (connection, i) in aiSearchConnections ?? []: {
    name: connection.name
    parent: project
    properties: {
      category: 'CognitiveSearch'
      target: connection.target
      authType: 'AAD'
      isSharedToAll: true
      metadata: {
        ApiType: 'Azure'
        ResourceId: connection.resourceId
        location: connection.location
      }
    }
  }
]

resource storageConnResources 'Microsoft.CognitiveServices/accounts/projects/connections@2025-06-01' = [
  for (connection, i) in storageAccountConnections ?? []: {
    name: connection.name
    parent: project
    properties: {
      category: 'AzureBlob'
      target: connection.target
      authType: 'AAD'
      isSharedToAll: true
      metadata: {
        ApiType: 'Azure'
        ResourceId: connection.resourceId
        location: connection.location
        accountName: connection.accountName
        containerName: connection.containerName
      }
    }
  }
]

resource cosmosDbConnResources 'Microsoft.CognitiveServices/accounts/projects/connections@2025-06-01' = [
  for (connection, i) in cosmosDbConnections ?? []: {
    name: connection.name
    parent: project
    properties: {
      category: 'CosmosDB'
      target: connection.target
      authType: 'AAD'
      isSharedToAll: true
      metadata: {
        ApiType: 'Azure'
        ResourceId: connection.resourceId
        location: connection.location
      }
    }
  }
]

var createCapabilityHost = !empty(cosmosDbConnections) && !empty(aiSearchConnections) && !empty(storageAccountConnections)

resource projectCapabilityHost 'Microsoft.CognitiveServices/accounts/projects/capabilityHosts@2025-06-01' = if (createCapabilityHost) {
  name: '${name}-cap-host'
  parent: project
  dependsOn: [...aiServiceConnResources, ...cosmosDbConnResources, ...aiSearchConnResources, ...storageConnResources]
  properties: {
    capabilityHostKind: 'Agents'
    vectorStoreConnections: [for (conn, i) in aiSearchConnections ?? []: aiSearchConnResources[i].name]
    storageConnections: [for (conn, i) in storageAccountConnections ?? []: storageConnResources[i].name]
    threadStorageConnections: [for (conn, i) in cosmosDbConnections ?? []: cosmosDbConnResources[i].name]
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

@description('AI Services Connections for the Project.')
output aiServicesConnections connectionOutputType[] = [
  for (conn, i) in aiServicesConnections ?? []: {
    resourceId: aiServiceConnResources[i].id
    name: aiServiceConnResources[i].name
    category: 'AIServices'
    target: aiServiceConnResources[i].properties.target
  }
]

@description('AI Search Connections for the Project.')
output aiSearchConnections connectionOutputType[] = [
  for (conn, i) in aiSearchConnections ?? []: {
    resourceId: aiSearchConnResources[i].id
    name: aiSearchConnResources[i].name
    category: 'CognitiveSearch'
    target: aiSearchConnResources[i].properties.target
  }
]

@description('Storage Account Connections for the Project.')
output storageAccountConnections connectionOutputType[] = [
  for (conn, i) in storageAccountConnections ?? []: {
    resourceId: storageConnResources[i].id
    name: storageConnResources[i].name
    category: 'AzureBlob'
    target: storageConnResources[i].properties.target
  }
]

@description('Cosmos DB Connections for the Project.')
output cosmosDbConnections connectionOutputType[] = [
  for (conn, i) in cosmosDbConnections ?? []: {
    resourceId: cosmosDbConnResources[i].id
    name: cosmosDbConnResources[i].name
    category: 'CosmosDB'
    target: cosmosDbConnResources[i].properties.target
  }
]

@export()
@description('Type representing values to create an Azure connection to an AI Foundry project.')
type azureConnectionType = {
  @description('Required. The name of the project connection.')
  name: string

  @description('Required. The resource ID of the Azure resource for the connection.')
  resourceId: string

  @description('Required. The target endpoint of the connection.')
  target: string

  @description('Required. Location of the Azure resource for the connection.')
  location: string
}

@export()
@description('Type representing values to create an Azure Storage Account connection to an AI Foundry project.')
type storageAccountConnectionType = {
  @description('Required. The name of the project connection.')
  name: string

  @description('Required. The resource ID of the Azure resource for the connection.')
  resourceId: string

  @description('Required. The target endpoint of the connection.')
  target: string

  @description('Required. Location of the Azure resource for the connection.')
  location: string

  @description('Required. The name of the Storage Account to use for the connection.')
  accountName: string

  @description('Required. The name of the container in the Storage Account to use for the connection.')
  containerName: string
}

@export()
@description('Custom type definition for connection resource information as output.')
type connectionAggregateType = {
  @description('Optional. List of AI Service connections created for the project.')
  aiserviceConnections: connectionOutputType[]

  @description('Optional. List of AI Search connections created for the project.')
  aiSearchConnections: connectionOutputType[]

  @description('Optional. List of Storage Account connections created for the project.')
  storageAccountConnections: connectionOutputType[]

  @description('Optional. List of Cosmos DB connections created for the project.')
  cosmosDbConnections: connectionOutputType[]
}

@export()
@description('Custom type definition for connection resource information as output.')
type connectionOutputType = {
  @description('Required. The name of the connection.')
  name: string

  @description('Required. The resource ID of the connection.')
  resourceId: string

  @description('Required. The category of the connection.')
  category: string

  @description('Required. The target endpoint of the connection.')
  target: string
}
