targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'msrdwaf'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-managedservices-registrationdef-${serviceShort}-rg'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name)}-test-${serviceShort}-${iteration}'
    params: {
      name: 'Component Validation - ${namePrefix}${serviceShort} Subscription assignment'
      registrationDescription: 'Managed by Lighthouse'
      location: location
      authorizations: [
        {
          principalId: 'ecadddf6-78c3-4516-afb2-7d30a174ea13'
          roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          principalIdDisplayName: 'Lighthouse Contributor'
        }
        {
          principalId: 'ecadddf6-78c3-4516-afb2-7d30a174ea13'
          roleDefinitionId: '91c1777a-f3dc-4fae-b103-61d183457e46'
          principalIdDisplayName: 'Managed Services Registration assignment Delete Role'
        }
        {
          principalId: 'ecadddf6-78c3-4516-afb2-7d30a174ea13'
          delegatedRoleDefinitionIds: [
            'acdd72a7-3385-48ef-bd42-f606fba81ae7' // Reader
          ]
          roleDefinitionId: '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9' // User Access Administrator
        }
      ]
      managedByTenantId: '449fbe1d-9c99-4509-9014-4fd5cf25b014'
    }
  }
]
