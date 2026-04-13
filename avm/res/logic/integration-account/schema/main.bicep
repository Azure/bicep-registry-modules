metadata name = 'Integration Account Schemas'
metadata description = 'This module deploys an Integration Account Schema.'

@description('Required. The Name of the schema resource.')
param name string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@description('Conditional. The name of the parent integration account. Required if the template is used in a standalone deployment.')
param integrationAccountName string

@description('Required. The schema content.')
param content string

@description('Optional. The schema content type.')
param contentType string = 'application/xml'

@description('Optional. The document name.')
param documentName string?

@description('Optional. The metadata.')
param metadata {
  @description('Optional. A metadata key-value pair.')
  *: string?
}? // Resource-derived type fails PSRule

@description('Optional. The schema type.')
param schemaType ('NotSpecified' | 'Xml') = 'Xml'

@description('Optional. The target namespace of the schema.')
param targetNamespace string?

@description('Optional. Resource tags.')
param tags resourceInput<'Microsoft.Logic/integrationAccounts/schemas@2019-05-01'>.tags?

resource integrationAccount 'Microsoft.Logic/integrationAccounts@2019-05-01' existing = {
  name: integrationAccountName
}

resource schema 'Microsoft.Logic/integrationAccounts/schemas@2019-05-01' = {
  name: name
  parent: integrationAccount
  location: location
  properties: {
    contentType: contentType
    content: content
    documentName: documentName
    metadata: metadata
    schemaType: schemaType
    targetNamespace: targetNamespace
  }
  tags: tags
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the integration account schema.')
output resourceId string = schema.id

@description('The name of the integration account schema.')
output name string = schema.name

@description('The resource group the integration account schema was deployed into.')
output resourceGroupName string = resourceGroup().name
