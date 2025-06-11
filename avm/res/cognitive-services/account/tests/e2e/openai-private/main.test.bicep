targetScope = 'subscription'

metadata name = 'Using `OpenAI` and `deployments` in parameter set with private endpoint'
metadata description = 'This instance deploys the module with the AI model deployment feature and private endpoint.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-cognitiveservices.accounts-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'csoai'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// Set to fixed location as different AI models are only available in very specific locations
param enforcedLocation string = 'eastus2'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: enforcedLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}-oai'
    params: {
      name: '${namePrefix}${serviceShort}002'
      kind: 'OpenAI'
      location: enforcedLocation
      customSubDomainName: '${namePrefix}x${serviceShort}ai'
      deployments: [
        {
          name: 'gpt-4o'
          model: {
            format: 'OpenAI'
            name: 'gpt-4o'
            version: '2024-11-20'
          }
          sku: {
            name: 'Standard'
            capacity: 10
          }
        }
      ]
      publicNetworkAccess: 'Disabled'
      privateEndpoints: [
        {
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
          subnetResourceId: nestedDependencies.outputs.subnetResourceId
        }
      ]
    }
  }
]
