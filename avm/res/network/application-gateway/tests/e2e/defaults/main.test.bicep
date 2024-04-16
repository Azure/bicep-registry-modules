targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
// e.g., for a module 'network/private-endpoint' you could use 'dep-dev-network.privateendpoints-${serviceShort}-rg'
param resourceGroupName string = 'dep-${namePrefix}-network.applicationgateway-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nagmin'

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
    publicIPName: 'dep-${namePrefix}-pip-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    location: resourceLocation
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
      // You parameters go here
      name: '${namePrefix}${serviceShort}001'
      zones: [
        '1'
        '2'
        '3'
      ]
      location: resourceLocation
      gatewayIPConfigurations: [
        {
          name: 'publicIPConfig1'
          publicIPAddressId: nestedDependencies.outputs.publicIPResourceId
          properties: {
            subnet: {
              id: nestedDependencies.outputs.defaultSubnetResourceId
            }
          }
        }
      ]
      frontendIPConfigurations: [
        {
          name: 'frontendIPConfig1'
          properties: {
            id: nestedDependencies.outputs.publicIPResourceId
          }
        }
      ]
      frontendPorts: [
        {
          name: 'frontendPort1'
          properties: {
            port: 80
          }
        }
      ]
      backendAddressPools: [
        {
          name: 'backendAddressPool1'
        }
      ]
      backendHttpSettingsCollection: [
        {
          name: 'backendHttpSettings1'
          properties: {
            port: 80
            protocol: 'Http'
            cookieBasedAffinity: 'Disabled'
          }
        }
      ]
    }
  }
]
