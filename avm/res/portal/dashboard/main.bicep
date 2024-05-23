metadata name = 'Portal Dashboards'
metadata description = 'This module deploys a Portal Dashboard.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the dashboard to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The dashboard lenses.')
param lenses object[] = []

@description('Optional. The dashboard metadata.')
param metadata object?

// ============== //
// Resources      //
// ============== //

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.portal-dashboard.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource dashboard 'Microsoft.Portal/dashboards@2020-09-01-preview' = {
  name: name
  location: location
  tags: tags
  properties: {
    lenses: lenses
    metadata: metadata
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the dashboard.')
output resourceId string = dashboard.id

@description('The name of the dashboard.')
output name string = dashboard.name

@description('The location the dashboard was deployed into.')
output location string = dashboard.location

// ================ //
// Definitions      //
// ================ //
//
// Add your User-defined-types here, if any
//
