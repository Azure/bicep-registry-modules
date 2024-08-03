targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.ddosprotectionplans-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ndppmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// Due to quotas and capacity challenges, this region must be used in the AVM testing subscription
#disable-next-line no-hardcoded-location
var enforcedLocation = 'northeurope'

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
    location: enforcedLocation
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    location: enforcedLocation
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        name: '60339368-138d-4667-988a-5431c156f6ff'
        roleDefinitionIdOrName: 'Owner'
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
      {
        name: guid('Custom seed ${namePrefix}${serviceShort}')
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: subscriptionResourceId(
          'Microsoft.Authorization/roleDefinitions',
          'acdd72a7-3385-48ef-bd42-f606fba81ae7'
        )
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
    ]
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}
