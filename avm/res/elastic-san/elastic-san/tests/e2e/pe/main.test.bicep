targetScope = 'subscription'

metadata name = 'Private endpoint-enabled deployment'
metadata description = 'This instance deploys the module with private endpoints.'

// ========== //
// Parameters //
// ========== //

@sys.description('Optional. The name of the resource group to deploy for testing purposes.')
@sys.maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-microsoft.elasticsan-${serviceShort}-rg'

@sys.description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@sys.description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'esanpe'

@sys.description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
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
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@sys.batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      sku: 'Premium_LRS'
      availabilityZone: 1
      // publicNetworkAccess: 'Disabled' // Private Endpoints should enforce this to be 'Disbled'
      tags: {
        Owner: 'Contoso'
        CostCenter: '123-456-789'
      }
      volumeGroups: [
        {
          // Test - Private endpoints
          name: 'vol-grp-01'
          privateEndpoints: [
            {
              subnetResourceId: nestedDependencies.outputs.subnetResourceId
              privateDnsZoneGroup: {
                privateDnsZoneGroupConfigs: [
                  {
                    privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
                  }
                ]
              }
              tags: {
                Owner: 'Contoso'
                CostCenter: '123-456-789'
              }
              lock: {
                kind: 'CanNotDelete'
                name: 'myCustomLockName'
              }
            }
          ]
        }
      ]
    }
  }
]

import { volumeGroupOutputType } from '../../../main.bicep'

output resourceId string = testDeployment[0].outputs.resourceId
output name string = testDeployment[0].outputs.name
output location string = testDeployment[0].outputs.location
output resourceGroupName string = testDeployment[0].outputs.resourceGroupName
output volumeGroups volumeGroupOutputType[] = testDeployment[0].outputs.volumeGroups
