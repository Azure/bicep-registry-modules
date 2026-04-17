metadata name = 'Dev Center Attached Network'
metadata description = 'This module deploys a Dev Center Attached Network.'

// ================ //
// Parameters       //
// ================ //

@description('Conditional. The name of the parent dev center. Required if the template is used in a standalone deployment.')
param devcenterName string

@description('Required. The name of the attached network.')
@minLength(3)
@maxLength(63)
param name string

@description('Required. The resource ID of the Network Connection you want to attach to the Dev Center.')
param networkConnectionResourceId string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.devcenter-devcenter-attachednetwork.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource attachedNetwork 'Microsoft.DevCenter/devcenters/attachednetworks@2025-02-01' = {
  parent: devcenter
  name: name
  properties: {
    networkConnectionId: networkConnectionResourceId
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the resource group the Dev Center Attached Network was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Dev Center Attached Network.')
output name string = attachedNetwork.name

@description('The resource ID of the Dev Center Attached Network.')
output resourceId string = attachedNetwork.id
