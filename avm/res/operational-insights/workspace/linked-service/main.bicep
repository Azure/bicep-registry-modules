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
param tags resourceInput<'Microsoft.OperationalInsights/workspaces/linkedServices@2025-07-01'>.tags?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.opins-worksp-linkedservice.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource workspace 'Microsoft.OperationalInsights/workspaces@2025-07-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource linkedService 'Microsoft.OperationalInsights/workspaces/linkedServices@2025-07-01' = {
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
