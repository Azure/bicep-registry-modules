metadata name = 'Integration Account Partners'
metadata description = 'This module deploys an Integration Account Partner.'

@description('Required. The Name of the partner resource.')
param name string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@description('Conditional. The name of the parent integration account. Required if the template is used in a standalone deployment.')
param integrationAccountName string

@description('Optional. B2B partner content settings.')
param b2b resourceInput<'Microsoft.Logic/integrationAccounts/partners@2019-05-01'>.properties.content.b2b?

@description('Optional. The metadata.')
param metadata {
  @description('Optional. A metadata key-value pair.')
  *: string?
}? // Resource-derived type fails PSRule

@description('Optional. Resource tags.')
param tags resourceInput<'Microsoft.Logic/integrationAccounts/partners@2019-05-01'>.tags?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.logic-integrationaccount-partner.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource partner 'Microsoft.Logic/integrationAccounts/partners@2019-05-01' = {
  name: name
  parent: integrationAccount
  location: location
  properties: {
    partnerType: 'B2B'
    metadata: metadata
    content: {
      b2b: b2b
    }
  }
  tags: tags
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the integration account partner.')
output resourceId string = partner.id

@description('The name of the integration account partner.')
output name string = partner.name

@description('The resource group the integration account partner was deployed into.')
output resourceGroupName string = resourceGroup().name
