metadata name = 'API Management Service APIs Diagnostics.'
metadata description = 'This module deploys an API Management Service API Diagnostics.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Conditional. The name of the parent API. Required if the template is used in a standalone deployment.')
param apiName string

@description('Conditional. The name of the logger. Required if the template is used in a standalone deployment.')
param loggerName string

@description('Optional. The name of the diagnostic.')
param name string = 'applicationinsights'

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName

  resource api 'apis@2021-08-01' existing = {
    name: apiName
  }

  resource logger 'loggers@2021-08-01' existing = {
    name: loggerName
  }
}

resource diagnostic 'Microsoft.ApiManagement/service/apis/diagnostics@2021-08-01' = {
  name: name
  parent: service::api
  properties: {
    loggerId: service::logger.id
  }
}

@description('The resource ID of the API diagnostic.')
output resourceId string = diagnostic.id

@description('The name of the API diagnostic.')
output name string = diagnostic.name

@description('The resource group the API diagnostic was deployed into.')
output resourceGroupName string = resourceGroup().name
