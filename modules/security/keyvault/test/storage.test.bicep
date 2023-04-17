param location string = resourceGroup().location

// Force creation of new resources using utcNow() to reproduce bug, running the deployment twice will not reproduce the bug
@minLength(3)
@maxLength(24)
param keyVaultName string = 'kv${uniqueString(resourceGroup().id, location, 'storage2keyvault-new', utcNow())}'
param storageAccountName string = 'sa${uniqueString(resourceGroup().id, location, 'storage2keyvault-new', utcNow())}'

module storageAccount 'br/public:storage/storage-account:0.0.1' = {
  name: 'mystorageaccount'
  params: {
    location: location
    name: storageAccountName
  }
}

module addKey 'nestedkv.test.bicep' = {
  name: 'addKeyToKeyVault'
  dependsOn: [
    storageAccount
  ]
  params: {
    location: location
    keyVaultName: keyVaultName
    storageAccountName: storageAccountName
  }
}

/* This is the first case that fails, we must nest the module instead.

  Content:
  {
    status: 'Failed'
    error: {
      code: 'DeploymentFailed'
      target: '/subscriptions/edf507a2-6235-46c5-b560-fd463ba2e771/resourceGroups/dcibkeyvaultstorage/providers/Microsoft.Resources/deployments/storage.test-230417-1904'
      message: 'At least one resource deployment operation failed. Please list deployment operations for details. Please see https://aka.ms/arm-deployment-operations for usage details.'
      details: [
        {
          code: 'ResourceNotFound'
          message: 'The Resource \'Microsoft.Storage/storageAccounts/sa4va4iv6hjynku\' under resource group \'dcibkeyvaultstorage\' was not found. For more details please go to https://aka.ms/ARMResourceNotFoundFix'
        }
      ]
    }
  }

resource existingStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  #disable-next-line use-stable-resource-identifiers // Force creation of new resources using utcNow() to reproduce bug
  name: storageAccountName
}

module keyVault '../main.bicep' = {
  name: 'myKeyVault'
  dependsOn: [
    storageAccount
  ]
  params: {
    location: location
    name: keyVaultName
    secretName: 'storage-secret'
    secretValue: existingStorageAccount.listKeys().keys[0].value
  }
}
*/
