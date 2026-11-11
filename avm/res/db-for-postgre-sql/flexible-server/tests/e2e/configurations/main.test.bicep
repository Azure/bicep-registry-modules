targetScope = 'subscription'

metadata name = 'Static configuration persistence'
metadata description = 'This instance validates that static PostgreSQL server parameters (which require a server restart) are actually persisted after deployment, guarding against regressions such as GitHub issue #7270.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-dbforpostgresql.flexibleservers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
var enforcedLocation = 'brazilsouth'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dfpcfg'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// The static (restart-required) configurations under test, plus their requested values.
var staticConfigurations = [
  {
    name: 'max_connections'
    source: 'user-override'
    value: '200'
  }
  {
    name: 'max_prepared_transactions'
    source: 'user-override'
    value: '10'
  }
]

// ============ //
// Dependencies //
// ============ //

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
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
      location: enforcedLocation
      availabilityZone: 1
      skuName: 'Standard_D2s_v3'
      tier: 'GeneralPurpose'
      administratorLogin: 'adminUserName'
      administratorLoginPassword: password
      authConfig: {
        activeDirectoryAuth: 'Disabled'
        passwordAuth: 'Enabled'
      }
      configurations: staticConfigurations
    }
  }
]

@description('The resource ID of the deployed flexible server. Consumed by the post-deployment test.')
output serverResourceId string = testDeployment[1].outputs.resourceId

@description('The static configurations and their requested values. Consumed by the post-deployment test.')
output expectedConfigurations object[] = [
  for configuration in staticConfigurations: {
    name: configuration.name
    value: configuration.value
  }
]
