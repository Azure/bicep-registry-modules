metadata name = 'Using only defaults.'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

targetScope = 'subscription'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ammin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    location: resourceLocation
    maintenanceConfigurationsResourceGroupNeworExisting: 'new'
    maintenanceConfigurationsResourceGroupName: '${namePrefix}-${serviceShort}-aum-RG'
    maintenanceConfigurations: [
      {
        maintenanceConfigName: 'maintenance_ring-01'
        location: resourceLocation
        installPatches: {
          linuxParameters: {
            classificationsToInclude: [
              'Critical'
              'Security'
            ]
            packageNameMasksToExclude: []
            packageNameMasksToInclude: []
          }
          rebootSetting: 'IfRequired'
          windowsParameters: {
            classificationsToInclude: [
              'Critical'
              'Security'
            ]
            kbNumbersToExclude: []
            kbNumbersToInclude: []
          }
        }
        lock: {}
        maintenanceWindow: {
          duration: '03:00'
          expirationDateTime: null
          recurEvery: '1Day'
          startDateTime: '2024-09-19 00:00'
          timeZone: 'UTC'
        }
        visibility: 'Custom'
        resourceFilter: {
          resourceGroups: []
          osTypes: [
            'Windows'
            'Linux'
          ]
          locations: []
        }
      }
      {
        maintenanceConfigName: 'maintenance_ring-02'
        location: resourceLocation
        installPatches: {
          linuxParameters: {
            classificationsToInclude: [
              'Other'
            ]
            packageNameMasksToExclude: []
            packageNameMasksToInclude: []
          }
          rebootSetting: 'IfRequired'
          windowsParameters: {
            classificationsToInclude: [
              'FeaturePack'
              'ServicePack'
            ]
            kbNumbersToExclude: []
            kbNumbersToInclude: []
          }
        }
        lock: {}
        maintenanceWindow: {
          duration: '05:00'
          expirationDateTime: null
          recurEvery: 'Week Saturday,Sunday'
          startDateTime: '2024-09-19 00:00'
          timeZone: 'UTC'
        }
        visibility: 'Custom'
        resourceFilter: {
          resourceGroups: []
          osTypes: [
            'Windows'
            'Linux'
          ]
          locations: []
        }
      }
    ]
    enableAUMTagName: 'aum_maintenance'
    enableAUMTagValue: 'Enabled'
    maintenanceConfigEnrollmentTagName: 'aum_maintenance_config'
    policyDeploymentManagedIdentityName: 'id-aumpolicy-contributor-001'
  }
}

output namePrefix string = namePrefix
output serviceShort string = serviceShort
output resourceLocation string = resourceLocation
