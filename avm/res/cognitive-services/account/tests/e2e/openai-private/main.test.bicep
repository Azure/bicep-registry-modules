targetScope = 'subscription'

metadata name = 'Using `OpenAI` and `deployments` in parameter set with private endpoint'
metadata description = 'This instance deploys the module with the AI model deployment feature and private endpoint.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-cognitiveservices.accounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'csoai'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: resourceLocation
  }
}


// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}-oai'
    params: {
      name: '${namePrefix}${serviceShort}002'
      kind: 'OpenAI'
      location: resourceLocation
      customSubDomainName: '${namePrefix}x${serviceShort}ai'
      deployments: [
        {
          name: 'gpt-35-turbo'
          model: {
            format: 'OpenAI'
            name: 'gpt-35-turbo'
            version: '0301'
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
          privateDnsZoneResourceIds: [
            nestedDependencies.outputs.privateDNSZoneResourceId
          ]
          subnetResourceId: nestedDependencies.outputs.subnetResourceId
        }
      ]
    }
  }
]
