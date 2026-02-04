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

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'fhmng'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. Principal ID of the deployer to grant storage access for testing.')
param deployerPrincipalId string = ''

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
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
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      // Required parameters
      hubName: '${namePrefix}${serviceShort}'
      
      // Non-required parameters
      location: resourceLocation
      
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
