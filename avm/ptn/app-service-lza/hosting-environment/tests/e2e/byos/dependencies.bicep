@description('Required. The name of the log analytics workspace to create.')
param logAnalyticsWorkspaceName string

@description('Required. The name of the storage account to create for BYOS.')
param storageAccountName string

@description('Required. The name of the file share to create.')
param fileShareName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' = {
  name: logAnalyticsWorkspaceName
  location: location
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
}

resource fileService 'Microsoft.Storage/storageAccounts/fileServices@2025-01-01' = {
  parent: storageAccount
  name: 'default'
}

resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2025-01-01' = {
  parent: fileService
  name: fileShareName
  properties: {
    shareQuota: 5
  }
}

@description('The resource ID of the created Log Analytics Workspace.')
output logAnalyticsWorkspaceResourceId string = logAnalyticsWorkspace.id

@description('The name of the created storage account.')
output storageAccountName string = storageAccount.name

#disable-next-line outputs-should-not-contain-secrets
@description('The access key for the storage account.')
output storageAccountKey string = storageAccount.listKeys().keys[0].value

@description('The name of the created file share.')
output fileShareName string = fileShare.name
