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

var backupPolicyName = 'policy${uniqueString(resourceGroup.id)}'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'inner.test.bicep' = {
  // module nestedDependencies 'dependencies.bicep' = {
  // scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    // managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    diskName: 'dep-${namePrefix}-dsk-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

// @batchSize(1)
// module testDeployment '../../../main.bicep' = [
//   for iteration in ['init', 'idem']: {
//     scope: resourceGroup
//     name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
//     params: {
//       name: 'vault${uniqueString(resourceGroup.id)}'
//       location: resourceLocation
//       azureMonitorAlertSettingsAlertsForAllJobFailures: 'Disabled'
//       immutabilitySettingState: 'Unlocked'
//       managedIdentities: {
//         systemAssigned: true
//       }
//       backupPolicies: [
//         {
//           name: backupPolicyName
//           properties: {
//             datasourceTypes: [
//               'Microsoft.Compute/disks'
//             ]
//             objectType: 'BackupPolicy'
//             policyRules: [
//               {
//                 backupParameters: {
//                   backupType: 'Incremental'
//                   objectType: 'AzureBackupParams'
//                 }
//                 dataStore: {
//                   dataStoreType: 'OperationalStore'
//                   objectType: 'DataStoreInfoBase'
//                 }
//                 name: 'BackupDaily'
//                 objectType: 'AzureBackupRule'
//                 trigger: {
//                   objectType: 'ScheduleBasedTriggerContext'
//                   schedule: {
//                     repeatingTimeIntervals: [
//                       'R/2022-05-31T23:30:00+01:00/P1D'
//                     ]
//                     timeZone: 'W. Europe Standard Time'
//                   }
//                   taggingCriteria: [
//                     {
//                       isDefault: true
//                       taggingPriority: 99
//                       tagInfo: {
//                         id: 'Default_'
//                         tagName: 'Default'
//                       }
//                     }
//                   ]
//                 }
//               }
//               {
//                 isDefault: true
//                 lifecycles: [
//                   {
//                     deleteAfter: {
//                       duration: 'P7D'
//                       objectType: 'AbsoluteDeleteOption'
//                     }
//                     sourceDataStore: {
//                       dataStoreType: 'OperationalStore'
//                       objectType: 'DataStoreInfoBase'
//                     }
//                     targetDataStoreCopySettings: []
//                   }
//                 ]
//                 name: 'Default'
//                 objectType: 'AzureRetentionRule'
//               }
//             ]
//           }
//         }
//       ]
//       backupInstances: [
//         {
//           // name: '${namePrefix}${serviceShort}disk001'
//           name: nestedDependencies.outputs.diskName
//           dataSourceInfo: {
//             objectType: 'Datasource'
//             resourceID: nestedDependencies.outputs.diskResourceId
//             resourceName: nestedDependencies.outputs.diskName
//             resourceType: 'Microsoft.Compute/disks'
//             resourceUri: nestedDependencies.outputs.diskResourceId
//             resourceLocation: resourceLocation
//             datasourceType: 'Microsoft.Compute/disks'
//           }
//           policyInfo: {
//             policyId: resourceId(
//               'Microsoft.DataProtection/backupVaults/backupPolicies',
//               resourceGroup.name,
//               backupPolicyName
//             )
//             policyParameters: {
//               dataStoreParametersList: [
//                 {
//                   objectType: 'AzureOperationalStoreParameters'
//                   dataStoreType: 'OperationalStore'
//                   resourceGroupId: resourceGroup.id
//                 }
//               ]
//             }
//           }
//         }
//       ]
//       lock: {
//         kind: 'CanNotDelete'
//         name: 'myCustomLockName'
//       }
//       tags: {
//         'hidden-title': 'This is visible in the resource name'
//         Environment: 'Non-Prod'
//         Role: 'DeploymentValidation'
//       }
//     }
//   }
// ]
