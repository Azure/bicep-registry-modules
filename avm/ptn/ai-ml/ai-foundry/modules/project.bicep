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

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  name: storageAccountConnection!.resourceIdOrName
}

resource aiSearch 'Microsoft.Search/searchServices@2025-05-01' existing = {
  name: aiSearchConnection!.resourceIdOrName
}

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2025-04-15' existing = {
  name: cosmosDbConnection!.resourceIdOrName
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
    name: storageAccountConnection!.resourceIdOrName
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
    name: aiSearchConnection!.resourceIdOrName
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
    name: cosmosDbConnection!.resourceIdOrName
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

resource capabilityHost 'Microsoft.CognitiveServices/accounts/capabilityHosts@2025-06-01' = if (createCapabilityHost) {
  name: take('${name}-cap-host', 64)
  parent: foundryAccount
  properties: {
    capabilityHostKind: 'Agents'
    tags: tags
  }
}

resource projectCapabilityHost 'Microsoft.CognitiveServices/accounts/projects/capabilityHosts@2025-06-01' = if (createCapabilityHost) {
  name: '${name}-cap-host'
  parent: project
  properties: {
    capabilityHostKind: 'Agents'
    vectorStoreConnections: ['${aiSearchConnection!.resourceIdOrName}']
    storageConnections: ['${storageAccountConnection!.resourceIdOrName}']
    threadStorageConnections: ['${cosmosDbConnection!.resourceIdOrName}']
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

#disable-next-line BCP053
var internalId = project.properties.internalId
var workspacePart1 = substring(internalId, 0, 8)
var workspacePart2 = substring(internalId, 8, 4) // Next 4 characters
var workspacePart3 = substring(internalId, 12, 4) // Next 4 characters
var workspacePart4 = substring(internalId, 16, 4) // Next 4 characters
var workspacePart5 = substring(internalId, 20, 12) // Remaining 12 characters

var projectWorkspaceId = '${workspacePart1}-${workspacePart2}-${workspacePart3}-${workspacePart4}-${workspacePart5}'

module storageAccountBlobContributorRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: take('proj-storage-blob-contributer-role-assign-${name}', 64)
  params: {
    resourceId: storageAccount.id
    principalId: project.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' // Blob Storage Contributor
  }
}

resource storageBlobDataOwnerRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'b7e6dc6d-f1e8-4753-8033-0f276bb0955b' // Storage Blob Data Owner
}

resource storageAccountDataOwnerRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storageAccount
  name: guid(storageAccount.id, storageBlobDataOwnerRoleDefinition.id, name)
  properties: {
    principalId: project.identity.principalId
    roleDefinitionId: storageBlobDataOwnerRoleDefinition.id
    principalType: 'ServicePrincipal'
    conditionVersion: '2.0'
    condition: '((!(ActionMatches{\'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/tags/read\'})  AND  !(ActionMatches{\'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/filter/action\'}) AND  !(ActionMatches{\'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/tags/write\'}) ) OR (@Resource[Microsoft.Storage/storageAccounts/blobServices/containers:name] StringStartsWithIgnoreCase \'${storageAccountConnection!.containerName}\'))'
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

module cosmosDbOperatorAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: take('proj-cosmos-db-operator-role-assign-${name}', 64)
  params: {
    resourceId: cosmosDb.id
    principalId: project.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: '230815da-be43-4aae-9cb4-875f7bd000aa' // Cosmos DB Operator
  }
}

var cosmosContainerNameSuffixes = createCapabilityHost
  ? [
      'thread-message-store'
      'system-thread-message-store'
      'agent-entity-store'
    ]
  : []

var cosmosDefaultSqlRoleDefinitionId = createCapabilityHost
  ? resourceId(
      'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions',
      cosmosDbConnection!.resourceIdOrName,
      '00000000-0000-0000-0000-000000000002'
    )
  : ''

resource cosmosDataRoleAssigment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2025-04-15' = [
  for (containerSuffix, i) in cosmosContainerNameSuffixes: {
    parent: cosmosDb
    name: guid(cosmosDefaultSqlRoleDefinitionId, name, containerSuffix)
    properties: {
      principalId: project.identity.principalId
      roleDefinitionId: cosmosDefaultSqlRoleDefinitionId
      scope: '${cosmosDb.id}/dbs/enterprise_memory/colls/${projectWorkspaceId}-${containerSuffix}'
    }
  }
]

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
}
