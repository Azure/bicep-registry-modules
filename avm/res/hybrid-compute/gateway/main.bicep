metadata name = 'Azure Arc Gateway'
metadata description = 'This module deploys a Azure Arc Gateway.'

@description('Required. Name of the resource to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Specifies the list of features that are enabled for this Gateway.')
param allowedFeatures string[] = ['*']

@description('Optional. The type of the Gateway resource.')
@allowed([
  'Public'
])
param gatewayType string = 'Public'

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.hybridcompute-gateway.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource gateway 'Microsoft.HybridCompute/gateways@2024-07-31-preview' = {
  name: name
  location: location
  tags: tags
  properties: {
    allowedFeatures: allowedFeatures
    gatewayType: gatewayType
  }
}

resource gateway_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: gateway
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the resource.')
output resourceId string = gateway.id

@description('The name of the resource.')
output name string = gateway.name

@description('The location the resource was deployed into.')
output location string = gateway.location

@description('The resource group of the deployed storage account.')
output resourceGroupName string = resourceGroup().name

