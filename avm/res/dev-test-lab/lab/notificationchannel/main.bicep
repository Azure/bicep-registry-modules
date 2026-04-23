metadata name = 'DevTest Lab Notification Channels'
metadata description = '''This module deploys a DevTest Lab Notification Channel.

Notification channels are used by the schedule resource type in order to send notifications or events to email addresses and/or webhooks.'''

@sys.description('Conditional. The name of the parent lab. Required if the template is used in a standalone deployment.')
param labName string

@allowed([
  'autoShutdown'
  'costThreshold'
])
@sys.description('Required. The name of the notification channel.')
param name string

@sys.description('Optional. Tags of the resource.')
param tags object?

@sys.description('Optional. Description of notification.')
param description string = ''

@sys.description('Required. The list of event for which this notification is enabled.')
param events array

@sys.description('Conditional. The email recipient to send notifications to (can be a list of semi-colon separated email addresses). Required if "webHookUrl" is empty.')
param emailRecipient string?

@sys.description('Conditional. The webhook URL to which the notification will be sent. Required if "emailRecipient" is empty.')
param webHookUrl string = ''

@sys.description('Optional. The locale to use when sending a notification (fallback for unsupported languages is EN).')
param notificationLocale string = 'en'

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.devtestlab-lab-notificationchannel.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource lab 'Microsoft.DevTestLab/labs@2018-09-15' existing = {
  name: labName
}

resource notificationChannel 'Microsoft.DevTestLab/labs/notificationchannels@2018-09-15' = {
  name: name
  parent: lab
  tags: tags
  properties: {
    description: description
    events: [
      for event in events: {
        eventName: event
      }
    ]
    emailRecipient: emailRecipient
    webHookUrl: webHookUrl
    notificationLocale: notificationLocale
  }
}

@sys.description('The name of the notification channel.')
output name string = notificationChannel.name

@sys.description('The resource ID of the notification channel.')
output resourceId string = notificationChannel.id

@sys.description('The name of the resource group the notification channel was created in.')
output resourceGroupName string = resourceGroup().name
