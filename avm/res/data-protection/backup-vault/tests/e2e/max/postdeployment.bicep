param backupVaultName string

@description('Change Vault Storage Type (not allowed if the vault has registered backups)')
@allowed([
  'LocallyRedundant'
  'ZoneRedundant'
  'GeoRedundant'
])
param vaultStorageRedundancy string = 'GeoRedundant'

@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Operational tier backup retention duration in days')
@minValue(1)
@maxValue(360)
param operationalTierRetentionInDays int = 30

@description('Vault tier default backup retention duration in days')
@minValue(7)
@maxValue(3650)
param vaultTierDefaultRetentionInDays int = 30

@description('Vault tier weekly backup retention duration in weeks')
@minValue(4)
@maxValue(521)
param vaultTierWeeklyRetentionInWeeks int = 30

@description('Vault tier monthly backup retention duration in months')
@minValue(5)
@maxValue(116)
param vaultTierMonthlyRetentionInMonths int = 30

@description('Vault tier yearly backup retention duration in years')
@minValue(1)
@maxValue(10)
param vaultTierYearlyRetentionInYears int = 10

@description('Vault tier daily backup schedule time')
param vaultTierDailyBackupScheduleTime string = '06:00'

@description('List of the containers to be protected')
param containerList array = [
  'container1'
  'container2'
]

var roleDefinitionId = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  'e5e2a7ff-d759-4cd2-bb51-3152d37e2eb1'
)
var operationalTierRetentionDuration = 'P${operationalTierRetentionInDays}D'
var vaultTierDefaultRetentionDuration = 'P${vaultTierDefaultRetentionInDays}D'
var vaultTierWeeklyRetentionDuration = 'P${vaultTierWeeklyRetentionInWeeks}W'
var vaultTierMonthlyRetentionDuration = 'P${vaultTierMonthlyRetentionInMonths}M'
var vaultTierYearlyRetentionDuration = 'P${vaultTierYearlyRetentionInYears}Y'
var repeatingTimeIntervals = 'R/2024-05-06T${vaultTierDailyBackupScheduleTime}:00+00:00/P1D'

param blobBackupPolicyName string

@description('Required. The name of the storage account to create.')
param storageAccountName string

@description('Required. The name of the storage account to create.')
param storageAccountResourceId string

var dataSourceType = 'Microsoft.Storage/storageAccounts/blobServices'
var resourceType = 'Microsoft.Storage/storageAccounts'

// resource vault 'Microsoft.DataProtection/backupVaults@2023-05-01' existing = {
//   name: backupVaultName

//   // resource backupPolicy 'backupPolicies@2023-05-01' existing = {
//   //   name: blobBackupPolicyName
//   // }
// }

resource vault 'Microsoft.DataProtection/backupVaults@2022-05-01' = {
  name: backupVaultName
  location: location
  identity: {
    type: 'systemAssigned'
  }
  properties: {
    storageSettings: [
      {
        datastoreType: 'VaultStore'
        type: vaultStorageRedundancy
      }
    ]
  }
}

resource backupPolicy 'Microsoft.DataProtection/backupVaults/backupPolicies@2022-05-01' = {
  parent: vault
  name: blobBackupPolicyName
  properties: {
    policyRules: [
      {
        name: 'Default'
        objectType: 'AzureRetentionRule'
        isDefault: true
        lifecycles: [
          {
            deleteAfter: {
              duration: operationalTierRetentionDuration
              objectType: 'AbsoluteDeleteOption'
            }
            sourceDataStore: {
              dataStoreType: 'OperationalStore'
              objectType: 'DataStoreInfoBase'
            }
            targetDataStoreCopySettings: []
          }
        ]
      }
      {
        name: 'Yearly'
        objectType: 'AzureRetentionRule'
        isDefault: false
        lifecycles: [
          {
            deleteAfter: {
              duration: vaultTierYearlyRetentionDuration
              objectType: 'AbsoluteDeleteOption'
            }
            sourceDataStore: {
              dataStoreType: 'VaultStore'
              objectType: 'DataStoreInfoBase'
            }
            targetDataStoreCopySettings: []
          }
        ]
      }
      {
        name: 'Monthly'
        objectType: 'AzureRetentionRule'
        isDefault: false
        lifecycles: [
          {
            deleteAfter: {
              duration: vaultTierMonthlyRetentionDuration
              objectType: 'AbsoluteDeleteOption'
            }
            sourceDataStore: {
              dataStoreType: 'VaultStore'
              objectType: 'DataStoreInfoBase'
            }
            targetDataStoreCopySettings: []
          }
        ]
      }
      {
        name: 'Weekly'
        objectType: 'AzureRetentionRule'
        isDefault: false
        lifecycles: [
          {
            deleteAfter: {
              duration: vaultTierWeeklyRetentionDuration
              objectType: 'AbsoluteDeleteOption'
            }
            sourceDataStore: {
              dataStoreType: 'VaultStore'
              objectType: 'DataStoreInfoBase'
            }
            targetDataStoreCopySettings: []
          }
        ]
      }
      {
        name: 'Default'
        objectType: 'AzureRetentionRule'
        isDefault: true
        lifecycles: [
          {
            deleteAfter: {
              duration: vaultTierDefaultRetentionDuration
              objectType: 'AbsoluteDeleteOption'
            }
            sourceDataStore: {
              dataStoreType: 'VaultStore'
              objectType: 'DataStoreInfoBase'
            }
            targetDataStoreCopySettings: []
          }
        ]
      }
      {
        name: 'BackupDaily'
        objectType: 'AzureBackupRule'
        backupParameters: {
          backupType: 'Discrete'
          objectType: 'AzureBackupParams'
        }
        dataStore: {
          dataStoreType: 'VaultStore'
          objectType: 'DataStoreInfoBase'
        }
        trigger: {
          schedule: {
            timeZone: 'UTC'
            repeatingTimeIntervals: [
              repeatingTimeIntervals
            ]
          }
          taggingCriteria: [
            {
              isDefault: false
              taggingPriority: 10
              tagInfo: {
                id: 'Yearly_'
                tagName: 'Yearly'
              }
              criteria: [
                {
                  absoluteCriteria: [
                    'FirstOfYear'
                  ]
                  objectType: 'ScheduleBasedBackupCriteria'
                }
              ]
            }
            {
              isDefault: false
              taggingPriority: 15
              tagInfo: {
                id: 'Monthly_'
                tagName: 'Monthly'
              }
              criteria: [
                {
                  absoluteCriteria: [
                    'FirstOfMonth'
                  ]
                  objectType: 'ScheduleBasedBackupCriteria'
                }
              ]
            }
            {
              isDefault: false
              taggingPriority: 20
              tagInfo: {
                id: 'Weekly_'
                tagName: 'Weekly'
              }
              criteria: [
                {
                  absoluteCriteria: [
                    'FirstOfWeek'
                  ]
                  objectType: 'ScheduleBasedBackupCriteria'
                }
              ]
            }
            {
              isDefault: true
              taggingPriority: 99
              tagInfo: {
                id: 'Default_'
                tagName: 'Default'
              }
            }
          ]
          objectType: 'ScheduleBasedTriggerContext'
        }
      }
    ]
    datasourceTypes: [
      dataSourceType
    ]
    objectType: 'BackupPolicy'
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountName
}

// module backupInstance_dataSourceResource_rbac '../../../backup-instance/modules/nested_dataSourceResourceRoleAssignment.bicep' = {
//   name: '${vault.name}-dataSourceResource-rbac'
//   // scope: resourceGroup(split(dataSourceInfo.resourceID, '/')[2], split(dataSourceInfo.resourceID, '/')[4])
//   params: {
//     resourceId: storageAccountResourceId
//     principalId: vault.identity.principalId
//   }
// }

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storageAccount
  name: guid(vault.id, roleDefinitionId, storageAccount.id)
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: reference(vault.id, '2021-01-01', 'Full').identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource backupInstance 'Microsoft.DataProtection/backupVaults/backupInstances@2022-05-01' = {
  parent: vault
  name: storageAccountName
  properties: {
    objectType: 'BackupInstance'
    friendlyName: storageAccountName
    dataSourceInfo: {
      objectType: 'Datasource'
      resourceID: storageAccount.id
      resourceName: storageAccountName
      resourceType: resourceType
      resourceUri: storageAccount.id
      resourceLocation: location
      datasourceType: dataSourceType
    }
    dataSourceSetInfo: {
      objectType: 'DatasourceSet'
      resourceID: storageAccount.id
      resourceName: storageAccountName
      resourceType: resourceType
      resourceUri: storageAccount.id
      resourceLocation: location
      datasourceType: dataSourceType
    }
    policyInfo: {
      policyId: backupPolicy.id
      name: blobBackupPolicyName
      policyParameters: {
        backupDatasourceParametersList: [
          {
            objectType: 'BlobBackupDatasourceParameters'
            containersList: containerList
          }
        ]
      }
    }
  }
  dependsOn: [
    // backupInstance_dataSourceResource_rbac
    roleAssignment
  ]
}

// module backupInstance '../../../backup-instance/main.bicep' = {
//   // parent: backupVault
//   name: storageAccountName
//   params: {
//     backupVaultName: backupVaultName
//     name: 'testmanualdelete-testmanualdelete-293fe4b2-5be2-419b-9ca1-a3c06c76f0e3'
//     friendlyName: storageAccountName
//     dataSourceInfo: {
//       objectType: 'Datasource'
//       resourceID: storageAccountResourceId
//       resourceName: storageAccountName
//       resourceType: 'Microsoft.Storage/storageAccounts'
//       resourceUri: storageAccountResourceId
//       resourceLocation: location
//       datasourceType: 'Microsoft.Storage/storageAccounts/blobServices'
//     }
//     dataSourceSetInfo: {
//       objectType: 'DatasourceSet'
//       resourceID: storageAccountResourceId
//       resourceName: storageAccountName
//       resourceType: 'Microsoft.Storage/storageAccounts'
//       resourceUri: storageAccountResourceId
//       resourceLocation: location
//       datasourceType: 'Microsoft.Storage/storageAccounts/blobServices'
//     }
//     policyInfo: {
//       policyName: blobBackupPolicyName
//       policyParameters: {
//         backupDatasourceParametersList: [
//           {
//             objectType: 'BlobBackupDatasourceParameters'
//             containersList: [
//               'c001'
//             ]
//           }
//         ]
//       }
//     }
//   }
//   // dependsOn: [
//   //   backupPolicy
//   // ]
// }
