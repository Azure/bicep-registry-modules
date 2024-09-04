metadata name = 'Application Gateway for Containers'
metadata description = 'This module deploys an Application Gateway for Containers'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Application Gateway for Containers to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Resource tags.')
param tags object?

@description('Optional. List of Application Gateway for Containers frontends.')
param frontends array = []

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.servicenetworking-trafficcontroller.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource trafficController 'Microsoft.ServiceNetworking/trafficControllers@2023-11-01' = {
  name: name
  location: location
  tags: tags
  properties: {}
}

module trafficController_frontends 'frontend/main.bicep' = [
  for (frontend, index) in frontends: {
    name: '${uniqueString(deployment().name, location)}-TrafficController-Frontend-${index}'
    params: {
      trafficControllerName: trafficController.name
      name: frontend.name
      location: location
    }
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the Application Gateway for Containers.')
output resourceId string = trafficController.id

@description('The name of the Application Gateway for Containers.')
output name string = trafficController.name

@description('The location the resource was deployed into.')
output location string = trafficController.location

// ================ //
// Definitions      //
// ================ //
//
// Add your User-defined-types here, if any
//
