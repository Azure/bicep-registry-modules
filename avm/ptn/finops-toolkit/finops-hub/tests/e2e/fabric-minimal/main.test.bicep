targetScope = 'subscription'

metadata name = 'Using Microsoft Fabric with minimal configuration'
metadata description = 'This instance deploys the module with Microsoft Fabric Eventhouse in a cost-effective dev/test configuration.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-finops-hub-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'fhfab'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// Unique suffix to avoid Key Vault soft-delete naming conflicts across CI runs
// Key Vaults use soft-delete with 90-day retention, causing VaultAlreadyExists errors
// when the same name is reused before purge
var deploymentSuffix = take(uniqueString(deployment().name), 4)

// NOTE: Fabric Eventhouse must be pre-created in Microsoft Fabric workspace.
// These URIs are obtained from your Fabric eventhouse settings.
// For automated testing, set these via pipeline parameters or parameter file.
@description('Required for Fabric tests. The query URI of the Microsoft Fabric eventhouse.')
param fabricQueryUri string = ''

@description('Optional. The ingestion URI of the Microsoft Fabric eventhouse.')
param fabricIngestionUri string = ''

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

// ============== //
// Test Execution //
// ============== //

// Note: This test requires a pre-existing Fabric eventhouse.
// Skip deployment if fabricQueryUri is not provided.
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: if (!empty(fabricQueryUri)) {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      // Required parameters - include deployment suffix to avoid Key Vault naming conflicts
      hubName: '${namePrefix}${serviceShort}${deploymentSuffix}'
      // Non-required parameters
      location: resourceLocation
      deploymentConfiguration: 'minimal'
      deploymentType: 'fabric'
      
      // Fabric Eventhouse configuration
      // The eventhouse must be pre-created in your Fabric workspace
      fabricQueryUri: fabricQueryUri
      fabricIngestionUri: fabricIngestionUri
      fabricDatabaseName: 'finops'
      
      enableTelemetry: true
      
      // Minimal config uses:
      // - Standard_LRS storage (cost-effective)
      // - No purge protection (easier cleanup)
      // - Public network access enabled
      tags: {
        SecurityControl: 'Ignore'
        Environment: 'Development'
        'hidden-title': 'FinOps Hub - Fabric Minimal'
      }
    }
  }
]
