metadata name = 'Microsoft Edge Site Resources'
metadata description = 'Resource group scoped resources for Microsoft Edge Site.'

// ============== //
//   Parameters   //
// ============== //

@sys.description('Required. Name of the resource to create.')
param name string

@sys.description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@sys.description('Optional. The description of the site.')
param description string?

@sys.description('Optional. The display name of the site.')
param displayName string = name

@sys.description('Optional. Labels for the site.')
param labels resourceInput<'Microsoft.Edge/sites@2025-03-01-preview'>.properties.labels?

@sys.description('Required. The physical address configuration of the site.')
param siteAddress resourceInput<'Microsoft.Edge/sites@2025-03-01-preview'>.properties.siteAddress

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.edge-site_rgscope.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource site 'Microsoft.Edge/sites@2025-03-01-preview' = {
  name: name
  properties: {
    description: description
    displayName: displayName
    labels: labels
    siteAddress: siteAddress
  }
}

// ============ //
// Outputs      //
// ============ //

@sys.description('The resource ID of the site.')
output resourceId string = site.id

@sys.description('The name of the site.')
output name string = site.name

@sys.description('The location the resource was deployed into.')
output location string = location

@sys.description('The name of the resource group the role assignment was applied at.')
output resourceGroupName string = resourceGroup().name
