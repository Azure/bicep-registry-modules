metadata name = 'Kusto Cluster Database Principal Assignments'
metadata description = 'This module deploys a Kusto Cluster Database Principal Assignment.'

@maxLength(22)
@description('Required. The name of the Kusto cluster.')
param kustoClusterName string

@minLength(4)
@maxLength(22)
@description('Required. The name of the parent Kusto Cluster Database. Required if the template is used in a standalone deployment.')
param kustoDatabaseName string

@description('Required. The principal id assigned to the Kusto Cluster database principal. It can be a user email, application id, or security group name.')
param principalId string

@description('Required. The principal type of the principal id.')
@allowed([
  'App'
  'Group'
  'User'
])
param principalType string

@description('Required. The Kusto Cluster database role to be assigned to the principal id.')
@allowed([
  'Admin'
  'Ingestor'
  'Monitor'
  'UnrestrictedViewer'
  'User'
  'Viewer'
])
param role string

@description('Optional. The tenant id of the principal.')
param tenantId string = tenant().tenantId

// ============== //
// Resources      //
// ============== //

resource cluster 'Microsoft.Kusto/clusters@2024-04-13' existing  = {
  name: kustoClusterName

  resource database 'databases@2024-04-13' existing = {
    name: kustoDatabaseName
  }
}

resource kustoClusterDatabasePrincipalAssignment 'Microsoft.Kusto/clusters/databases/principalAssignments@2024-04-13' = {
  name: principalId
  parent: cluster::database
  properties: {
    principalId: principalId
    principalType: principalType
    role: role
    tenantId: tenantId
  }
}

// =============== //
//     Outputs     //
// =============== //

@description('The name of the deployed Kusto Cluster Database Principal Assignment.')
output name string = kustoClusterDatabasePrincipalAssignment.name

@description('The resource id of the deployed Kusto Cluster Database Principal Assignment.')
output resourceId string = kustoClusterDatabasePrincipalAssignment.id

@description('The resource group name of the deployed Kusto Cluster Database Principal Assignment.')
output resourceGroupName string = resourceGroup().name
