targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
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

var resourceName = '${namePrefix}${serviceShort}001'

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      // You parameters go here
      name: resourceName
      location: resourceLocation
      gatewayIPConfigurations: [
        {
          name: 'publicIPConfig1'
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
            publicIPAddress: {
              id: nestedDependencies.outputs.publicIPResourceId
            }
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
      httpListeners: [
        {
          name: 'httpListener1'
          properties: {
            hostName: 'www.contoso.com'
            protocol: 'Http'
            frontendIPConfiguration: {
              id: '${resourceGroup.id}/providers/Microsoft.Network/applicationGateways/${resourceName}/frontendIPConfigurations/frontendIPConfig1'
            }
            frontendPort: {
              id: '${resourceGroup.id}/providers/Microsoft.Network/applicationGateways/${resourceName}/frontendPorts/frontendPort1'
            }
          }
        }
      ]
      requestRoutingRules: [
        {
          name: 'requestRoutingRule1'
          properties: {
            ruleType: 'Basic'
            priority: 100
            httpListener: {
              id: '${resourceGroup.id}/providers/Microsoft.Network/applicationGateways/${resourceName}/httpListeners/httpListener1'
            }
            backendAddressPool: {
              id: '${resourceGroup.id}/providers/Microsoft.Network/applicationGateways/${resourceName}/backendAddressPools/backendAddressPool1'
            }
            backendHttpSettings: {
              id: '${resourceGroup.id}/providers/Microsoft.Network/applicationGateways/${resourceName}/backendHttpSettingsCollection/backendHttpSettings1'
            }
          }
        }
      ]
    }
  }
]
