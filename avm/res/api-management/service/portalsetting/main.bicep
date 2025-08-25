metadata name = 'API Management Service Portal Settings'
metadata description = 'This module deploys an API Management Service Portal Setting.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Required. Portal setting name.')
@allowed([
  'delegation'
  'signin'
  'signup'
])
param name string

@description('Required. Portal setting properties.')
param properties resourceInput<'Microsoft.ApiManagement/service/portalsettings@2024-05-01'>.properties

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.apimgmt-portalsetting.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource portalSetting 'Microsoft.ApiManagement/service/portalsettings@2024-05-01' = {
  name: any(name)
  parent: service
  properties: properties
}

@description('The resource ID of the API management service portal setting.')
output resourceId string = portalSetting.id

@description('The name of the API management service portal setting.')
output name string = portalSetting.name

@description('The resource group the API management service portal setting was deployed into.')
output resourceGroupName string = resourceGroup().name
