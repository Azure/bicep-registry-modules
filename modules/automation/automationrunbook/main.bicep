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

type schedule = {
  frequency : 'Day' | 'Weekday' | 'Week'

  hour : hour
  minute : minute
}

@minValue(0)
@maxValue(23)
@description('Seperately declaring as a type allows for min/max validation')
type hour = int

@minValue(0)
@maxValue(59)
@description('Seperately declaring as a type allows for min/max validation')
type minute = int

@description('Automation Schedules to create')
param schedulesToCreate schedule[] = [
  {
    frequency:'Day'
    hour:9
    minute:0
  }
  {
    frequency:'Weekday'
    hour:9
    minute:0
  }
  {
    frequency:'Day'
    hour:19
    minute:0
  }
  {
    frequency:'Weekday'
    hour:19
    minute:0
  }
  {
    frequency:'Day'
    hour:0
    minute:0
  }
  {
    frequency:'Weekday'
    hour: 0
    minute:0
  }
]

type runbookJob = {
  scheduleName: string
  parameters: object?
}

@description('The Runbook-Schedule Jobs to create with workflow specific parameters')
param runbookJobSchedule runbookJob[]

@description('The name of the runbook to create')
param runbookName string

@allowed([
  'GraphPowerShell'
  'Script'
])
@description('The type of runbook that is being imported')
param runbookType string = 'Script'

@description('The URI to import the runbook code from')
param runbookUri string = ''

@description('A description of what the runbook does')
param runbookDescription string = ''

var runbookVersion = '1.0.0.0'
var tomorrow = dateTimeAdd(today, 'P1D','yyyy-MM-dd')
var timebase = '1900-01-01'
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

resource schedules 'Microsoft.Automation/automationAccounts/schedules@2022-08-08' = [for schedule in schedulesToCreate : {
  parent: automationAccount
  name: '${schedule.frequency} - ${dateTimeAdd(timebase,'PT${schedule.hour}H','HH')}:${dateTimeAdd(timebase,'PT${schedule.minute}M','mm')}'
  properties: {
    startTime: dateTimeAdd(dateTimeAdd(tomorrow,'PT${schedule.hour}H'), 'PT${schedule.minute}M','yyyy-MM-ddTHH:mm:00+00:00')
    expiryTime: scheduleNoExpiry
    interval: 1
    frequency: schedule.frequency == 'Day' ? 'Day' : 'Week'
    timeZone: timezone
    advancedSchedule: schedule.frequency == 'Weekday' ?  workWeek : {}
  }
}]

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
    description: runbookDescription
  }
}

resource automationJobs 'Microsoft.Automation/automationAccounts/jobSchedules@2022-08-08' = [for job in runbookJobSchedule : if(!empty(runbookName)) {
  parent: automationAccount
  name: guid(automationAccount.id, runbook.name, job.scheduleName)
  properties: {
    schedule: {
      name: job.scheduleName
    }
    runbook: {
      name: runbook.name
    }
    parameters: job.parameters
  }
  dependsOn: [schedules] //All of the possible schedules
}]

@description('The Automation Account Principal Id')
output automationAccountPrincipalId string = automationAccount.identity.principalId
