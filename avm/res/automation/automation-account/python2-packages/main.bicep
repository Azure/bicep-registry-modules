metadata name = 'Automation Account Python 2 Packages'
metadata description = 'This module deploys a Python2 Package in the Automation Account.'

@description('Required. Name of the Python2 Automation Account package.')
param name string

@description('Conditional. The name of the parent Automation Account. Required if the template is used in a standalone deployment.')
param automationAccountName string

@description('Required. Package URI, e.g. https://www.powershellgallery.com/api/v2/package.')
param uri string

@description('Optional. Package version or specify latest to get the latest version.')
param version string = 'latest'

@description('Optional. Tags of the Automation Account resource.')
param tags object?

resource automationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' existing = {
  name: automationAccountName
}

resource python2package 'Microsoft.Automation/automationAccounts/python2Packages@2023-11-01' = {
  name: name
  parent: automationAccount
  tags: tags
  properties: {
    contentLink: {
      uri: version != 'latest' ? '${uri}/${name}/${version}' : '${uri}/${name}'
      version: version != 'latest' ? version : null
    }
  }
}

@description('The name of the deployed package.')
output name string = python2package.name

@description('The resource ID of the deployed package.')
output resourceId string = python2package.id

@description('The resource group of the deployed package.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = python2package.location
