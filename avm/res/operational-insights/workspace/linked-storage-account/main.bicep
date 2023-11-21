metadata name = 'Log Analytics Workspace Linked Storage Accounts'
metadata description = 'This module deploys a Log Analytics Workspace Linked Storage Account.'
metadata owner = 'Azure/module-maintainers'

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

@description('Required. The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require read access.')
param resourceId string

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource linkedStorageAccount 'Microsoft.OperationalInsights/workspaces/linkedStorageAccounts@2020-08-01' = {
  name: name
  parent: workspace
  properties: {
    storageAccountIds: [
      resourceId
    ]
  }
}

@description('The name of the deployed linked storage account.')
output name string = linkedStorageAccount.name

@description('The resource ID of the deployed linked storage account.')
output resourceId string = linkedStorageAccount.id

@description('The resource group where the linked storage account is deployed.')
output resourceGroupName string = resourceGroup().name
