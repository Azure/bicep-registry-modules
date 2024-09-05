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
param dailyRecurrence dailyRecurrenceType

@sys.description('Optional. If the schedule will occur multiple times a day, specify the hourly recurrence.')
param hourlyRecurrence hourlyRecurrenceType

@sys.description('Optional. If the schedule will occur only some days of the week, specify the weekly recurrence.')
param weeklyRecurrence weeklyRecurrenceType

@allowed([
  'Enabled'
  'Disabled'
])
@sys.description('Optional. The status of the schedule (i.e. Enabled, Disabled).')
param status string = 'Enabled'

@sys.description('Optional. The resource ID to which the schedule belongs.')
param targetResourceId string?

@sys.description('Optional. The time zone ID (e.g. Pacific Standard time).')
param timeZoneId string = 'Pacific Standard time'

@sys.description('Optional. The notification settings for the schedule.')
param notificationSettings notificationSettingsType

resource lab 'Microsoft.DevTestLab/labs@2018-09-15' existing = {
  name: labName
}

resource schedule 'Microsoft.DevTestLab/labs/schedules@2018-09-15' = {
  name: name
  parent: lab
  tags: tags
  properties: {
    taskType: taskType
    dailyRecurrence: dailyRecurrence
    hourlyRecurrence: hourlyRecurrence
    weeklyRecurrence: weeklyRecurrence
    status: status
    targetResourceId: targetResourceId
    timeZoneId: timeZoneId
    notificationSettings: notificationSettings
  }
}

@sys.description('The name of the schedule.')
output name string = schedule.name

@sys.description('The resource ID of the schedule.')
output resourceId string = schedule.id

@sys.description('The name of the resource group the schedule was created in.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
type dailyRecurrenceType = {
  @sys.description('Required. The time of day the schedule will occur.')
  time: string
}?

@export()
type hourlyRecurrenceType = {
  @sys.description('Required. Minutes of the hour the schedule will run.')
  minute: int
}?

@export()
type weeklyRecurrenceType = {
  @sys.description('Required. The time of day the schedule will occur.')
  time: string

  @sys.description('Required. The days of the week for which the schedule is set (e.g. Sunday, Monday, Tuesday, etc.).')
  weekdays: string[]
}?

@export()
type notificationSettingsType = {
  @description('Conditional. The email recipient to send notifications to (can be a list of semi-colon separated email addresses). Required if "webHookUrl" is empty.')
  emailRecipient: string?

  @description('Optional. The locale to use when sending a notification (fallback for unsupported languages is EN).')
  notificationLocale: string?

  @sys.description('Optional. If notifications are enabled for this schedule (i.e. Enabled, Disabled). Default is Disabled.')
  status: 'Disabled' | 'Enabled'?

  @sys.description('Optional. Time in minutes before event at which notification will be sent. Default is 30 minutes if status is Enabled and not specified.')
  timeInMinutes: int?

  @description('Conditional. The webhook URL to which the notification will be sent. Required if "emailRecipient" is empty.')
  webHookUrl: string?
}?
