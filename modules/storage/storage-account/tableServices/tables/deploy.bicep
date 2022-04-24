@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('Optional. The name of the table service')
param tableServicesName string = 'default'

@description('Required. Name of the table.')
param name string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: storageAccountName

  resource tableServices 'tableServices@2021-04-01' existing = {
    name: tableServicesName
  }
}

resource table 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-06-01' = {
  name: name
  parent: storageAccount::tableServices
}

@description('The name of the deployed file share service')
output name string = table.name

@description('The resource ID of the deployed file share service')
output resourceId string = table.id

@description('The resource group of the deployed file share service')
output resourceGroupName string = resourceGroup().name
