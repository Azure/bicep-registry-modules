targetScope = 'subscription'

metadata name = 'ADX with Managed Network'
metadata description = 'This instance deploys the module with Azure Data Explorer and networkIsolationMode=Managed. This is the RECOMMENDED production configuration - ADX with full private networking, all managed by the module.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-finops-hub-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'fhadm'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. Principal ID of the deployer to grant ADX and storage access for testing.')
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
// This includes Kusto DNS zone for ADX private endpoints.

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
      // ADX Configuration
      // =====================================================
      deploymentType: 'adx'
      dataExplorerClusterName: '${namePrefix}${serviceShort}adx'
      deploymentConfiguration: 'waf-aligned'
      
      // =====================================================
      // KEY SETTING: Managed Network Isolation
      // =====================================================
      // This mode creates a self-contained deployment with:
      // - VNet with /24 address space
      // - Subnet for private endpoints
      // - NSG with secure defaults
      // - Private DNS zones for Storage, Key Vault, Data Factory, AND Kusto
      // - Private endpoints for all resources including ADX cluster
      //
      // Benefits:
      // - Just redeploy to upgrade - no customization to maintain
      // - Module handles all networking complexity including ADX
      // - Enterprise network teams can add their own PEs to access the resources
      networkIsolationMode: 'Managed'
      
      // ADX admin access for testing
      adxAdminPrincipalIds: []
      deployerPrincipalId: deployerPrincipalId
      
      // Telemetry
      enableTelemetry: true
      
      // Tags
      tags: {
        SecurityControl: 'Ignore'
        Environment: 'Production'
        'hidden-title': 'FinOps Hub - ADX Managed Network'
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

@description('The ADX cluster name.')
output dataExplorerName string = testDeployment[0].outputs.dataExplorerName

@description('The ADX cluster endpoint.')
output dataExplorerEndpoint string = testDeployment[0].outputs.dataExplorerEndpoint
