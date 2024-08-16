targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-aiplatform-baseline-${serviceShort}-rg'

// Enforce uksouth to avoid restrictions around VM zones in certain regions
#disable-next-line no-hardcoded-location
var enforcedLocation = 'uksouth'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'aipbwaf'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Generated. The password to leverage for the login.')
@secure()
param password string = newGuid()

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}st${serviceShort}'
    maintenanceConfigurationName: 'dep-${namePrefix}-mc-${serviceShort}'
    location: enforcedLocation
  }
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
      name: '${namePrefix}${serviceShort}${substring(uniqueString(baseTime), 0, 3)}'
      virtualMachineConfiguration: {
        adminUsername: 'localAdminUser'
        adminPassword: password
        enableAadLoginExtension: true
        enableAzureMonitorAgent: true
        maintenanceConfigurationResourceId: nestedDependencies.outputs.maintenanceConfigurationResourceId
        patchMode: 'AutomaticByPlatform'
        zone: 1
      }
      workspaceConfiguration: {
        networkIsolationMode: 'AllowOnlyApprovedOutbound'
        networkOutboundRules: {
          rule: {
            type: 'PrivateEndpoint'
            destination: {
              serviceResourceId: nestedDependencies.outputs.storageAccountResourceId
              subresourceTarget: 'blob'
            }
            category: 'UserDefined'
          }
        }
      }
      tags: {
        Env: 'test'
        'hidden-title': 'This is visible in the resource name'
      }
    }
  }
]
