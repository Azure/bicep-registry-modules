// ============================================================================
// ADX Managed Identity Policy Module - Enables Native Ingestion from ADF
// ============================================================================
// This module configures the ADX cluster's managed identity policy to allow
// native ingestion using the cluster's system-assigned managed identity.
//
// BACKGROUND:
// Azure Data Explorer requires explicit policy configuration to allow managed
// identity-based ingestion. The ingestion command uses 'managed_identity=system'
// which refers to the ADX cluster's own system-assigned identity. This policy
// must be set at the cluster level before any ingestion can occur.
//
// WHY A DEPLOYMENT SCRIPT?
// Cluster-level KQL commands (like .alter-merge cluster policy) cannot be
// executed via the Microsoft.Kusto/clusters/databases/scripts resource.
// Database scripts are limited to database-scoped commands only.
// Therefore, we use a deployment script with REST API calls.
//
// REQUIREMENTS:
// - The managed identity running this script needs "Cluster Admin" or
//   "AllDatabasesAdmin" role on the ADX cluster
// - Storage account with allowSharedKeyAccess: true for deployment script execution
//   (ACI mounts storage via access key - this is a platform limitation)
//
// REFERENCE:
// https://learn.microsoft.com/en-us/azure/data-explorer/ingest-data-managed-identity
// ============================================================================

@description('Required. Name of the Azure Data Explorer cluster.')
param clusterName string

@description('Required. Location for the deployment script resources.')
param location string = resourceGroup().location

@description('Required. Managed identity resource ID for running the script.')
param managedIdentityResourceId string

@description('Optional. Force script to run even if nothing changed. Use utcNow() when calling.')
param forceUpdateTag string = utcNow()

@description('Optional. Timeout for the script execution. Allows 3 min initial wait + 30 retries × 20s = 13 min.')
param timeout string = 'PT20M'

@description('Optional. Tags to apply to resources.')
param tags object = {}

// ============================================================================
// VARIABLES
// ============================================================================

// Generate a unique storage account name for deployment scripts
// Name starts with 'dep' to match PSRule suppression rules for dependencies
// Uses stable inputs (RG + cluster name) to avoid creating new storage accounts each run
var deploymentScriptStorageName = 'dep${take(uniqueString(resourceGroup().id, clusterName), 21)}'

// Reference the ADX cluster to get its URI
resource cluster 'Microsoft.Kusto/clusters@2024-04-13' existing = {
  name: clusterName
}

// ============================================================================
// DEPLOYMENT SCRIPT STORAGE ACCOUNT
// ============================================================================
// Deployment scripts require a storage account with allowSharedKeyAccess: true
// because Azure Container Instance (ACI) can only mount storage via access keys.
// This is a platform limitation documented at:
// https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-bicep
//
// The SecurityControl: 'Ignore' tag exempts this storage account from policies
// that enforce disabling shared key access.
resource deploymentScriptStorage 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: deploymentScriptStorageName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  tags: union(tags, {
    'ms-resource-usage': 'azure-deployment-script'
    SecurityControl: 'Ignore' // Exempt from policies disabling shared key access
  })
  properties: {
    // REQUIRED: ACI can only mount storage via access keys
    allowSharedKeyAccess: true
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    publicNetworkAccess: 'Enabled' // Required for deployment script container access
    networkAcls: {
      defaultAction: 'Allow' // Required for ACI access during deployment
      bypass: 'AzureServices'
    }
  }
}

// PowerShell script loaded from external file for maintainability
// See: modules/scripts/Set-AdxManagedIdentityPolicy.ps1
var policyScript = loadTextContent('scripts/Set-AdxManagedIdentityPolicy.ps1')

// ============================================================================
// RESOURCES
// ============================================================================

// Deployment script to configure the managed identity policy
// Use stable name so idempotent redeployments update in place; forceUpdateTag triggers re-execution
resource policySetupScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'adx-mi-policy-${uniqueString(resourceGroup().id, clusterName)}'
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityResourceId}': {}
    }
  }
  properties: {
    azPowerShellVersion: '11.0'
    retentionInterval: 'PT1H'
    timeout: timeout
    cleanupPreference: 'OnSuccess'
    forceUpdateTag: forceUpdateTag
    environmentVariables: [
      {
        name: 'CLUSTER_URI'
        value: cluster.properties.uri
      }
      {
        name: 'SUBSCRIPTION_ID'
        value: subscription().subscriptionId
      }
    ]
    scriptContent: policyScript
    // Use our dedicated storage account with allowSharedKeyAccess: true
    // ACI requires access key authentication - this is a platform limitation
    storageAccountSettings: {
      storageAccountName: deploymentScriptStorage.name
      storageAccountKey: deploymentScriptStorage.listKeys().keys[0].value
    }
  }
}

// ============================================================================
// OUTPUTS
// ============================================================================

@description('Status of the managed identity policy configuration.')
output status string = policySetupScript.properties.outputs.status

@description('Deployment script resource ID.')
output scriptResourceId string = policySetupScript.id

@description('Deployment script storage account name.')
output storageAccountName string = deploymentScriptStorage.name
