targetScope = 'subscription'

metadata name = 'Using only defaults and use AKS Automatic mode'
metadata description = 'This instance deploys the module with the set of automatic parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-containerservice.managedclusters-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'csauto'

@description('Optional. A token to inject into the name of each resource.')
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

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      maintenanceConfiguration: {
        maintenanceWindow: {
          schedule: {
            daily: null
            weekly: {
              intervalWeeks: 1
              dayOfWeek: 'Sunday'
            }
            absoluteMonthly: null
            relativeMonthly: null
          }
          durationHours: 4
          utcOffset: '+00:00'
          startDate: '2024-07-03'
          startTime: '00:00'
        }
      }
      managedIdentities: {
        systemAssigned: true
      }

      primaryAgentPoolProfile: [
        {
          name: 'systempool'
          count: 3
          vmSize: 'Standard_DS2_v2'
          mode: 'System'
        }
      ]
    }
  }
]
