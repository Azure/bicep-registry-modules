targetScope = 'subscription'

metadata name = 'ADX WAF-aligned'
metadata description = 'This instance deploys the module with Azure Data Explorer in alignment with the best-practices of the Azure Well-Architected Framework, including private endpoints.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-finops-hub-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
#disable-next-line no-unused-params // CI convention; test uses enforcedLocation for SKU availability
param resourceLocation string = deployment().location

// Enforced location for ADX tests - Italy North has broad SKU availability
// This avoids SKU availability issues in capacity-constrained regions
var enforcedLocation = 'italynorth'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'fhaxw'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// Stable suffix for idempotent deployments — must NOT depend on deployment().name
// which changes every CI run, causing orphan resources instead of in-place updates.
// Uses subscription + namePrefix + serviceShort so the name is identical across runs.
var deploymentSuffix = take(uniqueString(subscription().subscriptionId, namePrefix, serviceShort), 4)

@description('Optional. Principal ID of the deployer to grant ADX access for testing. If not provided, only the ADF managed identity will have access.')
param deployerPrincipalId string = ''

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

// Deploy networking dependencies (VNet, subnets, private DNS zones)
module dependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-dependencies'
  params: {
    location: enforcedLocation
    namePrefix: '${namePrefix}${serviceShort}'
  }
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
      
      // WAF-aligned configuration with ADX
      deploymentConfiguration: 'waf-aligned'
      deploymentType: 'adx'
      dataExplorerClusterName: '${namePrefix}${serviceShort}adx${deploymentSuffix}'
      
      // WAF-aligned automatically enables:
      // - Premium_ZRS storage for HA/DR
      // - Purge protection for Key Vault
      // - Disables public network access
      
      // BringYourOwn network isolation - customer manages subnet and DNS zones
      // ⚠️ You own upgrades when using BringYourOwn - test before deploying new versions
      // For easier upgrades, consider networkIsolationMode: 'Managed'
      networkIsolationMode: 'BringYourOwn'
      byoSubnetResourceId: dependencies.outputs.privateEndpointSubnetId
      byoBlobDnsZoneId: dependencies.outputs.storageBlobPrivateDnsZoneId
      byoDfsDnsZoneId: dependencies.outputs.storageDfsPrivateDnsZoneId
      byoVaultDnsZoneId: dependencies.outputs.keyVaultPrivateDnsZoneId
      byoDataFactoryDnsZoneId: dependencies.outputs.dataFactoryPrivateDnsZoneId
      enablePrivateDnsZoneGroups: true
      
      // ADX admin access for testing
      adxAdminPrincipalIds: []
      deployerPrincipalId: deployerPrincipalId
      
      // Telemetry
      enableTelemetry: true
      
      // WAF: AZR-000119 (KeyVault.Logs) - audit diagnostics for Key Vault
      diagnosticSettings: [
        {
          workspaceResourceId: dependencies.outputs.logAnalyticsWorkspaceId
        }
      ]
      
      // Tags following WAF recommendations
      tags: {
        SecurityControl: 'Ignore'
        Environment: 'Production'
        'hidden-title': 'FinOps Hub - ADX WAF Aligned'
        CostCenter: 'FinOps'
        Criticality: 'High'
      }
    }
  }
]
