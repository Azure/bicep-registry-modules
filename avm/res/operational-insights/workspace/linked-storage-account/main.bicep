metadata name = 'Log Analytics Workspace Linked Storage Accounts'
metadata description = 'This module deploys a Log Analytics Workspace Linked Storage Account.'

@description('Conditional. The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment.')
param logAnalyticsWorkspaceName string

@description('Required. Name of the link.')
@allowed([
  'Query'
  'Alerts'
  'CustomLogs'
  'AzureWatson'
])
param name string

@minLength(1)
@description('Required. Linked storage accounts resources Ids.')
param storageAccountIds string[]

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource linkedStorageAccount 'Microsoft.OperationalInsights/workspaces/linkedStorageAccounts@2020-08-01' = {
  name: name
  parent: workspace
  properties: {
    storageAccountIds: storageAccountIds
  }
}

@description('The name of the deployed linked storage account.')
output name string = linkedStorageAccount.name

@description('The resource ID of the deployed linked storage account.')
output resourceId string = linkedStorageAccount.id

@description('The resource group where the linked storage account is deployed.')
output resourceGroupName string = resourceGroup().name
