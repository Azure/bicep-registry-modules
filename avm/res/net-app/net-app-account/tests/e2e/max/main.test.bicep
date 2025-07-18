targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-netapp.netappaccounts-${serviceShort}-rg'

// enforcing location due to quote restrictions
#disable-next-line no-hardcoded-location
var enforcedLocation = 'australiaeast'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nanaamax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The source of the encryption key.')
param encryptionKeySource string = 'Microsoft.NetApp'

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
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: enforcedLocation
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
    backupPolicies: [
      {
        name: 'myBackupPolicy'
      }
    ]
    snapshotPolicies: [
      {
        name: 'mySnapshotPolicy'
        dailySchedule: {
          snapshotsToKeep: 1
          minute: 0
          hour: 0
        }
      }
    ]
    capacityPools: [
      {
        name: 'cp-001'
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalId: nestedDependencies.outputs.managedIdentityPrincipalId
            principalType: 'ServicePrincipal'
          }
        ]
        serviceLevel: 'Premium'
        size: 1
        volumes: [
          {
            name: 'vol-001'
            dataProtection: {
              backup: {
                backupPolicyName: 'myBackupPolicy'
                backupVaultName: 'myVault'
                policyEnforced: false
              }
              snapshot: {
                snapshotPolicyName: 'mySnapshotPolicy'
              }
            }
            exportPolicy: {
              rules: [
                {
                  allowedClients: '0.0.0.0/0'
                  nfsv3: false
                  nfsv41: true
                  ruleIndex: 1
                  unixReadOnly: false
                  unixReadWrite: true
                  kerberos5iReadOnly: false
                  kerberos5pReadOnly: false
                  kerberos5ReadOnly: false
                  kerberos5iReadWrite: false
                  kerberos5pReadWrite: false
                  kerberos5ReadWrite: false
                }
              ]
            }
            availabilityZone: 1
            networkFeatures: 'Standard'
            encryptionKeySource: encryptionKeySource
            protocolTypes: [
              'NFSv4.1'
            ]
            roleAssignments: [
              {
                roleDefinitionIdOrName: 'Reader'
                principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                principalType: 'ServicePrincipal'
              }
            ]
            subnetResourceId: nestedDependencies.outputs.subnetResourceId
            usageThreshold: 107374182400
          }
          {
            kerberosEnabled: false
            exportPolicy: {
              rules: [
                {
                  allowedClients: '0.0.0.0/0'
                  nfsv3: false
                  nfsv41: true
                  ruleIndex: 1
                  unixReadOnly: false
                  unixReadWrite: false
                  kerberos5ReadOnly: false
                  kerberos5ReadWrite: false
                  kerberos5iReadOnly: false
                  kerberos5iReadWrite: false
                  kerberos5pReadOnly: false
                  kerberos5pReadWrite: false
                }
              ]
            }
            name: 'vol-002'
            availabilityZone: 1
            networkFeatures: 'Standard'
            encryptionKeySource: encryptionKeySource
            protocolTypes: [
              'NFSv4.1'
            ]
            subnetResourceId: nestedDependencies.outputs.subnetResourceId
            usageThreshold: 107374182400
            smbEncryption: false
            smbContinuouslyAvailable: false
            smbNonBrowsable: 'Disabled'
          }
        ]
      }
      {
        name: 'cp-002'
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalId: nestedDependencies.outputs.managedIdentityPrincipalId
            principalType: 'ServicePrincipal'
          }
        ]
        serviceLevel: 'Premium'
        size: 1
        volumes: []
      }
    ]
    backupVault: {
      name: 'myVault'
      backups: [
        {
          name: 'myBackup01'
          capacityPoolName: 'cp-001'
          volumeName: 'vol-001'
          label: 'myLabel'
        }
      ]
    }
    roleAssignments: [
      {
        name: '18051111-2a33-4f8e-8b24-441aac1e6562'
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
      Contact: 'test.user@testcompany.com'
      CostCenter: '7890'
      Environment: 'Non-Prod'
      PurchaseOrder: '1234'
      Role: 'DeploymentValidation'
      ServiceName: 'DeploymentValidation'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        nestedDependencies.outputs.managedIdentityResourceId
      ]
    }
  }
}
