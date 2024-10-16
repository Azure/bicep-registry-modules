targetScope = 'subscription'

metadata name = 'Deploying multiple regions'
metadata description = 'This instance deploys the module in multiple regions with configs specific of multi region scenarios.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-documentdb.databaseaccounts-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dddaumr'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

// ============ //
// Dependencies //
// ============ //

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    pairedRegionScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
  }
}

// ============== //
// General resources
// ============== //
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: resourceLocation
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    automaticFailover: false
    location: resourceLocation
    backupPolicyType: 'Periodic'
    backupIntervalInMinutes: 300
    backupStorageRedundancy: 'Zone'
    backupRetentionIntervalInHours: 16
    enableMultipleWriteLocations: true
    name: '${namePrefix}-multi-region'
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: true
        locationName: resourceLocation
      }
      {
        failoverPriority: 1
        isZoneRedundant: true
        locationName: nestedDependencies.outputs.pairedRegionName
      }
    ]
    sqlDatabases: [
      {
        name: 'no-containers-specified'
      }
    ]
  }
}
