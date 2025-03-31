metadata name = 'Data Protection Backup Vault Backup Instances'
metadata description = 'This module deploys a Data Protection Backup Vault Backup Instance.'

@description('Conditional. The name of the parent Backup Vault. Required if the template is used in a standalone deployment.')
param backupVaultName string

@description('Required. The name of the backup instance.')
param name string

@description('Optional. The friendly name of the backup instance.')
param friendlyName string?

@description('Required. Gets or sets the data source information.')
param dataSourceInfo dataSourceInfoType

@description('Required. Gets or sets the policy information.')
param policyInfo policyInfoType

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

module backupInstance_dataSourceResource_rbac 'modules/nested_dataSourceResourceRoleAssignment.bicep' = {
  name: '${backupVault.name}-dataSourceResource-rbac'
  params: {
    resourceId: dataSourceInfo.resourceID
    principalId: backupVault.identity.principalId
  }
}

resource backupInstance 'Microsoft.DataProtection/backupVaults/backupInstances@2024-04-01' = {
  name: name
  parent: backupVault
  properties: {
    friendlyName: friendlyName
    objectType: 'BackupInstance'
    dataSourceInfo: dataSourceInfo
    policyInfo: policyInfoVar
    // tags: tags
    // datasourceAuthCredentials
    // identityDetails
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
  resourceType: string?
  resourceUri: string?
}

@export()
@description('The type for policy info properties.')
type policyInfoType = {
  policyName: string
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
