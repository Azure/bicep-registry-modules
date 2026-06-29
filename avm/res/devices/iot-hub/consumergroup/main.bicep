metadata name = 'IoT Hub Consumer Groups'
metadata description = 'This module deploys an IoT Hub Consumer Group.'

@description('Conditional. The name of the parent IoT Hub. Required if the template is used in a standalone deployment.')
param iotHubName string

@description('Required. The name of the consumer group.')
param name string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.iot-hub-consumer-group.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource iotHub 'Microsoft.Devices/IotHubs@2025-08-01-preview' existing = {
  name: iotHubName
}

resource consumerGroup 'Microsoft.Devices/IotHubs/eventHubEndpoints/ConsumerGroups@2023-06-30' = {
  name: '${iotHub.name}/events/${name}'
  properties: {
    name: name
  }
}

@description('The name of the consumer group.')
output name string = consumerGroup.name

@description('The resource ID of the consumer group.')
output resourceId string = consumerGroup.id

@description('The name of the resource group the consumer group was created in.')
output resourceGroupName string = resourceGroup().name
