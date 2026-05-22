metadata name = 'API Management Workspace Policies'
metadata description = 'This module deploys a Policy at API Management Workspace scope.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Conditional. The name of the parent Workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Optional. The name of the policy.')
param name string = 'policy'

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

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName

  resource workspace 'workspaces@2024-05-01' existing = {
    name: workspaceName
  }
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.apimgmt-service-workspacepolicy.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource policy 'Microsoft.ApiManagement/service/workspaces/policies@2024-05-01' = {
  name: name
  parent: service::workspace
  properties: {
    format: format
    value: value
  }
}

@description('The resource ID of the workspace policy.')
output resourceId string = policy.id

@description('The name of the workspace policy.')
output name string = policy.name

@description('The resource group the workspace policy was deployed into.')
output resourceGroupName string = resourceGroup().name
