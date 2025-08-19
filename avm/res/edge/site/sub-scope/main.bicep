targetScope = 'subscription'

// ============== //
//   Parameters   //
// ============== //

@description('Required. Name of the resource to create.')
param name string

@description('Required. Location for all Resources.')
param location string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The description of the site.')
param siteDescription resourceInput<'Microsoft.Edge/sites@2025-03-01-preview'>.properties.description?

@description('Optional. The display name of the site.')
param displayName resourceInput<'Microsoft.Edge/sites@2025-03-01-preview'>.properties.displayName = name

@description('Optional. Labels for the site.')
param labels resourceInput<'Microsoft.Edge/sites@2025-03-01-preview'>.properties.labels?

@description('Required. The physical address configuration of the site.')
param siteAddress resourceInput<'Microsoft.Edge/sites@2025-03-01-preview'>.properties.siteAddress

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.edge-site.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  location: location
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

// Deploy Edge Site at subscription scope
resource site 'Microsoft.Edge/sites@2025-03-01-preview' = {
  name: name
  properties: {
    description: siteDescription
    displayName: displayName
    labels: labels
    siteAddress: siteAddress
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the site.')
output resourceId string = site.id

@description('The name of the site.')
output name string = site.name

@description('The location the resource was deployed into.')
output location string = location
