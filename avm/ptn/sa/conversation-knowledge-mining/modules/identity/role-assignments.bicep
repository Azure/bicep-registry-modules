// ============================================================================
// Module: Role Assignments (centralized — all cross-service + data plane RBAC)
// Description: RG-level, cross-service, and data-plane role assignments.
//              One place to audit "who has access to what".
// ============================================================================

// ============================================================================
// Parameters
// ============================================================================

@description('Solution name suffix for generating unique role assignment GUIDs.')
param solutionName string = ''

@description('Whether to use an existing AI project (true) or create new (false).')
param useExistingAIProject bool = false

@description('Resource ID of the existing AI project (for deriving AI Services name/sub/RG).')
param existingFoundryProjectResourceId string = ''

// --- Identity Principal IDs ---

@description('Principal ID of the AI project identity (works for both new and existing projects).')
param aiProjectPrincipalId string = ''

@description('Principal ID of the AI Search identity.')
param aiSearchPrincipalId string = ''

@description('Principal ID of the backend App Service system-assigned identity (empty if not deployed).')
param backendAppServicePrincipalId string = ''

// --- Resource References ---

@description('Resource ID of the AI Foundry account (empty if not deployed — new project path).')
param aiFoundryResourceId string = ''

@description('Resource ID of the AI Search service (empty if not deployed).')
param aiSearchResourceId string = ''

@description('Resource ID of the Storage Account (empty if not deployed).')
param storageAccountResourceId string = ''

@description('Name of the Cosmos DB account (empty if not deployed).')
param cosmosDbAccountName string = ''

@description('Whether to use an existing container registry (true) or the one created in this deployment (false).')
param useExistingContainerRegistry bool = false

@description('Resource ID of the container registry to grant AcrPull on (for deriving name/sub/RG; empty = skip ACR role assignments).')
param containerRegistryResourceId string = ''

@description('Principals to grant AcrPull on the container registry (array of objects with principalId and principalType).')
param acrPullPrincipals array = []

// ============================================================================
// Derived Variables
// ============================================================================

var existingAIFoundryName = useExistingAIProject ? split(existingFoundryProjectResourceId, '/')[8] : ''
var existingAIFoundrySubscription = useExistingAIProject ? split(existingFoundryProjectResourceId, '/')[2] : subscription().subscriptionId
var existingAIFoundryResourceGroup = useExistingAIProject ? split(existingFoundryProjectResourceId, '/')[4] : resourceGroup().name

// Container registry — derive name, subscription, and resource group from the resource ID (new or existing).
var containerRegistryName = empty(containerRegistryResourceId) ? '' : split(containerRegistryResourceId, '/')[8]
var containerRegistrySubscription = empty(containerRegistryResourceId) ? subscription().subscriptionId : split(containerRegistryResourceId, '/')[2]
var containerRegistryResourceGroup = empty(containerRegistryResourceId) ? resourceGroup().name : split(containerRegistryResourceId, '/')[4]

// ============================================================================
// Role Definitions
// ============================================================================

var roleDefinitions = {
  azureAiUser: '53ca6127-db72-4b80-b1b0-d745d6d5456d' // Foundry User
  cognitiveServicesUser: 'a97b65f3-24c7-4388-baec-2e87135dc908'
  cognitiveServicesOpenAIUser: '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd'
  searchIndexDataReader: '1407120a-92aa-4202-b7e9-c0e197c71c8f'
  searchIndexDataContributor: '8ebe5a00-799e-43f5-93ac-243d3dce84a7'
  searchServiceContributor: '7ca78c08-252a-4471-8644-bb5ff32d4ba0'
  storageBlobDataContributor: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  storageBlobDataReader: '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
  storageQueueDataContributor: '974c5e8b-45b9-4653-ba55-5f855dd0fb88'
  acrPull: '7f951dda-4ed3-4680-a7ca-43fe172d538d'
}

// ============================================================================
// Existing Resource References
// ============================================================================

resource aiFoundryAccount 'Microsoft.CognitiveServices/accounts@2025-12-01' existing = if (!empty(aiFoundryResourceId)) {
  name: last(split(aiFoundryResourceId, '/'))
}

resource aiSearchService 'Microsoft.Search/searchServices@2025-05-01' existing = if (!empty(aiSearchResourceId)) {
  name: last(split(aiSearchResourceId, '/'))
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-08-01' existing = if (!empty(storageAccountResourceId)) {
  name: last(split(storageAccountResourceId, '/'))
}

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2025-10-15' existing = if (!empty(cosmosDbAccountName)) {
  name: cosmosDbAccountName
}

resource cosmosContributorRoleDefinition 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2025-10-15' existing = if (!empty(cosmosDbAccountName)) {
  parent: cosmosAccount
  name: '00000000-0000-0000-0000-000000000002' // Cosmos DB Built-in Data Contributor
}

// ============================================================================
// 1. AI SERVICES ROLE ASSIGNMENTS
//    Cross-service roles scoped to AI Foundry account
// ============================================================================

// AI Search → Cognitive Services OpenAI User on AI Foundry (new project, same RG)
resource assignOpenAIRoleToAISearch 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!useExistingAIProject && !empty(aiSearchPrincipalId) && !empty(aiFoundryResourceId)) {
  name: guid(solutionName, aiFoundryAccount.id, aiSearchPrincipalId, roleDefinitions.cognitiveServicesOpenAIUser)
  scope: aiFoundryAccount
  properties: {
    principalId: aiSearchPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.cognitiveServicesOpenAIUser)
    principalType: 'ServicePrincipal'
  }
}

// AI Search → Cognitive Services OpenAI User on existing AI Foundry (cross-scope)
module assignOpenAIToSearchExisting './cross-scope-role-assignment.bicep' = if (useExistingAIProject && !empty(aiSearchPrincipalId)) {
  name: 'assignOpenAIRoleToAISearchExisting'
  scope: resourceGroup(existingAIFoundrySubscription, existingAIFoundryResourceGroup)
  params: {
    principalId: aiSearchPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.cognitiveServicesOpenAIUser)
    roleAssignmentName: guid(solutionName, existingAIFoundryName, aiSearchPrincipalId, roleDefinitions.cognitiveServicesOpenAIUser)
    aiFoundryName: existingAIFoundryName
  }
}

// Backend App Service → Foundry User on AI Foundry (new project, same RG)
resource backendAppAiUserAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!useExistingAIProject && !empty(aiFoundryResourceId) && !empty(backendAppServicePrincipalId)) {
  name: guid(solutionName, aiFoundryAccount.id, backendAppServicePrincipalId, roleDefinitions.azureAiUser)
  scope: aiFoundryAccount
  properties: {
    principalId: backendAppServicePrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.azureAiUser)
    principalType: 'ServicePrincipal'
  }
}

// Backend App Service → Foundry User on existing AI Foundry (cross-scope)
module backendAppAiUserExisting './cross-scope-role-assignment.bicep' = if (useExistingAIProject && !empty(backendAppServicePrincipalId)) {
  name: 'assignAiUserRoleToBackendExisting'
  scope: resourceGroup(existingAIFoundrySubscription, existingAIFoundryResourceGroup)
  params: {
    principalId: backendAppServicePrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.azureAiUser)
    roleAssignmentName: guid(solutionName, existingAIFoundryName, backendAppServicePrincipalId, roleDefinitions.azureAiUser)
    aiFoundryName: existingAIFoundryName
  }
}

// Backend App Service → Cognitive Services OpenAI User on AI Foundry (new project, same RG)
resource backendAppOpenAIUserAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!useExistingAIProject && !empty(aiFoundryResourceId) && !empty(backendAppServicePrincipalId)) {
  name: guid(solutionName, aiFoundryAccount.id, backendAppServicePrincipalId, roleDefinitions.cognitiveServicesOpenAIUser)
  scope: aiFoundryAccount
  properties: {
    principalId: backendAppServicePrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.cognitiveServicesOpenAIUser)
    principalType: 'ServicePrincipal'
  }
}

// Backend App Service → Cognitive Services OpenAI User on existing AI Foundry (cross-scope)
module backendAppOpenAIUserExisting './cross-scope-role-assignment.bicep' = if (useExistingAIProject && !empty(backendAppServicePrincipalId)) {
  name: 'assignOpenAIUserRoleToBackendExisting'
  scope: resourceGroup(existingAIFoundrySubscription, existingAIFoundryResourceGroup)
  params: {
    principalId: backendAppServicePrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.cognitiveServicesOpenAIUser)
    roleAssignmentName: guid(solutionName, existingAIFoundryName, backendAppServicePrincipalId, roleDefinitions.cognitiveServicesOpenAIUser)
    aiFoundryName: existingAIFoundryName
  }
}

// ============================================================================
// 2. SEARCH SERVICE ROLE ASSIGNMENTS
//    AI Project and Backend identities → AI Search
// ============================================================================

// AI Project → Search Index Data Reader on AI Search
resource projectSearchReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(aiSearchResourceId) && !empty(aiProjectPrincipalId)) {
  name: guid(solutionName, aiSearchService.id, aiProjectPrincipalId, roleDefinitions.searchIndexDataReader)
  scope: aiSearchService
  properties: {
    principalId: aiProjectPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.searchIndexDataReader)
    principalType: 'ServicePrincipal'
  }
}

// AI Project → Search Service Contributor on AI Search
resource projectSearchContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(aiSearchResourceId) && !empty(aiProjectPrincipalId)) {
  name: guid(solutionName, aiSearchService.id, aiProjectPrincipalId, roleDefinitions.searchServiceContributor)
  scope: aiSearchService
  properties: {
    principalId: aiProjectPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.searchServiceContributor)
    principalType: 'ServicePrincipal'
  }
}

// Backend App Service → Search Index Data Contributor on AI Search
resource backendAppSearchIndexContributorAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(aiSearchResourceId) && !empty(backendAppServicePrincipalId)) {
  name: guid(solutionName, aiSearchService.id, backendAppServicePrincipalId, roleDefinitions.searchIndexDataContributor)
  scope: aiSearchService
  properties: {
    principalId: backendAppServicePrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.searchIndexDataContributor)
    principalType: 'ServicePrincipal'
  }
}

// Backend App Service → Search Service Contributor on AI Search
resource backendAppSearchContributorAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(aiSearchResourceId) && !empty(backendAppServicePrincipalId)) {
  name: guid(solutionName, aiSearchService.id, backendAppServicePrincipalId, roleDefinitions.searchServiceContributor)
  scope: aiSearchService
  properties: {
    principalId: backendAppServicePrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.searchServiceContributor)
    principalType: 'ServicePrincipal'
  }
}

// ============================================================================
// 3. STORAGE ROLE ASSIGNMENTS
//    AI Project, AI Search, and Existing Project identities → Storage
// ============================================================================

// AI Project → Storage Blob Data Contributor
resource projectStorageContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(storageAccountResourceId) && !empty(aiProjectPrincipalId)) {
  name: guid(solutionName, storageAccount.id, aiProjectPrincipalId, roleDefinitions.storageBlobDataContributor)
  scope: storageAccount
  properties: {
    principalId: aiProjectPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.storageBlobDataContributor)
    principalType: 'ServicePrincipal'
  }
}

// AI Project → Storage Blob Data Reader
resource projectStorageReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(storageAccountResourceId) && !empty(aiProjectPrincipalId)) {
  name: guid(solutionName, storageAccount.id, aiProjectPrincipalId, roleDefinitions.storageBlobDataReader)
  scope: storageAccount
  properties: {
    principalId: aiProjectPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.storageBlobDataReader)
    principalType: 'ServicePrincipal'
  }
}

// AI Search → Storage Blob Data Reader
resource searchStorageReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(storageAccountResourceId) && !empty(aiSearchPrincipalId)) {
  name: guid(solutionName, storageAccount.id, aiSearchPrincipalId, roleDefinitions.storageBlobDataReader)
  scope: storageAccount
  properties: {
    principalId: aiSearchPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.storageBlobDataReader)
    principalType: 'ServicePrincipal'
  }
}

// Backend App Service → Storage Blob Data Contributor
resource backendAppStorageBlobContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(storageAccountResourceId) && !empty(backendAppServicePrincipalId)) {
  name: guid(solutionName, storageAccount.id, backendAppServicePrincipalId, roleDefinitions.storageBlobDataContributor)
  scope: storageAccount
  properties: {
    principalId: backendAppServicePrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.storageBlobDataContributor)
    principalType: 'ServicePrincipal'
  }
}

// Backend App Service → Storage Queue Data Contributor
resource backendAppStorageQueueContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(storageAccountResourceId) && !empty(backendAppServicePrincipalId)) {
  name: guid(solutionName, storageAccount.id, backendAppServicePrincipalId, roleDefinitions.storageQueueDataContributor)
  scope: storageAccount
  properties: {
    principalId: backendAppServicePrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.storageQueueDataContributor)
    principalType: 'ServicePrincipal'
  }
}

// ============================================================================
// 4. COSMOS DB ROLE ASSIGNMENTS
//    Backend App Service → Cosmos DB (data-plane, uses sqlRoleAssignments)
// ============================================================================

resource backendAppCosmosRoleAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2025-10-15' = if (!empty(cosmosDbAccountName) && !empty(backendAppServicePrincipalId)) {
  parent: cosmosAccount
  name: guid(solutionName, cosmosContributorRoleDefinition.id, cosmosAccount.id, backendAppServicePrincipalId)
  properties: {
    principalId: backendAppServicePrincipalId
    roleDefinitionId: cosmosContributorRoleDefinition.id
    scope: cosmosAccount.id
  }
}

// ============================================================================
// 5. CONTAINER REGISTRY ROLE ASSIGNMENTS
//    Grants AcrPull to every principal in acrPullPrincipals (e.g. the deployer,
//    the backend/frontend app services, or container app identities). Mirrors
//    the AI Foundry pattern: a newly created (same resource group) registry is
//    assigned inline; an existing (reused) registry — which may live in another
//    resource group or subscription — is assigned via the cross-scope helper.
// ============================================================================

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2025-04-01' existing = if (!useExistingContainerRegistry) {
  name: containerRegistryName
}

// Each principal → AcrPull on a newly created (same resource group) container registry
resource acrPullAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for principal in acrPullPrincipals: if (!useExistingContainerRegistry && !empty(principal.principalId)) {
  name: guid(solutionName, containerRegistryName, principal.principalId, roleDefinitions.acrPull)
  scope: containerRegistry
  properties: {
    principalId: principal.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.acrPull)
    principalType: principal.principalType
  }
}]

// Each principal → AcrPull on an existing (reused) cross-scope container registry
module acrPullAssignmentsExisting './cross-scope-role-assignment.bicep' = [for principal in acrPullPrincipals: if (useExistingContainerRegistry && !empty(principal.principalId)) {
  name: take('acrPull-${uniqueString(solutionName, containerRegistryName, principal.principalId)}', 64)
  scope: resourceGroup(containerRegistrySubscription, containerRegistryResourceGroup)
  params: {
    targetResourceType: 'ContainerRegistry'
    containerRegistryName: containerRegistryName
    principalId: principal.principalId
    principalType: principal.principalType
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitions.acrPull)
    roleAssignmentName: guid(solutionName, containerRegistryName, principal.principalId, roleDefinitions.acrPull)
  }
}]
