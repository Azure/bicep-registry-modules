metadata name = 'Security Insights (Microsoft Sentinel)'
metadata description = 'This module deploys Security Insights (Microsoft Sentinel) instance and its resources.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The resource ID of the Log Analytics workspace where Security Insights (Microsoft Sentinel) will be deployed.')
param workspaceResourceId string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Status of the CMK setting')
param customerManagedKey bool = false

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.security-insights-onboarding-states.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: last(split(workspaceResourceId, '/'))
}

resource securityInsights 'Microsoft.SecurityInsights/onboardingStates@2025-01-01-preview' = {
  scope: workspace
  name: 'default'
  properties: {
    customerManagedKey: customerManagedKey
  }
}

@description('The name of the deployed Security Insights (Microsoft Sentinel) instance.')
output name string = securityInsights.name

@description('The resource ID of the deployed Security Insights (Microsoft Sentinel) instance.')
output resourceId string = securityInsights.id

@description('The resource group where the Security Insights (Microsoft Sentinel) instance is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = location
