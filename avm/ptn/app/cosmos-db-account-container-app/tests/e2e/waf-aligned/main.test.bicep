targetScope = 'subscription'

metadata name = 'Test with WAF-aligned parameters.'
metadata description = 'This test deploys the pattern using WAF-aligned parameters. For more informaation, see https://learn.microsoft.com/azure/well-architected/.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-cosmos-db-account-container-app-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cdaawaf'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-depdencies-${serviceShort}'
  params: {
    location: resourceLocation
    managedIdentityName: 'dep-${namePrefix}${serviceShort}${substring(uniqueString(baseTime), 0, 3)}-identity'
    deploymentScriptName: 'dep-${namePrefix}${serviceShort}${substring(uniqueString(baseTime), 0, 3)}-script'
    virtualNetworkName: 'dep-${namePrefix}${serviceShort}${substring(uniqueString(baseTime), 0, 3)}-vnet'
    subnetName: 'dep-${namePrefix}${serviceShort}${substring(uniqueString(baseTime), 0, 3)}-subnet'
  }
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
      name: '${namePrefix}${serviceShort}${substring(uniqueString(baseTime), 0, 3)}'
      database: {
        type: 'NoSQL'
        publicNetworkAccessEnabled: false
        enableLogAnalytics: true
        additionalLocations: [
          nestedDependencies.outputs.pairedRegionName
        ]
      }
      web: {
        publicNetworkAccessEnabled: false
        enableLogAnalytics: true
        virtualNetworkSubnetResourceId: nestedDependencies.outputs.virtualNetworkSubnetResourceId
        tiers: [
          {
            useManagedIdentity: true
            environment: [
              {
                name: 'AZURE_COSMOS_DB_ENDPOINT'
                knownValue: 'AzureCosmosDBEndpoint'
              }
            ]
          }
        ]
      }
    }
  }
]
