metadata name = 'Automation Account Credential'
metadata description = 'This module deploys Azure Automation Account Credential.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Automation Account. Required if the template is used in a standalone deployment.')
param automationAccountName string

@description('Required. The credential definition.')
param credentials credentialType

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

@description('The id of the credential associated to the automation account.')
output resourceId string = automationAccount_credential[0].id

@description('The name of the credential associated to the automation account.')
output name string = automationAccount_credential[0].name

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
