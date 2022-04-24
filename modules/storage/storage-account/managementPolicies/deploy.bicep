@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('Optional. The name of the storage container to deploy')
param name string = 'default'

@description('Required. The Storage Account ManagementPolicies Rules')
param rules array

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: storageAccountName
}

// lifecycle policy
resource managementPolicy 'Microsoft.Storage/storageAccounts/managementPolicies@2019-06-01' = if (!empty(rules)) {
  name: name
  parent: storageAccount
  properties: {
    policy: {
      rules: rules
    }
  }
}

@description('The resource ID of the deployed management policy')
output resourceId string = managementPolicy.name

@description('The name of the deployed management policy')
output name string = managementPolicy.name

@description('The resource group of the deployed management policy')
output resourceGroupName string = resourceGroup().name
