targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-app.managedenvironments-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'amemax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-paramNested'
  params: {
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    location: resourceLocation
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}'
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
      logAnalyticsWorkspaceResourceId: nestedDependencies.outputs.logAnalyticsWorkspaceResourceId
      location: resourceLocation
      workloadProfiles: [
        {
          workloadProfileType: 'D4'
          name: 'CAW01'
          minimumCount: 0
          maximumCount: 3
        }
      ]
      internal: true
      dockerBridgeCidr: '172.16.0.1/28'
      platformReservedCidr: '172.17.17.0/24'
      platformReservedDnsIP: '172.17.17.17'
      infrastructureSubnetId: nestedDependencies.outputs.subnetResourceId
      infrastructureResourceGroupName: 'me-${resourceGroupName}'
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      roleAssignments: [
        {
          name: '43fc5250-f111-472b-8722-f1cb4a0e754b'
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

      storages: [
        {
          kind: 'SMB'
          shareName: 'smbfileshare'
          accessMode: 'ReadWrite'
          storageAccountName: nestedDependencies.outputs.storageAccountName
        }
        {
          kind: 'NFS'
          shareName: 'nfsfileshare'
          accessMode: 'ReadWrite'
          storageAccountName: nestedDependencies.outputs.storageAccountName
        }
      ]

      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Env: 'test'
      }
    }
    dependsOn: [
      nestedDependencies
    ]
  }
]
