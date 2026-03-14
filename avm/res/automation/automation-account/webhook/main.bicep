metadata name = 'Automation Account Webhook'
metadata description = 'This module deploys an Azure Automation Account Webhook.'

@sys.description('Conditional. The name of the parent Automation Account. Required if the template is used in a standalone deployment.')
param automationAccountName string

@sys.description('Required. The name of the webhook.')
param name string

@sys.description('Required. The runbook in which the webhook will be used.')
param runbookName string

@description('Optional. The hybrid worker group that the scheduled job should run on.')
param runOn string = ''

@description('Optional. List of job properties.')
param parameters object = {}

@description('Optional. The expiration time of the webhook.')
param expiryTime string = utcNow()

resource automationAccount 'Microsoft.Automation/automationAccounts@2024-10-23' existing = {
  name: automationAccountName
}

resource webhook 'Microsoft.Automation/automationAccounts/webhooks@2024-10-23' = {
  name: name
  parent: automationAccount
  properties: {
    isEnabled: false
    expiryTime: expiryTime
    runbook: {
      name: runbookName
    }
    runOn: runOn
    uri: ''
    parameters: parameters
  }
}

@sys.description('The name of the deployed variable.')
output name string = webhook.name

@sys.description('The resource ID of the deployed variable.')
output resourceId string = webhook.id

@sys.description('The URI of the deployed webhook.')
output uri string = webhook.properties.uri

@sys.description('The resource group of the deployed variable.')
output resourceGroupName string = resourceGroup().name
