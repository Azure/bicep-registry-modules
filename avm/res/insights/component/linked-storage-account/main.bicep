metadata name = 'Application Insights Linked Storage Account'
metadata description = 'This component deploys an Application Insights Linked Storage Account.'

@description('Conditional. The name of the parent Application Insights instance. Required if the template is used in a standalone deployment.')
param appInsightsName string

@description('Required. Linked storage account resource ID.')
param storageAccountResourceId string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.insights-component-linkedstoracct.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
}

resource linkedStorageAccount 'Microsoft.Insights/components/linkedStorageAccounts@2020-03-01-preview' = {
  name: 'ServiceProfiler'
  parent: appInsights
  properties: {
    linkedStorageAccount: storageAccountResourceId
  }
}

@description('The name of the Linked Storage Account.')
output name string = linkedStorageAccount.name

@description('The resource ID of the Linked Storage Account.')
output resourceId string = linkedStorageAccount.id

@description('The resource group the agent pool was deployed into.')
output resourceGroupName string = resourceGroup().name
