metadata name = 'Automation Account Credentials'
metadata description = 'This module deploys Azure Automation Account Credentials.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Automation Account module.')
param name string

@description('Conditional. The name of the parent Automation Account. Required if the template is used in a standalone deployment.')
param automationAccountName string

@description('Required. The user name associated to the credential.')
param userName string

@description('Required. Password of the credential.')
@secure()
param password string

@description('Optional. Description of the credential.')
param credentialDescription string = ''

resource automationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' existing = {
  name: automationAccountName
}

resource credential 'Microsoft.Automation/automationAccounts/credentials@2023-11-01' = {
  name: name
  parent: automationAccount
  properties: {
    password: password
    userName: userName
    description: credentialDescription
  }
}
