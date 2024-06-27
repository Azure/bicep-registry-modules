metadata name = 'Automation Account Powershell72 Modules'
metadata description = 'This module deploys a Powershell72 Module in the Automation Account.'

@description('Required. Name of the Powershell72 Automation Account module.')
param name string

@description('Conditional. The name of the parent Automation Account. Required if the template is used in a standalone deployment.')
param automationAccountName string

@description('Required. Module package URI, e.g. https://www.powershellgallery.com/api/v2/package.')
param uri string

@description('Optional. Module version or specify latest to get the latest version.')
param version string = 'latest'

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the Powershell 72 module resource.')
param tags object?

resource automationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' existing = {
  name: automationAccountName
}

resource powershell72module 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  name: name
  parent: automationAccount
  location: location
  tags: tags
  properties: {
    contentLink: {
      uri: version != 'latest' ? '${uri}/${name}/${version}' : '${uri}/${name}'
      version: version != 'latest' ? version : null
    }
  }
}

@description('The name of the deployed module.')
output name string = powershell72module.name

@description('The resource ID of the deployed module.')
output resourceId string = powershell72module.id

@description('The resource group of the deployed module.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = powershell72module.location
