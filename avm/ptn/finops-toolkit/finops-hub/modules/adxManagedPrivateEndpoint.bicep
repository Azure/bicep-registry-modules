// ============================================================================
// ADX Managed Private Endpoint for ADF
// ============================================================================
// Creates a managed private endpoint from ADF's managed VNet to the ADX cluster.
// This is deployed AFTER both ADF and ADX exist to avoid circular dependencies.
// Pattern from: https://github.com/microsoft/finops-toolkit (Analytics/app.bicep)
// ============================================================================

@description('Required. Name of the Data Factory.')
param dataFactoryName string

@description('Required. Name of the ADX cluster.')
param adxClusterName string

@description('Required. Resource ID of the ADX cluster.')
param adxClusterResourceId string

@description('Required. Azure region (for constructing ADX FQDN).')
param location string

// ============================================================================
// RESOURCES
// ============================================================================

// Reference the existing Data Factory
resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

// Reference the existing managed VNet (created when ADF was deployed with managedVirtualNetwork)
resource managedVNet 'Microsoft.DataFactory/factories/managedVirtualNetworks@2018-06-01' existing = {
  name: 'default'
  parent: dataFactory
}

// Create the managed private endpoint for ADX cluster
// This allows ADF pipelines running in the managed VNet to reach ADX privately
resource adxManagedPrivateEndpoint 'Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints@2018-06-01' = {
  name: '${adxClusterName}-mpe'
  parent: managedVNet
  properties: {
    groupId: 'cluster'
    privateLinkResourceId: adxClusterResourceId
    fqdns: [
      'https://${adxClusterName}.${location}.kusto.windows.net'
    ]
  }
}

// Create the managed private endpoint for ADX ingestion
// Required for data ingestion operations (uses ingest- prefix FQDN)
resource adxIngestionManagedPrivateEndpoint 'Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints@2018-06-01' = {
  name: '${adxClusterName}-ingest-mpe'
  parent: managedVNet
  properties: {
    groupId: 'ingestion'
    privateLinkResourceId: adxClusterResourceId
    fqdns: [
      'https://ingest-${adxClusterName}.${location}.kusto.windows.net'
    ]
  }
}

// ============================================================================
// OUTPUTS
// ============================================================================

@description('Name of the created cluster managed private endpoint.')
output clusterManagedPrivateEndpointName string = adxManagedPrivateEndpoint.name

@description('Name of the created ingestion managed private endpoint.')
output ingestionManagedPrivateEndpointName string = adxIngestionManagedPrivateEndpoint.name

@description('Provisioning state of the cluster managed private endpoint.')
output clusterProvisioningState string = adxManagedPrivateEndpoint.properties.provisioningState ?? 'Unknown'

@description('Provisioning state of the ingestion managed private endpoint.')
output ingestionProvisioningState string = adxIngestionManagedPrivateEndpoint.properties.provisioningState ?? 'Unknown'

@description('Connection state of the cluster managed private endpoint.')
output clusterConnectionState string = adxManagedPrivateEndpoint.properties.connectionState.status ?? 'Pending'

@description('Connection state of the ingestion managed private endpoint.')
output ingestionConnectionState string = adxIngestionManagedPrivateEndpoint.properties.connectionState.status ?? 'Pending'
