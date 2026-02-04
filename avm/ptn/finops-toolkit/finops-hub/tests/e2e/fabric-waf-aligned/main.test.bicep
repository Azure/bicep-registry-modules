targetScope = 'subscription'

metadata name = 'Fabric WAF-aligned'
metadata description = 'This instance deploys the module with Microsoft Fabric Eventhouse in alignment with the best-practices of the Azure Well-Architected Framework, including private endpoints.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-finops-hub-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'fhfaw'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

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

// Deploy networking dependencies (VNet, subnets, private DNS zones)
module dependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-dependencies'
  params: {
    location: resourceLocation
    namePrefix: '${namePrefix}${serviceShort}'
  }
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
      // Required parameters
      hubName: '${namePrefix}${serviceShort}'
      // Non-required parameters
      location: resourceLocation
      
      // WAF-aligned configuration with Fabric
      deploymentConfiguration: 'waf-aligned'
      deploymentType: 'fabric'
      
      // Fabric Eventhouse configuration
      // The eventhouse must be pre-created in your Fabric workspace
      fabricQueryUri: fabricQueryUri
      fabricIngestionUri: fabricIngestionUri
      fabricDatabaseName: 'finops'
      
      // WAF-aligned automatically enables:
      // - Premium_ZRS storage for HA/DR
      // - Purge protection for Key Vault
      // - Disables public network access
      
      // Private endpoint configuration
      privateEndpointSubnetId: dependencies.outputs.privateEndpointSubnetId
      storageBlobPrivateDnsZoneId: dependencies.outputs.storageBlobPrivateDnsZoneId
      storageDfsPrivateDnsZoneId: dependencies.outputs.storageDfsPrivateDnsZoneId
      keyVaultPrivateDnsZoneId: dependencies.outputs.keyVaultPrivateDnsZoneId
      dataFactoryPrivateDnsZoneId: dependencies.outputs.dataFactoryPrivateDnsZoneId
      
      // Telemetry
      enableTelemetry: true
      
      // Tags following WAF recommendations
      tags: {
        SecurityControl: 'Ignore'
        Environment: 'Production'
        'hidden-title': 'FinOps Hub - Fabric WAF Aligned'
        CostCenter: 'FinOps'
        Criticality: 'High'
      }
    }
  }
]
