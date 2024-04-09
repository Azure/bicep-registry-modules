targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtualHub-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvhwaf'

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
    virtualWANName: 'dep-${namePrefix}-vw-${serviceShort}'
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
      name: '${namePrefix}-${serviceShort}'
      location: resourceLocation
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      addressPrefix: '10.1.0.0/16'
      virtualWanId: nestedDependencies.outputs.virtualWWANResourceId
      hubRouteTables: [
        {
          name: 'routeTable1'
        }
      ]
      hubVirtualNetworkConnections: [
        {
          name: 'connection1'
          remoteVirtualNetworkId: nestedDependencies.outputs.virtualNetworkResourceId
          routingConfiguration: {
            associatedRouteTable: {
              id: '${resourceGroup.id}/providers/Microsoft.Network/virtualHubs/${namePrefix}-${serviceShort}/hubRouteTables/routeTable1'
            }
            propagatedRouteTables: {
              ids: [
                {
                  id: '${resourceGroup.id}/providers/Microsoft.Network/virtualHubs/${namePrefix}-${serviceShort}/hubRouteTables/routeTable1'
                }
              ]
              labels: [
                'none'
              ]
            }
          }
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
