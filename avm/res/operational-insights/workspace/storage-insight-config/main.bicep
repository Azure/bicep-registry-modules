metadata name = 'Log Analytics Workspace Storage Insight Configs'
metadata description = 'This module deploys a Log Analytics Workspace Storage Insight Config.'

@description('Conditional. The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment.')
param logAnalyticsWorkspaceName string

@description('Optional. The name of the storage insights config.')
param name string = '${last(split(storageAccountResourceId, '/'))}-stinsconfig'

@description('Required. The Azure Resource Manager ID of the storage account resource.')
param storageAccountResourceId string

@description('Optional. The names of the blob containers that the workspace should read.')
param containers string[]?

@description('Optional. The names of the Azure tables that the workspace should read.')
param tables string[]?

@description('Optional. Tags to configure in the resource.')
param tags object?

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: last(split(storageAccountResourceId, '/'))!
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource storageinsightconfig 'Microsoft.OperationalInsights/workspaces/storageInsightConfigs@2020-08-01' = {
  name: name
  parent: workspace
  tags: tags
  properties: {
    containers: containers
    tables: tables
    storageAccount: {
      id: storageAccountResourceId
      key: storageAccount.listKeys().keys[0].value
    }
  }
}

@description('The resource ID of the deployed storage insights configuration.')
output resourceId string = storageinsightconfig.id

@description('The resource group where the storage insight configuration is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The name of the storage insights configuration.')
output name string = storageinsightconfig.name
