metadata name = 'Microsoft Edge Site Resources'
metadata description = 'Resource group scoped resources for Microsoft Edge Site.'

// ============== //
//   Parameters   //
// ============== //

@description('Required. Name of the resource to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

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

@description('The name of the resource group the role assignment was applied at.')
output resourceGroupName string = resourceGroup().name
