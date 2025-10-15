targetScope = 'subscription'

metadata name = 'Using public IP load balancer parameter - public IP address prefixes'
metadata description = 'This instance deploys the module with the minimum set of required parameters and creates an external public IP prefix for the frontend.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.loadbalancers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nlbpipfix'

@description('Optional. A token to inject into the name of each resource.')
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
      name: '${namePrefix}${serviceShort}001'
      frontendIPConfigurations: [
        {
          name: 'publicIPprefix1'
          pipPrefixConfiguration: {
            name: '${namePrefix}${serviceShort}-pipfix-001'
            skuName: 'Standard'
            publicIPAddressVersion: 'IPv4'
            prefixLength: 28
          }
        }
      ]
    }
  }
]
