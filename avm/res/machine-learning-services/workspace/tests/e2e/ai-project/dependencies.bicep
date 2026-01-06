@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Application Insights instance to create.')
param applicationInsightsName string

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

@description('Required. The name of the additional Storage Account to create.')
param secondaryStorageAccountName string

@description('Required. The name of the AI Hub to create.')
param aiHubName string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enablePurgeProtection: null
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enableRbacAuthorization: true
    accessPolicies: []
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: ''
  properties: {}
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource secondaryStorageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: secondaryStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource aiHub 'Microsoft.MachineLearningServices/workspaces@2024-10-01-preview' = {
  name: aiHubName
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  kind: 'Hub'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    storageAccount: storageAccount.id
    keyVault: keyVault.id
    applicationInsights: applicationInsights.id
  }
}

@description('The resource ID of the created Application Insights instance.')
output applicationInsightsResourceId string = applicationInsights.id

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The resource ID of the additional created Storage Account.')
output secondaryStorageAccountResourceId string = secondaryStorageAccount.id

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The resource ID of the created AI Hub.')
output aiHubResourceId string = aiHub.id
