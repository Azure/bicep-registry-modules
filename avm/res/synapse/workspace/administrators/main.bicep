metadata name = 'Synapse Workspaces Administrators'
metadata description = 'This module deploys Synapse Workspaces Administrators.'

@description('Conditional. The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Required. Workspace active directory administrator type.')
param administratorType string

@description('Required. Login of the workspace active directory administrator.')
@secure()
param login string

@description('Required. Object ID of the workspace active directory administrator.')
@secure()
param sid string

@description('Optional. Tenant ID of the workspace active directory administrator.')
param tenantId string = tenant().tenantId

resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = {
  name: workspaceName
}

resource synapse_workspace_administrator 'Microsoft.Synapse/workspaces/administrators@2021-06-01' = {
  name: 'activeDirectory'
  parent: workspace
  properties: {
    administratorType: administratorType
    login: login
    sid: sid
    tenantId: tenantId
  }
}

@description('The name of the deployed administrator.')
output name string = synapse_workspace_administrator.name

@description('The resource ID of the deployed administrator.')
output resourceId string = synapse_workspace_administrator.id

@description('The resource group of the deployed administrator.')
output resourceGroupName string = resourceGroup().name
