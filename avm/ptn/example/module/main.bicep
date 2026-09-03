metadata name = 'Azure Verified Module Example'
metadata description = '''Deploys a virtual network as a canary for Azure Verified Modules tooling and publishing processes.

**Warning:** This module is maintained by the Azure Verified Modules team for internal testing only. It is not production-ready and must not be used by consumers.'''

@description('Required. The name of the virtual network.')
param name string

@description('Optional. The address prefixes for the virtual network.')
param addressPrefixes string[] = [
  '10.0.0.0/24'
]

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.example-module.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

module virtualNetwork 'br/public:avm/res/network/virtual-network:0.10.2' = {
  name: 'virtualNetwork'
  params: {
    name: name
    addressPrefixes: addressPrefixes
    location: location
    enableTelemetry: enableTelemetry
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource group the virtual network was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the virtual network.')
output resourceId string = virtualNetwork.outputs.resourceId

@description('The name of the virtual network.')
output name string = virtualNetwork.outputs.name

@description('The location the virtual network was deployed into.')
output location string = virtualNetwork.outputs.location
