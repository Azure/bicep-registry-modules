targetScope = 'subscription'

metadata name = 'Using Azure Data Explorer with minimal configuration'
metadata description = 'This instance deploys the module with Azure Data Explorer in a cost-effective dev/test configuration.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-finops-hub-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

// Enforced location for ADX tests - Italy North has broad SKU availability
// This avoids SKU availability issues in capacity-constrained regions
var enforcedLocation = 'italynorth'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'fhadx'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// Unique suffix to avoid Key Vault soft-delete naming conflicts across CI runs
// Key Vaults use soft-delete with 90-day retention, causing VaultAlreadyExists errors
// when the same name is reused before purge
var deploymentSuffix = take(uniqueString(deployment().name), 4)

@description('Optional. Principal ID of the deployer to grant ADX access for testing. If not provided, only the ADF managed identity will have access.')
param deployerPrincipalId string = ''

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      // Required parameters - include deployment suffix to avoid Key Vault naming conflicts
      hubName: '${namePrefix}${serviceShort}${deploymentSuffix}'
      // Non-required parameters
      location: enforcedLocation
      deploymentConfiguration: 'minimal'
      deploymentType: 'adx'
      dataExplorerClusterName: '${namePrefix}${serviceShort}adx${deploymentSuffix}'
      enableTelemetry: true
      // Grant deployer access to ADX for testing/verification
      adxAdminPrincipalIds: []
      deployerPrincipalId: deployerPrincipalId
      // Use Dev SKU for testing - cheapest option with modern AMD EPYC v4 hardware
      // Standard_E2a_v4: 2 vCPUs, 16GB RAM, ~$0.15/hr (cheaper than D11_v2)
      dataExplorerSku: 'Dev(No SLA)_Standard_E2a_v4'
      dataExplorerCapacity: 1 // Dev SKU supports single node
      // Minimal config with Dev SKU:
      // - Dev(No SLA)_Standard_E2a_v4 with 1 node (no SLA, but cheapest + modern)
      // - enableAutoStop: true (saves costs when idle)
      tags: {
        SecurityControl: 'Ignore'
        Environment: 'Development'
        'hidden-title': 'FinOps Hub - ADX Minimal'
      }
    }
  }
]
