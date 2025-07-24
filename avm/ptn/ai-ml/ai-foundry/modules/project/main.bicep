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

@batchSize(1)
module aiServicesConnResources 'connections/aiServices.bicep' = [
  for connection in aiServicesConnections ?? []: {
    name: take('${name}-ai-services-conn-${take(uniqueString(connection!.resourceId), 5)}', 64)
    params: {
      name: connection.?name
      accountName: accountName
      projectName: project.name
      resourceIdOrName: connection!.resourceId
    }
  }
]

@batchSize(1)
module aiSearchConnResources 'connections/aiSearch.bicep' = [
  for connection in aiSearchConnections ?? []: {
    name: take('${name}-ai-search-conn-${take(uniqueString(connection!.resourceId), 5)}', 64)
    params: {
      name: connection.?name
      accountName: accountName
      projectName: project.name
      resourceIdOrName: connection!.resourceId
    }
  }
]

@batchSize(1)
module cosmosDbConnResources 'connections/cosmosDb.bicep' = [
  for connection in cosmosDbConnections ?? []: {
    name: take('${name}-cosmos-db-conn-${take(uniqueString(connection!.resourceId), 5)}', 64)
    params: {
      name: connection.?name
      accountName: accountName
      projectName: project.name
      resourceIdOrName: connection!.resourceId
    }
  }
]

@batchSize(1)
module storageAccountConnResources 'connections/storageAccount.bicep' = [
  for connection in storageAccountConnections ?? []: {
    name: take('${name}-storage-conn-${take(uniqueString(connection!.resourceId), 5)}', 64)
    params: {
      name: connection.?name
      accountName: accountName
      projectName: project.name
      resourceIdOrName: connection!.resourceId
      containerName: connection!.containerName
    }
  }
]

var createCapabilityHost = includeCapabilityHost && !empty(cosmosDbConnections) && !empty(aiSearchConnections) && !empty(storageAccountConnections)

resource projectCapabilityHost 'Microsoft.CognitiveServices/accounts/projects/capabilityHosts@2025-06-01' = if (createCapabilityHost) {
  name: '${name}-cap-host'
  parent: project
  #disable-next-line no-unnecessary-dependson
  dependsOn: [aiServicesConnResources, cosmosDbConnResources, aiSearchConnResources, storageAccountConnResources]
  properties: {
    capabilityHostKind: 'Agents'
    vectorStoreConnections: [for (conn, i) in aiSearchConnections ?? []: aiSearchConnResources[i].outputs.name]
    storageConnections: [for (conn, i) in storageAccountConnections ?? []: storageAccountConnResources[i].outputs.name]
    threadStorageConnections: [for (conn, i) in cosmosDbConnections ?? []: cosmosDbConnResources[i].outputs.name]
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
  @description('Optional. The name of the project connection. Will default to "<account>-<container>" if not provided.')
  name: string?

  @description('Required. The resource ID of the Azure resource for the connection.')
  resourceId: string

  @description('Required. Name of container in the Storage Account to use for the connections.')
  containerName: string
}
