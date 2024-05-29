targetScope = 'subscription'

metadata name = 'Test case for disaster recovery enabled'
metadata description = 'This instance deploys the module with disaster recovery enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-recoveryservices.vaults-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'rsvdr'

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

// ============== //
// Test Execution //
// ============== //
var rsvName = '${namePrefix}${serviceShort}001'
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      location: resourceLocation
      name: rsvName
      replicationFabrics: [
        {
          location: 'NorthEurope'
          replicationContainers: [
            {
              name: 'ne-container1'
              replicationContainerMappings: [
                {
                  policyName: 'Default_values'
                  targetContainerName: 'pluto'
                  targetProtectionContainerId: '${resourceGroup.id}/providers/Microsoft.RecoveryServices/vaults/${rsvName}/replicationFabrics/NorthEurope/replicationProtectionContainers/ne-container2'
                }
              ]
            }
            {
              name: 'ne-container2'
              replicationContainerMappings: [
                {
                  policyName: 'Default_values'
                  targetContainerFabricName: 'WE-2'
                  targetContainerName: 'we-container1'
                }
              ]
            }
          ]
        }
        {
          location: 'WestEurope'
          name: 'WE-2'
          replicationContainers: [
            {
              name: 'we-container1'
              replicationContainerMappings: [
                {
                  policyName: 'Default_values'
                  targetContainerFabricName: 'NorthEurope'
                  targetContainerName: 'ne-container2'
                }
              ]
            }
          ]
        }
      ]
      replicationPolicies: [
        {
          name: 'Default_values'
        }
        {
          appConsistentFrequencyInMinutes: 240
          crashConsistentFrequencyInMinutes: 7
          multiVmSyncStatus: 'Disable'
          name: 'Custom_values'
          recoveryPointHistory: 2880
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
