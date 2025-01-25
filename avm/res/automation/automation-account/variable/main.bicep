metadata name = 'Automation Account Variables'
metadata description = 'This module deploys an Azure Automation Account Variable.'

@sys.description('Conditional. The name of the parent Automation Account. Required if the template is used in a standalone deployment.')
param automationAccountName string

@sys.description('Required. The name of the variable.')
param name string

@secure()
@sys.description('Required. The value of the variable. For security best practices, this value is always passed as a secure string as it could contain an encrypted value when the "isEncrypted" property is set to true.')
param value string

@sys.description('Optional. The description of the variable.')
param description string = ''

@sys.description('Optional. If the variable should be encrypted. For security reasons encryption of variables should be enabled.')
param isEncrypted bool = true

resource automationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' existing = {
  name: automationAccountName
}

resource variable 'Microsoft.Automation/automationAccounts/variables@2022-08-08' = {
  name: name
  parent: automationAccount
  properties: {
    description: description
    isEncrypted: isEncrypted
    value: value
  }
}

@sys.description('The name of the deployed variable.')
output name string = variable.name

@sys.description('The resource ID of the deployed variable.')
output resourceId string = variable.id

@sys.description('The resource group of the deployed variable.')
output resourceGroupName string = resourceGroup().name
