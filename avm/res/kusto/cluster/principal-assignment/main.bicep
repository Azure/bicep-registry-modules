metadata name = 'Kusto Cluster Principal Assignments'
metadata description = 'This module deploys a Kusto Cluster Principal Assignment.'

@minLength(4)
@maxLength(22)
@description('Conditional. The name of the parent Kusto Cluster. Required if the template is used in a standalone deployment.')
param kustoClusterName string

@description('Required. The principal id assigned to the Kusto Cluster principal. It can be a user email, application id, or security group name.')
param clusterPrincipalAssignment clusterPrincipalAssignmentType

// ============== //
// Resources      //
// ============== //

resource kustoCluster 'Microsoft.Kusto/clusters@2024-04-13' existing = {
  name: kustoClusterName
}

resource kustoClusterPrincipalAssignment 'Microsoft.Kusto/clusters/principalAssignments@2023-08-15' = {
  name: clusterPrincipalAssignment.principalId
  parent: kustoCluster
  properties: {
    principalId: clusterPrincipalAssignment.principalId
    principalType: clusterPrincipalAssignment.principalType
    role: clusterPrincipalAssignment.role
    tenantId: clusterPrincipalAssignment.tenantId
  }
}

// =============== //
//     Outputs     //
// =============== //

@description('The name of the deployed Kusto Cluster Principal Assignment.')
output name string = kustoClusterPrincipalAssignment.name

@description('The resource id of the deployed Kusto Cluster Principal Assignment.')
output resourceId string = kustoClusterPrincipalAssignment.id

@description('The resource group name of the deployed Kusto Cluster Principal Assignment.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
type clusterPrincipalAssignmentType = {
  @description('Required. The principal id assigned to the Kusto Cluster principal. It can be a user email, application id, or security group name.')
  principalId: string

  @description('Required. The principal type of the principal id.')
  principalType: 'App' | 'Group' | 'User'

  @description('Required. The Kusto Cluster role to be assigned to the principal id.')
  role: 'AllDatabasesAdmin' | 'AllDatabasesViewer'

  @description('Required. The tenant id of the principal.')
  tenantId: string
}
