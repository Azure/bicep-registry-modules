@description('The name of the Automation Account')
param automationAccountName string

@description('Deployment Location')
param location string = resourceGroup().location

@description('Used to reference todays date')
param today string = utcNow('yyyyMMddTHHmmssZ')

@description('The timezone to align schedules to. (Eg. "Europe/London" or "America/Los_Angeles")')
param timezone string = 'Etc/UTC'

@allowed(['Basic', 'Free'])
@description('The Automation Account SKU. See https://learn.microsoft.com/en-us/azure/automation/overview#pricing-for-azure-automation')
param accountSku string = 'Basic'

@description('For Automation job logging')
param loganalyticsWorkspaceId string = ''

@description('Which logging categeories to log')
param diagnosticCategories array = [
  'JobLogs'
  'JobStreams'
  'AuditEvent'
]

@description('Which Automation Schedules to create')
param schedulesToCreate array = [
  'Daily9am'
  'Weekday9am'
  'DailyMidnight'
  'WeekdayMidnight'
]

@description('The Runbook-Schedule Jobs to create')
param runbookJobSchedule array = [
  {
    schedule: 'Weekday9am'
    parameters: {}
  }
  {
    Schedule: 'WeekdayMidnight'
    parameters: {}
  }
]

@description('The name of the runbook to create')
param runbookName string

@description('The type of runbook that is being imported')
param runbookType string = 'Script'

@description('The URI to import the runbook code from')
param runbookUri string = ''

var runbookVersion = '1.0.0.0'
var tomorrow = dateTimeAdd(today, 'P1D','yyyy-MM-dd')
var scheduleNoExpiry = '9999-12-31T23:59:00+00:00'
var workWeek = {weekDays: [
                  'Monday'
                  'Tuesday'
                  'Wednesday'
                  'Thursday'
                  'Friday'
                  ]
                }

resource automationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' = {
  name: automationAccountName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    sku: {
      name: accountSku
    }
  }
}

resource automationAccountDiagLogging 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if(!empty(loganalyticsWorkspaceId)) {
  name: 'diags'
  scope: automationAccount
  properties: {
    workspaceId: loganalyticsWorkspaceId
    logs: [for diagCategory in diagnosticCategories: {
      category: diagCategory
      enabled: true
    }]
  } 
}

resource runbook 'Microsoft.Automation/automationAccounts/runbooks@2022-08-08' = if(!empty(runbookName)) {
  parent: automationAccount
  name: !empty(runbookName) ? runbookName : 'armtemplatevalidationissue'
  location: location
  properties: {
    logVerbose: true
    logProgress: true
    runbookType: runbookType
    publishContentLink: {
      uri: runbookUri
      version: runbookVersion
    }
    description: 'Deletes the resources in tagged resource groups'
  }
}

resource automationScheduleNight 'Microsoft.Automation/automationAccounts/schedules@2022-08-08' = {
  parent: automationAccount
  name: 'Midnight - Daily'
  properties: {
    startTime: '${take(tomorrow,10)}T00:01:00+00:00'
    expiryTime: scheduleNoExpiry
    interval: 1
    frequency: 'Day'
    timeZone: timezone
    description: 'Daily out of hours schedule'
  }
}

resource Daily9am 'Microsoft.Automation/automationAccounts/schedules@2022-08-08' = if(contains(schedulesToCreate,'Daily9am')) {
  parent: automationAccount
  name: 'Daily - 9am'
  properties: {
    startTime: '${take(tomorrow,10)}T09:00:00+00:00'
    expiryTime: scheduleNoExpiry
    interval: 1
    frequency: 'Day'
    timeZone: timezone
    description: 'Daily out of hours schedule'
  }
}

resource Weekday9am 'Microsoft.Automation/automationAccounts/schedules@2022-08-08' = if(contains(schedulesToCreate,'Weekday9am')) {
  parent: automationAccount
  name: 'Weekday - 9am'
  properties: {
    startTime: '${take(tomorrow,10)}T09:00:00+00:00'
    expiryTime: scheduleNoExpiry
    interval: 1
    frequency: 'Week'
    timeZone: timezone
    description: 'Daily out of hours schedule'
    advancedSchedule: workWeek
  }
}

resource automationJobs 'Microsoft.Automation/automationAccounts/jobSchedules@2022-08-08' = [for job in runbookJobSchedule : if(!empty(runbookName)) {
  parent: automationAccount
  name: guid(automationAccount.id, runbookName, job.schedule)
  properties: {
    schedule: {
      name: job.schedule
    }
    runbook: {
      name: runbookName
    }
    parameters: job.parameters
  }
  dependsOn: [Daily9am,Weekday9am] //All of the possible schedules
}]

@description('The Automation Account Principal Id')
output automationAccountPrincipalId string = automationAccount.identity.principalId
