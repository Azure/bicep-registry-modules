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

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.logic-integrationaccount-certificate.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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
