metadata name = 'API Management Workspace Loggers'
metadata description = 'This module deploys a Logger in an API Management Workspace.'

@sys.description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@sys.description('Conditional. The name of the parent Workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

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
param credentials resourceInput<'Microsoft.ApiManagement/service/workspaces/loggers@2024-05-01'>.properties.credentials?

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName

  resource workspace 'workspaces@2024-05-01' existing = {
    name: workspaceName
  }
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.apimgmt-service-workspacelogger.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource logger 'Microsoft.ApiManagement/service/workspaces/loggers@2024-05-01' = {
  name: name
  parent: service::workspace
  properties: {
    description: description
    isBuffered: isBuffered
    loggerType: type
    resourceId: targetResourceId
    ...(type != 'azureMonitor' ? { credentials: credentials } : {})
  }
}

@sys.description('The resource ID of the workspace logger.')
output resourceId string = logger.id

@sys.description('The name of the workspace logger.')
output name string = logger.name

@sys.description('The resource group the workspace logger was deployed into.')
output resourceGroupName string = resourceGroup().name
