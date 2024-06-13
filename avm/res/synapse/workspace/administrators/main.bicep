metadata name = 'Synapse Workspaces Administrators'
metadata description = 'This module deploys Synapse Workspaces Administrators.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Required. The administrators definition.')
param administrator adminType

resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = {
  name: workspaceName
}

resource synapse_workspace_administrator 'Microsoft.Synapse/workspaces/administrators@2021-06-01' = if (!empty(administrator)) {
  name: 'activeDirectory'
  parent: workspace
  properties: {
    administratorType: administrator.administratorType
    login: administrator.login
    sid: administrator.sid
    tenantId: subscription().tenantId
  }
}

@description('The name of the deployed administrator.')
output name string = synapse_workspace_administrator.name

@description('The resource ID of the deployed administrator.')
output resourceId string = synapse_workspace_administrator.id

@description('The resource group of the deployed administrator.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //

@export()
type adminType = {
  @description('Optional. Workspace active directory administrator type.')
  administratorType: string?

  @description('Optional. Login of the workspace active directory administrator.')
  @secure()
  login: string?

  @description('Optional. Object ID of the workspace active directory administrator.')
  @secure()
  sid: string?
}
