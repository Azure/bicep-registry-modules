metadata name = 'API Management Service Caches'
metadata description = 'This module deploys an API Management Service Cache.'

@sys.description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@sys.description('Required. Identifier of the Cache entity. Cache identifier (should be either \'default\' or valid Azure region identifier).')
param name string

@sys.description('Required. Runtime connection string to cache. Can be referenced by a named value like so, {{<named-value>}}.')
param connectionString string

@sys.description('Optional. Cache description.')
param description string?

@sys.description('Optional. Original uri of entity in external system cache points to.')
param resourceId string?

@sys.description('Required. Location identifier to use cache from (should be either \'default\' or valid Azure region identifier).')
param useFromLocation string

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.apimgmt-cache.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource cache 'Microsoft.ApiManagement/service/caches@2024-05-01' = {
  name: name
  parent: service
  properties: {
    description: description
    connectionString: connectionString
    useFromLocation: useFromLocation
    resourceId: resourceId
  }
}

@sys.description('The resource ID of the API management service cache.')
output resourceId string = cache.id

@sys.description('The name of the API management service cache.')
output name string = cache.name

@sys.description('The resource group the API management service cache was deployed into.')
output resourceGroupName string = resourceGroup().name
