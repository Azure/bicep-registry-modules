targetScope = 'subscription'

metadata name = 'Using private networking'
metadata description = 'This instance deploys the module in alignment with private networking and restricted access.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-storage.storageaccounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssapn'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
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
      skuName: 'Standard_GRS'
      kind: 'StorageV2'
      accessTier: 'Hot'
      supportsHttpsTrafficOnly: true
      allowBlobPublicAccess: false
      requireInfrastructureEncryption: true
      largeFileSharesState: 'Enabled'
      allowSharedKeyAccess: true
      publicNetworkAccess: 'Disabled'
      privateEndpoints: [
        {
          service: 'blob'
          subnetResourceId: nestedDependencies.outputs.privateEndpointSubnetResourceId
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
        }
        {
          service: 'file'
          subnetResourceId: nestedDependencies.outputs.privateEndpointSubnetResourceId
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
        }
        {
          service: 'queue'
          subnetResourceId: nestedDependencies.outputs.privateEndpointSubnetResourceId
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
        }
      ]
      networkAcls: {
        bypass: 'AzureServices'
        defaultAction: 'Deny'
        virtualNetworkRules: [
          {
            action: 'Allow'
            id: nestedDependencies.outputs.defaultSubnetResourceId
          }
        ]
        ipRules: [
          {
            action: 'Allow'
            value: '1.1.1.1'
          }
        ]
      }
      localUsers: [
        {
          name: 'testuser'
          hasSharedKey: false
          hasSshKey: true
          hasSshPassword: false
          homeDirectory: 'avdscripts'
          permissionScopes: [
            {
              permissions: 'r'
              service: 'blob'
              resourceName: 'avdscripts'
            }
          ]
        }
      ]
      blobServices: {
        lastAccessTimeTrackingPolicyEnabled: true
        containers: [
          {
            name: 'avdscripts'
            publicAccess: 'None'
          }
          {
            name: 'avdscripts2'
            publicAccess: 'None'
          }
          {
            name: 'avdscripts3'
            publicAccess: 'None'
          }
          {
            name: 'avdscripts4'
            publicAccess: 'None'
          }
          {
            name: 'avdscripts5'
            publicAccess: 'None'
          }
          {
            name: 'avdscripts6'
            publicAccess: 'None'
          }
          {
            name: 'avdscripts7'
            publicAccess: 'None'
          }
          {
            name: 'avdscripts8'
            publicAccess: 'None'
          }
          {
            name: 'avdscripts9'
            publicAccess: 'None'
          }
          {
            name: 'archivecontainer'
            publicAccess: 'None'
            metadata: {
              testKey: 'testValue'
            }
            immutabilityPolicy: {
              immutabilityPeriodSinceCreationInDays: 7
              allowProtectedAppendWrites: false
              allowProtectedAppendWritesAll: true
            }
          }
        ]
        automaticSnapshotPolicyEnabled: true
        containerDeleteRetentionPolicyEnabled: true
        containerDeleteRetentionPolicyDays: 10
        deleteRetentionPolicyEnabled: true
        deleteRetentionPolicyDays: 9
        isVersioningEnabled: true
        versionDeletePolicyDays: 3
      }
      queueServices: {
        queues: [
          {
            name: 'queue-one'
          }
          {
            name: 'queue-two'
          }
        ]
      }
      sasExpirationPeriod: '180.00:00:00'
      managedIdentities: {
        systemAssigned: false
        userAssignedResourceIds: []
      }
      roleAssignments: [
        {
          roleDefinitionIdOrName: 'Storage Blob Data Contributor'
          principalId: deployer().objectId
          principalType: 'User'
        }
        {
          roleDefinitionIdOrName: 'Storage Blob Data Reader'
          principalId: deployer().objectId
          principalType: 'User'
        }
        {
          roleDefinitionIdOrName: 'Storage Queue Data Contributor'
          principalId: deployer().objectId
          principalType: 'User'
        }
        {
          roleDefinitionIdOrName: 'Storage Blob Data Contributor'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: 'Storage Blob Data Reader'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: 'Storage Queue Data Contributor'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: 'Storage File Data Privileged Contributor'
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
]
