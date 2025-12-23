metadata name = 'Integration Account Certificates'
metadata description = 'This module deploys an Integration Account Certificate.'

@description('Required. The Name of the certificate resource.')
param name string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@description('Conditional. The name of the parent integration account. Required if the template is used in a standalone deployment.')
param integrationAccountName string

@description('Optional. The key details in the key vault.')
param key resourceInput<'Microsoft.Logic/integrationAccounts/certificates@2019-05-01'>.properties.key?

@description('Optional. The certificate metadata.')
param metadata resourceInput<'Microsoft.Logic/integrationAccounts/certificates@2019-05-01'>.properties.metadata?

@description('Optional. The public certificate.')
param publicCertificate string?

@description('Optional. Resource tags.')
param tags resourceInput<'Microsoft.Logic/integrationAccounts/certificates@2019-05-01'>.tags?

resource integrationAccount 'Microsoft.Logic/integrationAccounts@2019-05-01' existing = {
  name: integrationAccountName
}

resource certificate 'Microsoft.Logic/integrationAccounts/certificates@2019-05-01' = {
  name: name
  parent: integrationAccount
  location: location
  properties: {
    key: key
    metadata: metadata
    publicCertificate: publicCertificate
  }
  tags: tags
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the integration account certificate.')
output resourceId string = certificate.id

@description('The name of the integration account certificate.')
output name string = certificate.name

@description('The resource group the integration account certificate was deployed into.')
output resourceGroupName string = resourceGroup().name
