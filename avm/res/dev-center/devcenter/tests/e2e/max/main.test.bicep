targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
param resourceGroupName string = 'dep-${namePrefix}-devcenter-devcenter-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dcdcmax'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================

resource resourceGroup1 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

resource resourceGroup2 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: '${resourceGroupName}-2'
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup1
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    devCenterNetworkConnectionName: 'dep-${namePrefix}-dcnc-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

var devcenterName = '${namePrefix}${serviceShort}001'
var devcenterExpectedResourceID = '${resourceGroup1.id}/providers/Microsoft.DevCenter/devcenters/${devcenterName}'
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup1
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: devcenterName
      location: resourceLocation
      tags: {
        costCenter: '1234'
      }
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      roleAssignments: [
        {
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          roleDefinitionIdOrName: 'DevCenter Project Admin'
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
      devboxDefinitions: [
        {
          name: 'test-devbox-definition-builtin-gallery-image'
          imageResourceId: '${devcenterExpectedResourceID}/galleries/Default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2'
          //osStorageType: 'Premium_LRS'
          sku: {
            name: 'general_i_8c32gb512ssd_v2'
            family: 'general_i'
            capacity: 1
          }
          hibernateSupport: 'Enabled'
          tags: {
            costCenter: '1234'
          }
        }
      ]
      catalogs: [
        {
          name: 'quickstart-catalog'
          gitHub: {
            uri: 'https://github.com/microsoft/devcenter-catalog.git'
            branch: 'main'
            path: 'Environment-Definitions'
          }
          syncType: 'Scheduled'
        }
        {
          name: 'testCatalogAzureDevOpsGit'
          adoGit: {
            uri: 'https://contoso@dev.azure.com/contoso/your-project/_git/your-repo'
            branch: 'main'
            secretIdentifier: nestedDependencies.outputs.keyVaultSecretUri
          }
          syncType: 'Manual'
        }
      ]
      //customerManagedKey: {
      //  keyName: nestedDependencies.outputs.keyVaultKeyName
      //  keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
      //  userAssignedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
      //}
      displayName: 'Dev Center Test'
      devBoxProvisioningSettings: {
        installAzureMonitorAgentEnableStatus: 'Enabled'
      }
      networkSettings: {
        microsoftHostedNetworkEnableStatus: 'Disabled'
      }
      projectCatalogSettings: {
        catalogItemSyncEnableStatus: 'Enabled'
      }
      environmentTypes: [
        {
          name: 'dev'
          displayName: 'Development Environment'
          tags: {
            costCenter: '1234'
          }
        }
        {
          name: 'test'
          displayName: 'Testing Environment'
          tags: {
            costCenter: '5678'
          }
        }
        {
          name: 'prod'
          displayName: 'Production Environment'
          tags: {
            costCenter: '9012'
          }
        }
      ]
      projects: [
        {
          name: 'test-project-same-resource-group'
        }
        {
          name: 'test-project-another-resource-group'
          resourceGroupResourceId: resourceGroup2.id
        }
      ]
      projectPolicies: [
        {
          name: 'Default'
          resourcePolicies: [
            {
              action: 'Allow'
              resourceType: 'Images'
            }
            {
              action: 'Allow'
              resourceType: 'Skus'
            }
            {
              action: 'Allow'
              resourceType: 'AttachedNetworks'
            }
          ]
        }
        {
          name: 'DevProjectsPolicy'
          resourcePolicies: [
            {
              resources: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.DevCenter/skus'
              filter: 'Name eq \'general_i_8c32gb512ssd_v2\''
            }
            {
              resources: '${devcenterExpectedResourceID}/galleries/Default/images/microsoftvisualstudio_windowsplustools_base-win11-gen2'
            }
            {
              resources: '${devcenterExpectedResourceID}/galleries/Default/images/microsoftwindowsdesktop_windows-ent-cpc_win11-24h2-ent-cpc'
            }
            {
              action: 'Deny'
              resourceType: 'AttachedNetworks'
            }
          ]
          projectsResourceIdOrName: [
            'test-project-same-resource-group'
            '${resourceGroup2.id}/providers/Microsoft.DevCenter/projects/test-project-another-resource-group'
          ]
        }
      ]
      attachedNetworks: [
        {
          name: 'test-attached-network'
          networkConnectionResourceId: nestedDependencies.outputs.networkConnectionResourceId
        }
      ]
    }
  }
]
