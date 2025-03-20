metadata name = 'Data Protection Backup Vault Backup Instances'
metadata description = 'This module deploys a Data Protection Backup Vault Backup Instance.'

@description('Conditional. The name of the parent Backup Vault. Required if the template is used in a standalone deployment.')
param backupVaultName string

@description('Required. The name of the backup instance.')
param name string

@description('Optional. The backup instance object type.')
param objectType string = 'BackupInstance'

@description('Required. Gets or sets the data source information.')
param dataSourceInfo dataSourceInfoType

@description('Required. Gets or sets the policy information.')
param policyInfo policyInfoType

resource backupVault 'Microsoft.DataProtection/backupVaults@2023-05-01' existing = {
  name: backupVaultName
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' existing = if (dataSourceInfo.datasourceType == 'AzureStorage') {
  name: dataSourceInfo.resourceName
}

// Req: assign permission on storage or on disk (storage account backup contributor)
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, storageAccount.id, backupVault.id)
  scope: storageAccount
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'e5e2a7ff-d759-4cd2-bb51-3152d37e2eb1' // Storage Account Backup Contributor
    )
    principalId: backupVault.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource backupInstance 'Microsoft.DataProtection/backupVaults/backupInstances@2024-04-01' = {
  name: name
  parent: backupVault
  properties: {
    objectType: objectType
    dataSourceInfo: dataSourceInfo
    policyInfo: policyInfo
  }
}

@description('The name of the backup instance.')
output name string = backupInstance.name

@description('The resource ID of the backup instance.')
output resourceId string = backupInstance.id

@description('The name of the resource group the backup instance was created in.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

//TODO: add all descriptions
@export()
@description('The type for data source info properties.')
type dataSourceInfoType = {
  objectType: 'Datasource'
  resourceID: string
  resourceLocation: string
  resourceName: string
  resourceProperties: {
    objectType: string
    // For remaining properties, see BaseResourceProperties objects
  }
  resourceType: string
  resourceUri: string
}

@export()
@description('The type for policy info properties.')
type policyInfoType = {
  policyId: string
  // objectType: string
  // resourceID: string
  // resourceLocation: string
  // resourceName: string
  // resourceProperties: {
  //   objectType: string
  //   // For remaining properties, see BaseResourceProperties objects
  // }
  // resourceType: string
  // resourceUri: string
}

// policyInfo: {
// policyId: 'string'
// policyParameters: {
// backupDatasourceParametersList: [
// {
// objectType: 'string'
// // For remaining properties, see BackupDatasourceParameters objects
// }
// ]
// dataStoreParametersList: [
// {
// dataStoreType: 'string'
// objectType: 'string'
// // For remaining properties, see DataStoreParameters objects
// }
// ]
// }
// }
