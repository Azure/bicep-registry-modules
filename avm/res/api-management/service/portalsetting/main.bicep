metadata name = 'API Management Service Portal Settings'
metadata description = 'This module deploys an API Management Service Portal Setting.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Required. Portal setting name.')
@allowed([
  'delegation'
  'signin'
  'signup'
])
param name string

@description('Optional. Portal setting properties.')
param properties object = {}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource portalSetting 'Microsoft.ApiManagement/service/portalsettings@2021-08-01' = if (!empty(properties)) {
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
