metadata name = 'Machine Learning Services Workspaces Datastores'
metadata description = 'This module creates a datastore in a Machine Learning Services workspace.'

// ================ //
// Parameters       //
// ================ //

@description('Required. Name of the datastore to create.')
param name string

@description('Required. The name of the parent Machine Learning Workspace.')
param machineLearningWorkspaceName string

@description('Required. The properties of the datastore.')
param properties resourceInput<'Microsoft.MachineLearningServices/workspaces/datastores@2024-10-01'>.properties

// ============================= //
// Existing resources references //
// ============================= //

resource machineLearningWorkspace 'Microsoft.MachineLearningServices/workspaces@2025-01-01-preview' existing = {
  name: machineLearningWorkspaceName
}

// ============== //
// Resources      //
// ============== //

resource datastore 'Microsoft.MachineLearningServices/workspaces/datastores@2024-10-01' = {
  name: name
  parent: machineLearningWorkspace
  properties: properties
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the datastore.')
output resourceId string = datastore.id

@description('The name of the datastore.')
output name string = datastore.name

@description('The name of the resource group the datastore was created in.')
output resourceGroupName string = resourceGroup().name
