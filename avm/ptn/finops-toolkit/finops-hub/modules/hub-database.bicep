// ============================================================================
// FinOps Hub - Database Script Deployment Module
// ============================================================================
// Deploys KQL scripts to Azure Data Explorer databases during Bicep deployment.
// This mirrors the official FinOps Toolkit approach using Microsoft.Kusto/clusters/databases/scripts.
// ============================================================================

@description('Required. Name of the Azure Data Explorer cluster.')
param clusterName string

@description('Required. Name of the database to run scripts on.')
param databaseName string

@description('Required. Dictionary of scripts to run. Key = script name, Value = KQL script content.')
param scripts object

@description('Optional. If true, script execution continues even if some commands fail. Default: true.')
param continueOnErrors bool = true

@description('Optional. Force script re-execution by changing this value. Uses current UTC time by default.')
param forceUpdateTag string = utcNow()

// ============================================================================
// RESOURCES
// ============================================================================

// Reference the existing ADX cluster and database
resource cluster 'Microsoft.Kusto/clusters@2024-04-13' existing = {
  name: clusterName

  resource database 'databases' existing = {
    name: databaseName

    // Deploy each script as a database script resource
    // This is the key mechanism that runs KQL during Bicep deployment
    resource script 'scripts' = [for scr in items(scripts): {
      name: scr.key
      properties: {
        // The actual KQL script content
        #disable-next-line use-secure-value-for-secure-inputs // KQL scripts don't contain sensitive information
        scriptContent: scr.value
        // Allow partial success - some commands may fail if objects already exist
        continueOnErrors: continueOnErrors
        // Changing this forces re-execution of the script
        forceUpdateTag: forceUpdateTag
      }
    }]
  }
}

// ============================================================================
// OUTPUTS
// ============================================================================

@description('Cluster name where scripts were deployed.')
output clusterName string = cluster.name

@description('Database name where scripts were deployed.')
output databaseName string = databaseName

@description('Number of scripts deployed.')
output scriptCount int = length(items(scripts))
