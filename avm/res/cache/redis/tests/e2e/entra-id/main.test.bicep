targetScope = 'subscription'

metadata name = 'Using EntraID authentication'
metadata description = 'This instance deploys the module with EntraID authentication.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-cache.redis-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'crentrid'

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
    location: resourceLocation
    managedIdentityName: 'dep-${namePrefix}-mi-${serviceShort}'
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
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      redisConfiguration: {
        'aad-enabled': 'true'
      }
      accessPolicyAssignments: [
        {
          accessPolicyName: 'Data Contributor'
          objectId: nestedDependencies.outputs.managedIdentityPrincipalId
          objectIdAlias: nestedDependencies.outputs.managedIdentityName
        }
      ]
      accessPolicies: [
        {
          name: 'Prefixed Contributor'
          permissions: '+@read +set ~Az*'
        }
      ]
    }
    dependsOn: [
      nestedDependencies
    ]
  }
]
