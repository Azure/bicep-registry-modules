@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

param backupVaultName string

param blobBackupPolicyName string

@description('Required. The name of the storage account to create.')
param storageAccountName string

@description('Required. The name of the storage account to create.')
param storageAccountResourceId string

resource backupVault 'Microsoft.DataProtection/backupVaults@2023-05-01' existing = {
  name: backupVaultName

  resource backupPolicy 'backupPolicies@2023-05-01' existing = {
    name: blobBackupPolicyName
  }
}

resource backupInstance 'Microsoft.DataProtection/backupVaults/backupInstances@2024-04-01' = {
  parent: backupVault
  name: storageAccountName
  properties: {
    objectType: 'BackupInstance'
    friendlyName: storageAccountName
    dataSourceInfo: {
      objectType: 'Datasource'
      resourceID: storageAccountResourceId
      resourceName: storageAccountName
      resourceType: 'Microsoft.Storage/storageAccounts'
      resourceUri: storageAccountResourceId
      resourceLocation: location
      datasourceType: 'Microsoft.Storage/storageAccounts/blobServices'
    }
    dataSourceSetInfo: {
      objectType: 'DatasourceSet'
      resourceID: storageAccountResourceId
      resourceName: storageAccountName
      resourceType: 'Microsoft.Storage/storageAccounts'
      resourceUri: storageAccountResourceId
      resourceLocation: location
      datasourceType: 'Microsoft.Storage/storageAccounts/blobServices'
    }
    policyInfo: {
      policyId: backupVault::backupPolicy.id
      // name: blobBackupPolicyName
      policyParameters: {
        backupDatasourceParametersList: [
          {
            objectType: 'BlobBackupDatasourceParameters'
            containersList: [
              'container001'
            ]
          }
        ]
      }
    }
  }
}
