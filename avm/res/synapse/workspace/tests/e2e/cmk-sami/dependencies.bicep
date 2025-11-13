@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Synapse Workspace to create.')
param workspaceName string

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

resource keyVault 'Microsoft.KeyVault/vaults@2025-05-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enablePurgeProtection: true // Required for encryption to work
    softDeleteRetentionInDays: 7
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enableRbacAuthorization: true
    accessPolicies: []
  }

  resource key 'keys@2025-05-01' = {
    name: 'keyEncryptionKey'
    properties: {
      kty: 'RSA'
    }
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    isHnsEnabled: true
  }

  resource blobService 'blobServices@2025-01-01' = {
    name: 'default'

    resource container 'containers@2025-01-01' = {
      name: 'synapsews'
    }
  }
}

resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: workspaceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      resourceId: storageAccount.id
      filesystem: storageAccount::blobService::container.name
      accountUrl: storageAccount.properties.primaryEndpoints.dfs
    }
    managedVirtualNetwork: 'default'
    azureADOnlyAuthentication: false
    sqlAdministratorLogin: 'sqlAdministratorLogin'
  }
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${keyVault::key.id}-${location}-${workspaceName}-Key-Reader-RoleAssignment')
  scope: keyVault::key
  properties: {
    principalId: workspace.identity.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '12338af0-0e69-4776-bea7-57ae8d297424'
    ) // Key Vault Crypto User
    principalType: 'ServicePrincipal'
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
