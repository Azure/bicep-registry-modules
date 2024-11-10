targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@sys.description('Optional. The name of the resource group to deploy for testing purposes.')
@sys.maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-microsoft.elasticsan-${serviceShort}-rg'

// enforcing location due to ESAN ZRS availability
#disable-next-line no-hardcoded-location
var enforcedLocation = 'northeurope'

@sys.description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'esanmax'

@sys.description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

// ============== //
// Test Execution //
// ============== //

@sys.batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      volumeGroups: [
        {
          name: 'vol-grp-01'
          // No Volumes
        }
        {
          name: 'vol-grp-02'
          volumes: [
            {
              name: 'vol-grp-02-vol-01'
              sizeGiB: 1
              // No Snapshots
            }
            {
              name: 'vol-grp-02-vol-02'
              sizeGiB: 2
              snapshots: [
                {
                  name: 'vol-grp-02-vol-02-snap-01-${iteration}'
                }
                {
                  name: 'vol-grp-02-vol-02-snap-02-${iteration}'
                }
              ]
            }
          ]
        }

        //virtualNetworkRules
        //managedIdentities
        //customerManagedKey
        //privateEndpoints
      ]
      tags: {
        Owner: 'Contoso'
        CostCenter: '123-456-789'
      }

      //location
      //sku
      //availabilityZone
      //baseSizeTiB
      //extendedCapacitySizeTiB
      //publicNetworkAccess
      //enableTelemetry

      // TODO: Include as many additional parameters as possible. Ideally all.
    }
  }
]

import { volumeGroupOutputType } from '../../../main.bicep'

output resourceId string = testDeployment[0].outputs.resourceId
output name string = testDeployment[0].outputs.name
output location string = testDeployment[0].outputs.location
output resourceGroupName string = testDeployment[0].outputs.resourceGroupName
output volumeGroups volumeGroupOutputType[] = testDeployment[0].outputs.volumeGroups

// TODO: Add additional outputs as needed

//
