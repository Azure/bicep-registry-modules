metadata name = 'Dev Center Project Pool Schedule'
metadata description = 'This module deploys a Dev Center Project Pool Schedule.'

// ================ //
// Parameters       //
// ================ //

@description('Conditional. The name of the parent dev center project pool. Required if the template is used in a standalone deployment.')
param poolName string

@description('Conditional. The name of the parent dev center project. Required if the template is used in a standalone deployment.')
param projectName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Resource tags to apply to the pool.')
param tags object?

@description('Required. Indicates whether or not this scheduled task is enabled. Allowed values: Disabled, Enabled.')
@allowed([
  'Disabled'
  'Enabled'
])
param state string

@description('Required. The target time to trigger the action. The format is HH:MM. For example, "14:30" for 2:30 PM.')
param time string

@description('Required. The IANA timezone id at which the schedule should execute. For example, "Australia/Sydney", "Canada/Central".')
param timeZone string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.devcenter-project-poolschedule.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource project 'Microsoft.DevCenter/projects@2025-02-01' existing = {
  name: projectName

  resource pool 'pools@2025-02-01' existing = {
    name: poolName
  }
}

resource schedule 'Microsoft.DevCenter/projects/pools/schedules@2025-02-01' = {
  name: 'default'
  parent: project::pool
  properties: {
    frequency: 'Daily'
    location: location
    state: state
    tags: tags
    time: time
    timeZone: timeZone
    type: 'StopDevBox'
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the deployed schedule.')
output name string = schedule.name

@description('The resource ID of the deployed schedule.')
output resourceId string = schedule.id

@description('The resource group the schedule was deployed into.')
output resourceGroupName string = resourceGroup().name
