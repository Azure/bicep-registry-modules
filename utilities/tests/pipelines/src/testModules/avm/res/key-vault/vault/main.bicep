metadata name = 'Parent module'
metadata description = 'This is a parent module for tests.'

// ================ //
// Parameters       //
// ================ //
@description('Required. An required param.')
@maxLength(24)
param requiredParam string

@description('Optional. An optional param.')
param optionalParam string?

// =========== //
// Variables   //
// =========== //

var aVariable string = 'oi'

// ============ //
// Dependencies //
// ============ //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = {
  name: '46d3xbcp.res.testModule.full.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource main 'Microsoft.KeyVault/vaults@2025-05-01' = {
  name: requiredParam
  location: aVariable
  properties: {
    sku: {
      name: requiredParam
      family: requiredParam
    }
    tenantId: tenant().tenantId
  }
}

module main_child 'secret/main.bicep' = {
  name: '${uniqueString(deployment().name)}-child'
  params: {
    requiredParam: requiredParam
  }
}

#disable-next-line use-recent-module-versions // This is just a test so we don't need to keep the module up to date
module keyVault_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.11.1' = [
  for (privateEndpoint, index) in []: {
    name: '${uniqueString(deployment().name)}-keyVault-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      name: 'wouldbeName'
      subnetResourceId: 'wouldBeSubnetResourceId'
    }
  }
]

// =========== //
// Outputs     //
// =========== //
@description('An output value.')
output anOutput string? = optionalParam
