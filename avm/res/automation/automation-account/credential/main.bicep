metadata name = 'Automation Account Credential'
metadata description = 'This module deploys Azure Automation Account Credential.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Automation Account. Required if the template is used in a standalone deployment.')
param automationAccountName string

@description('Required. The credential definition.')
param credentials credentialType

var credentialsCount = length(credentials)

resource automationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' existing = {
  name: automationAccountName
}

resource automationAccount_credential 'Microsoft.Automation/automationAccounts/credentials@2023-11-01' = [
  for credential in credentials: {
    name: credential.name
    parent: automationAccount
    properties: {
      password: credential.password
      userName: credential.userName
      description: credential.?description ?? ''
    }
  }
]

@description('The name of the credential associated to the automation account.')
output credentialInfo array = [
  for i in range(0, credentialsCount): {
    name: automationAccount_credential[i].name
    id: automationAccount_credential[i].id
  }
]

@description('The resource group of the deployed credential.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //

@export()
type credentialType = {
  @description('Required. Name of the Automation Account credential.')
  name: string

  @description('Required. The user name associated to the credential.')
  userName: string

  @description('Optional. Password of the credential.')
  @secure()
  password: string

  @description('Optional. Description of the credential.')
  description: string?
}[]
