metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
// e.g., for a module 'network/private-endpoint' you could use 'dep-dev-network.privateendpoints-${serviceShort}-rg'
param resourceGroupName string = 'dep-${namePrefix}-maintenance-aum-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
// e.g., for a module 'network/private-endpoint' you could use 'npe' as a prefix and then 'waf' as a suffix for the waf-aligned test
param serviceShort string = 'maumwaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

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

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      // You parameters go here
      location: resourceLocation
      maintenanceConfigurationsResourceGroupName: '${namePrefix}-${serviceShort}-${iteration}-${substring(uniqueString(baseTime), 0, 3)}-RG'
      maintenanceConfigurations: [
        {
          maintenanceConfigName: 'maintenance_ring-${serviceShort}-01'
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
          maintenanceConfigName: 'maintenance_ring-${serviceShort}-02'
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
            duration: '03:00'
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
      policyDeploymentManagedIdentityName: 'id-aumpolicy-contributor-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    }
  }
]
