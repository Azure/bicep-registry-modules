// =========================================================================== //
// AI Foundry Project (child of an existing Cognitive Services AIServices acct) //
// =========================================================================== //

@description('Required. Name of the AI Foundry project to create.')
param name string

@description('Optional. The location of the AI Foundry project. Defaults to the resource group location.')
param location string = resourceGroup().location

@description('Optional. The description of the AI Foundry project. Defaults to the project name.')
param desc string = name

@description('Required. Name of the existing Cognitive Services (AIServices kind) account in which to create the project.')
param aiServicesName string

@description('Optional. Tags to apply to the project.')
param tags object = {}

resource cogServiceReference 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = {
  name: aiServicesName
}

resource aiProject 'Microsoft.CognitiveServices/accounts/projects@2025-06-01' = {
  parent: cogServiceReference
  name: name
  tags: tags
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    description: desc
    displayName: name
  }
}

@description('Name of the AI Foundry project.')
output name string = aiProject.name

@description('Resource ID of the AI Foundry project.')
output resourceId string = aiProject.id

@description('Principal ID of the AI Foundry project system-assigned managed identity.')
output principalId string = aiProject.identity.principalId

@description('AI Foundry API endpoint exposed by the project.')
output apiEndpoint string = aiProject!.properties.endpoints['AI Foundry API']
