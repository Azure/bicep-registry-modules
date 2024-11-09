targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-microsoft.elasticsan-${serviceShort}-rg'

// enforcing location due to ESAN ZRS availability
#disable-next-line no-hardcoded-location
var enforcedLocation = 'northeurope'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'esanwaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
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

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      // TODO: Include additional parameters as needed - Required, Conditional, Optional parameters BUT only those to ensure compliance with the Azure Well-Architected Framework.
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
