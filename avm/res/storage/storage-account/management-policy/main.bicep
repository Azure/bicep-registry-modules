metadata name = 'Storage Account Management Policies'
metadata description = 'This module deploys a Storage Account Management Policy.'
metadata owner = 'Azure/module-maintainers'

@maxLength(24)
@description('Conditional. The name of the parent Storage Account. Required if the template is used in a standalone deployment.')
param storageAccountName string

@description('Required. The Storage Account ManagementPolicies Rules.')
param rules array

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountName
}

// lifecycle policy
resource managementPolicy 'Microsoft.Storage/storageAccounts/managementPolicies@2023-01-01' = {
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
