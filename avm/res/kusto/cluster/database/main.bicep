metadata name = 'Kusto Cluster Databases'
metadata description = 'This module deploys a Kusto Cluster Database.'

@description('Required. The name of the Kusto Cluster database.')
param name string

@description('Conditional. The name of the parent Kusto Cluster. Required if the template is used in a standalone deployment.')
param kustoClusterName string

@description('Optional. Location for the databases.')
param location string = resourceGroup().location

@description('Optional. The object type of the databse.')
@allowed([
  'ReadWrite'
  'ReadOnlyFollowing'
])
param databaseKind string = 'ReadWrite'

@description('Optional. The properties of the database if using read-write. Only used if databaseKind is ReadWrite.')
param databaseReadWriteProperties databaseReadWriteType

@description('Optional. The principal assignments for the Kusto database.')
param databasePrincipalAssignments databasePrincipalAssignmentType[]?

// ============== //
// Resources      //
// ============== //

resource kustoCluster 'Microsoft.Kusto/clusters@2024-04-13' existing = {
  name: kustoClusterName
}

resource database_readWrite 'Microsoft.Kusto/clusters/databases@2024-04-13' = if (databaseKind == 'ReadWrite') {
  name: name
  parent: kustoCluster
  location: location
  kind: 'ReadWrite'
  properties: databaseReadWriteProperties ?? null
}

resource database_readOnly 'Microsoft.Kusto/clusters/databases@2024-04-13' = if (databaseKind == 'ReadOnlyFollowing') {
  name: name
  parent: kustoCluster
  location: location
  kind: 'ReadOnlyFollowing'
}

module database_readWrite_PrincipalAssignment './principal-assignment/main.bicep' = [
  for (principalAssignment, index) in (databasePrincipalAssignments ?? []): {
    name: '${uniqueString(deployment().name, location)}-KustoDb-PrincipalAssignment-${index}'
    params: {
      kustoClusterName: kustoClusterName
      kustoDatabaseName: databaseKind == 'ReadOnlyFollowing' ? database_readOnly.name : database_readWrite.name
      principalId: principalAssignment.principalId
      principalType: principalAssignment.principalType
      role: principalAssignment.role
      tenantId: principalAssignment.tenantId
    }
  }
]

// =============== //
//     Outputs     //
// =============== //

@description('The name of the Kusto Cluster database.')
output name string = databaseKind == 'ReadOnlyFollowing' ? database_readOnly.name : database_readWrite.name

@description('The resource ID of the Kusto Cluster database.')
output resourceId string = databaseKind == 'ReadOnlyFollowing' ? database_readOnly.id : database_readWrite.id

@description('The resource group containing the Kusto Cluster database.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
@description('Conditional. The properties of the database if using read-write.')
type databaseReadWriteType = {
  @description('Optional. Te time the data should be kept in cache for fast queries in TimeSpan.')
  hotCachePeriod: string?
  @description('Optional. The properties of the key vault.')
  keyVaultProperties: {
    @description('Optional. The name of the key.')
    keyName: string?
    @description('Optional. The Uri of the key vault.')
    keyVaultUri: string?
    @description('Optional. The version of the key.')
    keyVersion: string?
    @description('Optional. The user identity.')
    userIdentity: string?
  }?
  @description('Optional. The time the data should be kept before it stops being accessible to queries in TimeSpan.')
  softDeletePeriod: string?
}?

@export()
@description('The type of a database principal assignment.')
type databasePrincipalAssignmentType = {
  @description('Required. The principal id assigned to the Kusto Cluster database principal. It can be a user email, application id, or security group name.')
  principalId: string

  @description('Required. The principal type of the principal id.')
  principalType: 'App' | 'Group' | 'User'

  @description('Required. The Kusto Cluster database role to be assigned to the principal id.')
  role: 'Admin' | 'Ingestor' | 'Monitor' | 'UnrestrictedViewer' | 'User' | 'Viewer'

  @description('Required. The tenant id of the principal.')
  tenantId: string
}

