metadata name = 'DevTest Lab Costs'
metadata description = '''This module deploys a DevTest Lab Cost.

Manage lab costs by setting a spending target that can be viewed in the Monthly Estimated Cost Trend chart. DevTest Labs can send a notification when spending reaches the specified target threshold.'''

@sys.description('Conditional. The name of the parent lab. Required if the template is used in a standalone deployment.')
param labName string

@allowed([
  'Custom'
  'CalendarMonth'
])
@sys.description('Required. Reporting cycle type.')
param cycleType string

@sys.description('Optional. Tags of the resource.')
param tags object?

@sys.description('Conditional. Reporting cycle start date in the zulu time format (e.g. 2023-12-01T00:00:00.000Z). Required if cycleType is set to "Custom".')
param cycleStartDateTime string?

@sys.description('Conditional. Reporting cycle end date in the zulu time format (e.g. 2023-12-01T00:00:00.000Z). Required if cycleType is set to "Custom".')
param cycleEndDateTime string?

@allowed([
  'Enabled'
  'Disabled'
])
@sys.description('Optional. Target cost status.')
param status string = 'Enabled'

@sys.description('Optional. Lab target cost (e.g. 100). The target cost will appear in the "Cost trend" chart to allow tracking lab spending relative to the target cost for the current reporting cycleSetting the target cost to 0 will disable all thresholds.')
param target int = 0

@sys.description('Optional. The currency code of the cost.')
param currencyCode string = 'USD'

@allowed([
  'Enabled'
  'Disabled'
])
@sys.description('Optional. Target Cost threshold at 25% display on chart. Indicates whether this threshold will be displayed on cost charts.')
param thresholdValue25DisplayOnChart string = 'Disabled'

@allowed([
  'Enabled'
  'Disabled'
])
@sys.description('Optional. Target cost threshold at 25% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.')
param thresholdValue25SendNotificationWhenExceeded string = 'Disabled'

@allowed([
  'Enabled'
  'Disabled'
])
@sys.description('Optional. Target Cost threshold at 50% display on chart. Indicates whether this threshold will be displayed on cost charts.')
param thresholdValue50DisplayOnChart string = 'Disabled'

@allowed([
  'Enabled'
  'Disabled'
])
@sys.description('Optional. Target cost threshold at 50% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.')
param thresholdValue50SendNotificationWhenExceeded string = 'Disabled'

@allowed([
  'Enabled'
  'Disabled'
])
@sys.description('Optional. Target Cost threshold at 75% display on chart. Indicates whether this threshold will be displayed on cost charts.')
param thresholdValue75DisplayOnChart string = 'Disabled'

@allowed([
  'Enabled'
  'Disabled'
])
@sys.description('Optional. Target cost threshold at 75% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.')
param thresholdValue75SendNotificationWhenExceeded string = 'Disabled'

@allowed([
  'Enabled'
  'Disabled'
])
@sys.description('Optional. Target Cost threshold at 100% display on chart. Indicates whether this threshold will be displayed on cost charts.')
param thresholdValue100DisplayOnChart string = 'Disabled'

@allowed([
  'Enabled'
  'Disabled'
])
@sys.description('Optional. Target cost threshold at 100% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.')
param thresholdValue100SendNotificationWhenExceeded string = 'Disabled'

@allowed([
  'Enabled'
  'Disabled'
])
@sys.description('Optional. Target Cost threshold at 125% display on chart. Indicates whether this threshold will be displayed on cost charts.')
param thresholdValue125DisplayOnChart string = 'Disabled'

@allowed([
  'Enabled'
  'Disabled'
])
@sys.description('Optional. Target cost threshold at 125% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.')
param thresholdValue125SendNotificationWhenExceeded string = 'Disabled'

resource lab 'Microsoft.DevTestLab/labs@2018-09-15' existing = {
  name: labName
}

resource cost 'Microsoft.DevTestLab/labs/costs@2018-09-15' = {
  name: 'targetCost'
  parent: lab
  tags: tags
  properties: {
    currencyCode: currencyCode
    startDateTime: cycleStartDateTime
    endDateTime: cycleEndDateTime
    targetCost: {
      target: target
      cycleStartDateTime: cycleStartDateTime
      cycleEndDateTime: cycleEndDateTime
      cycleType: cycleType
      status: status
      costThresholds: [
        {
          thresholdId: '00000000-0000-0000-0000-000000000001'
          percentageThreshold: {
            thresholdValue: 25
          }
          displayOnChart: thresholdValue25DisplayOnChart
          sendNotificationWhenExceeded: thresholdValue25SendNotificationWhenExceeded
        }
        {
          thresholdId: '00000000-0000-0000-0000-000000000002'
          percentageThreshold: {
            thresholdValue: 50
          }
          displayOnChart: thresholdValue50DisplayOnChart
          sendNotificationWhenExceeded: thresholdValue50SendNotificationWhenExceeded
        }
        {
          thresholdId: '00000000-0000-0000-0000-000000000003'
          percentageThreshold: {
            thresholdValue: 75
          }
          displayOnChart: thresholdValue75DisplayOnChart
          sendNotificationWhenExceeded: thresholdValue75SendNotificationWhenExceeded
        }
        {
          thresholdId: '00000000-0000-0000-0000-000000000004'
          percentageThreshold: {
            thresholdValue: 100
          }
          displayOnChart: thresholdValue100DisplayOnChart
          sendNotificationWhenExceeded: thresholdValue100SendNotificationWhenExceeded
        }
        {
          thresholdId: '00000000-0000-0000-0000-000000000005'
          percentageThreshold: {
            thresholdValue: 125
          }
          displayOnChart: thresholdValue125DisplayOnChart
          sendNotificationWhenExceeded: thresholdValue125SendNotificationWhenExceeded
        }
      ]
    }
  }
}

@sys.description('The name of the cost.')
output name string = cost.name

@sys.description('The resource ID of the cost.')
output resourceId string = cost.id

@sys.description('The name of the resource group the cost was created in.')
output resourceGroupName string = resourceGroup().name
