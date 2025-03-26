@description('Name of the Vault')
param vaultName string = 'vault${uniqueString(resourceGroup().id)}'

@description('Change Vault Storage Type (not allowed if the vault has registered backups)')
@allowed([
  'LocallyRedundant'
  'GeoRedundant'
])
param vaultStorageRedundancy string = 'GeoRedundant'

@description('Name of the Backup Policy')
param backupPolicyName string = 'policy${uniqueString(resourceGroup().id)}'

@description('Retention duration in days')
@minValue(1)
@maxValue(35)
param retentionDays int = 30

@description('Name of the Disk')
param diskName string = 'disk${uniqueString(resourceGroup().id)}'

@description('Location for all resources')
param location string = resourceGroup().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dpbvmax'

var roleDefinitionIdForDisk = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '3e5e47e6-65f7-47ef-90b5-e5dd4d455f24'
)
var roleDefinitionIdForSnapshotRG = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '7efff54f-a5b4-42b5-a1c5-5411624893ce'
)
var dataSourceType = 'Microsoft.Compute/disks'
var resourceType = 'Microsoft.Compute/disks'
var retentionDuration = 'P${retentionDays}D'
var repeatingTimeInterval = 'R/2021-05-20T22:00:00+00:00/PT4H'
var roleNameGuidForDisk = guid(resourceGroup().id, roleDefinitionIdForDisk, backupVault.id)
var roleNameGuidForSnapshotRG = guid(resourceGroup().id, roleDefinitionIdForSnapshotRG, backupVault.id)

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    // scope: resourceGroup
    name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
    params: {
      name: vaultName
      location: location
      azureMonitorAlertSettingsAlertsForAllJobFailures: 'Disabled'
      managedIdentities: {
        systemAssigned: true
      }
      backupPolicies: [
        {
          name: backupPolicyName
          properties: {
            datasourceTypes: [
              'Microsoft.Compute/disks'
            ]
            objectType: 'BackupPolicy'
            policyRules: [
              {
                backupParameters: {
                  backupType: 'Incremental'
                  objectType: 'AzureBackupParams'
                }
                dataStore: {
                  dataStoreType: 'OperationalStore'
                  objectType: 'DataStoreInfoBase'
                }
                name: 'BackupDaily'
                objectType: 'AzureBackupRule'
                trigger: {
                  objectType: 'ScheduleBasedTriggerContext'
                  schedule: {
                    repeatingTimeIntervals: [
                      'R/2022-05-31T23:30:00+01:00/P1D'
                    ]
                    timeZone: 'W. Europe Standard Time'
                  }
                  taggingCriteria: [
                    {
                      isDefault: true
                      taggingPriority: 99
                      tagInfo: {
                        id: 'Default_'
                        tagName: 'Default'
                      }
                    }
                  ]
                }
              }
              {
                isDefault: true
                lifecycles: [
                  {
                    deleteAfter: {
                      duration: 'P7D'
                      objectType: 'AbsoluteDeleteOption'
                    }
                    sourceDataStore: {
                      dataStoreType: 'OperationalStore'
                      objectType: 'DataStoreInfoBase'
                    }
                    targetDataStoreCopySettings: []
                  }
                ]
                name: 'Default'
                objectType: 'AzureRetentionRule'
              }
            ]
          }
        }
      ]
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]

// resource backupVault 'Microsoft.DataProtection/backupVaults@2021-01-01' = {
//   name: vaultName
//   location: location
//   identity: {
//     type: 'systemAssigned'
//   }
//   properties: {
//     storageSettings: [
//       {
//         datastoreType: 'VaultStore'
//         type: vaultStorageRedundancy
//       }
//     ]
//   }
// }

// resource backupPolicy 'Microsoft.DataProtection/backupVaults/backupPolicies@2021-01-01' = {
//   parent: backupVault
//   name: backupPolicyName
//   properties: {
//     policyRules: [
//       {
//         backupParameters: {
//           backupType: 'Incremental'
//           objectType: 'AzureBackupParams'
//         }
//         trigger: {
//           schedule: {
//             repeatingTimeIntervals: [
//               repeatingTimeInterval // 'R/2022-05-31T23:30:00+01:00/P1D'
//             ]
//             timeZone: 'UTC' // 'W. Europe Standard Time'
//           }
//           taggingCriteria: [
//             {
//               tagInfo: {
//                 tagName: 'Default'
//                 id: 'Default_'
//               }
//               taggingPriority: 99
//               isDefault: true
//             }
//           ]
//           objectType: 'ScheduleBasedTriggerContext'
//         }
//         dataStore: {
//           dataStoreType: 'OperationalStore'
//           objectType: 'DataStoreInfoBase'
//         }
//         name: 'BackupHourly' //'BackupDaily'
//         objectType: 'AzureBackupRule'
//       }
//       {
//         lifecycles: [
//           {
//             sourceDataStore: {
//               dataStoreType: 'OperationalStore'
//               objectType: 'DataStoreInfoBase'
//             }
//             deleteAfter: {
//               objectType: 'AbsoluteDeleteOption'
//               duration: retentionDuration // 'P7D'
//             }
//             // targetDataStoreCopySettings: []
//           }
//         ]
//         isDefault: true
//         name: 'Default'
//         objectType: 'AzureRetentionRule'
//         ruleType: 'Retention' // commented out in the original
//       }
//     ]
//     datasourceTypes: [
//       dataSourceType
//     ]
//     objectType: 'BackupPolicy'
//   }
// }

resource backupVault 'Microsoft.DataProtection/backupVaults@2021-01-01' existing = {
  name: vaultName
}

resource backupPolicy 'Microsoft.DataProtection/backupVaults/backupPolicies@2021-01-01' existing = {
  parent: backupVault
  name: backupPolicyName
}

resource computeDisk 'Microsoft.Compute/disks@2020-12-01' = {
  name: diskName
  location: location
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 200
  }
}

resource roleAssignmentForDisk 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: roleNameGuidForDisk
  properties: {
    roleDefinitionId: roleDefinitionIdForDisk
    principalId: reference(backupVault.id, '2021-01-01', 'Full').identity.principalId
  }
  dependsOn: [
    backupPolicy
    computeDisk
  ]
}

resource roleAssignmentForSnapshotRG 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: roleNameGuidForSnapshotRG
  properties: {
    roleDefinitionId: roleDefinitionIdForSnapshotRG
    principalId: reference(backupVault.id, '2021-01-01', 'Full').identity.principalId
  }
  dependsOn: [
    backupPolicy
    computeDisk
  ]
}

resource backupInstance 'Microsoft.DataProtection/backupvaults/backupInstances@2021-01-01' = {
  parent: backupVault
  name: diskName
  properties: {
    objectType: 'BackupInstance'
    dataSourceInfo: {
      objectType: 'Datasource'
      resourceID: computeDisk.id
      resourceName: diskName
      resourceType: resourceType
      resourceUri: computeDisk.id
      resourceLocation: location
      datasourceType: dataSourceType
    }
    policyInfo: {
      policyId: backupPolicy.id
      name: backupPolicyName
      policyParameters: {
        dataStoreParametersList: [
          {
            objectType: 'AzureOperationalStoreParameters'
            dataStoreType: 'OperationalStore'
            resourceGroupId: resourceGroup().id
          }
        ]
      }
    }
  }
  dependsOn: [
    roleAssignmentForDisk
    roleAssignmentForSnapshotRG
  ]
}
