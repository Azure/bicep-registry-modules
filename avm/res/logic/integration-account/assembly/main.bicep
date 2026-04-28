metadata name = 'Integration Account Assemblies'
metadata description = 'This module deploys an Integration Account Assembly.'

@description('Required. The Name of the assembly resource.')
param name string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@description('Conditional. The name of the parent integration account. Required if the template is used in a standalone deployment.')
param integrationAccountName string

@description('Required. The assembly name.')
param assemblyName string

@description('Required. The Base64-encoded assembly content.')
@secure()
param content string

@description('Optional. The assembly content type.')
param contentType string = 'application/octet-stream'

@description('Optional. The assembly metadata.')
param metadata resourceInput<'Microsoft.Logic/integrationAccounts/assemblies@2019-05-01'>.properties.metadata?

@description('Optional. Resource tags.')
param tags resourceInput<'Microsoft.Logic/integrationAccounts/assemblies@2019-05-01'>.tags?

resource integrationAccount 'Microsoft.Logic/integrationAccounts@2019-05-01' existing = {
  name: integrationAccountName
}

resource assembly 'Microsoft.Logic/integrationAccounts/assemblies@2019-05-01' = {
  name: name
  parent: integrationAccount
  location: location
  properties: {
    assemblyName: assemblyName
    content: content
    contentType: contentType
    metadata: metadata
  }
  tags: tags
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the integration account assembly.')
output resourceId string = assembly.id

@description('The name of the integration account assembly.')
output name string = assembly.name

@description('The resource group the integration account assembly was deployed into.')
output resourceGroupName string = resourceGroup().name
