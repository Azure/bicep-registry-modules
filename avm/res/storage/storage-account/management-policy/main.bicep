metadata name = 'Storage Account Management Policies'
metadata description = 'This module deploys a Storage Account Management Policy.'

@maxLength(24)
@description('Conditional. The name of the parent Storage Account. Required if the template is used in a standalone deployment.')
param storageAccountName string

@description('Required. The Storage Account ManagementPolicies Rules.')
param rules resourceInput<'Microsoft.Storage/storageAccounts/managementPolicies@2024-01-01'>.properties.policy.rules

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.storage-mgmtpolicy.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' existing = {
  name: storageAccountName
}

// lifecycle policy
resource managementPolicy 'Microsoft.Storage/storageAccounts/managementPolicies@2024-01-01' = {
  name: 'default'
  parent: storageAccount
  properties: {
    policy: {
      rules: rules
    }
  }
}

@description('The resource ID of the deployed management policy.')
output resourceId string = managementPolicy.name

@description('The name of the deployed management policy.')
output name string = managementPolicy.name

@description('The resource group of the deployed management policy.')
output resourceGroupName string = resourceGroup().name
