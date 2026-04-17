metadata name = 'Dev Center Environment Type'
metadata description = 'This module deploys a Dev Center Environment Type.'

// ================ //
// Parameters       //
// ================ //

@description('Conditional. The name of the parent dev center. Required if the template is used in a standalone deployment.')
param devcenterName string

@description('Required. The name of the environment type.')
param name string

@description('Optional. The display name of the environment type.')
param displayName string?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.DevCenter/devcenters/environmentTypes@2025-02-01'>.tags?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.devcenter-devcenter-environmenttype.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource devcenter 'Microsoft.DevCenter/devcenters@2025-02-01' existing = {
  name: devcenterName
}

resource environmentType 'Microsoft.DevCenter/devcenters/environmentTypes@2025-02-01' = {
  parent: devcenter
  name: name
  properties: {
    displayName: displayName
  }
  tags: tags
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the resource group the Dev Center Environment Type was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Dev Center Environment Type.')
output name string = environmentType.name

@description('The resource ID of the Dev Center Environment Type.')
output resourceId string = environmentType.id
