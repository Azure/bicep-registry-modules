targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module with WAF aligned settings.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-app-paasasecosmosdbt4-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apactwaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

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
      name: '${namePrefix}${serviceShort}001'

      // Optional parameters with custom values for WAF-aligned testing
      suffix: 'waf'
      tags: {
        Environment: 'Test'
        Purpose: 'WAF-Aligned-Testing'
        Module: 'avm/ptn/app/paas-ase-cosmosdb-tier4'
      }

      // Network parameters (using defaults but can be customized)
      vNetAddressPrefix: '192.168.250.0/23'
      defaultSubnetAddressPrefix: '192.168.250.0/24'
      privateEndpointSubnetAddressPrefix: '192.168.251.0/24'
    }
  }
]
