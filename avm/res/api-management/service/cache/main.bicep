metadata name = 'API Management Service Caches'
metadata description = 'This module deploys an API Management Service Cache.'
metadata owner = 'Azure/module-maintainers'

@sys.description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@sys.description('Required. Identifier of the Cache entity. Cache identifier (should be either \'default\' or valid Azure region identifier).')
param name string

@sys.description('Required. Runtime connection string to cache. Can be referenced by a named value like so, {{<named-value>}}.')
param connectionString string

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@sys.description('Optional. Cache description.')
param description string = ''

@sys.description('Optional. Original uri of entity in external system cache points to.')
param resourceId string = ''

@sys.description('Required. Location identifier to use cache from (should be either \'default\' or valid Azure region identifier).')
param useFromLocation string

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

resource cache 'Microsoft.ApiManagement/service/caches@2021-08-01' = {
  name: name
  parent: service
  properties: {
    description: !empty(description) ? description : null
    connectionString: connectionString
    useFromLocation: useFromLocation
    resourceId: !empty(resourceId) ? resourceId : null
  }
}

@sys.description('The resource ID of the API management service cache.')
output resourceId string = cache.id

@sys.description('The name of the API management service cache.')
output name string = cache.name

@sys.description('The resource group the API management service cache was deployed into.')
output resourceGroupName string = resourceGroup().name
