metadata name = 'Fork Workflow Example'
metadata description = 'Disposable VNet pattern for fork workflow testing.'

@description('Required. Name of the resource to create.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags for the virtual network.')
param tags resourceInput<'Microsoft.Network/virtualNetworks@2025-05-01'>.tags?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var telemetryIdPrefix = loadJsonContent('metadata.json', 'telemetryIdPrefix')

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '${telemetryIdPrefix}.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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
  name: '${uniqueString(deployment().name, location)}-vnet'
  params: {
    name: name
    location: location
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

@description('The resource ID of the virtual network.')
output resourceId string = virtualNetwork.outputs.resourceId

@description('The resource group containing the virtual network.')
output resourceGroupName string = resourceGroup().name
