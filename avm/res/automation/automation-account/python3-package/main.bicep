metadata name = 'Automation Account Python 3 Packages'
metadata description = 'This module deploys a Python3 Package in the Automation Account.'

@description('Required. Name of the Python3 Automation Account package.')
param name string

@description('Conditional. The name of the parent Automation Account. Required if the template is used in a standalone deployment.')
param automationAccountName string

@description('Required. Package URI, e.g. https://www.powershellgallery.com/api/v2/package.')
param uri string

@description('Optional. Package version or specify latest to get the latest version.')
param version string = 'latest'

@description('Optional. Tags of the Automation Account resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.aut-autacct-python3package.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource python3package 'Microsoft.Automation/automationAccounts/python3Packages@2024-10-23' = {
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
output name string = python3package.name

@description('The resource ID of the deployed package.')
output resourceId string = python3package.id

@description('The resource group of the deployed package.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = python3package.location
