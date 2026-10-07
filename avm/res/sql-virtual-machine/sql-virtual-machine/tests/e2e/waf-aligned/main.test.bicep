targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module using secure, recommended configuration.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sqlvm.sqlvm-${serviceShort}-rg'

#disable-next-line no-hardcoded-location
var resourceLocation = 'eastus2'

@description('Optional. A short identifier for the kind of deployment.')
param serviceShort string = 'sqlvmwaf'

@description('Optional. The administrator password for the virtual machine.')
@secure()
param password string = newGuid()

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies '../dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-dependencies'
  params: {
    virtualMachineName: '${namePrefix}${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-mi-${serviceShort}'
    adminPassword: password
    location: resourceLocation
  }
}

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: nestedDependencies.outputs.virtualMachineName
      virtualMachineResourceId: nestedDependencies.outputs.virtualMachineResourceId
      sqlServerLicenseType: 'PAYG'
      assessmentSettings: {
        enable: true
        runImmediately: false
        schedule: {
          dayOfWeek: 'Sunday'
          enable: true
          startTime: '02:00'
          weeklyInterval: 1
        }
      }
      autoPatchingSettings: {
        additionalVmPatch: 'MicrosoftUpdate'
        dayOfWeek: 'Sunday'
        enable: true
        maintenanceWindowDuration: 60
        maintenanceWindowStartingHour: 2
      }
      enableAutomaticUpgrade: true
      leastPrivilegeMode: 'Enabled'
      virtualMachineIdentitySettings: {
        type: 'SystemAssigned'
      }
    }
  }
]
