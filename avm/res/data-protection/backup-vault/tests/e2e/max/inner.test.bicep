@description('Name of the Vault')
param vaultName string = 'vault${uniqueString(resourceGroup().id)}'

// @description('Change Vault Storage Type (not allowed if the vault has registered backups)')
// @allowed([
//   'LocallyRedundant'
//   'GeoRedundant'
// ])
// param vaultStorageRedundancy string = 'GeoRedundant'

@description('Name of the Backup Policy')
param backupPolicyName string = 'policy${uniqueString(resourceGroup().id)}'

@description('Retention duration in days')
@minValue(1)
@maxValue(35)
param retentionDays int = 30

@description('Required. The name of the managed disk to create.')
param diskName string

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

var resourceLocation = 'uksouth'

// var roleNameGuidForDisk = guid(resourceGroup().id, roleDefinitionIdForDisk, backupVault.id)
// var roleNameGuidForSnapshotRG = guid(resourceGroup().id, roleDefinitionIdForSnapshotRG, backupVault.id)

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup()
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    // managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    diskName: diskName
    location: resourceLocation
  }
}

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    // scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: vaultName
      location: resourceLocation
      azureMonitorAlertSettingsAlertsForAllJobFailures: 'Disabled'
      immutabilitySettingState: 'Unlocked'
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
      backupInstances: [
        {
          name: nestedDependencies.outputs.diskName
          dataSourceInfo: {
            objectType: 'Datasource'
            resourceID: nestedDependencies.outputs.diskResourceId
            resourceName: diskName
            resourceType: resourceType
            resourceUri: nestedDependencies.outputs.diskResourceId
            resourceLocation: resourceLocation
            datasourceType: dataSourceType
          }
          policyInfo: {
            policyId: resourceId(
              'Microsoft.DataProtection/backupVaults/backupPolicies',
              resourceGroup().name,
              backupPolicyName
            )
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
