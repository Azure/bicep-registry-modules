metadata name = 'Integration Account Maps'
metadata description = 'This module deploys an Integration Account Map.'

@description('Required. The name of the map resource.')
param name string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@description('Conditional. The name of the parent integration account. Required if the template is used in a standalone deployment.')
param integrationAccountName string

@description('Required. The content of the map.')
param content string

@description('Optional. The content type of the map.')
param contentType string?

@description('Optional. The map type.')
param mapType ('Liquid' | 'NotSpecified' | 'Xslt' | 'Xslt20' | 'Xslt30') = 'Xslt'

@description('Optional. The metadata.')
param metadata {
  @description('Optional. A metadata key-value pair.')
  *: string?
}? // Resource-derived type fails PSRule

@description('Optional. The parameters schema of integration account map.')
param parametersSchema resourceInput<'Microsoft.Logic/integrationAccounts/maps@2019-05-01'>.properties.parametersSchema?

@description('Optional. Resource tags.')
param tags resourceInput<'Microsoft.Logic/integrationAccounts/maps@2019-05-01'>.tags?

var defaultContentType = mapType == 'Liquid' ? 'application/liquid' : 'application/xml'

resource integrationAccount 'Microsoft.Logic/integrationAccounts@2019-05-01' existing = {
  name: integrationAccountName
}

resource map 'Microsoft.Logic/integrationAccounts/maps@2019-05-01' = {
  name: name
  parent: integrationAccount
  location: location
  properties: {
    content: content
    contentType: contentType ?? defaultContentType
    mapType: mapType
    metadata: metadata
    parametersSchema: parametersSchema
  }
  tags: tags
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the integration account map.')
output resourceId string = map.id

@description('The name of the integration account map.')
output name string = map.name

@description('The resource group the integration account map was deployed into.')
output resourceGroupName string = resourceGroup().name
