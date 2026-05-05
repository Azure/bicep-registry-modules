// ========== existing-ai-services-roles.bicep ========== //
// Module to assign RBAC roles to managed identity on an existing AI Services account
// This is required when reusing an existing AI Foundry project from a different resource group

@description('Required. The principal ID of the managed identity to grant access.')
param principalId string

@description('Required. The name of the existing AI Services account.')
param aiServicesName string

@description('Optional. The name of the existing AI Project.')
param aiProjectName string = ''

@description('Optional. The principal type of the identity.')
@allowed([
  'Device'
  'ForeignGroup'
  'Group'
  'ServicePrincipal'
  'User'
])
param principalType string = 'ServicePrincipal'

// ========== Role Definitions ========== //

// Azure AI User role - for AI Foundry project access (used by AIProjectClient for image generation)
resource azureAiUserRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '53ca6127-db72-4b80-b1b0-d745d6d5456d'
}

// Cognitive Services OpenAI User role - for chat completions (used by AzureOpenAIChatClient)
resource cognitiveServicesOpenAiUserRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd'
}

// ========== Existing Resources ========== //

// Reference the existing AI Services account
resource existingAiServices 'Microsoft.CognitiveServices/accounts@2026-01-15-preview' existing = {
  name: aiServicesName
}

// Reference the existing AI Project (if provided)
resource existingAiProject 'Microsoft.CognitiveServices/accounts/projects@2026-01-15-preview' existing = if (!empty(aiProjectName)) {
  name: aiProjectName
  parent: existingAiServices
}

// ========== Role Assignments ========== //

// Azure AI User role assignment - same as reference accelerator
// Required for AIProjectClient (used for image generation in Foundry mode)
resource assignAzureAiUserRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(existingAiServices.id, principalId, azureAiUserRole.id)
  scope: existingAiServices
  properties: {
    roleDefinitionId: azureAiUserRole.id
    principalId: principalId
    principalType: principalType
  }
}

// Cognitive Services OpenAI User role assignment
// Required for AzureOpenAIChatClient (used for chat completions)
resource assignCognitiveServicesOpenAiUserRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(existingAiServices.id, principalId, cognitiveServicesOpenAiUserRole.id)
  scope: existingAiServices
  properties: {
    roleDefinitionId: cognitiveServicesOpenAiUserRole.id
    principalId: principalId
    principalType: principalType
  }
}

// ========== Outputs ========== //

@description('The resource ID of the existing AI Services account.')
output aiServicesResourceId string = existingAiServices.id

@description('The endpoint of the existing AI Services account.')
output aiServicesEndpoint string = existingAiServices.properties.endpoint

@description('The principal ID of the existing AI Project (if provided).')
output aiProjectPrincipalId string = !empty(aiProjectName) ? existingAiProject.?identity.?principalId ?? '' : ''
