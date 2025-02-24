targetScope = 'subscription'

metadata name = 'Deploying a bi-directional peering'
metadata description = 'This instance deploys the module with both an inbound and outbound peering.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtualnetworks-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvnpeer'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    networkSecurityGroupBastionName: 'dep-${namePrefix}-nsg-bastion-${serviceShort}'
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
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      addressPrefixes: [
        '10.1.0.0/24'
      ]
      subnets: [
        {
          addressPrefix: '10.1.0.0/26'
          name: 'GatewaySubnet'
        }
        {
          addressPrefix: '10.1.0.64/26'
          name: 'AzureBastionSubnet'
          networkSecurityGroupResourceId: nestedDependencies.outputs.networkSecurityGroupBastionResourceId
        }
        {
          addressPrefix: '10.1.0.128/26'
          name: 'AzureFirewallSubnet'
        }
      ]
      peerings: [
        {
          allowForwardedTraffic: true
          allowGatewayTransit: false
          allowVirtualNetworkAccess: true
          remotePeeringAllowForwardedTraffic: true
          remotePeeringAllowVirtualNetworkAccess: true
          remotePeeringEnabled: true
          remotePeeringName: 'customName'
          remoteVirtualNetworkResourceId: nestedDependencies.outputs.virtualNetworkResourceId
          useRemoteGateways: false
        }
      ]
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
