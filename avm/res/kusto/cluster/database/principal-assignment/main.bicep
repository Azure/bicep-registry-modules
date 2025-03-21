metadata name = 'Kusto Cluster Database Principal Assignments'
metadata description = 'This module deploys a Kusto Cluster Database Principal Assignment.'

@minLength(4)
@maxLength(22)
@description('Conditional. The name of the parent Kusto Cluster Database. Required if the template is used in a standalone deployment.')
param kustoClusterDatabaseName string

@description('Required. The principal assignement for the Kusto Cluster Database.')
param databasePrincipalAssignment databasePrincipalAssignmentType

// ============== //
// Resources      //
// ============== //

@minLength(4)
@maxLength(22)
@description('Conditional. The name of the Kusto cluster.')
param clusterName string

@minLength(4)
@maxLength(22)
@description('Conditional. The name of the parent Kusto Cluster Database. Required if the template is used in a standalone deployment.')
param databaseName string

resource kustoCluster 'Microsoft.Kusto/clusters@2024-04-13' existing  = {
  name: clusterName

  resource database 'databases@2024-04-13' existing = {
    name: databaseName
  }
}

resource kustoDatabasePrincipalAssignment 'Microsoft.Kusto/clusters/databases/principalAssignments@2024-04-13' = {
  name: databasePrincipalAssignment.principalId
  parent: kustoCluster::databaseName
  properties: {
    principalId: databasePrincipalAssignment.principalId
    principalType: databasePrincipalAssignment.principalType
    role: databasePrincipalAssignment.role
    tenantId: databasePrincipalAssignment.tenantId
  }
}

// =============== //
//     Outputs     //
// =============== //

@description('The name of the deployed Kusto Cluster Database Principal Assignment.')
output name string = kustoDatabasePrincipalAssignment.name

@description('The resource id of the deployed Kusto Cluster Database Principal Assignment.')
output resourceId string = kustoClusterDatabase.id

@description('The resource group name of the deployed Kusto Cluster Database Principal Assignment.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
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
