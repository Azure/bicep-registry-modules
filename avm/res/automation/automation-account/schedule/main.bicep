metadata name = 'Automation Account Schedules'
metadata description = 'This module deploys an Azure Automation Account Schedule.'

@sys.description('Required. Name of the Automation Account schedule.')
param name string

@sys.description('Conditional. The name of the parent Automation Account. Required if the template is used in a standalone deployment.')
param automationAccountName string

@sys.description('Optional. The properties of the create Advanced Schedule.')
@metadata({
  monthDays: 'Days of the month that the job should execute on. Must be between 1 and 31.'
  monthlyOccurrences: 'Occurrences of days within a month.'
  weekDays: 'Days of the week that the job should execute on.'
})
param advancedSchedule object = {}

@sys.description('Optional. The description of the schedule.')
param description string = ''

@sys.description('Optional. The end time of the schedule.')
param expiryTime string = ''

@allowed([
  'Day'
  'Hour'
  'Minute'
  'Month'
  'OneTime'
  'Week'
])
@sys.description('Optional. The frequency of the schedule.')
param frequency string = 'OneTime'

@sys.description('Optional. Anything.')
param interval int = 0

@sys.description('Optional. The start time of the schedule.')
param startTime string = ''

@sys.description('Optional. The time zone of the schedule.')
param timeZone string = ''

@sys.description('Generated. Time used as a basis for e.g. the schedule start date.')
param baseTime string = utcNow('u')

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.aut-autacct-schedule.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource automationAccount 'Microsoft.Automation/automationAccounts@2024-10-23' existing = {
  name: automationAccountName
}

resource schedule 'Microsoft.Automation/automationAccounts/schedules@2024-10-23' = {
  name: name
  parent: automationAccount
  properties: {
    advancedSchedule: !empty(advancedSchedule) ? advancedSchedule : null
    description: !empty(description) ? description : null
    expiryTime: !empty(expiryTime) ? expiryTime : null
    frequency: !empty(frequency) ? frequency : 'OneTime'
    interval: (interval != 0) ? interval : null
    startTime: !empty(startTime) ? startTime : dateTimeAdd(baseTime, 'PT15M')
    timeZone: !empty(timeZone) ? timeZone : null
  }
}

@sys.description('The name of the deployed schedule.')
output name string = schedule.name

@sys.description('The resource ID of the deployed schedule.')
output resourceId string = schedule.id

@sys.description('The resource group of the deployed schedule.')
output resourceGroupName string = resourceGroup().name
