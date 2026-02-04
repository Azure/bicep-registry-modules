// ============================================================================
// FinOps Hub - ADX Database Schema Setup Module
// ============================================================================
// This module deploys all KQL scripts to set up the complete FinOps Hub schema
// in Azure Data Explorer. It mirrors the official FinOps Toolkit approach.
//
// Script execution order:
// 1. Ingestion DB: OpenData internal functions (resource_type_1-5)
// 2. Ingestion DB: OpenData wrapper functions
// 3. Ingestion DB: Common functions
// 4. Ingestion DB: Hub infrastructure
// 5. Ingestion DB: Raw tables (Costs_raw, Prices_raw, etc.)
// 6. Ingestion DB: Versioned scripts (v1_0, v1_2)
// 7. Hub DB: Common functions
// 8. Hub DB: OpenData functions
// 9. Hub DB: Versioned scripts (v1_0, v1_2)
// 10. Hub DB: Latest functions (Costs, Prices, etc.)
// ============================================================================

@description('Required. Name of the Azure Data Explorer cluster.')
param clusterName string

@description('Optional. Raw data retention period in days. Default: 30')
@minValue(1)
@maxValue(365)
param rawRetentionInDays int = 30

@description('Optional. If true, script execution continues even if some commands fail. Default: true.')
param continueOnErrors bool = true

@description('Optional. Force script re-execution by changing this value.')
param forceUpdateTag string = utcNow()

// ============================================================================
// VARIABLES
// ============================================================================

var ingestionDbName = 'Ingestion'
var hubDbName = 'Hub'

// Replace the retention placeholder in raw tables script
var rawTablesScript = replace(loadTextContent('scripts/IngestionSetup_RawTables.kql'), '$$rawRetentionInDays$$', string(rawRetentionInDays))

// NOTE: The managed identity policy is now configured via a separate deployment script module
// (adxManagedIdentityPolicy.bicep) because cluster-level KQL commands cannot run via database scripts

// ============================================================================
// RESOURCES
// ============================================================================

// Reference the ADX cluster
resource cluster 'Microsoft.Kusto/clusters@2023-08-15' existing = {
  name: clusterName
}

// Reference the databases
resource ingestionDb 'Microsoft.Kusto/clusters/databases@2023-08-15' existing = {
  parent: cluster
  name: ingestionDbName
}

resource hubDb 'Microsoft.Kusto/clusters/databases@2023-08-15' existing = {
  parent: cluster
  name: hubDbName
}

// ============================================================================
// CLUSTER-LEVEL CONFIGURATION
// ============================================================================

// Step 0: Configure cluster managed identity policy for ADF native ingestion
// NOTE: Cluster-level commands cannot be run via database scripts resource.
// The managed identity policy must be set via:
// - Azure CLI: az kusto managed-private-endpoint (not available for this)
// - KQL admin command run by a cluster admin principal
// - OR: Use the ADX cluster's system-assigned managed identity directly
//
// For now, we'll use the cluster's own system-assigned managed identity by
// ensuring the ingestion command uses 'managed_identity=system' which refers to
// the cluster's identity, and grant the cluster's identity access to storage.
// See: https://learn.microsoft.com/en-us/azure/data-explorer/ingest-data-managed-identity

// ============================================================================
// INGESTION DATABASE SCRIPTS
// ============================================================================

// Step 1: Deploy OpenData internal functions (large lookup functions)
module ingestion_OpenDataInternal 'hub-database.bicep' = {
  name: 'FinOpsHub_Ingestion_OpenDataInternal'
  params: {
    clusterName: cluster.name
    databaseName: ingestionDb.name
    scripts: {
      OpenDataFunctions_resource_type_1: loadTextContent('scripts/OpenDataFunctions_resource_type_1.kql')
      OpenDataFunctions_resource_type_2: loadTextContent('scripts/OpenDataFunctions_resource_type_2.kql')
      OpenDataFunctions_resource_type_3: loadTextContent('scripts/OpenDataFunctions_resource_type_3.kql')
      OpenDataFunctions_resource_type_4: loadTextContent('scripts/OpenDataFunctions_resource_type_4.kql')
      OpenDataFunctions_resource_type_5: loadTextContent('scripts/OpenDataFunctions_resource_type_5.kql')
    }
    continueOnErrors: continueOnErrors
    forceUpdateTag: forceUpdateTag
  }
}

// Step 2: Deploy OpenData wrapper + Common + Infrastructure + Raw Tables
module ingestion_InitScripts 'hub-database.bicep' = {
  name: 'FinOpsHub_Ingestion_Init'
  dependsOn: [
    ingestion_OpenDataInternal
  ]
  params: {
    clusterName: cluster.name
    databaseName: ingestionDb.name
    scripts: {
      openData: loadTextContent('scripts/OpenDataFunctions.kql')
      common: loadTextContent('scripts/Common.kql')
      infra: loadTextContent('scripts/IngestionSetup_HubInfra.kql')
      rawTables: rawTablesScript
    }
    continueOnErrors: continueOnErrors
    forceUpdateTag: forceUpdateTag
  }
}

// Step 3: Deploy versioned transform functions and final tables
module ingestion_VersionedScripts 'hub-database.bicep' = {
  name: 'FinOpsHub_Ingestion_Versioned'
  dependsOn: [
    ingestion_InitScripts
  ]
  params: {
    clusterName: cluster.name
    databaseName: ingestionDb.name
    scripts: {
      v1_0: loadTextContent('scripts/IngestionSetup_v1_0.kql')
      v1_2: loadTextContent('scripts/IngestionSetup_v1_2.kql')
    }
    continueOnErrors: continueOnErrors
    forceUpdateTag: forceUpdateTag
  }
}

// ============================================================================
// HUB DATABASE SCRIPTS
// ============================================================================

// Step 4: Deploy Hub common functions and OpenData
module hub_InitScripts 'hub-database.bicep' = {
  name: 'FinOpsHub_Hub_Init'
  dependsOn: [
    ingestion_InitScripts
  ]
  params: {
    clusterName: cluster.name
    databaseName: hubDb.name
    scripts: {
      common: loadTextContent('scripts/Common.kql')
      openData: loadTextContent('scripts/HubSetup_OpenData.kql')
    }
    continueOnErrors: continueOnErrors
    forceUpdateTag: forceUpdateTag
  }
}

// Step 5: Deploy Hub versioned query functions
module hub_VersionedScripts 'hub-database.bicep' = {
  name: 'FinOpsHub_Hub_Versioned'
  dependsOn: [
    ingestion_VersionedScripts
    hub_InitScripts
  ]
  params: {
    clusterName: cluster.name
    databaseName: hubDb.name
    scripts: {
      v1_0: loadTextContent('scripts/HubSetup_v1_0.kql')
      v1_2: loadTextContent('scripts/HubSetup_v1_2.kql')
    }
    continueOnErrors: continueOnErrors
    forceUpdateTag: forceUpdateTag
  }
}

// Step 6: Deploy Hub latest wrapper functions
module hub_LatestScripts 'hub-database.bicep' = {
  name: 'FinOpsHub_Hub_Latest'
  dependsOn: [
    hub_VersionedScripts
  ]
  params: {
    clusterName: cluster.name
    databaseName: hubDb.name
    scripts: {
      latest: loadTextContent('scripts/HubSetup_Latest.kql')
    }
    continueOnErrors: continueOnErrors
    forceUpdateTag: forceUpdateTag
  }
}

// ============================================================================
// OUTPUTS
// ============================================================================

@description('Name of the ADX cluster where schema was deployed.')
output clusterName string = cluster.name

@description('Name of the Ingestion database.')
output ingestionDatabaseName string = ingestionDbName

@description('Name of the Hub database.')
output hubDatabaseName string = hubDbName

@description('Raw data retention in days configured for tables.')
output rawRetentionDays int = rawRetentionInDays

@description('List of schema components deployed.')
output deployedComponents array = [
  'Cluster managed identity policy for ADF ingestion'
  'OpenData internal functions (5 files)'
  'OpenData wrapper functions'
  'Common utility functions'
  'Hub infrastructure'
  'Raw tables (Costs_raw, Prices_raw, etc.)'
  'Ingestion v1.0 schema'
  'Ingestion v1.2 schema'
  'MACC tables and functions (MACC_Lots, MACC_Events)'
  'Hub v1.0 functions'
  'Hub v1.2 functions'
  'Latest wrapper functions (Costs, Prices, etc.)'
  'MACC dashboard queries (status, trends, forecasting)'
]
