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

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.opins-worksp-linkedstgaccount.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource linkedStorageAccount 'Microsoft.OperationalInsights/workspaces/linkedStorageAccounts@2025-07-01' = {
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
