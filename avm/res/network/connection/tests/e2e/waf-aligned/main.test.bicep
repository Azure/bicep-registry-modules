targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.connections-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ncwaf'

@description('Optional. The password to leverage for the shared key.')
@secure()
param password string = newGuid()

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
    primaryPublicIPName: 'dep-${namePrefix}-pip-${serviceShort}-1'
    primaryVirtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}-1'
    primaryVirtualNetworkGatewayName: 'dep-${namePrefix}-vpn-gw-${serviceShort}-1'
    secondaryPublicIPName: 'dep-${namePrefix}-pip-${serviceShort}-2'
    secondaryVirtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}-2'
    secondaryVirtualNetworkGatewayName: 'dep-${namePrefix}-vpn-gw-${serviceShort}-2'
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
      location: resourceLocation
      name: '${namePrefix}${serviceShort}001'
      virtualNetworkGateway1: {
        id: nestedDependencies.outputs.primaryVNETGatewayResourceID
      }
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      virtualNetworkGateway2: {
        id: nestedDependencies.outputs.secondaryVNETGatewayResourceID
      }
      connectionType: 'Vnet2Vnet'
      vpnSharedKey: password
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    dependsOn: [
      nestedDependencies
    ]
  }
]
