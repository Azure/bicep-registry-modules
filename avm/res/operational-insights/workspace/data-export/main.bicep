metadata name = 'Log Analytics Workspace Data Exports'
metadata description = 'This module deploys a Log Analytics Workspace Data Export.'

// ============== //
//   Parameters   //
// ============== //

@description('Required. The data export rule name.')
@minLength(4)
@maxLength(63)
param name string

@description('Conditional. The name of the parent workspaces. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Optional. Destination properties.')
param destination destinationType?

@description('Optional. Active when enabled.')
param enable bool = false

@minLength(1)
@description('Required. An array of tables to export, for example: [\'Heartbeat\', \'SecurityEvent\'].')
param tableNames string[]

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// =============== //
//   Deployments   //
// =============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.opins-worksp-dataexport.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource workspace 'Microsoft.OperationalInsights/workspaces@2025-07-01' existing = {
  name: workspaceName
}

resource dataExport 'Microsoft.OperationalInsights/workspaces/dataExports@2025-07-01' = {
  parent: workspace
  name: name
  properties: {
    destination: destination
    enable: enable
    tableNames: tableNames
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the data export.')
output name string = dataExport.name

@description('The resource ID of the data export.')
output resourceId string = dataExport.id

@description('The name of the resource group the data export was created in.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The data export destination properties.')
type destinationType = {
  @description('Required. The destination resource ID.')
  resourceId: string
  @description('Optional. The destination metadata.')
  metaData: {
    @description('Optional. Allows to define an Event Hub name. Not applicable when destination is Storage Account.')
    eventHubName: string?
  }?
}
