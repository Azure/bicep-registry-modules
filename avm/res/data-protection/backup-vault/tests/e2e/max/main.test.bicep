targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-dataprotection.backupvaults-${serviceShort}-rg'

// @description('Optional. The location to deploy resources to.')
// param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dpbvmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

var resourceLocation = 'uksouth'

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
    storageAccountName: 'dep${namePrefix}sa${serviceShort}01'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    diskName: 'dep-${namePrefix}-dsk-${serviceShort}'
    location: resourceLocation
  }
}

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
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      azureMonitorAlertSettingsAlertsForAllJobFailures: 'Disabled'
      immutabilitySettingState: 'Unlocked'
      managedIdentities: {
        systemAssigned: true
      }
      backupPolicies: [
        {
          name: diskBackupPolicyName
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
                name: 'Default'
                objectType: 'AzureRetentionRule'
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
              }
            ]
          }
        }
        {
          name: blobBackupPolicyName
          properties: {
            datasourceTypes: [
              'Microsoft.Storage/storageAccounts/blobServices'
            ]
            objectType: 'BackupPolicy'
            policyRules: [
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
                  objectType: 'ScheduleBasedTriggerContext'
                  schedule: {
                    repeatingTimeIntervals: [
                      'R/2025-03-01T23:30:00+01:00/P1D'
                    ]
                    timeZone: 'UTC'
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
                name: 'Default'
                objectType: 'AzureRetentionRule'
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
              }
            ]
          }
        }
      ]
      backupInstances: [
        // {
        //   name: nestedDependencies.outputs.storageAccountName
        //   dataSourceInfo: {
        //     objectType: 'Datasource'
        //     resourceID: nestedDependencies.outputs.storageAccountResourceId
        //     resourceName: nestedDependencies.outputs.storageAccountName
        //     resourceType: 'Microsoft.Storage/storageAccounts'
        //     resourceUri: nestedDependencies.outputs.storageAccountResourceId
        //     resourceLocation: resourceLocation
        //     datasourceType: 'Microsoft.Storage/storageAccounts/blobServices'
        //   }
        //   dataSourceSetInfo: {
        //     objectType: 'DatasourceSet'
        //     resourceID: nestedDependencies.outputs.storageAccountResourceId
        //     resourceName: nestedDependencies.outputs.storageAccountName
        //     resourceType: 'Microsoft.Storage/storageAccounts'
        //     resourceUri: nestedDependencies.outputs.storageAccountResourceId
        //     resourceLocation: resourceLocation
        //     datasourceType: 'Microsoft.Storage/storageAccounts/blobServices'
        //   }
        //   policyInfo: {
        //     policyName: blobBackupPolicyName
        //     policyParameters: {
        //       backupDatasourceParametersList: [
        //         {
        //           objectType: 'BlobBackupDatasourceParameters'
        //           containersList: [
        //             'container001'
        //           ]
        //         }
        //       ]
        //     }
        //   }
        // }
        {
          name: nestedDependencies.outputs.diskName
          dataSourceInfo: {
            objectType: 'Datasource'
            resourceID: nestedDependencies.outputs.diskResourceId
            resourceName: nestedDependencies.outputs.diskName
            resourceType: 'Microsoft.Compute/disks'
            resourceUri: nestedDependencies.outputs.diskResourceId
            resourceLocation: resourceLocation
            datasourceType: 'Microsoft.Compute/disks'
          }
          policyInfo: {
            policyName: diskBackupPolicyName
            policyParameters: {
              dataStoreParametersList: [
                {
                  objectType: 'AzureOperationalStoreParameters'
                  dataStoreType: 'OperationalStore'
                  resourceGroupId: resourceGroup.id
                }
              ]
            }
          }
        }
      ]
      roleAssignments: [
        {
          name: 'cbc3932a-1bee-4318-ae76-d70e1ba399c8'
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

module postDeployment 'postdeployment.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-postdeployment'
  params: {
    storageAccountName: 'dep${namePrefix}sa${serviceShort}01'
    storageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
    backupVaultName: '${namePrefix}${serviceShort}001'
    blobBackupPolicyName: blobBackupPolicyName
    location: resourceLocation
  }
  dependsOn: [
    testDeployment
  ]
}
