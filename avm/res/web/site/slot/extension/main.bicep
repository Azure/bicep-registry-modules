metadata name = 'Site Deployment Extension '
metadata description = 'This module deploys a Site extension for MSDeploy.'

@description('Conditional. The name of the parent site resource. Required if the template is used in a standalone deployment.')
param appName string

@description('Conditional. The name of the parent web site slot. Required if the template is used in a standalone deployment.')
param slotName string

@description('Optional. The name of the extension.')
@allowed([
  'MSDeploy'
])
param name string = 'MSDeploy'

@description('Optional. The kind of extension.')
@allowed([
  'MSDeploy'
])
param kind string = 'MSDeploy'

@description('Optional. Sets the properties.')
param properties resourceInput<'Microsoft.Web/sites/extensions@2024-04-01'>.properties?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.web-site-slotextension.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource app 'Microsoft.Web/sites@2025-03-01' existing = {
  name: appName

  resource slot 'slots' existing = {
    name: slotName
  }
}
resource msdeploy 'Microsoft.Web/sites/slots/extensions@2025-03-01' = {
  name: name
  kind: kind
  parent: app::slot
  properties: properties
}

@description('The name of the extension.')
output name string = msdeploy.name

@description('The resource ID of the extension.')
output resourceId string = msdeploy.id

@description('The resource group the extensino was deployed into.')
output resourceGroupName string = resourceGroup().name
