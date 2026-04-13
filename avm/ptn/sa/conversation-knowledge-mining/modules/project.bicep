@description('Required. Name of the AI Services project.')
param name string

@description('Required. The location of the Project resource.')
param location string = resourceGroup().location

@description('Optional. The description of the AI Foundry project to create. Defaults to the project name.')
param desc string = name

@description('Required. Name of the existing Cognitive Services resource to create the AI Foundry project in.')
param aiServicesName string

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

@description('Optional. Use this parameter to use an existing AI project resource ID from different resource group')
param existingFoundryProjectResourceId string = ''

// // Extract components from existing AI Project Resource ID if provided
var useExistingProject = !empty(existingFoundryProjectResourceId)
var existingProjName = useExistingProject ? last(split(existingFoundryProjectResourceId, '/')) : ''
var existingAiFoundryAiServicesSubscriptionId = useExistingProject ? split(existingFoundryProjectResourceId, '/')[2] : ''
var existingAiFoundryAiServicesResourceGroupName = useExistingProject ? split(existingFoundryProjectResourceId, '/')[4] : ''
var existingAiFoundryAiServicesServiceName = useExistingProject ? split(existingFoundryProjectResourceId, '/')[8] : ''
// Example endpoint (only if existing project provided)
var existingProjEndpoint = useExistingProject ? format('https://{0}.services.ai.azure.com/api/projects/{1}', existingAiFoundryAiServicesServiceName, existingProjName) : ''
// Reference to cognitive service in current resource group for new projects
resource cogServiceReference 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = {
  name: aiServicesName
}

// Create new AI project only if not reusing existing one
resource aiProject 'Microsoft.CognitiveServices/accounts/projects@2025-06-01' = if(!useExistingProject) {
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

// Reference the existing AI Foundry project if reusing
resource existingAiProject 'Microsoft.CognitiveServices/accounts/projects@2025-06-01' existing = if (useExistingProject){
  name: '${existingAiFoundryAiServicesServiceName}/${existingProjName}'
  scope: resourceGroup(existingAiFoundryAiServicesSubscriptionId, existingAiFoundryAiServicesResourceGroupName)
}

@description('AI Project metadata including name, resource ID, and API endpoint.')
output aiProjectInfo aiProjectOutputType = {
  name: useExistingProject ? existingProjName : aiProject.name
  resourceId: useExistingProject ? existingFoundryProjectResourceId : aiProject.id
  apiEndpoint: useExistingProject ? existingProjEndpoint : aiProject!.properties.endpoints['AI Foundry API']
  aiprojectSystemAssignedMIPrincipalId : useExistingProject ? existingAiProject!.identity.principalId : aiProject!.identity.principalId
}

@export()
@description('Output type representing AI project information.')
type aiProjectOutputType = {
  @description('Required. Name of the AI project.')
  name: string

  @description('Required. Resource ID of the AI project.')
  resourceId: string

  @description('Required. API endpoint for the AI project.')
  apiEndpoint: string

  @description('Required. System Assigned Managed Identity Principal Id of the AI project.')
  aiprojectSystemAssignedMIPrincipalId: string
}
