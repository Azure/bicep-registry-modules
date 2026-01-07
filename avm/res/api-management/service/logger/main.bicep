metadata name = 'API Management Service Loggers'
metadata description = 'This module deploys an API Management Service Logger.'

@sys.description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@sys.description('Required. Logger name.')
param name string

@sys.description('Optional. Description of the logger.')
@maxLength(256)
param description string?

@sys.description('Optional. Whether records are buffered in the logger before publishing.')
param isBuffered bool = true

@sys.description('Required. Logger type.')
@allowed([
  'applicationInsights'
  'azureEventHub'
  'azureMonitor'
])
param type string

@sys.description('Conditional. Azure Resource Id of a log target (either Azure Event Hub resource or Azure Application Insights resource). Required if loggerType = applicationInsights or azureEventHub.')
param targetResourceId string?

@secure()
@sys.description('Conditional. The name and SendRule connection string of the event hub for azureEventHub logger. Instrumentation key for applicationInsights logger. Required if loggerType = applicationInsights or azureEventHub, ignored if loggerType = azureMonitor.')
param credentials resourceInput<'Microsoft.ApiManagement/service/loggers@2024-05-01'>.properties.credentials?

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.apimgmt-logger.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource logger 'Microsoft.ApiManagement/service/loggers@2024-05-01' = {
  name: name
  parent: service
  properties: {
    description: description
    isBuffered: isBuffered
    loggerType: type
    resourceId: targetResourceId
    ...(type != 'azureMonitor' ? { credentials: credentials } : {})
  }
}

@sys.description('The resource ID of the logger.')
output resourceId string = logger.id

@sys.description('The name of the logger.')
output name string = logger.name

@sys.description('The resource group the logger was deployed into.')
output resourceGroupName string = resourceGroup().name
