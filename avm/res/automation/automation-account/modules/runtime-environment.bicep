metadata name = 'Automation Account Runtime Environment'
metadata description = 'This module deploys an Azure Automation Account Runtime Environment.'

@sys.description('Required. Name of the Automation Account runtime environment.')
param name string

@sys.description('Conditional. The name of the parent Automation Account. Required if the template is used in a standalone deployment.')
param automationAccountName string

@sys.description('Required. Runtime configuration.')
param runtime {
  @sys.description('Required. Runtime language, for example PowerShell or Python.')
  language: string

  @sys.description('Required. Runtime language version.')
  version: string
}

@sys.description('Optional. Description of the runtime environment.')
param description string?

@sys.description('Optional. Default packages available in the runtime environment.')
param defaultPackages {
  @sys.description('Required. A default package name and version pair.')
  *: string
}?

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Optional. Tags of the runtime environment resource.')
param tags resourceInput<'Microsoft.Automation/automationAccounts/runtimeEnvironments@2024-10-23'>.tags?

resource automationAccount 'Microsoft.Automation/automationAccounts@2024-10-23' existing = {
  name: automationAccountName
}

resource runtimeEnvironment 'Microsoft.Automation/automationAccounts/runtimeEnvironments@2024-10-23' = {
  name: name
  parent: automationAccount
  location: location
  tags: tags
  properties: {
    description: description
    runtime: runtime
    defaultPackages: defaultPackages
  }
}

@sys.description('The name of the deployed runtime environment.')
output name string = runtimeEnvironment.name

@sys.description('The resource ID of the deployed runtime environment.')
output resourceId string = runtimeEnvironment.id

@sys.description('The resource group of the deployed runtime environment.')
output resourceGroupName string = resourceGroup().name

@sys.description('The location the runtime environment was deployed into.')
output location string = runtimeEnvironment.location
