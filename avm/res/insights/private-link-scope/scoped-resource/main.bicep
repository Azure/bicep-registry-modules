metadata name = 'Private Link Scope Scoped Resources'
metadata description = 'This module deploys a Private Link Scope Scoped Resource.'

@description('Required. Name of the private link scoped resource.')
@minLength(1)
param name string

@description('Conditional. The name of the parent private link scope. Required if the template is used in a standalone deployment.')
@minLength(1)
param privateLinkScopeName string

@description('Required. The resource ID of the scoped Azure monitor resource.')
param linkedResourceId string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.insights-privatelinkscope-scopedres.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource privateLinkScope 'Microsoft.Insights/privateLinkScopes@2021-07-01-preview' existing = {
  name: privateLinkScopeName
}

resource scopedResource 'Microsoft.Insights/privateLinkScopes/scopedResources@2021-07-01-preview' = {
  name: name
  parent: privateLinkScope
  properties: {
    linkedResourceId: linkedResourceId
  }
}

@description('The name of the resource group where the resource has been deployed.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the deployed scopedResource.')
output resourceId string = scopedResource.id

@description('The full name of the deployed Scoped Resource.')
output name string = scopedResource.name
