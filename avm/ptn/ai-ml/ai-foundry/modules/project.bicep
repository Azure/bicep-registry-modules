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

@description('Optional. Azure Cosmos DB connection for the project.')
param cosmosDbConnection azureConnectionType?

@description('Optional. Azure Cognitive Search connection for the project.')
param aiSearchConnection azureConnectionType?

@description('Optional. Storage Account connection for the project.')
param storageAccountConnection storageAccountConnectionType?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Tags to be applied to the resources.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {}

resource foundryAccount 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = {
  name: accountName
}

var storageAccountName = contains(storageAccountConnection!.resourceIdOrName, '/')
  ? last(split(storageAccountConnection!.resourceIdOrName, '/'))
  : storageAccountConnection!.resourceIdOrName
resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  name: storageAccountName
  scope: resourceGroup(
    storageAccountConnection.?subscriptionId ?? subscription().subscriptionId,
    storageAccountConnection.?resourceGroupName ?? resourceGroup().name
  )
}

var aiSearchName = contains(aiSearchConnection!.resourceIdOrName, '/')
  ? last(split(aiSearchConnection!.resourceIdOrName, '/'))
  : aiSearchConnection!.resourceIdOrName
resource aiSearch 'Microsoft.Search/searchServices@2025-05-01' existing = {
  name: aiSearchName
  scope: resourceGroup(
    aiSearchConnection.?subscriptionId ?? subscription().subscriptionId,
    aiSearchConnection.?resourceGroupName ?? resourceGroup().name
  )
}

var cosmosDbName = contains(cosmosDbConnection!.resourceIdOrName, '/')
  ? last(split(cosmosDbConnection!.resourceIdOrName, '/'))
  : cosmosDbConnection!.resourceIdOrName
resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2025-04-15' existing = {
  name: cosmosDbName
  scope: resourceGroup(
    cosmosDbConnection.?subscriptionId ?? subscription().subscriptionId,
    cosmosDbConnection.?resourceGroupName ?? resourceGroup().name
  )
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

  resource storageConnection 'connections@2025-06-01' = {
    name: storageAccount.name
    properties: {
      category: 'AzureBlob'
      target: storageAccount!.properties.primaryEndpoints.blob
      authType: 'AAD'
      metadata: {
        ApiType: 'Azure'
        ResourceId: storageAccount.id
        location: storageAccount!.location
        AccountName: storageAccount!.name
        ContainerName: storageAccountConnection!.containerName
      }
    }
  }

  resource searchConnection 'connections@2025-06-01' = {
    name: aiSearch.name
    properties: {
      category: 'CognitiveSearch'
      target: 'https://${aiSearch!.name}.search.windows.net/'
      authType: 'AAD'
      metadata: {
        ApiType: 'Azure'
        ResourceId: aiSearch!.id
        location: aiSearch!.location
      }
    }
  }

  resource cosmosConnection 'connections@2025-06-01' = {
    name: cosmosDb.name
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
}

var createCapabilityHost = includeCapabilityHost && !empty(cosmosDbConnection) && !empty(aiSearchConnection) && !empty(storageAccountConnection)

resource accountCapabilityHost 'Microsoft.CognitiveServices/accounts/capabilityHosts@2025-06-01' = if (createCapabilityHost) {
  name: take('${accountName}-cap-host', 64)
  parent: foundryAccount
  properties: {
    capabilityHostKind: 'Agents'
    tags: tags
  }
}

resource projectCapabilityHost 'Microsoft.CognitiveServices/accounts/projects/capabilityHosts@2025-06-01' = if (createCapabilityHost) {
  name: take('${name}-cap-host', 64)
  parent: project
  properties: {
    capabilityHostKind: 'Agents'
    vectorStoreConnections: ['${aiSearch.name}']
    storageConnections: ['${storageAccount.name}']
    threadStorageConnections: ['${cosmosDb.name}']
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

module storageAccountRoleAssignments 'project.roles.storage.bicep' = {
  name: take('proj-storage-role-assignments-${name}', 64)
  scope: resourceGroup(
    storageAccountConnection.?subscriptionId ?? subscription().subscriptionId,
    storageAccountConnection.?resourceGroupName ?? resourceGroup().name
  )
  params: {
    storageAccountName: storageAccountName
    projectIdentityPrincipalId: project.identity.principalId
    containerName: storageAccountConnection!.containerName
  }
}

#disable-next-line BCP053
var internalId = project.properties.internalId
var workspacePart1 = substring(internalId, 0, 8)
var workspacePart2 = substring(internalId, 8, 4) // Next 4 characters
var workspacePart3 = substring(internalId, 12, 4) // Next 4 characters
var workspacePart4 = substring(internalId, 16, 4) // Next 4 characters
var workspacePart5 = substring(internalId, 20, 12) // Remaining 12 characters

var projectWorkspaceId = '${workspacePart1}-${workspacePart2}-${workspacePart3}-${workspacePart4}-${workspacePart5}'

module cosmosDbRoleAssignments 'project.roles.cosmos.bicep' = {
  name: take('proj-cosmos-role-assignments-${name}', 64)
  scope: resourceGroup(
    cosmosDbConnection.?subscriptionId ?? subscription().subscriptionId,
    cosmosDbConnection.?resourceGroupName ?? resourceGroup().name
  )
  params: {
    cosmosDbName: cosmosDbName
    projectIdentityPrincipalId: project.identity.principalId
    projectWorkspaceId: projectWorkspaceId
    createCapabilityHost: createCapabilityHost
  }
}

module searchRoleIndexDataContributorAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: take('proj-search-index-data-contributor-role-assign-${name}', 64)
  params: {
    resourceId: aiSearch.id
    principalId: project.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: '8ebe5a00-799e-43f5-93ac-243d3dce84a7' // Search Index Data Contributor
  }
}

module searchServiceContributorAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: take('proj-search-service-contributor-role-assign-${name}', 64)
  params: {
    resourceId: aiSearch.id
    principalId: project.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: '7ca78c08-252a-4471-8644-bb5ff32d4ba0' // Search Service Contributor
  }
}

@description('Name of the deployed Azure Resource Group.')
output resourceGroupName string = resourceGroup().name

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

  @description('Required. The resource ID or name of the Azure resource for the connection.')
  resourceIdOrName: string

  @description('Optional. The subscription ID of the resource. If not provided, the current subscription will be used.')
  subscriptionId: string?

  @description('Optional. The resource group name of the resource. If not provided, the current resource group will be used.')
  resourceGroupName: string?
}

@export()
@description('Type representing values to create an Azure Storage Account connections to an AI Foundry project.')
type storageAccountConnectionType = {
  @description('Optional. The name of the project connection. Will default to "<account>-<container>" if not provided.')
  name: string?

  @description('Required. The resource ID or name of the Storage Account for the connection.')
  resourceIdOrName: string

  @description('Required. Name of container in the Storage Account to use for the connections.')
  containerName: string

  @description('Optional. The subscription ID of the Storage Account. If not provided, the current subscription will be used.')
  subscriptionId: string?

  @description('Optional. The resource group name of the Storage Account. If not provided, the current resource group will be used.')
  resourceGroupName: string?
}
