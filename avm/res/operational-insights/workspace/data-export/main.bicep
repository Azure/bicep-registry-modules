metadata name = 'Log Analytics Workspace Data Exports'
metadata description = 'This module deploys a Log Analytics Workspace Data Export.'
metadata owner = 'Azure/module-maintainers'

// ============== //
//   Parameters   //
// ============== //

@description('Required. The data export rule name.')
@minLength(4)
@maxLength(63)
param name string

@description('Conditional. The name of the parent workspaces. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Optional. Destination properties.')
param destination object = {}

@description('Optional. Active when enabled.')
param enable bool = false

@description('Optional. An array of tables to export, for example: [\'Heartbeat\', \'SecurityEvent\'].')
param tableNames array = []

// =============== //
//   Deployments   //
// =============== //

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: workspaceName
}

resource dataExport 'Microsoft.OperationalInsights/workspaces/dataExports@2020-08-01' = {
  parent: workspace
  name: name
  properties: {
    destination: destination
    enable: enable
    tableNames: tableNames
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the data export.')
output name string = dataExport.name

@description('The resource ID of the data export.')
output resourceId string = dataExport.id

@description('The name of the resource group the data export was created in.')
output resourceGroupName string = resourceGroup().name
