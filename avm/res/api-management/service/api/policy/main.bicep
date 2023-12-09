metadata name = 'API Management Service APIs Policies'
metadata description = 'This module deploys an API Management Service API Policy.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Conditional. The name of the parent API. Required if the template is used in a standalone deployment.')
param apiName string

@description('Optional. The name of the policy.')
param name string = 'policy'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Format of the policyContent.')
@allowed([
  'rawxml'
  'rawxml-link'
  'xml'
  'xml-link'
])
param format string = 'xml'

@description('Required. Contents of the Policy as defined by the format.')
param value string

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

  resource api 'apis@2021-08-01' existing = {
    name: apiName
  }
}

resource policy 'Microsoft.ApiManagement/service/apis/policies@2021-08-01' = {
  name: name
  parent: service::api
  properties: {
    format: format
    value: value
  }
}

@description('The resource ID of the API policy.')
output resourceId string = policy.id

@description('The name of the API policy.')
output name string = policy.name

@description('The resource group the API policy was deployed into.')
output resourceGroupName string = resourceGroup().name
