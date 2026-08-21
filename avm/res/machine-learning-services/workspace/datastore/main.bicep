metadata name = 'Machine Learning Services Workspaces Datastores'
metadata description = 'This module creates a datastore in a Machine Learning Services workspace.'

// ================ //
// Parameters       //
// ================ //

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.mlservices-workspace-datastore.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

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
