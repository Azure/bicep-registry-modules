// ============================================================================
// ADX Private Endpoint Connection Approval
// ============================================================================
// Approves pending private endpoint connections on the ADX cluster.
// This is called after the managed PE is created from ADF.
// Pattern from: https://github.com/microsoft/finops-toolkit (Analytics/dataExplorerEndpoints.bicep)
// ============================================================================

@description('Required. Name of the ADX cluster.')
param adxClusterName string

@description('Optional. Array of private endpoint connections to approve. If empty, will query the cluster.')
param privateEndpointConnections array = []

// ============================================================================
// RESOURCES
// ============================================================================

// Reference the existing ADX cluster
resource cluster 'Microsoft.Kusto/clusters@2024-04-13' existing = {
  name: adxClusterName
}

// Approve any pending private endpoint connections
// This resource is deployed in a loop for each pending connection
resource approveConnection 'Microsoft.Kusto/clusters/privateEndpointConnections@2024-04-13' = [for connection in privateEndpointConnections: if (connection.properties.privateLinkServiceConnectionState.status == 'Pending') {
  name: last(array(split(connection.id, '/')))
  parent: cluster
  properties: {
    privateLinkServiceConnectionState: {
      status: 'Approved'
      description: 'Approved by FinOps Hub deployment'
    }
  }
}]

// ============================================================================
// OUTPUTS
// ============================================================================

@description('Current private endpoint connections on the cluster (for chaining get->approve pattern).')
output privateEndpointConnections array = cluster.properties.privateEndpointConnections ?? []
