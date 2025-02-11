metadata name = 'Automation Account Runbooks'
metadata description = 'This module deploys an Azure Automation Account Runbook.'

@sys.description('Required. Name of the Automation Account runbook.')
param name string

@sys.description('Conditional. The name of the parent Automation Account. Required if the template is used in a standalone deployment.')
param automationAccountName string

@allowed([
  'Graph'
  'GraphPowerShell'
  'GraphPowerShellWorkflow'
  'PowerShell'
  'PowerShell72'
  'PowerShellWorkflow'
  'Python2'
  'Python3'
  'Script'
])
@sys.description('Required. The type of the runbook.')
param type string

@sys.description('Optional. The description of the runbook.')
param description string = ''

@sys.description('Optional. The uri of the runbook content.')
param uri string = ''

@sys.description('Optional. The version of the runbook content.')
param version string = ''

@sys.description('Optional. Resource Id of the runbook storage account.')
param scriptStorageAccountResourceId string?

@sys.description('Generated. Time used as a basis for e.g. the schedule start date.')
param baseTime string = utcNow('u')

@sys.description('Optional. SAS token validity length. Usage: \'PT8H\' - valid for 8 hours; \'P5D\' - valid for 5 days; \'P1Y\' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours.')
param sasTokenValidityLength string = 'PT8H'

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Optional. Tags of the Automation Account resource.')
param tags object?

var accountSasProperties = {
  signedServices: 'b'
  signedPermission: 'r'
  signedExpiry: dateTimeAdd(baseTime, sasTokenValidityLength)
  signedResourceTypes: 'o'
  signedProtocol: 'https'
}

resource automationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' existing = {
  name: automationAccountName
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = if (!empty(scriptStorageAccountResourceId)) {
  name: last(split((scriptStorageAccountResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(
    split((scriptStorageAccountResourceId ?? '//'), '/')[2],
    split((scriptStorageAccountResourceId ?? '////'), '/')[4]
  )
}

var publishContentLink = empty(uri)
  ? null
  : {
      uri: !empty(uri)
        ? (empty(scriptStorageAccountResourceId)
            ? uri
            : '${uri}?${storageAccount.listAccountSas('2021-04-01', accountSasProperties).accountSasToken}')
        : null
      version: !empty(version) ? version : null
    }

resource runbook 'Microsoft.Automation/automationAccounts/runbooks@2023-11-01' = {
  name: name
  parent: automationAccount
  location: location
  tags: tags
  properties: {
    runbookType: type
    description: description
    publishContentLink: !empty(uri) ? publishContentLink : null
  }
}

@sys.description('The name of the deployed runbook.')
output name string = runbook.name

@sys.description('The resource ID of the deployed runbook.')
output resourceId string = runbook.id

@sys.description('The resource group of the deployed runbook.')
output resourceGroupName string = resourceGroup().name

@sys.description('The location the resource was deployed into.')
output location string = runbook.location
