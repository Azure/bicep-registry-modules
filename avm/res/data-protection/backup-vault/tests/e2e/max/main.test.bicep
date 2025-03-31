targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-dataprotection.backupvaults-${serviceShort}-rg-qs'

// @description('Optional. The location to deploy resources to.')
// param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dpbvmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

var resourceLocation = 'uksouth'

// TODO replace
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
var dataSourceType = 'Microsoft.Storage/storageAccounts/blobServices'
var resourceType = 'Microsoft.Storage/storageAccounts'
var operationalTierRetentionDuration = 'P${operationalTierRetentionInDays}D'
var vaultTierDefaultRetentionDuration = 'P${vaultTierDefaultRetentionInDays}D'
var vaultTierWeeklyRetentionDuration = 'P${vaultTierWeeklyRetentionInWeeks}W'
var vaultTierMonthlyRetentionDuration = 'P${vaultTierMonthlyRetentionInMonths}M'
var vaultTierYearlyRetentionDuration = 'P${vaultTierYearlyRetentionInYears}Y'
var repeatingTimeIntervals = 'R/2024-05-06T${vaultTierDailyBackupScheduleTime}:00+00:00/P1D'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

// module nestedDependencies 'inner.test.bicep' = {
module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}sa${serviceShort}06'
    storageAccountName2: 'dep${namePrefix}sa${serviceShort}07'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    diskName: 'dep-${namePrefix}-dsk-${serviceShort}'
    location: resourceLocation
  }
}

// module nestedDependencies2 'inner.test.bicep' = {
//   // module nestedDependencies 'dependencies.bicep' = {
//   scope: resourceGroup
//   name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
//   params: {
//     // storageAccountName: 'dep${namePrefix}sa${serviceShort}04'
//     // managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
//     // diskName: 'dep-${namePrefix}-dsk-${serviceShort}'
//     location: resourceLocation
//   }
// }

// ============== //
// Test Execution //
// ============== //

var diskBackupPolicyName = '${namePrefix}${serviceShort}diskpolicy001'
var blobBackupPolicyName = '${namePrefix}${serviceShort}blobpolicy001'

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}002'
      location: resourceLocation
      azureMonitorAlertSettingsAlertsForAllJobFailures: 'Disabled'
      immutabilitySettingState: 'Unlocked'
      managedIdentities: {
        systemAssigned: true
      }
      backupPolicies: [
        // {
        //   name: diskBackupPolicyName
        //   properties: {
        //     datasourceTypes: [
        //       'Microsoft.Compute/disks'
        //     ]
        //     objectType: 'BackupPolicy'
        //     policyRules: [
        //       {
        //         backupParameters: {
        //           backupType: 'Incremental'
        //           objectType: 'AzureBackupParams'
        //         }
        //         dataStore: {
        //           dataStoreType: 'OperationalStore'
        //           objectType: 'DataStoreInfoBase'
        //         }
        //         name: 'BackupDaily'
        //         objectType: 'AzureBackupRule'
        //         trigger: {
        //           objectType: 'ScheduleBasedTriggerContext'
        //           schedule: {
        //             repeatingTimeIntervals: [
        //               'R/2022-05-31T23:30:00+01:00/P1D'
        //             ]
        //             timeZone: 'W. Europe Standard Time'
        //           }
        //           taggingCriteria: [
        //             {
        //               isDefault: true
        //               taggingPriority: 99
        //               tagInfo: {
        //                 id: 'Default_'
        //                 tagName: 'Default'
        //               }
        //             }
        //           ]
        //         }
        //       }
        //       {
        //         name: 'Default'
        //         objectType: 'AzureRetentionRule'
        //         isDefault: true
        //         lifecycles: [
        //           {
        //             deleteAfter: {
        //               duration: 'P7D'
        //               objectType: 'AbsoluteDeleteOption'
        //             }
        //             sourceDataStore: {
        //               dataStoreType: 'OperationalStore'
        //               objectType: 'DataStoreInfoBase'
        //             }
        //             targetDataStoreCopySettings: []
        //           }
        //         ]
        //       }
        //     ]
        //   }
        // }
        {
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
      ]
      // backupInstances: [
      //   // {
      //   //   name: nestedDependencies.outputs.storageAccountName
      //   //   dataSourceInfo: {
      //   //     objectType: 'Datasource'
      //   //     resourceID: nestedDependencies.outputs.storageAccountResourceId
      //   //     resourceName: nestedDependencies.outputs.storageAccountName
      //   //     resourceType: 'Microsoft.Storage/storageAccounts'
      //   //     resourceUri: nestedDependencies.outputs.storageAccountResourceId
      //   //     resourceLocation: resourceLocation
      //   //     datasourceType: 'Microsoft.Storage/storageAccounts/blobServices'
      //   //   }
      //   //   dataSourceSetInfo: {
      //   //     objectType: 'DatasourceSet'
      //   //     resourceID: nestedDependencies.outputs.storageAccountResourceId
      //   //     resourceName: nestedDependencies.outputs.storageAccountName
      //   //     resourceType: 'Microsoft.Storage/storageAccounts'
      //   //     resourceUri: nestedDependencies.outputs.storageAccountResourceId
      //   //     resourceLocation: resourceLocation
      //   //     datasourceType: 'Microsoft.Storage/storageAccounts/blobServices'
      //   //   }
      //   //   policyInfo: {
      //   //     policyName: blobBackupPolicyName
      //   //     policyParameters: {
      //   //       backupDatasourceParametersList: [
      //   //         {
      //   //           objectType: 'BlobBackupDatasourceParameters'
      //   //           containersList: [
      //   //             'container001'
      //   //           ]
      //   //         }
      //   //       ]
      //   //     }
      //   //   }
      //   // }
      //   {
      //     name: nestedDependencies.outputs.diskName
      //     dataSourceInfo: {
      //       objectType: 'Datasource'
      //       resourceID: nestedDependencies.outputs.diskResourceId
      //       resourceName: nestedDependencies.outputs.diskName
      //       resourceType: 'Microsoft.Compute/disks'
      //       resourceUri: nestedDependencies.outputs.diskResourceId
      //       resourceLocation: resourceLocation
      //       datasourceType: 'Microsoft.Compute/disks'
      //     }
      //     policyInfo: {
      //       policyName: diskBackupPolicyName
      //       policyParameters: {
      //         dataStoreParametersList: [
      //           {
      //             objectType: 'AzureOperationalStoreParameters'
      //             dataStoreType: 'OperationalStore'
      //             resourceGroupId: resourceGroup.id
      //           }
      //         ]
      //       }
      //     }
      //   }
      // ]
      // roleAssignments: [
      //   {
      //     name: 'cbc3932a-1bee-4318-ae76-d70e1ba399c8'
      //     roleDefinitionIdOrName: 'Owner'
      //     principalId: nestedDependencies.outputs.managedIdentityPrincipalId
      //     principalType: 'ServicePrincipal'
      //   }
      //   {
      //     name: guid('Custom seed ${namePrefix}${serviceShort}')
      //     roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      //     principalId: nestedDependencies.outputs.managedIdentityPrincipalId
      //     principalType: 'ServicePrincipal'
      //   }
      //   {
      //     roleDefinitionIdOrName: subscriptionResourceId(
      //       'Microsoft.Authorization/roleDefinitions',
      //       'acdd72a7-3385-48ef-bd42-f606fba81ae7'
      //     )
      //     principalId: nestedDependencies.outputs.managedIdentityPrincipalId
      //     principalType: 'ServicePrincipal'
      //   }
      // ]
      // lock: {
      //   kind: 'CanNotDelete'
      //   name: 'myCustomLockName'
      // }
      // tags: {
      //   'hidden-title': 'This is visible in the resource name'
      //   Environment: 'Non-Prod'
      //   Role: 'DeploymentValidation'
      // }
    }
  }
]

// // resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
// //   name: 'testmanualdelete'
// //   scope: az.resourceGroup('dep-avma-dataprotection.backupvaults-dpbvmax-rg')
// // }

module postDeployment 'postdeployment.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-postdeployment'
  params: {
    storageAccountName: nestedDependencies.outputs.storageAccountName
    // storageAccountName: 'testmanualdelete'
    storageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
    // storageAccountResourceId: storageAccount.id
    backupVaultName: '${namePrefix}${serviceShort}001'
    // blobBackupPolicyName: blobBackupPolicyName
    blobBackupPolicyName: blobBackupPolicyName
    location: resourceLocation
  }
  // dependsOn: [
  //   testDeployment
  // ]
}

module postDeployment2 'postdeployment2.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-postdeployment2'
  params: {
    storageAccountName: nestedDependencies.outputs.storageAccountName2
    // storageAccountName: 'testmanualdelete'
    storageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId2
    // storageAccountResourceId: storageAccount.id
    backupVaultName: '${namePrefix}${serviceShort}002'
    // blobBackupPolicyName: blobBackupPolicyName
    blobBackupPolicyName: blobBackupPolicyName
    location: resourceLocation
  }
  dependsOn: [
    testDeployment
  ]
}
