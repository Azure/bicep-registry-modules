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

resource automationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' existing = {
  name: automationAccountName
}

resource credential 'Microsoft.Automation/automationAccounts/credentials@2023-11-01' = {
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
