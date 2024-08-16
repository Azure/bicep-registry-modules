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

@description('Required. The name of the AI Services to create.')
param aiServicesName string

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

resource aiServices 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: aiServicesName
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'AIServices'
}

@description('The resource ID of the created Application Insights instance.')
output applicationInsightsResourceId string = applicationInsights.id

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The resource ID of the additional created Storage Account.')
output secondaryStorageAccountResourceId string = secondaryStorageAccount.id

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The resource ID of the created AI Services.')
output aiServicesResourceId string = aiServices.id

@description('The main endpoint of the created AI Services.')
output aiServicesEndpoint string = aiServices.properties.endpoint

@description('The endpoints of the created AI Services.')
output aiServicesEndpoints object = aiServices.properties.endpoints
