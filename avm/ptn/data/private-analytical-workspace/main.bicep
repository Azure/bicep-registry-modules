metadata name = 'private-analytical-workspace'
metadata description = 'Using this pattern module, you can combine Azure services that frequently help with data analytics solutions.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the private analytical workspace solution and its components. Used to ensure unique resource names.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. You can specify an existing Log Analytics Workspace if you have one. If not, this module will create a new one for you.')
param logAnalyticsWorkspaceResourceId string = ''

// ============== //
// Resources      //
// ============== //

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.ptn.data-privateanalyticalworkspace.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
    64
  )
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

//
// Add your resources here
//

module dbw 'br/public:avm/res/databricks/workspace:0.4.0' = {
  name: '${name}'
  params: {
    // Required parameters
    name: '${name}'
    // Non-required parameters
    location: location
  }
}

// ============ //
// Outputs      //
// ============ //

// Add your outputs here

@description('The resource ID of the resource.')
output resourceId string = dbw.outputs.resourceId

@description('The name of the resource.')
output name string = dbw.outputs.name

@description('The location the resource was deployed into.')
output location string = dbw.outputs.location

@description('The name of the managed resource group.')
output resourceGroupName string = dbw.outputs.resourceGroupName

// ================ //
// Definitions      //
// ================ //
//
// Add your User-defined-types here, if any
//

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?
