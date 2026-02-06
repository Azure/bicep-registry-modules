targetScope = 'subscription'

metadata name = 'Managed Network Isolation'
metadata description = 'This instance deploys the module with networkIsolationMode=Managed, which creates a self-contained VNet, private endpoints, and DNS zones. This is the RECOMMENDED approach for production - enables clean upgrades without customization.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-finops-hub-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

// ========================================================================
// ENFORCED LOCATION FOR CI RELIABILITY
// ========================================================================
// WAF-aligned deployments require Premium_ZRS storage, which is not available
// in all regions. The CI rotation (uksouth, northeurope, westeurope) can land
// on regions without Premium_ZRS availability.
//
// Italy North supports Premium_ZRS and has good capacity for ADX/storage deployments.
// This ensures consistent CI results regardless of rotation.
var enforcedLocation = 'italynorth'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'fhmng'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// Unique suffix to avoid Key Vault soft-delete naming conflicts across CI runs
// Key Vaults use soft-delete with 90-day retention, causing VaultAlreadyExists errors
// when the same name is reused before purge
var deploymentSuffix = take(uniqueString(deployment().name), 4)

@description('Optional. Principal ID of the deployer to grant storage access for testing.')
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

// NOTE: No dependencies.bicep needed for Managed mode!
// The module creates its own VNet, subnet, private DNS zones, and private endpoints.
// This is a key benefit of Managed mode - simpler deployment, no external dependencies.

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
      
      // =====================================================
      // KEY SETTING: Managed Network Isolation
      // =====================================================
      // This mode creates a self-contained deployment with:
      // - VNet with /24 address space
      // - Subnet for private endpoints
      // - NSG with secure defaults
      // - Private DNS zones for all required services
      // - Private endpoints for Storage, Key Vault, Data Factory
      //
      // Benefits:
      // - Just redeploy to upgrade - no customization to maintain
      // - Module handles all networking complexity
      // - Enterprise network teams can add their own PEs to access the resources
      networkIsolationMode: 'Managed'
      
      // Optional: Customize address space if needed (defaults shown)
      // managedVnetAddressPrefix: '10.0.0.0/24'
      // managedSubnetAddressPrefix: '10.0.0.0/26'
      
      // Storage-only deployment for faster testing (no ADX)
      deploymentType: 'storage-only'
      deploymentConfiguration: 'waf-aligned'
      
      // Deployer access for testing
      deployerPrincipalId: deployerPrincipalId
      
      // Telemetry
      enableTelemetry: true
      
      // Tags
      tags: {
        SecurityControl: 'Ignore'
        Environment: 'Production'
        'hidden-title': 'FinOps Hub - Managed Network Isolation'
        CostCenter: 'FinOps'
        Criticality: 'High'
        NetworkMode: 'Managed'
      }
    }
  }
]

// ============== //
// Outputs        //
// ============== //

@description('The network isolation mode used.')
output networkIsolationMode string = testDeployment[0].outputs.networkIsolationMode

@description('The VNet resource ID (created by the module).')
output vnetResourceId string = testDeployment[0].outputs.vnetResourceId

@description('The private endpoint subnet resource ID.')
output subnetResourceId string = testDeployment[0].outputs.privateEndpointSubnetResourceId
