// ============================================================================
// ADX Managed Identity Policy Module - Using Database Script Resource
// ============================================================================
// This module configures the ADX cluster's managed identity policy to allow
// native ingestion using the cluster's system-assigned managed identity.
//
// APPROACH:
// Uses Microsoft.Kusto/clusters/databases/scripts resource with scriptLevel='Cluster'
// instead of a deployment script. This is more reliable because:
// - The ARM deployment identity (SP or user) executes the script
// - No separate managed identity authentication needed
// - No storage account required for script execution
// - ARM handles token acquisition and retries
//
// REFERENCE:
// https://learn.microsoft.com/en-us/azure/templates/microsoft.kusto/clusters/databases/scripts
// ============================================================================

@description('Required. Name of the Azure Data Explorer cluster.')
param clusterName string

@description('Required. Name of an existing database in the cluster (any database works for cluster-level scripts).')
param databaseName string

@description('Optional. Force script to run even if nothing changed. Use utcNow() when calling.')
param forceUpdateTag string = utcNow()

// Reference the existing cluster and database
resource cluster 'Microsoft.Kusto/clusters@2024-04-13' existing = {
  name: clusterName
}

resource database 'Microsoft.Kusto/clusters/databases@2024-04-13' existing = {
  parent: cluster
  name: databaseName
}

// The KQL command to set the managed identity policy
// Using "system" as ObjectId refers to the cluster's own system-assigned managed identity
// This is required for ADF to use managed_identity=system in ingestion commands
var kqlCommand = '.alter-merge cluster policy managed_identity ```[{"ObjectId":"system","AllowedUsages":"NativeIngestion"}]```'

// Database script resource with scriptLevel='Cluster' for cluster-level commands
// This executes using the ARM deployment principal's permissions (which has AllDatabasesAdmin)
// Note: scriptContent is marked as 'Sensitive' in the ARM schema, but our KQL command
// contains no secrets - it's a standard policy configuration command
resource miPolicyScript 'Microsoft.Kusto/clusters/databases/scripts@2024-04-13' = {
  parent: database
  name: 'configure-mi-policy'
  properties: {
    #disable-next-line use-secure-value-for-secure-inputs
    scriptContent: kqlCommand
    scriptLevel: 'Cluster'  // Execute as cluster-level command
    continueOnErrors: false
    forceUpdateTag: forceUpdateTag
  }
}

// ============================================================================
// OUTPUTS
// ============================================================================

@description('Script resource ID.')
output scriptResourceId string = miPolicyScript.id

@description('Script name.')
output scriptName string = miPolicyScript.name
