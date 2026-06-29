metadata name = 'Web Site Slot Basic Publishing Credentials Policies'
metadata description = 'This module deploys a Web Site Slot Basic Publishing Credentials Policy.'

@description('Required. The name of the resource.')
@allowed([
  'scm'
  'ftp'
])
param name string

@description('Optional. Set to true to enable or false to disable a publishing method.')
param allow bool = true

@description('Conditional. The name of the parent web site. Required if the template is used in a standalone deployment.')
param appName string

@description('Conditional. The name of the parent web site slot. Required if the template is used in a standalone deployment.')
param slotName string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.web-site-slotbasicpubcredpolicy.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource app 'Microsoft.Web/sites@2025-03-01' existing = {
  name: appName

  resource slot 'slots' existing = {
    name: slotName
  }
}

resource basicPublishingCredentialsPolicy 'Microsoft.Web/sites/slots/basicPublishingCredentialsPolicies@2025-03-01' = {
  #disable-next-line BCP225 // False-positive. Value is required.
  name: name
  location: location
  parent: app::slot
  properties: {
    allow: allow
  }
}

@description('The name of the basic publishing credential policy.')
output name string = basicPublishingCredentialsPolicy.name

@description('The resource ID of the basic publishing credential policy.')
output resourceId string = basicPublishingCredentialsPolicy.id

@description('The name of the resource group the basic publishing credential policy was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = basicPublishingCredentialsPolicy.location
