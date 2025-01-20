metadata name = 'Kusto Cluster Principal Assignments'
metadata description = 'This module deploys a Kusto Cluster Principal Assignment.'

@minLength(4)
@maxLength(22)
@description('Conditional. The name of the parent Kusto Cluster. Required if the template is used in a standalone deployment.')
param kustoClusterName string

@description('Required. The principal id assigned to the Kusto Cluster principal. It can be a user email, application id, or security group name.')
param principalId string

@allowed([
  'App'
  'Group'
  'User'
])
@description('Required. The principal type of the principal id.')
param principalType string

@allowed([
  'AllDatabasesAdmin'
  'AllDatabasesViewer'
])
@description('Required. The Kusto Cluster role to be assigned to the principal id.')
param role string

@description('Optional. The tenant id of the principal id.')
param tenantId string = tenant().tenantId

resource kustoCluster 'Microsoft.Kusto/clusters@2023-08-15' existing = {
  name: kustoClusterName
}

resource kustoClusterPrincipalAssignment 'Microsoft.Kusto/clusters/principalAssignments@2023-08-15' = {
  name: principalId
  parent: kustoCluster
  properties: {
    principalId: principalId
    principalType: principalType
    role: role
    tenantId: tenantId
  }
}

@description('The name of the deployed Kusto Cluster Principal Assignment.')
output name string = kustoClusterPrincipalAssignment.name

@description('The resource id of the deployed Kusto Cluster Principal Assignment.')
output resourceId string = kustoClusterPrincipalAssignment.id

@description('The resource group name of the deployed Kusto Cluster Principal Assignment.')
output resourceGroupName string = resourceGroup().name
