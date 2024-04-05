metadata name = 'DevTest Lab Schedules'
metadata description = '''This module deploys a DevTest Lab Schedule.

Lab schedules are used to modify the settings for auto-shutdown, auto-start for lab virtual machines.'''
metadata owner = 'Azure/module-maintainers'

@sys.description('Conditional. The name of the parent lab. Required if the template is used in a standalone deployment.')
param labName string

@allowed([
  'LabVmsShutdown'
  'LabVmAutoStart'
])
@sys.description('Required. The name of the schedule.')
param name string

@allowed([
  'LabVmsShutdownTask'
  'LabVmsStartupTask'
])
@sys.description('Required. The task type of the schedule (e.g. LabVmsShutdownTask, LabVmsStartupTask).')
param taskType string

@sys.description('Optional. Tags of the resource.')
param tags object?

@sys.description('Optional. If the schedule will occur once each day of the week, specify the daily recurrence.')
param dailyRecurrence object = {}

@sys.description('Optional. If the schedule will occur multiple times a day, specify the hourly recurrence.')
param hourlyRecurrence object = {}

@sys.description('Optional. If the schedule will occur only some days of the week, specify the weekly recurrence.')
param weeklyRecurrence object = {}

@allowed([
  'Enabled'
  'Disabled'
])
@sys.description('Optional. The status of the schedule (i.e. Enabled, Disabled).')
param status string = 'Enabled'

@sys.description('Optional. The resource ID to which the schedule belongs.')
param targetResourceId string = ''

@sys.description('Optional. The time zone ID (e.g. Pacific Standard time).')
param timeZoneId string = 'Pacific Standard time'

@allowed([
  'Enabled'
  'Disabled'
])
@sys.description('Optional. If notifications are enabled for this schedule (i.e. Enabled, Disabled).')
param notificationSettingsStatus string = 'Disabled'

@sys.description('Optional. Time in minutes before event at which notification will be sent. Optional if "notificationSettingsStatus" is set to "Enabled". Default is 30 minutes.')
param notificationSettingsTimeInMinutes int = 30

resource lab 'Microsoft.DevTestLab/labs@2018-09-15' existing = {
  name: labName
}

resource schedule 'Microsoft.DevTestLab/labs/schedules@2018-09-15' = {
  name: name
  parent: lab
  tags: tags
  properties: {
    taskType: taskType
    dailyRecurrence: !empty(dailyRecurrence) ? dailyRecurrence : null
    hourlyRecurrence: !empty(hourlyRecurrence) ? hourlyRecurrence : null
    weeklyRecurrence: !empty(weeklyRecurrence) ? weeklyRecurrence : null
    status: status
    targetResourceId: !empty(targetResourceId) ? targetResourceId : null
    timeZoneId: timeZoneId
    notificationSettings: notificationSettingsStatus == 'Enabled'
      ? {
          status: notificationSettingsStatus
          timeInMinutes: notificationSettingsTimeInMinutes
        }
      : {}
  }
}

@sys.description('The name of the schedule.')
output name string = schedule.name

@sys.description('The resource ID of the schedule.')
output resourceId string = schedule.id

@sys.description('The name of the resource group the schedule was created in.')
output resourceGroupName string = resourceGroup().name
