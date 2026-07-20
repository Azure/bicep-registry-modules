metadata name = 'Automation Account Credential'
metadata description = 'This module deploys Azure Automation Account Credential.'

@sys.description('Conditional. The name of the parent Automation Account. Required if the template is used in a standalone deployment.')
param automationAccountName string

@sys.description('Required. Name of the Automation Account credential.')
param name string

@sys.description('Required. The user name associated to the credential.')
param userName string

@sys.description('Required. Password of the credential.')
@secure()
param password string

@sys.description('Optional. Description of the credential.')
param description string?

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.aut-autacct-credential.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource credential 'Microsoft.Automation/automationAccounts/credentials@2024-10-23' = {
  name: name
  parent: automationAccount
  properties: {
    password: password
    userName: userName
    description: description ?? ''
  }
}

@sys.description('The resource Id of the credential associated to the automation account.')
output resourceId string = credential.id

@sys.description('The name of the credential associated to the automation account.')
output name string = credential.name

@sys.description('The resource group of the deployed credential.')
output resourceGroupName string = resourceGroup().name
