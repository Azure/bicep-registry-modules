metadata name = 'Data Protection Backup Vault Backup Instances'
metadata description = 'This module deploys a Data Protection Backup Vault Backup Instance.'

@description('Conditional. The name of the parent Backup Vault. Required if the template is used in a standalone deployment.')
param backupVaultName string

@description('Required. The name of the backup instance.')
param name string

// @description('Optional. The backup instance object type.')
// param objectType string = 'BackupInstance'

@description('Required. Gets or sets the data source information.')
param dataSourceInfo dataSourceInfoType

@description('Required. Gets or sets the policy information.')
param policyInfo policyInfoType

// var resourceType = '${split(dataSourceInfo.resourceID, '/')[6]}/${split(dataSourceInfo.resourceID, '/')[7]}'

resource backupVault 'Microsoft.DataProtection/backupVaults@2023-05-01' existing = {
  name: backupVaultName

  resource backupPolicy 'backupPolicies@2023-05-01' existing = {
    name: policyInfo.policyName
  }
}

var policyInfoVar = {
  policyId: backupVault::backupPolicy.id
  policyParameters: policyInfo.policyParameters
}
// resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' existing = if (resourceType == 'Microsoft.Storage/storageAccounts') {
//   name: last(split(dataSourceInfo.resourceID, '/'))
//   scope: resourceGroup(split(dataSourceInfo.resourceID, '/')[2], split(dataSourceInfo.resourceID, '/')[4])
// }

// // Req: assign permission on storage or on disk (storage account backup contributor)
// resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid(resourceGroup().id, storageAccount.id, backupVault.id)
//   scope: storageAccount
//   properties: {
//     roleDefinitionId: subscriptionResourceId(
//       'Microsoft.Authorization/roleDefinitions',
//       'e5e2a7ff-d759-4cd2-bb51-3152d37e2eb1' // Storage Account Backup Contributor
//     )
//     principalId: backupVault.identity.principalId
//     principalType: 'ServicePrincipal'
//   }
// }

module backupInstance_dataSourceResource_rbac 'modules/nested_dataSourceResourceRoleAssignment.bicep' = {
  name: '${backupVault.name}-dataSourceResource-rbac'
  // scope: resourceGroup(split(dataSourceInfo.resourceID, '/')[2], split(dataSourceInfo.resourceID, '/')[4])
  params: {
    resourceId: dataSourceInfo.resourceID
    principalId: backupVault.identity.principalId
  }
}

resource backupInstance 'Microsoft.DataProtection/backupVaults/backupInstances@2024-04-01' = {
  name: name
  parent: backupVault
  properties: {
    objectType: 'BackupInstance'
    dataSourceInfo: dataSourceInfo
    policyInfo: policyInfoVar
    // tags: tags
    // datasourceAuthCredentials
    // identityDetails
    // dataSourceSetInfo
    // friendlyName
    // resourceGuardOperationRequests
    // validationType
  }
  dependsOn: [
    backupInstance_dataSourceResource_rbac
  ]
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
  datasourceType: string? //TODO check allowed values
  objectType: 'Datasource'
  resourceID: string
  resourceLocation: string?
  resourceName: string?
  // resourceProperties: object?
  resourceType: string?
  resourceUri: string?
}

@export()
@description('The type for policy info properties.')
type policyInfoType = {
  policyName: string
  policyId: string?
  policyParameters: object
  // policyParameters: {
  //   backupDatasourceParametersList: backupDatasourceParameterType[]?
  //   dataStoreParametersList: dataStoreParameterType[]?
  // }?
}

// @export() //TODO: implement discriminator
// @description('The type for backupDatasourceParameter properties.')
// type backupDatasourceParameterType = {
//   objectType: 'BlobBackupDatasourceParameters' | 'KubernetesClusterBackupDatasourceParameters'
//   // containersList: string[]
// }

// @export()
// @description('The type for dataStoreParameter properties.')
// type dataStoreParameterType = {
//   objectType: 'AzureOperationalStoreParameters'
//   dataStoreType: 'ArchiveStore' | 'OperationalStore' | 'VaultStore'
//   resourceGroupId: string?
// }
