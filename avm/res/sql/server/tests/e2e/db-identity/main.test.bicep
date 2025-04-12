targetScope = 'subscription'

metadata name = 'With an administrator'
metadata description = 'This instance deploys the module with a Microsoft Entra ID identity as SQL administrator.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sql.servers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sqlsdbi'

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

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    serverAdminIdentityName: 'dep-${namePrefix}-admin-${serviceShort}'
    databaseIdentityName: 'dep-${namePrefix}-dbmsi-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}-${serviceShort}'
      location: resourceLocation
      administrators: {
        azureADOnlyAuthentication: true
        login: 'myspn'
        sid: nestedDependencies.outputs.serverAdminIdentityPrincipalId
        principalType: 'Application'
      }
      databases: [
        {
          name: '${namePrefix}-${serviceShort}-db1'
          sku: {
            name: 'S1'
            tier: 'Standard'
          }
          maxSizeBytes: 2147483648
          zoneRedundant: false
          managedIdentities: {
            userAssignedResourceIds: [
              nestedDependencies.outputs.databaseIdentityResourceId
            ]
          }
        }
      ]
    }
  }
]
