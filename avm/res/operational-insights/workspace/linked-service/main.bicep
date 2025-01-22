metadata name = 'Log Analytics Workspace Linked Services'
metadata description = 'This module deploys a Log Analytics Workspace Linked Service.'

@description('Conditional. The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment.')
param logAnalyticsWorkspaceName string

@description('Required. Name of the link.')
param name string

@description('Optional. The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require read access.')
param resourceId string?

@description('Optional. The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require write access.')
param writeAccessResourceId string?

@description('Optional. Tags to configure in the resource.')
param tags object?

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource linkedService 'Microsoft.OperationalInsights/workspaces/linkedServices@2020-08-01' = {
  name: name
  parent: workspace
  tags: tags
  properties: {
    resourceId: resourceId
    writeAccessResourceId: writeAccessResourceId
  }
}

@description('The name of the deployed linked service.')
output name string = linkedService.name

@description('The resource ID of the deployed linked service.')
output resourceId string = linkedService.id

@description('The resource group where the linked service is deployed.')
output resourceGroupName string = resourceGroup().name
