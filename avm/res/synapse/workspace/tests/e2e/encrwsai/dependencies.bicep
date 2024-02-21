@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
    name: keyVaultName
    location: location
    properties: {
        sku: {
            family: 'A'
            name: 'standard'
        }
        tenantId: tenant().tenantId
        enablePurgeProtection: true
        softDeleteRetentionInDays: 7
        enabledForTemplateDeployment: true
        enabledForDiskEncryption: true
        enabledForDeployment: true
        enableRbacAuthorization: true
        accessPolicies: []
    }

    resource key 'keys@2022-07-01' = {
        name: 'keyEncryptionKey'
        properties: {
            kty: 'RSA'
        }
    }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
    name: storageAccountName
    location: location
    sku: {
        name: 'Standard_LRS'
    }
    kind: 'StorageV2'
    properties: {
        isHnsEnabled: true
    }

    resource blobService 'blobServices@2022-09-01' = {
        name: 'default'

        resource container 'containers@2022-09-01' = {
            name: 'synapsews'
        }
    }
}

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The name of the Key Vault Encryption Key.')
output keyVaultEncryptionKeyName string = keyVault::key.name

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The name of the created container.')
output storageContainerName string = storageAccount::blobService::container.name
