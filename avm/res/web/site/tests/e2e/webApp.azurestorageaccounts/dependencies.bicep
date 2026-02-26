@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Server Farm to create.')
param serverFarmName string

@description('Required. The name of the primary Storage Account to create.')
param primaryStorageAccountName string

@description('Required. The name of the secondary Storage Account to create.')
param secondaryStorageAccountName string

// Server farm for the web app
resource serverFarm 'Microsoft.Web/serverfarms@2025-03-01' = {
  name: serverFarmName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    family: 'B'
    capacity: 1
  }
  properties: {}
}

// Primary storage account with file shares for Azure Files mounting
resource primaryStorageAccount 'Microsoft.Storage/storageAccounts@2025-06-01' = {
  name: primaryStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowSharedKeyAccess: true // Required for Azure Files mounting
  }

  resource fileService 'fileServices@2025-01-01' = {
    name: 'default'

    resource configShare 'shares@2025-01-01' = {
      name: 'config-share'
      properties: {
        shareQuota: 10
      }
    }

    resource logsShare 'shares@2025-01-01' = {
      name: 'logs-share'
      properties: {
        shareQuota: 5
      }
    }
  }
}

// Secondary storage account for additional storage mounting scenarios
resource secondaryStorageAccount 'Microsoft.Storage/storageAccounts@2025-06-01' = {
  name: secondaryStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowSharedKeyAccess: true // Required for Azure Files mounting
  }

  resource fileService 'fileServices@2025-01-01' = {
    name: 'default'

    resource dataShare 'shares@2025-01-01' = {
      name: 'data-share'
      properties: {
        shareQuota: 20
      }
    }
  }
}

@description('The resource ID of the created Server Farm.')
output serverFarmResourceId string = serverFarm.id

@description('The resource ID of the primary Storage Account.')
output primaryStorageAccountResourceId string = primaryStorageAccount.id

@description('The name of the primary Storage Account.')
output primaryStorageAccountName string = primaryStorageAccount.name

@description('The primary access key of the primary Storage Account.')
output primaryStorageAccountKey string = primaryStorageAccount.listKeys().keys[0].value

@description('The resource ID of the secondary Storage Account.')
output secondaryStorageAccountResourceId string = secondaryStorageAccount.id

@description('The name of the secondary Storage Account.')
output secondaryStorageAccountName string = secondaryStorageAccount.name

@description('The primary access key of the secondary Storage Account.')
output secondaryStorageAccountKey string = secondaryStorageAccount.listKeys().keys[0].value
