targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@sys.description('Optional. The name of the resource group to deploy for testing purposes.')
@sys.maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-microsoft.elasticsan-${serviceShort}-rg'

@sys.description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@sys.description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'esanmax'

@sys.description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
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
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: resourceLocation
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@sys.batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      sku: 'Premium_LRS'
      baseSizeTiB: 2
      extendedCapacitySizeTiB: 1
      availabilityZone: 3
      // publicNetworkAccess: 'Enabled' // virtualNetworkRules should enforce this to be 'Enabled'
      volumeGroups: [
        {
          // Test - No Volumes
          name: 'vol-grp-01'
        }
        {
          // Test - Multiple Volumes
          name: 'vol-grp-02'
          volumes: [
            {
              // Test - No Snapshots
              name: 'vol-grp-02-vol-01'
              sizeGiB: 1
            }
            {
              // Test - Multiple Snapshots
              name: 'vol-grp-02-vol-02'
              sizeGiB: 2
              snapshots: [
                {
                  name: 'vol-grp-02-vol-02-snap-01-${iteration}'
                }
                {
                  name: 'vol-grp-02-vol-02-snap-02-${iteration}'
                }
              ]
            }
          ]
        }
        {
          // Test - Virtual Network Rules
          name: 'vol-grp-03'
          virtualNetworkRules: [
            {
              virtualNetworkSubnetResourceId: nestedDependencies.outputs.subnetResourceId
            }
          ]
        }
        {
          // Test - Managed Identity - System Assigned Only
          name: 'vol-grp-04'
          managedIdentities: {
            systemAssigned: true
          }
        }
        {
          // Test - Managed Identity - User Assigned Only
          name: 'vol-grp-05'
          managedIdentities: {
            userAssignedResourceIds: [
              nestedDependencies.outputs.managedIdentityResourceId
            ]
          }
        }
        {
          // Test - Managed Identity - System Assigned + User Assigned
          name: 'vol-grp-06'
          managedIdentities: {
            systemAssigned: true
            userAssignedResourceIds: [
              nestedDependencies.outputs.managedIdentityResourceId
            ]
          }
        }
      ]
      roleAssignments: [
        {
          roleDefinitionIdOrName: 'Owner'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          // Contributor
          roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          // Reader
          roleDefinitionIdOrName: subscriptionResourceId(
            'Microsoft.Authorization/roleDefinitions',
            'acdd72a7-3385-48ef-bd42-f606fba81ae7'
          )
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }

        {
          roleDefinitionIdOrName: 'Role Based Access Control Administrator'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: 'User Access Administrator'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: 'Elastic SAN Network Admin'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: 'Elastic SAN Owner'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: 'Elastic SAN Reader'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: 'Elastic SAN Volume Group Owner'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
      ]
      tags: {
        Owner: 'Contoso'
        CostCenter: '123-456-789'
      }
      diagnosticSettings: [
        {
          name: 'customSetting'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
    }
  }
]

import { volumeGroupOutputType } from '../../../main.bicep'

output resourceId string = testDeployment[0].outputs.resourceId
output name string = testDeployment[0].outputs.name
output location string = testDeployment[0].outputs.location
output resourceGroupName string = testDeployment[0].outputs.resourceGroupName
output volumeGroups volumeGroupOutputType[] = testDeployment[0].outputs.volumeGroups

output tenantId string = tenant().tenantId
output managedIdentityResourceId string = nestedDependencies.outputs.managedIdentityResourceId
output virtualNetworkRule string = nestedDependencies.outputs.subnetResourceId

output logAnalyticsWorkspaceResourceId string = diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
