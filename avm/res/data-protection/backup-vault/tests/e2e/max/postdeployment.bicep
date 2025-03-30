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

var operationalTierRetentionDuration = 'P${operationalTierRetentionInDays}D'
var vaultTierDefaultRetentionDuration = 'P${vaultTierDefaultRetentionInDays}D'
var vaultTierWeeklyRetentionDuration = 'P${vaultTierWeeklyRetentionInWeeks}W'
var vaultTierMonthlyRetentionDuration = 'P${vaultTierMonthlyRetentionInMonths}M'
var vaultTierYearlyRetentionDuration = 'P${vaultTierYearlyRetentionInYears}Y'
var repeatingTimeIntervals = 'R/2024-05-06T${vaultTierDailyBackupScheduleTime}:00+00:00/P1D'

param backupVaultName string

param blobBackupPolicyName string

@description('Required. The name of the storage account to create.')
param storageAccountName string

@description('Required. The name of the storage account to create.')
param storageAccountResourceId string

resource backupVault 'Microsoft.DataProtection/backupVaults@2023-05-01' existing = {
  name: backupVaultName

  // resource backupPolicy 'backupPolicies@2023-05-01' existing = {
  //   name: blobBackupPolicyName
  // }
}

resource backupPolicy 'Microsoft.DataProtection/backupVaults/backupPolicies@2022-05-01' = {
  parent: backupVault
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
      'Microsoft.Storage/storageAccounts/blobServices'
    ]
    objectType: 'BackupPolicy'
  }
}

// module backupInstance_dataSourceResource_rbac '../../../backup-instance/modules/nested_dataSourceResourceRoleAssignment.bicep' = {
//   name: '${backupVault.name}-dataSourceResource-rbac'
//   // scope: resourceGroup(split(dataSourceInfo.resourceID, '/')[2], split(dataSourceInfo.resourceID, '/')[4])
//   params: {
//     resourceId: storageAccountResourceId
//     principalId: backupVault.identity.principalId
//   }
// }

// resource backupInstance 'Microsoft.DataProtection/backupVaults/backupInstances@2024-04-01' = {
//   parent: backupVault
//   name: storageAccountName
//   properties: {
//     objectType: 'BackupInstance'
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
//       policyId: backupVault::backupPolicy.id
//       // name: blobBackupPolicyName
//       policyParameters: {
//         backupDatasourceParametersList: [
//           {
//             objectType: 'BlobBackupDatasourceParameters'
//             containersList: [
//               'container001'
//             ]
//           }
//         ]
//       }
//     }
//   }
//   dependsOn: [
//     backupInstance_dataSourceResource_rbac
//   ]
// }

module backupInstance '../../../backup-instance/main.bicep' = {
  // parent: backupVault
  name: storageAccountName
  params: {
    backupVaultName: backupVaultName
    name: 'testmanualdelete-testmanualdelete-293fe4b2-5be2-419b-9ca1-a3c06c76f0e3'
    friendlyName: storageAccountName
    dataSourceInfo: {
      objectType: 'Datasource'
      resourceID: storageAccountResourceId
      resourceName: storageAccountName
      resourceType: 'Microsoft.Storage/storageAccounts'
      resourceUri: storageAccountResourceId
      resourceLocation: location
      datasourceType: 'Microsoft.Storage/storageAccounts/blobServices'
    }
    dataSourceSetInfo: {
      objectType: 'DatasourceSet'
      resourceID: storageAccountResourceId
      resourceName: storageAccountName
      resourceType: 'Microsoft.Storage/storageAccounts'
      resourceUri: storageAccountResourceId
      resourceLocation: location
      datasourceType: 'Microsoft.Storage/storageAccounts/blobServices'
    }
    policyInfo: {
      policyName: blobBackupPolicyName
      policyParameters: {
        backupDatasourceParametersList: [
          {
            objectType: 'BlobBackupDatasourceParameters'
            containersList: [
              'c001'
            ]
          }
        ]
      }
    }
  }
  // dependsOn: [
  //   backupPolicy
  // ]
}

// "properties": {
// "dataSourceInfo": {
// "datasourceType": "Microsoft.Storage/storageAccounts/blobServices",
// "objectType": "Datasource",
// "resourceID": "[parameters('storageAccounts_testmanualdelete_externalid')]",
// "resourceLocation": "uksouth",
// "resourceName": "testmanualdelete",
// "resourceType": "Microsoft.Storage/storageAccounts",
// "resourceUri": "[parameters('storageAccounts_testmanualdelete_externalid')]"
// },
// "dataSourceSetInfo": {
// "datasourceType": "Microsoft.Storage/storageAccounts/blobServices",
// "objectType": "DatasourceSet",
// "resourceID": "[parameters('storageAccounts_testmanualdelete_externalid')]",
// "resourceLocation": "uksouth",
// "resourceName": "testmanualdelete",
// "resourceType": "Microsoft.Storage/storageAccounts",
// "resourceUri": "[parameters('storageAccounts_testmanualdelete_externalid')]"
// },
// "friendlyName": "testmanualdelete",
// "identityDetails": {
// "useSystemAssignedIdentity": true
// },
// "objectType": "BackupInstance",
// "policyInfo": {
// "policyId": "[resourceId('Microsoft.DataProtection/backupVaults/backupPolicies', parameters('backupVaults_avmxdpbvmax001_name'), 'Testmanual')]",
// "policyParameters": {
// "backupDatasourceParametersList": [
// {
// "containersList": [
// "c001"
// ],
// "objectType": "BlobBackupDatasourceParameters"
// }
// ]
// }
// }
// }
