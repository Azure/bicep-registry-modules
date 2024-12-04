metadata name = 'Kusto Cluster Databases'
metadata description = 'This module deploys a Kusto Cluster Database.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the Kusto Cluster database.')
param name string

@description('Conditional. The name of the parent Kusto Cluster. Required if the template is used in a standalone deployment.')
param kustoClusterName string

@description('Optional. The object type of the databse.')
@allowed([
  'ReadWrite'
  'ReadOnlyFollowing'
])
param databaseKind string = 'ReadWrite'

@description('Optional. The properties of the database if using read-write. Only used if databaseKind is ReadWrite.')
param databaseReadWriteProperties databaseReadWriteType

resource kustoCluster 'Microsoft.Kusto/clusters@2023-08-15' existing = {
  name: kustoClusterName
}

resource database_readOnly 'Microsoft.Kusto/clusters/databases@2023-08-15' = if (databaseKind == 'ReadOnlyFollowing') {
  name: name
  parent: kustoCluster
  kind: 'ReadOnlyFollowing'
}

resource database_readWrite 'Microsoft.Kusto/clusters/databases@2023-08-15' = if (databaseKind == 'ReadWrite') {
  name: name
  parent: kustoCluster
  kind: 'ReadWrite'
  properties: databaseKind == 'ReadWrite' ? databaseReadWriteProperties : null
}

// =============== //
//     Outputs     //
// =============== //

@description('The name of the Kusto Cluster database.')
output databaseName string = name

@description('The resource ID of the Kusto Cluster database.')
output databaseResourceId string = databaseKind == 'ReadWrite' ? database_readWrite.id : database_readOnly.id

@description('The name of the Kusto Cluster read-only following database.')
output databaseNameReadOnly string = databaseKind == 'ReadOnlyFollowing' ? database_readOnly.name : ''

@description('The name of the Kusto Cluster read-write database.')
output databaseNameReadWrite string = databaseKind == 'ReadWrite' ? database_readWrite.name : ''

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
