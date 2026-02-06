targetScope = 'subscription'

metadata name = 'Multi-scope module'
metadata description = 'This is a multi-scope module for tests.'

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
  name: '46d3xbcp.res.testModule.multi-scope.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource role 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: requiredParam
  properties: {
    principalId: requiredParam
    roleDefinitionId: aVariable
  }
}

// =========== //
// Outputs     //
// =========== //
@description('An output value.')
output anOutput string? = optionalParam
