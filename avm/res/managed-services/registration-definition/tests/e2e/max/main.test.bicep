targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'msrdmax'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Required. The tenant Id of the lighthouse tenant. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-LighthouseManagedByTenantId\'.')
@secure()
param lighthouseManagedByTenantId string = ''

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name)}-test-${serviceShort}-${iteration}'
    params: {
      name: 'Component Validation - ${namePrefix}${serviceShort} Subscription assignment'
      registrationId: guid(tenant().tenantId, subscription().tenantId, subscription().subscriptionId, namePrefix)
      metadataLocation: resourceLocation
      registrationDescription: 'Managed by Lighthouse'
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
      managedByTenantId: lighthouseManagedByTenantId
    }
  }
]
