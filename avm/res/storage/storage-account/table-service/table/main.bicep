metadata name = 'Storage Account Table'
metadata description = 'This module deploys a Storage Account Table.'
metadata owner = 'Azure/module-maintainers'

@maxLength(24)
@description('Conditional. The name of the parent Storage Account. Required if the template is used in a standalone deployment.')
param storageAccountName string

@description('Required. Name of the table.')
param name string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: storageAccountName

  resource tableServices 'tableServices@2021-09-01' existing = {
    name: 'default'
  }
}

resource table 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-09-01' = {
  name: name
  parent: storageAccount::tableServices
}

@description('The name of the deployed file share service.')
output name string = table.name

@description('The resource ID of the deployed file share service.')
output resourceId string = table.id

@description('The resource group of the deployed file share service.')
output resourceGroupName string = resourceGroup().name
