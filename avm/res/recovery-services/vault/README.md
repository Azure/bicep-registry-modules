# Recovery Services Vaults `[Microsoft.RecoveryServices/vaults]`

This module deploys a Recovery Services Vault.

You can reference the module as follows:
```bicep
module vault 'br/public:avm/res/recovery-services/vault:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.RecoveryServices/vaults` | 2024-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2024-04-01/vaults)</li></ul> |
| `Microsoft.RecoveryServices/vaults/backupconfig` | 2023-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_backupconfig.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupconfig)</li></ul> |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_backupfabrics_protectioncontainers_protecteditems.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2024-10-01/vaults/backupFabrics/protectionContainers/protectedItems)</li></ul> |
| `Microsoft.RecoveryServices/vaults/backupPolicies` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_backuppolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2024-10-01/vaults/backupPolicies)</li></ul> |
| `Microsoft.RecoveryServices/vaults/replicationAlertSettings` | 2022-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_replicationalertsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationAlertSettings)</li></ul> |
| `Microsoft.RecoveryServices/vaults/replicationFabrics` | 2022-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_replicationfabrics.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics)</li></ul> |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers` | 2022-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_replicationfabrics_replicationprotectioncontainers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics/replicationProtectionContainers)</li></ul> |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings` | 2022-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_replicationfabrics_replicationprotectioncontainers_replicationprotectioncontainermappings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings)</li></ul> |
| `Microsoft.RecoveryServices/vaults/replicationPolicies` | 2023-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_replicationpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-06-01/vaults/replicationPolicies)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/recovery-services/vault:<version>`.

- [Using managed HSM Customer-Managed-Keys with User-Assigned identity](#example-1-using-managed-hsm-customer-managed-keys-with-user-assigned-identity)
- [Using encryption with Customer-Managed-Key](#example-2-using-encryption-with-customer-managed-key)
- [Using only defaults](#example-3-using-only-defaults)
- [Test case for disaster recovery enabled](#example-4-test-case-for-disaster-recovery-enabled)
- [Using large parameter set](#example-5-using-large-parameter-set)
- [WAF-aligned](#example-6-waf-aligned)

### Example 1: _Using managed HSM Customer-Managed-Keys with User-Assigned identity_

This instance deploys the module with Managed HSM-based Customer Managed Key (CMK) encryption, using a User-Assigned Managed Identity to access the HSM key.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/cmk-hsm-uami]

> **Note**: This test is skipped from the CI deployment validation due to the presence of a `.e2eignore` file in the test folder. The reason for skipping the deployment is:
```text
The test is skipped because running the HSM scenario requires a persistent Managed HSM instance to be available and configured at all times, which would incur significant costs for contributors.
```

<details>

<summary>via Bicep module</summary>

```bicep
module vault 'br/public:avm/res/recovery-services/vault:<version>' = {
  params: {
    // Required parameters
    name: 'rsvhsmu001'
    // Non-required parameters
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "rsvhsmu001"
    },
    // Non-required parameters
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
      }
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/recovery-services/vault:<version>'

// Required parameters
param name = 'rsvhsmu001'
// Non-required parameters
param customerManagedKey = {
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
  userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
}
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
```

</details>
<p>

### Example 2: _Using encryption with Customer-Managed-Key_

This instance deploys the module using Customer-Managed-Keys using a User-Assigned Identity to access the Customer-Managed-Key secret.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/cmk-uami]


<details>

<summary>via Bicep module</summary>

```bicep
module vault 'br/public:avm/res/recovery-services/vault:<version>' = {
  params: {
    // Required parameters
    name: 'rsvencr001'
    // Non-required parameters
    customerManagedKey: {
      autoRotationEnabled: false
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "rsvencr001"
    },
    // Non-required parameters
    "customerManagedKey": {
      "value": {
        "autoRotationEnabled": false,
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
      }
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/recovery-services/vault:<version>'

// Required parameters
param name = 'rsvencr001'
// Non-required parameters
param customerManagedKey = {
  autoRotationEnabled: false
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
  userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
}
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
```

</details>
<p>

### Example 3: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module vault 'br/public:avm/res/recovery-services/vault:<version>' = {
  params: {
    name: 'rsvmin001'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": "rsvmin001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/recovery-services/vault:<version>'

param name = 'rsvmin001'
```

</details>
<p>

### Example 4: _Test case for disaster recovery enabled_

This instance deploys the module with disaster recovery enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/dr]


<details>

<summary>via Bicep module</summary>

```bicep
module vault 'br/public:avm/res/recovery-services/vault:<version>' = {
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    replicationFabrics: [
      {
        location: 'NorthEurope'
        replicationContainers: [
          {
            mappings: [
              {
                policyName: 'Default_values'
                targetContainerName: 'pluto'
                targetProtectionContainerResourceId: '<targetProtectionContainerResourceId>'
              }
            ]
            name: 'ne-container1'
          }
          {
            mappings: [
              {
                policyName: 'Default_values'
                targetContainerFabricName: 'WE-2'
                targetContainerName: 'we-container1'
              }
            ]
            name: 'ne-container2'
          }
        ]
      }
      {
        location: 'WestEurope'
        name: 'WE-2'
        replicationContainers: [
          {
            mappings: [
              {
                policyName: 'Default_values'
                targetContainerFabricName: 'NorthEurope'
                targetContainerName: 'ne-container2'
              }
            ]
            name: 'we-container1'
          }
        ]
      }
    ]
    replicationPolicies: [
      {
        name: 'Default_values'
      }
      {
        appConsistentFrequencyInMinutes: 240
        crashConsistentFrequencyInMinutes: 7
        multiVmSyncStatus: 'Disable'
        name: 'Custom_values'
        recoveryPointHistory: 2880
      }
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "<name>"
    },
    // Non-required parameters
    "replicationFabrics": {
      "value": [
        {
          "location": "NorthEurope",
          "replicationContainers": [
            {
              "mappings": [
                {
                  "policyName": "Default_values",
                  "targetContainerName": "pluto",
                  "targetProtectionContainerResourceId": "<targetProtectionContainerResourceId>"
                }
              ],
              "name": "ne-container1"
            },
            {
              "mappings": [
                {
                  "policyName": "Default_values",
                  "targetContainerFabricName": "WE-2",
                  "targetContainerName": "we-container1"
                }
              ],
              "name": "ne-container2"
            }
          ]
        },
        {
          "location": "WestEurope",
          "name": "WE-2",
          "replicationContainers": [
            {
              "mappings": [
                {
                  "policyName": "Default_values",
                  "targetContainerFabricName": "NorthEurope",
                  "targetContainerName": "ne-container2"
                }
              ],
              "name": "we-container1"
            }
          ]
        }
      ]
    },
    "replicationPolicies": {
      "value": [
        {
          "name": "Default_values"
        },
        {
          "appConsistentFrequencyInMinutes": 240,
          "crashConsistentFrequencyInMinutes": 7,
          "multiVmSyncStatus": "Disable",
          "name": "Custom_values",
          "recoveryPointHistory": 2880
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/recovery-services/vault:<version>'

// Required parameters
param name = '<name>'
// Non-required parameters
param replicationFabrics = [
  {
    location: 'NorthEurope'
    replicationContainers: [
      {
        mappings: [
          {
            policyName: 'Default_values'
            targetContainerName: 'pluto'
            targetProtectionContainerResourceId: '<targetProtectionContainerResourceId>'
          }
        ]
        name: 'ne-container1'
      }
      {
        mappings: [
          {
            policyName: 'Default_values'
            targetContainerFabricName: 'WE-2'
            targetContainerName: 'we-container1'
          }
        ]
        name: 'ne-container2'
      }
    ]
  }
  {
    location: 'WestEurope'
    name: 'WE-2'
    replicationContainers: [
      {
        mappings: [
          {
            policyName: 'Default_values'
            targetContainerFabricName: 'NorthEurope'
            targetContainerName: 'ne-container2'
          }
        ]
        name: 'we-container1'
      }
    ]
  }
]
param replicationPolicies = [
  {
    name: 'Default_values'
  }
  {
    appConsistentFrequencyInMinutes: 240
    crashConsistentFrequencyInMinutes: 7
    multiVmSyncStatus: 'Disable'
    name: 'Custom_values'
    recoveryPointHistory: 2880
  }
]
```

</details>
<p>

### Example 5: _Using large parameter set_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module vault 'br/public:avm/res/recovery-services/vault:<version>' = {
  params: {
    // Required parameters
    name: 'rsvmax001'
    // Non-required parameters
    backupConfig: {
      enhancedSecurityState: 'Disabled'
      softDeleteFeatureState: 'Disabled'
    }
    backupPolicies: [
      {
        name: 'VMpolicy'
        properties: {
          backupManagementType: 'AzureIaasVM'
          instantRPDetails: {}
          instantRpRetentionRangeInDays: 2
          protectedItemsCount: 0
          retentionPolicy: {
            dailySchedule: {
              retentionDuration: {
                count: 180
                durationType: 'Days'
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
            monthlySchedule: {
              retentionDuration: {
                count: 60
                durationType: 'Months'
              }
              retentionScheduleFormatType: 'Weekly'
              retentionScheduleWeekly: {
                daysOfTheWeek: [
                  'Sunday'
                ]
                weeksOfTheMonth: [
                  'First'
                ]
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
            retentionPolicyType: 'LongTermRetentionPolicy'
            weeklySchedule: {
              daysOfTheWeek: [
                'Sunday'
              ]
              retentionDuration: {
                count: 12
                durationType: 'Weeks'
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
            yearlySchedule: {
              monthsOfYear: [
                'January'
              ]
              retentionDuration: {
                count: 10
                durationType: 'Years'
              }
              retentionScheduleFormatType: 'Weekly'
              retentionScheduleWeekly: {
                daysOfTheWeek: [
                  'Sunday'
                ]
                weeksOfTheMonth: [
                  'First'
                ]
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
          }
          schedulePolicy: {
            schedulePolicyType: 'SimpleSchedulePolicy'
            scheduleRunFrequency: 'Daily'
            scheduleRunTimes: [
              '2019-11-07T07:00:00Z'
            ]
            scheduleWeeklyFrequency: 0
          }
          timeZone: 'UTC'
        }
      }
      {
        name: 'sqlpolicy'
        properties: {
          backupManagementType: 'AzureWorkload'
          protectedItemsCount: 0
          settings: {
            isCompression: true
            issqlcompression: true
            timeZone: 'UTC'
          }
          subProtectionPolicy: [
            {
              policyType: 'Full'
              retentionPolicy: {
                monthlySchedule: {
                  retentionDuration: {
                    count: 60
                    durationType: 'Months'
                  }
                  retentionScheduleFormatType: 'Weekly'
                  retentionScheduleWeekly: {
                    daysOfTheWeek: [
                      'Sunday'
                    ]
                    weeksOfTheMonth: [
                      'First'
                    ]
                  }
                  retentionTimes: [
                    '2019-11-07T22:00:00Z'
                  ]
                }
                retentionPolicyType: 'LongTermRetentionPolicy'
                weeklySchedule: {
                  daysOfTheWeek: [
                    'Sunday'
                  ]
                  retentionDuration: {
                    count: 104
                    durationType: 'Weeks'
                  }
                  retentionTimes: [
                    '2019-11-07T22:00:00Z'
                  ]
                }
                yearlySchedule: {
                  monthsOfYear: [
                    'January'
                  ]
                  retentionDuration: {
                    count: 10
                    durationType: 'Years'
                  }
                  retentionScheduleFormatType: 'Weekly'
                  retentionScheduleWeekly: {
                    daysOfTheWeek: [
                      'Sunday'
                    ]
                    weeksOfTheMonth: [
                      'First'
                    ]
                  }
                  retentionTimes: [
                    '2019-11-07T22:00:00Z'
                  ]
                }
              }
              schedulePolicy: {
                schedulePolicyType: 'SimpleSchedulePolicy'
                scheduleRunDays: [
                  'Sunday'
                ]
                scheduleRunFrequency: 'Weekly'
                scheduleRunTimes: [
                  '2019-11-07T22:00:00Z'
                ]
                scheduleWeeklyFrequency: 0
              }
            }
            {
              policyType: 'Differential'
              retentionPolicy: {
                retentionDuration: {
                  count: 30
                  durationType: 'Days'
                }
                retentionPolicyType: 'SimpleRetentionPolicy'
              }
              schedulePolicy: {
                schedulePolicyType: 'SimpleSchedulePolicy'
                scheduleRunDays: [
                  'Monday'
                ]
                scheduleRunFrequency: 'Weekly'
                scheduleRunTimes: [
                  '2017-03-07T02:00:00Z'
                ]
                scheduleWeeklyFrequency: 0
              }
            }
            {
              policyType: 'Log'
              retentionPolicy: {
                retentionDuration: {
                  count: 15
                  durationType: 'Days'
                }
                retentionPolicyType: 'SimpleRetentionPolicy'
              }
              schedulePolicy: {
                scheduleFrequencyInMins: 120
                schedulePolicyType: 'LogSchedulePolicy'
              }
            }
          ]
          workLoadType: 'SQLDataBase'
        }
      }
      {
        name: 'filesharepolicy'
        properties: {
          backupManagementType: 'AzureStorage'
          protectedItemsCount: 0
          retentionPolicy: {
            dailySchedule: {
              retentionDuration: {
                count: 30
                durationType: 'Days'
              }
              retentionTimes: [
                '2019-11-07T04:30:00Z'
              ]
            }
            retentionPolicyType: 'LongTermRetentionPolicy'
          }
          schedulePolicy: {
            schedulePolicyType: 'SimpleSchedulePolicy'
            scheduleRunFrequency: 'Daily'
            scheduleRunTimes: [
              '2019-11-07T04:30:00Z'
            ]
            scheduleWeeklyFrequency: 0
          }
          timeZone: 'UTC'
          workloadType: 'AzureFileShare'
        }
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    immutabilitySettingState: 'Unlocked'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    monitoringSettings: {
      azureMonitorAlertSettings: {
        alertsForAllFailoverIssues: 'Enabled'
        alertsForAllJobFailures: 'Enabled'
        alertsForAllReplicationIssues: 'Enabled'
      }
      classicAlertSettings: {
        alertsForCriticalOperations: 'Enabled'
        emailNotificationsForSiteRecovery: 'Enabled'
      }
    }
    privateEndpoints: [
      {
        ipConfigurations: [
          {
            name: 'myIpConfig-1'
            properties: {
              groupId: 'AzureSiteRecovery'
              memberName: 'SiteRecovery-tel1'
              privateIPAddress: '10.0.0.10'
            }
          }
          {
            name: 'myIPconfig-2'
            properties: {
              groupId: 'AzureSiteRecovery'
              memberName: 'SiteRecovery-prot2'
              privateIPAddress: '10.0.0.11'
            }
          }
          {
            name: 'myIPconfig-3'
            properties: {
              groupId: 'AzureSiteRecovery'
              memberName: 'SiteRecovery-srs1'
              privateIPAddress: '10.0.0.12'
            }
          }
          {
            name: 'myIPconfig-4'
            properties: {
              groupId: 'AzureSiteRecovery'
              memberName: 'SiteRecovery-rcm1'
              privateIPAddress: '10.0.0.13'
            }
          }
          {
            name: 'myIPconfig-5'
            properties: {
              groupId: 'AzureSiteRecovery'
              memberName: 'SiteRecovery-id1'
              privateIPAddress: '10.0.0.14'
            }
          }
        ]
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    protectedItems: [
      {
        name: '<name>'
        policyName: 'VMpolicy'
        protectedItemType: 'Microsoft.Compute/virtualMachines'
        protectionContainerName: '<protectionContainerName>'
        sourceResourceId: '<sourceResourceId>'
      }
    ]
    redundancySettings: {
      standardTierStorageRedundancy: 'LocallyRedundant'
    }
    replicationAlertSettings: {
      customEmailAddresses: [
        'test.user@testcompany.com'
      ]
      locale: 'en-US'
      sendToOwners: 'Send'
    }
    roleAssignments: [
      {
        name: '35288372-e6b4-4333-9ee6-dd997b96d52b'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        name: '<name>'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
    softDeleteSettings: {
      enhancedSecurityState: 'Enabled'
      softDeleteRetentionPeriodInDays: 14
      softDeleteState: 'Enabled'
    }
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "rsvmax001"
    },
    // Non-required parameters
    "backupConfig": {
      "value": {
        "enhancedSecurityState": "Disabled",
        "softDeleteFeatureState": "Disabled"
      }
    },
    "backupPolicies": {
      "value": [
        {
          "name": "VMpolicy",
          "properties": {
            "backupManagementType": "AzureIaasVM",
            "instantRPDetails": {},
            "instantRpRetentionRangeInDays": 2,
            "protectedItemsCount": 0,
            "retentionPolicy": {
              "dailySchedule": {
                "retentionDuration": {
                  "count": 180,
                  "durationType": "Days"
                },
                "retentionTimes": [
                  "2019-11-07T07:00:00Z"
                ]
              },
              "monthlySchedule": {
                "retentionDuration": {
                  "count": 60,
                  "durationType": "Months"
                },
                "retentionScheduleFormatType": "Weekly",
                "retentionScheduleWeekly": {
                  "daysOfTheWeek": [
                    "Sunday"
                  ],
                  "weeksOfTheMonth": [
                    "First"
                  ]
                },
                "retentionTimes": [
                  "2019-11-07T07:00:00Z"
                ]
              },
              "retentionPolicyType": "LongTermRetentionPolicy",
              "weeklySchedule": {
                "daysOfTheWeek": [
                  "Sunday"
                ],
                "retentionDuration": {
                  "count": 12,
                  "durationType": "Weeks"
                },
                "retentionTimes": [
                  "2019-11-07T07:00:00Z"
                ]
              },
              "yearlySchedule": {
                "monthsOfYear": [
                  "January"
                ],
                "retentionDuration": {
                  "count": 10,
                  "durationType": "Years"
                },
                "retentionScheduleFormatType": "Weekly",
                "retentionScheduleWeekly": {
                  "daysOfTheWeek": [
                    "Sunday"
                  ],
                  "weeksOfTheMonth": [
                    "First"
                  ]
                },
                "retentionTimes": [
                  "2019-11-07T07:00:00Z"
                ]
              }
            },
            "schedulePolicy": {
              "schedulePolicyType": "SimpleSchedulePolicy",
              "scheduleRunFrequency": "Daily",
              "scheduleRunTimes": [
                "2019-11-07T07:00:00Z"
              ],
              "scheduleWeeklyFrequency": 0
            },
            "timeZone": "UTC"
          }
        },
        {
          "name": "sqlpolicy",
          "properties": {
            "backupManagementType": "AzureWorkload",
            "protectedItemsCount": 0,
            "settings": {
              "isCompression": true,
              "issqlcompression": true,
              "timeZone": "UTC"
            },
            "subProtectionPolicy": [
              {
                "policyType": "Full",
                "retentionPolicy": {
                  "monthlySchedule": {
                    "retentionDuration": {
                      "count": 60,
                      "durationType": "Months"
                    },
                    "retentionScheduleFormatType": "Weekly",
                    "retentionScheduleWeekly": {
                      "daysOfTheWeek": [
                        "Sunday"
                      ],
                      "weeksOfTheMonth": [
                        "First"
                      ]
                    },
                    "retentionTimes": [
                      "2019-11-07T22:00:00Z"
                    ]
                  },
                  "retentionPolicyType": "LongTermRetentionPolicy",
                  "weeklySchedule": {
                    "daysOfTheWeek": [
                      "Sunday"
                    ],
                    "retentionDuration": {
                      "count": 104,
                      "durationType": "Weeks"
                    },
                    "retentionTimes": [
                      "2019-11-07T22:00:00Z"
                    ]
                  },
                  "yearlySchedule": {
                    "monthsOfYear": [
                      "January"
                    ],
                    "retentionDuration": {
                      "count": 10,
                      "durationType": "Years"
                    },
                    "retentionScheduleFormatType": "Weekly",
                    "retentionScheduleWeekly": {
                      "daysOfTheWeek": [
                        "Sunday"
                      ],
                      "weeksOfTheMonth": [
                        "First"
                      ]
                    },
                    "retentionTimes": [
                      "2019-11-07T22:00:00Z"
                    ]
                  }
                },
                "schedulePolicy": {
                  "schedulePolicyType": "SimpleSchedulePolicy",
                  "scheduleRunDays": [
                    "Sunday"
                  ],
                  "scheduleRunFrequency": "Weekly",
                  "scheduleRunTimes": [
                    "2019-11-07T22:00:00Z"
                  ],
                  "scheduleWeeklyFrequency": 0
                }
              },
              {
                "policyType": "Differential",
                "retentionPolicy": {
                  "retentionDuration": {
                    "count": 30,
                    "durationType": "Days"
                  },
                  "retentionPolicyType": "SimpleRetentionPolicy"
                },
                "schedulePolicy": {
                  "schedulePolicyType": "SimpleSchedulePolicy",
                  "scheduleRunDays": [
                    "Monday"
                  ],
                  "scheduleRunFrequency": "Weekly",
                  "scheduleRunTimes": [
                    "2017-03-07T02:00:00Z"
                  ],
                  "scheduleWeeklyFrequency": 0
                }
              },
              {
                "policyType": "Log",
                "retentionPolicy": {
                  "retentionDuration": {
                    "count": 15,
                    "durationType": "Days"
                  },
                  "retentionPolicyType": "SimpleRetentionPolicy"
                },
                "schedulePolicy": {
                  "scheduleFrequencyInMins": 120,
                  "schedulePolicyType": "LogSchedulePolicy"
                }
              }
            ],
            "workLoadType": "SQLDataBase"
          }
        },
        {
          "name": "filesharepolicy",
          "properties": {
            "backupManagementType": "AzureStorage",
            "protectedItemsCount": 0,
            "retentionPolicy": {
              "dailySchedule": {
                "retentionDuration": {
                  "count": 30,
                  "durationType": "Days"
                },
                "retentionTimes": [
                  "2019-11-07T04:30:00Z"
                ]
              },
              "retentionPolicyType": "LongTermRetentionPolicy"
            },
            "schedulePolicy": {
              "schedulePolicyType": "SimpleSchedulePolicy",
              "scheduleRunFrequency": "Daily",
              "scheduleRunTimes": [
                "2019-11-07T04:30:00Z"
              ],
              "scheduleWeeklyFrequency": 0
            },
            "timeZone": "UTC",
            "workloadType": "AzureFileShare"
          }
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "immutabilitySettingState": {
      "value": "Unlocked"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "monitoringSettings": {
      "value": {
        "azureMonitorAlertSettings": {
          "alertsForAllFailoverIssues": "Enabled",
          "alertsForAllJobFailures": "Enabled",
          "alertsForAllReplicationIssues": "Enabled"
        },
        "classicAlertSettings": {
          "alertsForCriticalOperations": "Enabled",
          "emailNotificationsForSiteRecovery": "Enabled"
        }
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "myIpConfig-1",
              "properties": {
                "groupId": "AzureSiteRecovery",
                "memberName": "SiteRecovery-tel1",
                "privateIPAddress": "10.0.0.10"
              }
            },
            {
              "name": "myIPconfig-2",
              "properties": {
                "groupId": "AzureSiteRecovery",
                "memberName": "SiteRecovery-prot2",
                "privateIPAddress": "10.0.0.11"
              }
            },
            {
              "name": "myIPconfig-3",
              "properties": {
                "groupId": "AzureSiteRecovery",
                "memberName": "SiteRecovery-srs1",
                "privateIPAddress": "10.0.0.12"
              }
            },
            {
              "name": "myIPconfig-4",
              "properties": {
                "groupId": "AzureSiteRecovery",
                "memberName": "SiteRecovery-rcm1",
                "privateIPAddress": "10.0.0.13"
              }
            },
            {
              "name": "myIPconfig-5",
              "properties": {
                "groupId": "AzureSiteRecovery",
                "memberName": "SiteRecovery-id1",
                "privateIPAddress": "10.0.0.14"
              }
            }
          ],
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "protectedItems": {
      "value": [
        {
          "name": "<name>",
          "policyName": "VMpolicy",
          "protectedItemType": "Microsoft.Compute/virtualMachines",
          "protectionContainerName": "<protectionContainerName>",
          "sourceResourceId": "<sourceResourceId>"
        }
      ]
    },
    "redundancySettings": {
      "value": {
        "standardTierStorageRedundancy": "LocallyRedundant"
      }
    },
    "replicationAlertSettings": {
      "value": {
        "customEmailAddresses": [
          "test.user@testcompany.com"
        ],
        "locale": "en-US",
        "sendToOwners": "Send"
      }
    },
    "roleAssignments": {
      "value": [
        {
          "name": "35288372-e6b4-4333-9ee6-dd997b96d52b",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "name": "<name>",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
        }
      ]
    },
    "softDeleteSettings": {
      "value": {
        "enhancedSecurityState": "Enabled",
        "softDeleteRetentionPeriodInDays": 14,
        "softDeleteState": "Enabled"
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/recovery-services/vault:<version>'

// Required parameters
param name = 'rsvmax001'
// Non-required parameters
param backupConfig = {
  enhancedSecurityState: 'Disabled'
  softDeleteFeatureState: 'Disabled'
}
param backupPolicies = [
  {
    name: 'VMpolicy'
    properties: {
      backupManagementType: 'AzureIaasVM'
      instantRPDetails: {}
      instantRpRetentionRangeInDays: 2
      protectedItemsCount: 0
      retentionPolicy: {
        dailySchedule: {
          retentionDuration: {
            count: 180
            durationType: 'Days'
          }
          retentionTimes: [
            '2019-11-07T07:00:00Z'
          ]
        }
        monthlySchedule: {
          retentionDuration: {
            count: 60
            durationType: 'Months'
          }
          retentionScheduleFormatType: 'Weekly'
          retentionScheduleWeekly: {
            daysOfTheWeek: [
              'Sunday'
            ]
            weeksOfTheMonth: [
              'First'
            ]
          }
          retentionTimes: [
            '2019-11-07T07:00:00Z'
          ]
        }
        retentionPolicyType: 'LongTermRetentionPolicy'
        weeklySchedule: {
          daysOfTheWeek: [
            'Sunday'
          ]
          retentionDuration: {
            count: 12
            durationType: 'Weeks'
          }
          retentionTimes: [
            '2019-11-07T07:00:00Z'
          ]
        }
        yearlySchedule: {
          monthsOfYear: [
            'January'
          ]
          retentionDuration: {
            count: 10
            durationType: 'Years'
          }
          retentionScheduleFormatType: 'Weekly'
          retentionScheduleWeekly: {
            daysOfTheWeek: [
              'Sunday'
            ]
            weeksOfTheMonth: [
              'First'
            ]
          }
          retentionTimes: [
            '2019-11-07T07:00:00Z'
          ]
        }
      }
      schedulePolicy: {
        schedulePolicyType: 'SimpleSchedulePolicy'
        scheduleRunFrequency: 'Daily'
        scheduleRunTimes: [
          '2019-11-07T07:00:00Z'
        ]
        scheduleWeeklyFrequency: 0
      }
      timeZone: 'UTC'
    }
  }
  {
    name: 'sqlpolicy'
    properties: {
      backupManagementType: 'AzureWorkload'
      protectedItemsCount: 0
      settings: {
        isCompression: true
        issqlcompression: true
        timeZone: 'UTC'
      }
      subProtectionPolicy: [
        {
          policyType: 'Full'
          retentionPolicy: {
            monthlySchedule: {
              retentionDuration: {
                count: 60
                durationType: 'Months'
              }
              retentionScheduleFormatType: 'Weekly'
              retentionScheduleWeekly: {
                daysOfTheWeek: [
                  'Sunday'
                ]
                weeksOfTheMonth: [
                  'First'
                ]
              }
              retentionTimes: [
                '2019-11-07T22:00:00Z'
              ]
            }
            retentionPolicyType: 'LongTermRetentionPolicy'
            weeklySchedule: {
              daysOfTheWeek: [
                'Sunday'
              ]
              retentionDuration: {
                count: 104
                durationType: 'Weeks'
              }
              retentionTimes: [
                '2019-11-07T22:00:00Z'
              ]
            }
            yearlySchedule: {
              monthsOfYear: [
                'January'
              ]
              retentionDuration: {
                count: 10
                durationType: 'Years'
              }
              retentionScheduleFormatType: 'Weekly'
              retentionScheduleWeekly: {
                daysOfTheWeek: [
                  'Sunday'
                ]
                weeksOfTheMonth: [
                  'First'
                ]
              }
              retentionTimes: [
                '2019-11-07T22:00:00Z'
              ]
            }
          }
          schedulePolicy: {
            schedulePolicyType: 'SimpleSchedulePolicy'
            scheduleRunDays: [
              'Sunday'
            ]
            scheduleRunFrequency: 'Weekly'
            scheduleRunTimes: [
              '2019-11-07T22:00:00Z'
            ]
            scheduleWeeklyFrequency: 0
          }
        }
        {
          policyType: 'Differential'
          retentionPolicy: {
            retentionDuration: {
              count: 30
              durationType: 'Days'
            }
            retentionPolicyType: 'SimpleRetentionPolicy'
          }
          schedulePolicy: {
            schedulePolicyType: 'SimpleSchedulePolicy'
            scheduleRunDays: [
              'Monday'
            ]
            scheduleRunFrequency: 'Weekly'
            scheduleRunTimes: [
              '2017-03-07T02:00:00Z'
            ]
            scheduleWeeklyFrequency: 0
          }
        }
        {
          policyType: 'Log'
          retentionPolicy: {
            retentionDuration: {
              count: 15
              durationType: 'Days'
            }
            retentionPolicyType: 'SimpleRetentionPolicy'
          }
          schedulePolicy: {
            scheduleFrequencyInMins: 120
            schedulePolicyType: 'LogSchedulePolicy'
          }
        }
      ]
      workLoadType: 'SQLDataBase'
    }
  }
  {
    name: 'filesharepolicy'
    properties: {
      backupManagementType: 'AzureStorage'
      protectedItemsCount: 0
      retentionPolicy: {
        dailySchedule: {
          retentionDuration: {
            count: 30
            durationType: 'Days'
          }
          retentionTimes: [
            '2019-11-07T04:30:00Z'
          ]
        }
        retentionPolicyType: 'LongTermRetentionPolicy'
      }
      schedulePolicy: {
        schedulePolicyType: 'SimpleSchedulePolicy'
        scheduleRunFrequency: 'Daily'
        scheduleRunTimes: [
          '2019-11-07T04:30:00Z'
        ]
        scheduleWeeklyFrequency: 0
      }
      timeZone: 'UTC'
      workloadType: 'AzureFileShare'
    }
  }
]
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param immutabilitySettingState = 'Unlocked'
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param monitoringSettings = {
  azureMonitorAlertSettings: {
    alertsForAllFailoverIssues: 'Enabled'
    alertsForAllJobFailures: 'Enabled'
    alertsForAllReplicationIssues: 'Enabled'
  }
  classicAlertSettings: {
    alertsForCriticalOperations: 'Enabled'
    emailNotificationsForSiteRecovery: 'Enabled'
  }
}
param privateEndpoints = [
  {
    ipConfigurations: [
      {
        name: 'myIpConfig-1'
        properties: {
          groupId: 'AzureSiteRecovery'
          memberName: 'SiteRecovery-tel1'
          privateIPAddress: '10.0.0.10'
        }
      }
      {
        name: 'myIPconfig-2'
        properties: {
          groupId: 'AzureSiteRecovery'
          memberName: 'SiteRecovery-prot2'
          privateIPAddress: '10.0.0.11'
        }
      }
      {
        name: 'myIPconfig-3'
        properties: {
          groupId: 'AzureSiteRecovery'
          memberName: 'SiteRecovery-srs1'
          privateIPAddress: '10.0.0.12'
        }
      }
      {
        name: 'myIPconfig-4'
        properties: {
          groupId: 'AzureSiteRecovery'
          memberName: 'SiteRecovery-rcm1'
          privateIPAddress: '10.0.0.13'
        }
      }
      {
        name: 'myIPconfig-5'
        properties: {
          groupId: 'AzureSiteRecovery'
          memberName: 'SiteRecovery-id1'
          privateIPAddress: '10.0.0.14'
        }
      }
    ]
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    subnetResourceId: '<subnetResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
]
param protectedItems = [
  {
    name: '<name>'
    policyName: 'VMpolicy'
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    protectionContainerName: '<protectionContainerName>'
    sourceResourceId: '<sourceResourceId>'
  }
]
param redundancySettings = {
  standardTierStorageRedundancy: 'LocallyRedundant'
}
param replicationAlertSettings = {
  customEmailAddresses: [
    'test.user@testcompany.com'
  ]
  locale: 'en-US'
  sendToOwners: 'Send'
}
param roleAssignments = [
  {
    name: '35288372-e6b4-4333-9ee6-dd997b96d52b'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Owner'
  }
  {
    name: '<name>'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
  }
]
param softDeleteSettings = {
  enhancedSecurityState: 'Enabled'
  softDeleteRetentionPeriodInDays: 14
  softDeleteState: 'Enabled'
}
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 6: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module vault 'br/public:avm/res/recovery-services/vault:<version>' = {
  params: {
    // Required parameters
    name: 'rsvwaf001'
    // Non-required parameters
    backupConfig: {
      enhancedSecurityState: 'Disabled'
      softDeleteFeatureState: 'Disabled'
    }
    backupPolicies: [
      {
        name: 'VMpolicy'
        properties: {
          backupManagementType: 'AzureIaasVM'
          instantRPDetails: {}
          instantRpRetentionRangeInDays: 2
          protectedItemsCount: 0
          retentionPolicy: {
            dailySchedule: {
              retentionDuration: {
                count: 180
                durationType: 'Days'
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
            monthlySchedule: {
              retentionDuration: {
                count: 60
                durationType: 'Months'
              }
              retentionScheduleFormatType: 'Weekly'
              retentionScheduleWeekly: {
                daysOfTheWeek: [
                  'Sunday'
                ]
                weeksOfTheMonth: [
                  'First'
                ]
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
            retentionPolicyType: 'LongTermRetentionPolicy'
            weeklySchedule: {
              daysOfTheWeek: [
                'Sunday'
              ]
              retentionDuration: {
                count: 12
                durationType: 'Weeks'
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
            yearlySchedule: {
              monthsOfYear: [
                'January'
              ]
              retentionDuration: {
                count: 10
                durationType: 'Years'
              }
              retentionScheduleFormatType: 'Weekly'
              retentionScheduleWeekly: {
                daysOfTheWeek: [
                  'Sunday'
                ]
                weeksOfTheMonth: [
                  'First'
                ]
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
          }
          schedulePolicy: {
            schedulePolicyType: 'SimpleSchedulePolicy'
            scheduleRunFrequency: 'Daily'
            scheduleRunTimes: [
              '2019-11-07T07:00:00Z'
            ]
            scheduleWeeklyFrequency: 0
          }
          timeZone: 'UTC'
        }
      }
      {
        name: 'sqlpolicy'
        properties: {
          backupManagementType: 'AzureWorkload'
          protectedItemsCount: 0
          settings: {
            isCompression: true
            issqlcompression: true
            timeZone: 'UTC'
          }
          subProtectionPolicy: [
            {
              policyType: 'Full'
              retentionPolicy: {
                monthlySchedule: {
                  retentionDuration: {
                    count: 60
                    durationType: 'Months'
                  }
                  retentionScheduleFormatType: 'Weekly'
                  retentionScheduleWeekly: {
                    daysOfTheWeek: [
                      'Sunday'
                    ]
                    weeksOfTheMonth: [
                      'First'
                    ]
                  }
                  retentionTimes: [
                    '2019-11-07T22:00:00Z'
                  ]
                }
                retentionPolicyType: 'LongTermRetentionPolicy'
                weeklySchedule: {
                  daysOfTheWeek: [
                    'Sunday'
                  ]
                  retentionDuration: {
                    count: 104
                    durationType: 'Weeks'
                  }
                  retentionTimes: [
                    '2019-11-07T22:00:00Z'
                  ]
                }
                yearlySchedule: {
                  monthsOfYear: [
                    'January'
                  ]
                  retentionDuration: {
                    count: 10
                    durationType: 'Years'
                  }
                  retentionScheduleFormatType: 'Weekly'
                  retentionScheduleWeekly: {
                    daysOfTheWeek: [
                      'Sunday'
                    ]
                    weeksOfTheMonth: [
                      'First'
                    ]
                  }
                  retentionTimes: [
                    '2019-11-07T22:00:00Z'
                  ]
                }
              }
              schedulePolicy: {
                schedulePolicyType: 'SimpleSchedulePolicy'
                scheduleRunDays: [
                  'Sunday'
                ]
                scheduleRunFrequency: 'Weekly'
                scheduleRunTimes: [
                  '2019-11-07T22:00:00Z'
                ]
                scheduleWeeklyFrequency: 0
              }
            }
            {
              policyType: 'Differential'
              retentionPolicy: {
                retentionDuration: {
                  count: 30
                  durationType: 'Days'
                }
                retentionPolicyType: 'SimpleRetentionPolicy'
              }
              schedulePolicy: {
                schedulePolicyType: 'SimpleSchedulePolicy'
                scheduleRunDays: [
                  'Monday'
                ]
                scheduleRunFrequency: 'Weekly'
                scheduleRunTimes: [
                  '2017-03-07T02:00:00Z'
                ]
                scheduleWeeklyFrequency: 0
              }
            }
            {
              policyType: 'Log'
              retentionPolicy: {
                retentionDuration: {
                  count: 15
                  durationType: 'Days'
                }
                retentionPolicyType: 'SimpleRetentionPolicy'
              }
              schedulePolicy: {
                scheduleFrequencyInMins: 120
                schedulePolicyType: 'LogSchedulePolicy'
              }
            }
          ]
          workLoadType: 'SQLDataBase'
        }
      }
      {
        name: 'filesharepolicy'
        properties: {
          backupManagementType: 'AzureStorage'
          protectedItemsCount: 0
          retentionPolicy: {
            dailySchedule: {
              retentionDuration: {
                count: 30
                durationType: 'Days'
              }
              retentionTimes: [
                '2019-11-07T04:30:00Z'
              ]
            }
            retentionPolicyType: 'LongTermRetentionPolicy'
          }
          schedulePolicy: {
            schedulePolicyType: 'SimpleSchedulePolicy'
            scheduleRunFrequency: 'Daily'
            scheduleRunTimes: [
              '2019-11-07T04:30:00Z'
            ]
            scheduleWeeklyFrequency: 0
          }
          timeZone: 'UTC'
          workloadType: 'AzureFileShare'
        }
      }
    ]
    customerManagedKey: {
      autoRotationEnabled: true
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    immutabilitySettingState: 'Unlocked'
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    monitoringSettings: {
      azureMonitorAlertSettings: {
        alertsForAllFailoverIssues: 'Enabled'
        alertsForAllJobFailures: 'Enabled'
        alertsForAllReplicationIssues: 'Enabled'
      }
      classicAlertSettings: {
        alertsForCriticalOperations: 'Enabled'
        emailNotificationsForSiteRecovery: 'Enabled'
      }
    }
    privateEndpoints: [
      {
        ipConfigurations: [
          {
            name: 'myIpConfig-1'
            properties: {
              groupId: 'AzureSiteRecovery'
              memberName: 'SiteRecovery-tel1'
              privateIPAddress: '10.0.0.10'
            }
          }
          {
            name: 'myIPconfig-2'
            properties: {
              groupId: 'AzureSiteRecovery'
              memberName: 'SiteRecovery-prot2'
              privateIPAddress: '10.0.0.11'
            }
          }
          {
            name: 'myIPconfig-3'
            properties: {
              groupId: 'AzureSiteRecovery'
              memberName: 'SiteRecovery-srs1'
              privateIPAddress: '10.0.0.12'
            }
          }
          {
            name: 'myIPconfig-4'
            properties: {
              groupId: 'AzureSiteRecovery'
              memberName: 'SiteRecovery-rcm1'
              privateIPAddress: '10.0.0.13'
            }
          }
          {
            name: 'myIPconfig-5'
            properties: {
              groupId: 'AzureSiteRecovery'
              memberName: 'SiteRecovery-id1'
              privateIPAddress: '10.0.0.14'
            }
          }
        ]
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    replicationAlertSettings: {
      customEmailAddresses: [
        'test.user@testcompany.com'
      ]
      locale: 'en-US'
      sendToOwners: 'Send'
    }
    softDeleteSettings: {
      enhancedSecurityState: 'Enabled'
      softDeleteRetentionPeriodInDays: 14
      softDeleteState: 'Enabled'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "rsvwaf001"
    },
    // Non-required parameters
    "backupConfig": {
      "value": {
        "enhancedSecurityState": "Disabled",
        "softDeleteFeatureState": "Disabled"
      }
    },
    "backupPolicies": {
      "value": [
        {
          "name": "VMpolicy",
          "properties": {
            "backupManagementType": "AzureIaasVM",
            "instantRPDetails": {},
            "instantRpRetentionRangeInDays": 2,
            "protectedItemsCount": 0,
            "retentionPolicy": {
              "dailySchedule": {
                "retentionDuration": {
                  "count": 180,
                  "durationType": "Days"
                },
                "retentionTimes": [
                  "2019-11-07T07:00:00Z"
                ]
              },
              "monthlySchedule": {
                "retentionDuration": {
                  "count": 60,
                  "durationType": "Months"
                },
                "retentionScheduleFormatType": "Weekly",
                "retentionScheduleWeekly": {
                  "daysOfTheWeek": [
                    "Sunday"
                  ],
                  "weeksOfTheMonth": [
                    "First"
                  ]
                },
                "retentionTimes": [
                  "2019-11-07T07:00:00Z"
                ]
              },
              "retentionPolicyType": "LongTermRetentionPolicy",
              "weeklySchedule": {
                "daysOfTheWeek": [
                  "Sunday"
                ],
                "retentionDuration": {
                  "count": 12,
                  "durationType": "Weeks"
                },
                "retentionTimes": [
                  "2019-11-07T07:00:00Z"
                ]
              },
              "yearlySchedule": {
                "monthsOfYear": [
                  "January"
                ],
                "retentionDuration": {
                  "count": 10,
                  "durationType": "Years"
                },
                "retentionScheduleFormatType": "Weekly",
                "retentionScheduleWeekly": {
                  "daysOfTheWeek": [
                    "Sunday"
                  ],
                  "weeksOfTheMonth": [
                    "First"
                  ]
                },
                "retentionTimes": [
                  "2019-11-07T07:00:00Z"
                ]
              }
            },
            "schedulePolicy": {
              "schedulePolicyType": "SimpleSchedulePolicy",
              "scheduleRunFrequency": "Daily",
              "scheduleRunTimes": [
                "2019-11-07T07:00:00Z"
              ],
              "scheduleWeeklyFrequency": 0
            },
            "timeZone": "UTC"
          }
        },
        {
          "name": "sqlpolicy",
          "properties": {
            "backupManagementType": "AzureWorkload",
            "protectedItemsCount": 0,
            "settings": {
              "isCompression": true,
              "issqlcompression": true,
              "timeZone": "UTC"
            },
            "subProtectionPolicy": [
              {
                "policyType": "Full",
                "retentionPolicy": {
                  "monthlySchedule": {
                    "retentionDuration": {
                      "count": 60,
                      "durationType": "Months"
                    },
                    "retentionScheduleFormatType": "Weekly",
                    "retentionScheduleWeekly": {
                      "daysOfTheWeek": [
                        "Sunday"
                      ],
                      "weeksOfTheMonth": [
                        "First"
                      ]
                    },
                    "retentionTimes": [
                      "2019-11-07T22:00:00Z"
                    ]
                  },
                  "retentionPolicyType": "LongTermRetentionPolicy",
                  "weeklySchedule": {
                    "daysOfTheWeek": [
                      "Sunday"
                    ],
                    "retentionDuration": {
                      "count": 104,
                      "durationType": "Weeks"
                    },
                    "retentionTimes": [
                      "2019-11-07T22:00:00Z"
                    ]
                  },
                  "yearlySchedule": {
                    "monthsOfYear": [
                      "January"
                    ],
                    "retentionDuration": {
                      "count": 10,
                      "durationType": "Years"
                    },
                    "retentionScheduleFormatType": "Weekly",
                    "retentionScheduleWeekly": {
                      "daysOfTheWeek": [
                        "Sunday"
                      ],
                      "weeksOfTheMonth": [
                        "First"
                      ]
                    },
                    "retentionTimes": [
                      "2019-11-07T22:00:00Z"
                    ]
                  }
                },
                "schedulePolicy": {
                  "schedulePolicyType": "SimpleSchedulePolicy",
                  "scheduleRunDays": [
                    "Sunday"
                  ],
                  "scheduleRunFrequency": "Weekly",
                  "scheduleRunTimes": [
                    "2019-11-07T22:00:00Z"
                  ],
                  "scheduleWeeklyFrequency": 0
                }
              },
              {
                "policyType": "Differential",
                "retentionPolicy": {
                  "retentionDuration": {
                    "count": 30,
                    "durationType": "Days"
                  },
                  "retentionPolicyType": "SimpleRetentionPolicy"
                },
                "schedulePolicy": {
                  "schedulePolicyType": "SimpleSchedulePolicy",
                  "scheduleRunDays": [
                    "Monday"
                  ],
                  "scheduleRunFrequency": "Weekly",
                  "scheduleRunTimes": [
                    "2017-03-07T02:00:00Z"
                  ],
                  "scheduleWeeklyFrequency": 0
                }
              },
              {
                "policyType": "Log",
                "retentionPolicy": {
                  "retentionDuration": {
                    "count": 15,
                    "durationType": "Days"
                  },
                  "retentionPolicyType": "SimpleRetentionPolicy"
                },
                "schedulePolicy": {
                  "scheduleFrequencyInMins": 120,
                  "schedulePolicyType": "LogSchedulePolicy"
                }
              }
            ],
            "workLoadType": "SQLDataBase"
          }
        },
        {
          "name": "filesharepolicy",
          "properties": {
            "backupManagementType": "AzureStorage",
            "protectedItemsCount": 0,
            "retentionPolicy": {
              "dailySchedule": {
                "retentionDuration": {
                  "count": 30,
                  "durationType": "Days"
                },
                "retentionTimes": [
                  "2019-11-07T04:30:00Z"
                ]
              },
              "retentionPolicyType": "LongTermRetentionPolicy"
            },
            "schedulePolicy": {
              "schedulePolicyType": "SimpleSchedulePolicy",
              "scheduleRunFrequency": "Daily",
              "scheduleRunTimes": [
                "2019-11-07T04:30:00Z"
              ],
              "scheduleWeeklyFrequency": 0
            },
            "timeZone": "UTC",
            "workloadType": "AzureFileShare"
          }
        }
      ]
    },
    "customerManagedKey": {
      "value": {
        "autoRotationEnabled": true,
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
      }
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "immutabilitySettingState": {
      "value": "Unlocked"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "monitoringSettings": {
      "value": {
        "azureMonitorAlertSettings": {
          "alertsForAllFailoverIssues": "Enabled",
          "alertsForAllJobFailures": "Enabled",
          "alertsForAllReplicationIssues": "Enabled"
        },
        "classicAlertSettings": {
          "alertsForCriticalOperations": "Enabled",
          "emailNotificationsForSiteRecovery": "Enabled"
        }
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "myIpConfig-1",
              "properties": {
                "groupId": "AzureSiteRecovery",
                "memberName": "SiteRecovery-tel1",
                "privateIPAddress": "10.0.0.10"
              }
            },
            {
              "name": "myIPconfig-2",
              "properties": {
                "groupId": "AzureSiteRecovery",
                "memberName": "SiteRecovery-prot2",
                "privateIPAddress": "10.0.0.11"
              }
            },
            {
              "name": "myIPconfig-3",
              "properties": {
                "groupId": "AzureSiteRecovery",
                "memberName": "SiteRecovery-srs1",
                "privateIPAddress": "10.0.0.12"
              }
            },
            {
              "name": "myIPconfig-4",
              "properties": {
                "groupId": "AzureSiteRecovery",
                "memberName": "SiteRecovery-rcm1",
                "privateIPAddress": "10.0.0.13"
              }
            },
            {
              "name": "myIPconfig-5",
              "properties": {
                "groupId": "AzureSiteRecovery",
                "memberName": "SiteRecovery-id1",
                "privateIPAddress": "10.0.0.14"
              }
            }
          ],
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "replicationAlertSettings": {
      "value": {
        "customEmailAddresses": [
          "test.user@testcompany.com"
        ],
        "locale": "en-US",
        "sendToOwners": "Send"
      }
    },
    "softDeleteSettings": {
      "value": {
        "enhancedSecurityState": "Enabled",
        "softDeleteRetentionPeriodInDays": 14,
        "softDeleteState": "Enabled"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/recovery-services/vault:<version>'

// Required parameters
param name = 'rsvwaf001'
// Non-required parameters
param backupConfig = {
  enhancedSecurityState: 'Disabled'
  softDeleteFeatureState: 'Disabled'
}
param backupPolicies = [
  {
    name: 'VMpolicy'
    properties: {
      backupManagementType: 'AzureIaasVM'
      instantRPDetails: {}
      instantRpRetentionRangeInDays: 2
      protectedItemsCount: 0
      retentionPolicy: {
        dailySchedule: {
          retentionDuration: {
            count: 180
            durationType: 'Days'
          }
          retentionTimes: [
            '2019-11-07T07:00:00Z'
          ]
        }
        monthlySchedule: {
          retentionDuration: {
            count: 60
            durationType: 'Months'
          }
          retentionScheduleFormatType: 'Weekly'
          retentionScheduleWeekly: {
            daysOfTheWeek: [
              'Sunday'
            ]
            weeksOfTheMonth: [
              'First'
            ]
          }
          retentionTimes: [
            '2019-11-07T07:00:00Z'
          ]
        }
        retentionPolicyType: 'LongTermRetentionPolicy'
        weeklySchedule: {
          daysOfTheWeek: [
            'Sunday'
          ]
          retentionDuration: {
            count: 12
            durationType: 'Weeks'
          }
          retentionTimes: [
            '2019-11-07T07:00:00Z'
          ]
        }
        yearlySchedule: {
          monthsOfYear: [
            'January'
          ]
          retentionDuration: {
            count: 10
            durationType: 'Years'
          }
          retentionScheduleFormatType: 'Weekly'
          retentionScheduleWeekly: {
            daysOfTheWeek: [
              'Sunday'
            ]
            weeksOfTheMonth: [
              'First'
            ]
          }
          retentionTimes: [
            '2019-11-07T07:00:00Z'
          ]
        }
      }
      schedulePolicy: {
        schedulePolicyType: 'SimpleSchedulePolicy'
        scheduleRunFrequency: 'Daily'
        scheduleRunTimes: [
          '2019-11-07T07:00:00Z'
        ]
        scheduleWeeklyFrequency: 0
      }
      timeZone: 'UTC'
    }
  }
  {
    name: 'sqlpolicy'
    properties: {
      backupManagementType: 'AzureWorkload'
      protectedItemsCount: 0
      settings: {
        isCompression: true
        issqlcompression: true
        timeZone: 'UTC'
      }
      subProtectionPolicy: [
        {
          policyType: 'Full'
          retentionPolicy: {
            monthlySchedule: {
              retentionDuration: {
                count: 60
                durationType: 'Months'
              }
              retentionScheduleFormatType: 'Weekly'
              retentionScheduleWeekly: {
                daysOfTheWeek: [
                  'Sunday'
                ]
                weeksOfTheMonth: [
                  'First'
                ]
              }
              retentionTimes: [
                '2019-11-07T22:00:00Z'
              ]
            }
            retentionPolicyType: 'LongTermRetentionPolicy'
            weeklySchedule: {
              daysOfTheWeek: [
                'Sunday'
              ]
              retentionDuration: {
                count: 104
                durationType: 'Weeks'
              }
              retentionTimes: [
                '2019-11-07T22:00:00Z'
              ]
            }
            yearlySchedule: {
              monthsOfYear: [
                'January'
              ]
              retentionDuration: {
                count: 10
                durationType: 'Years'
              }
              retentionScheduleFormatType: 'Weekly'
              retentionScheduleWeekly: {
                daysOfTheWeek: [
                  'Sunday'
                ]
                weeksOfTheMonth: [
                  'First'
                ]
              }
              retentionTimes: [
                '2019-11-07T22:00:00Z'
              ]
            }
          }
          schedulePolicy: {
            schedulePolicyType: 'SimpleSchedulePolicy'
            scheduleRunDays: [
              'Sunday'
            ]
            scheduleRunFrequency: 'Weekly'
            scheduleRunTimes: [
              '2019-11-07T22:00:00Z'
            ]
            scheduleWeeklyFrequency: 0
          }
        }
        {
          policyType: 'Differential'
          retentionPolicy: {
            retentionDuration: {
              count: 30
              durationType: 'Days'
            }
            retentionPolicyType: 'SimpleRetentionPolicy'
          }
          schedulePolicy: {
            schedulePolicyType: 'SimpleSchedulePolicy'
            scheduleRunDays: [
              'Monday'
            ]
            scheduleRunFrequency: 'Weekly'
            scheduleRunTimes: [
              '2017-03-07T02:00:00Z'
            ]
            scheduleWeeklyFrequency: 0
          }
        }
        {
          policyType: 'Log'
          retentionPolicy: {
            retentionDuration: {
              count: 15
              durationType: 'Days'
            }
            retentionPolicyType: 'SimpleRetentionPolicy'
          }
          schedulePolicy: {
            scheduleFrequencyInMins: 120
            schedulePolicyType: 'LogSchedulePolicy'
          }
        }
      ]
      workLoadType: 'SQLDataBase'
    }
  }
  {
    name: 'filesharepolicy'
    properties: {
      backupManagementType: 'AzureStorage'
      protectedItemsCount: 0
      retentionPolicy: {
        dailySchedule: {
          retentionDuration: {
            count: 30
            durationType: 'Days'
          }
          retentionTimes: [
            '2019-11-07T04:30:00Z'
          ]
        }
        retentionPolicyType: 'LongTermRetentionPolicy'
      }
      schedulePolicy: {
        schedulePolicyType: 'SimpleSchedulePolicy'
        scheduleRunFrequency: 'Daily'
        scheduleRunTimes: [
          '2019-11-07T04:30:00Z'
        ]
        scheduleWeeklyFrequency: 0
      }
      timeZone: 'UTC'
      workloadType: 'AzureFileShare'
    }
  }
]
param customerManagedKey = {
  autoRotationEnabled: true
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
  userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
}
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param immutabilitySettingState = 'Unlocked'
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param monitoringSettings = {
  azureMonitorAlertSettings: {
    alertsForAllFailoverIssues: 'Enabled'
    alertsForAllJobFailures: 'Enabled'
    alertsForAllReplicationIssues: 'Enabled'
  }
  classicAlertSettings: {
    alertsForCriticalOperations: 'Enabled'
    emailNotificationsForSiteRecovery: 'Enabled'
  }
}
param privateEndpoints = [
  {
    ipConfigurations: [
      {
        name: 'myIpConfig-1'
        properties: {
          groupId: 'AzureSiteRecovery'
          memberName: 'SiteRecovery-tel1'
          privateIPAddress: '10.0.0.10'
        }
      }
      {
        name: 'myIPconfig-2'
        properties: {
          groupId: 'AzureSiteRecovery'
          memberName: 'SiteRecovery-prot2'
          privateIPAddress: '10.0.0.11'
        }
      }
      {
        name: 'myIPconfig-3'
        properties: {
          groupId: 'AzureSiteRecovery'
          memberName: 'SiteRecovery-srs1'
          privateIPAddress: '10.0.0.12'
        }
      }
      {
        name: 'myIPconfig-4'
        properties: {
          groupId: 'AzureSiteRecovery'
          memberName: 'SiteRecovery-rcm1'
          privateIPAddress: '10.0.0.13'
        }
      }
      {
        name: 'myIPconfig-5'
        properties: {
          groupId: 'AzureSiteRecovery'
          memberName: 'SiteRecovery-id1'
          privateIPAddress: '10.0.0.14'
        }
      }
    ]
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    subnetResourceId: '<subnetResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
]
param replicationAlertSettings = {
  customEmailAddresses: [
    'test.user@testcompany.com'
  ]
  locale: 'en-US'
  sendToOwners: 'Send'
}
param softDeleteSettings = {
  enhancedSecurityState: 'Enabled'
  softDeleteRetentionPeriodInDays: 14
  softDeleteState: 'Enabled'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Azure Recovery Service Vault. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupConfig`](#parameter-backupconfig) | object | The backup configuration. |
| [`backupPolicies`](#parameter-backuppolicies) | array | List of all backup policies. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`immutabilitySettingState`](#parameter-immutabilitysettingstate) | string | The immmutability setting state of the recovery services vault resource. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`monitoringSettings`](#parameter-monitoringsettings) | object | Monitoring Settings of the vault. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`protectedItems`](#parameter-protecteditems) | array | List of all protection containers. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. |
| [`redundancySettings`](#parameter-redundancysettings) | object | The redundancy settings of the vault. |
| [`replicationAlertSettings`](#parameter-replicationalertsettings) | object | Replication alert settings. |
| [`replicationFabrics`](#parameter-replicationfabrics) | array | List of all replication fabrics. |
| [`replicationPolicies`](#parameter-replicationpolicies) | array | List of all replication policies. |
| [`restoreSettings`](#parameter-restoresettings) | object | The restore settings of the vault. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`softDeleteSettings`](#parameter-softdeletesettings) | object | The soft delete related settings. |
| [`tags`](#parameter-tags) | object | Tags of the Recovery Service Vault resource. |

### Parameter: `name`

Name of the Azure Recovery Service Vault.

- Required: Yes
- Type: string

### Parameter: `backupConfig`

The backup configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enhancedSecurityState`](#parameter-backupconfigenhancedsecuritystate) | string | Enable this setting to protect hybrid backups against accidental deletes and add additional layer of authentication for critical operations. |
| [`isSoftDeleteFeatureStateEditable`](#parameter-backupconfigissoftdeletefeaturestateeditable) | bool | Is soft delete feature state editable. |
| [`name`](#parameter-backupconfigname) | string | Name of the Azure Recovery Service Vault Backup Policy. |
| [`resourceGuardOperationRequests`](#parameter-backupconfigresourceguardoperationrequests) | array | ResourceGuard Operation Requests. |
| [`softDeleteFeatureState`](#parameter-backupconfigsoftdeletefeaturestate) | string | Enable this setting to protect backup data for Azure VM, SQL Server in Azure VM and SAP HANA in Azure VM from accidental deletes. |
| [`storageModelType`](#parameter-backupconfigstoragemodeltype) | string | Storage type. |
| [`storageType`](#parameter-backupconfigstoragetype) | string | Storage type. |
| [`storageTypeState`](#parameter-backupconfigstoragetypestate) | string | Once a machine is registered against a resource, the storageTypeState is always Locked. |

### Parameter: `backupConfig.enhancedSecurityState`

Enable this setting to protect hybrid backups against accidental deletes and add additional layer of authentication for critical operations.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `backupConfig.isSoftDeleteFeatureStateEditable`

Is soft delete feature state editable.

- Required: No
- Type: bool

### Parameter: `backupConfig.name`

Name of the Azure Recovery Service Vault Backup Policy.

- Required: No
- Type: string

### Parameter: `backupConfig.resourceGuardOperationRequests`

ResourceGuard Operation Requests.

- Required: No
- Type: array

### Parameter: `backupConfig.softDeleteFeatureState`

Enable this setting to protect backup data for Azure VM, SQL Server in Azure VM and SAP HANA in Azure VM from accidental deletes.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `backupConfig.storageModelType`

Storage type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'GeoRedundant'
    'LocallyRedundant'
    'ReadAccessGeoZoneRedundant'
    'ZoneRedundant'
  ]
  ```

### Parameter: `backupConfig.storageType`

Storage type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'GeoRedundant'
    'LocallyRedundant'
    'ReadAccessGeoZoneRedundant'
    'ZoneRedundant'
  ]
  ```

### Parameter: `backupConfig.storageTypeState`

Once a machine is registered against a resource, the storageTypeState is always Locked.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Locked'
    'Unlocked'
  ]
  ```

### Parameter: `backupPolicies`

List of all backup policies.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-backuppoliciesname) | string | Name of the Azure Recovery Service Vault Backup Policy. |
| [`properties`](#parameter-backuppoliciesproperties) | object | Configuration of the Azure Recovery Service Vault Backup Policy. |

### Parameter: `backupPolicies.name`

Name of the Azure Recovery Service Vault Backup Policy.

- Required: Yes
- Type: string

### Parameter: `backupPolicies.properties`

Configuration of the Azure Recovery Service Vault Backup Policy.

- Required: Yes
- Type: object

### Parameter: `customerManagedKey`

The customer managed key definition.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyName`](#parameter-customermanagedkeykeyname) | string | The name of the customer managed key to use for encryption. |
| [`keyVaultResourceId`](#parameter-customermanagedkeykeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoRotationEnabled`](#parameter-customermanagedkeyautorotationenabled) | bool | Enable or disable auto-rotating to the latest key version. Default is `true`. If set to `false`, the latest key version at the time of the deployment is used. |
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, using version as per 'autoRotationEnabled' setting. |
| [`userAssignedIdentityResourceId`](#parameter-customermanagedkeyuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use. |

### Parameter: `customerManagedKey.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.autoRotationEnabled`

Enable or disable auto-rotating to the latest key version. Default is `true`. If set to `false`, the latest key version at the time of the deployment is used.

- Required: No
- Type: bool

### Parameter: `customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, using version as per 'autoRotationEnabled' setting.

- Required: No
- Type: string

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

- Required: No
- Type: string

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-diagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-diagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `immutabilitySettingState`

The immmutability setting state of the recovery services vault resource.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Locked'
    'Unlocked'
  ]
  ```

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |
| [`notes`](#parameter-locknotes) | string | Specify the notes of the lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `monitoringSettings`

Monitoring Settings of the vault.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureMonitorAlertSettings`](#parameter-monitoringsettingsazuremonitoralertsettings) | object | The alert settings. |
| [`classicAlertSettings`](#parameter-monitoringsettingsclassicalertsettings) | object | The classic alert settings. |

### Parameter: `monitoringSettings.azureMonitorAlertSettings`

The alert settings.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alertsForAllFailoverIssues`](#parameter-monitoringsettingsazuremonitoralertsettingsalertsforallfailoverissues) | string | Enable / disable alerts for all failover issues. |
| [`alertsForAllJobFailures`](#parameter-monitoringsettingsazuremonitoralertsettingsalertsforalljobfailures) | string | Enable / disable alerts for all job failures. |
| [`alertsForAllReplicationIssues`](#parameter-monitoringsettingsazuremonitoralertsettingsalertsforallreplicationissues) | string | Enable / disable alerts for all replication issues. |

### Parameter: `monitoringSettings.azureMonitorAlertSettings.alertsForAllFailoverIssues`

Enable / disable alerts for all failover issues.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `monitoringSettings.azureMonitorAlertSettings.alertsForAllJobFailures`

Enable / disable alerts for all job failures.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `monitoringSettings.azureMonitorAlertSettings.alertsForAllReplicationIssues`

Enable / disable alerts for all replication issues.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `monitoringSettings.classicAlertSettings`

The classic alert settings.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alertsForCriticalOperations`](#parameter-monitoringsettingsclassicalertsettingsalertsforcriticaloperations) | string | Enable / disable alerts for critical operations. |
| [`emailNotificationsForSiteRecovery`](#parameter-monitoringsettingsclassicalertsettingsemailnotificationsforsiterecovery) | string | Enable / disable email notifications for site recovery. |

### Parameter: `monitoringSettings.classicAlertSettings.alertsForCriticalOperations`

Enable / disable alerts for critical operations.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `monitoringSettings.classicAlertSettings.emailNotificationsForSiteRecovery`

Enable / disable email notifications for site recovery.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-privateendpointssubnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-privateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the Private Endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-privateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-privateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the Private Endpoint. |
| [`enableTelemetry`](#parameter-privateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-privateendpointsipconfigurations) | array | A list of IP configurations of the Private Endpoint. This will be used to map to the first-party Service endpoints. |
| [`isManualConnection`](#parameter-privateendpointsismanualconnection) | bool | If Manual Private Link Connection is required. |
| [`location`](#parameter-privateendpointslocation) | string | The location to deploy the Private Endpoint to. |
| [`lock`](#parameter-privateendpointslock) | object | Specify the type of lock. |
| [`manualConnectionRequestMessage`](#parameter-privateendpointsmanualconnectionrequestmessage) | string | A message passed to the owner of the remote resource with the manual connection request. |
| [`name`](#parameter-privateendpointsname) | string | The name of the Private Endpoint. |
| [`privateDnsZoneGroup`](#parameter-privateendpointsprivatednszonegroup) | object | The private DNS Zone Group to configure for the Private Endpoint. |
| [`privateLinkServiceConnectionName`](#parameter-privateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupResourceId`](#parameter-privateendpointsresourcegroupresourceid) | string | The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | array | Array of role assignments to create. |
| [`service`](#parameter-privateendpointsservice) | string | The subresource to deploy the Private Endpoint for. For example "vault" for a Key Vault Private Endpoint. |
| [`tags`](#parameter-privateendpointstags) | object | Tags to be applied on all resources/Resource Groups in this deployment. |

### Parameter: `privateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the Private Endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipAddresses`](#parameter-privateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-privateendpointscustomdnsconfigsfqdn) | string | FQDN that resolves to private endpoint IP address. |

### Parameter: `privateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs.fqdn`

FQDN that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `privateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the Private Endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.ipConfigurations`

A list of IP configurations of the Private Endpoint. This will be used to map to the first-party Service endpoints.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsipconfigurationsname) | string | The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-privateendpointsipconfigurationsproperties) | object | Properties of private endpoint IP configurations. |

### Parameter: `privateEndpoints.ipConfigurations.name`

The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties`

Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupId`](#parameter-privateendpointsipconfigurationspropertiesgroupid) | string | The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-privateendpointsipconfigurationspropertiesmembername) | string | The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-privateendpointsipconfigurationspropertiesprivateipaddress) | string | A private IP address obtained from the private endpoint's subnet. |

### Parameter: `privateEndpoints.ipConfigurations.properties.groupId`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.memberName`

The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.privateIPAddress`

A private IP address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.isManualConnection`

If Manual Private Link Connection is required.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.location`

The location to deploy the Private Endpoint to.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock`

Specify the type of lock.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-privateendpointslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-privateendpointslockname) | string | Specify the name of lock. |
| [`notes`](#parameter-privateendpointslocknotes) | string | Specify the notes of the lock. |

### Parameter: `privateEndpoints.lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `privateEndpoints.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `privateEndpoints.manualConnectionRequestMessage`

A message passed to the owner of the remote resource with the manual connection request.

- Required: No
- Type: string

### Parameter: `privateEndpoints.name`

The name of the Private Endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup`

The private DNS Zone Group to configure for the Private Endpoint.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneGroupConfigs`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigs) | array | The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupname) | string | The name of the Private DNS Zone Group. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs`

The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneResourceId`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsprivatednszoneresourceid) | string | The resource id of the private DNS zone. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsname) | string | The name of the private DNS Zone Group config. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.privateDnsZoneResourceId`

The resource id of the private DNS zone.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.name`

The name of the private DNS Zone Group config.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup.name`

The name of the Private DNS Zone Group.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateLinkServiceConnectionName`

The name of the private link connection to create.

- Required: No
- Type: string

### Parameter: `privateEndpoints.resourceGroupResourceId`

The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'DNS Resolver Contributor'`
  - `'DNS Zone Contributor'`
  - `'Domain Services Contributor'`
  - `'Domain Services Reader'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Private DNS Zone Contributor'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-privateendpointsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-privateendpointsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-privateendpointsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-privateendpointsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-privateendpointsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-privateendpointsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-privateendpointsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-privateendpointsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `privateEndpoints.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `privateEndpoints.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `privateEndpoints.service`

The subresource to deploy the Private Endpoint for. For example "vault" for a Key Vault Private Endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.tags`

Tags to be applied on all resources/Resource Groups in this deployment.

- Required: No
- Type: object

### Parameter: `protectedItems`

List of all protection containers.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-protecteditemsname) | string | Name of the resource. |
| [`policyName`](#parameter-protecteditemspolicyname) | string | The backup policy with which this item is backed up. |
| [`protectedItemType`](#parameter-protecteditemsprotecteditemtype) | string | The backup item type. |
| [`protectionContainerName`](#parameter-protecteditemsprotectioncontainername) | string | Name of the Azure Recovery Service Vault Protection Container. |
| [`sourceResourceId`](#parameter-protecteditemssourceresourceid) | string | Resource ID of the resource to back up. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-protecteditemslocation) | string | Location for all resources. |

### Parameter: `protectedItems.name`

Name of the resource.

- Required: Yes
- Type: string

### Parameter: `protectedItems.policyName`

The backup policy with which this item is backed up.

- Required: Yes
- Type: string

### Parameter: `protectedItems.protectedItemType`

The backup item type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureFileShareProtectedItem'
    'AzureVmWorkloadSAPAseDatabase'
    'AzureVmWorkloadSAPHanaDatabase'
    'AzureVmWorkloadSQLDatabase'
    'DPMProtectedItem'
    'GenericProtectedItem'
    'MabFileFolderProtectedItem'
    'Microsoft.ClassicCompute/virtualMachines'
    'Microsoft.Compute/virtualMachines'
    'Microsoft.Sql/servers/databases'
  ]
  ```

### Parameter: `protectedItems.protectionContainerName`

Name of the Azure Recovery Service Vault Protection Container.

- Required: Yes
- Type: string

### Parameter: `protectedItems.sourceResourceId`

Resource ID of the resource to back up.

- Required: Yes
- Type: string

### Parameter: `protectedItems.location`

Location for all resources.

- Required: No
- Type: string

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `redundancySettings`

The redundancy settings of the vault.

- Required: No
- Type: object
- Discriminator: `standardTierStorageRedundancy`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`GeoRedundant`](#variant-redundancysettingsstandardtierstorageredundancy-georedundant) |  |
| [`LocallyRedundant`](#variant-redundancysettingsstandardtierstorageredundancy-locallyredundant) |  |
| [`ZoneRedundant`](#variant-redundancysettingsstandardtierstorageredundancy-zoneredundant) |  |

### Variant: `redundancySettings.standardTierStorageRedundancy-GeoRedundant`


To use this variant, set the property `standardTierStorageRedundancy` to `GeoRedundant`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`standardTierStorageRedundancy`](#parameter-redundancysettingsstandardtierstorageredundancy-georedundantstandardtierstorageredundancy) | string | The storage redundancy setting of a vault. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`crossRegionRestore`](#parameter-redundancysettingsstandardtierstorageredundancy-georedundantcrossregionrestore) | string | Flag to show if Cross Region Restore is enabled on the Vault or not. |

### Parameter: `redundancySettings.standardTierStorageRedundancy-GeoRedundant.standardTierStorageRedundancy`

The storage redundancy setting of a vault.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'GeoRedundant'
  ]
  ```

### Parameter: `redundancySettings.standardTierStorageRedundancy-GeoRedundant.crossRegionRestore`

Flag to show if Cross Region Restore is enabled on the Vault or not.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Variant: `redundancySettings.standardTierStorageRedundancy-LocallyRedundant`


To use this variant, set the property `standardTierStorageRedundancy` to `LocallyRedundant`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`standardTierStorageRedundancy`](#parameter-redundancysettingsstandardtierstorageredundancy-locallyredundantstandardtierstorageredundancy) | string | The storage redundancy setting of a vault. |

### Parameter: `redundancySettings.standardTierStorageRedundancy-LocallyRedundant.standardTierStorageRedundancy`

The storage redundancy setting of a vault.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'LocallyRedundant'
  ]
  ```

### Variant: `redundancySettings.standardTierStorageRedundancy-ZoneRedundant`


To use this variant, set the property `standardTierStorageRedundancy` to `ZoneRedundant`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`standardTierStorageRedundancy`](#parameter-redundancysettingsstandardtierstorageredundancy-zoneredundantstandardtierstorageredundancy) | string | The storage redundancy setting of a vault. |

### Parameter: `redundancySettings.standardTierStorageRedundancy-ZoneRedundant.standardTierStorageRedundancy`

The storage redundancy setting of a vault.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ZoneRedundant'
  ]
  ```

### Parameter: `replicationAlertSettings`

Replication alert settings.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customEmailAddresses`](#parameter-replicationalertsettingscustomemailaddresses) | array | The custom email address for sending emails. |
| [`locale`](#parameter-replicationalertsettingslocale) | string | The locale for the email notification. |
| [`name`](#parameter-replicationalertsettingsname) | string | The name of the replication Alert Setting. |
| [`sendToOwners`](#parameter-replicationalertsettingssendtoowners) | string | The value indicating whether to send email to subscription administrator. |

### Parameter: `replicationAlertSettings.customEmailAddresses`

The custom email address for sending emails.

- Required: No
- Type: array

### Parameter: `replicationAlertSettings.locale`

The locale for the email notification.

- Required: No
- Type: string

### Parameter: `replicationAlertSettings.name`

The name of the replication Alert Setting.

- Required: No
- Type: string

### Parameter: `replicationAlertSettings.sendToOwners`

The value indicating whether to send email to subscription administrator.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'DoNotSend'
    'Send'
  ]
  ```

### Parameter: `replicationFabrics`

List of all replication fabrics.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-replicationfabricslocation) | string | The recovery location the fabric represents. |
| [`name`](#parameter-replicationfabricsname) | string | The name of the fabric. |
| [`replicationContainers`](#parameter-replicationfabricsreplicationcontainers) | array | Replication containers to create. |

### Parameter: `replicationFabrics.location`

The recovery location the fabric represents.

- Required: No
- Type: string

### Parameter: `replicationFabrics.name`

The name of the fabric.

- Required: No
- Type: string

### Parameter: `replicationFabrics.replicationContainers`

Replication containers to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-replicationfabricsreplicationcontainersname) | string | The name of the replication container. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`mappings`](#parameter-replicationfabricsreplicationcontainersmappings) | array | Replication containers mappings to create. |

### Parameter: `replicationFabrics.replicationContainers.name`

The name of the replication container.

- Required: Yes
- Type: string

### Parameter: `replicationFabrics.replicationContainers.mappings`

Replication containers mappings to create.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-replicationfabricsreplicationcontainersmappingsname) | string | The name of the replication container mapping. If not provided, it will be automatically generated as `<source_container_name>-<target_container_name>`. |
| [`policyName`](#parameter-replicationfabricsreplicationcontainersmappingspolicyname) | string | Name of the replication policy. Will be ignored if policyResourceId is also specified. |
| [`policyResourceId`](#parameter-replicationfabricsreplicationcontainersmappingspolicyresourceid) | string | Resource ID of the replication policy. If defined, policyName will be ignored. |
| [`targetContainerFabricName`](#parameter-replicationfabricsreplicationcontainersmappingstargetcontainerfabricname) | string | Name of the fabric containing the target container. If targetProtectionContainerResourceId is specified, this parameter will be ignored. |
| [`targetContainerName`](#parameter-replicationfabricsreplicationcontainersmappingstargetcontainername) | string | Name of the target container. Must be specified if targetProtectionContainerResourceId is not. If targetProtectionContainerResourceId is specified, this parameter will be ignored. |
| [`targetProtectionContainerResourceId`](#parameter-replicationfabricsreplicationcontainersmappingstargetprotectioncontainerresourceid) | string | Resource ID of the target Replication container. Must be specified if targetContainerName is not. If specified, targetContainerFabricName and targetContainerName will be ignored. |

### Parameter: `replicationFabrics.replicationContainers.mappings.name`

The name of the replication container mapping. If not provided, it will be automatically generated as `<source_container_name>-<target_container_name>`.

- Required: No
- Type: string

### Parameter: `replicationFabrics.replicationContainers.mappings.policyName`

Name of the replication policy. Will be ignored if policyResourceId is also specified.

- Required: No
- Type: string

### Parameter: `replicationFabrics.replicationContainers.mappings.policyResourceId`

Resource ID of the replication policy. If defined, policyName will be ignored.

- Required: No
- Type: string

### Parameter: `replicationFabrics.replicationContainers.mappings.targetContainerFabricName`

Name of the fabric containing the target container. If targetProtectionContainerResourceId is specified, this parameter will be ignored.

- Required: No
- Type: string

### Parameter: `replicationFabrics.replicationContainers.mappings.targetContainerName`

Name of the target container. Must be specified if targetProtectionContainerResourceId is not. If targetProtectionContainerResourceId is specified, this parameter will be ignored.

- Required: No
- Type: string

### Parameter: `replicationFabrics.replicationContainers.mappings.targetProtectionContainerResourceId`

Resource ID of the target Replication container. Must be specified if targetContainerName is not. If specified, targetContainerFabricName and targetContainerName will be ignored.

- Required: No
- Type: string

### Parameter: `replicationPolicies`

List of all replication policies.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-replicationpoliciesname) | string | The name of the replication policy. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appConsistentFrequencyInMinutes`](#parameter-replicationpoliciesappconsistentfrequencyinminutes) | int | The app consistent snapshot frequency (in minutes). |
| [`crashConsistentFrequencyInMinutes`](#parameter-replicationpoliciescrashconsistentfrequencyinminutes) | int | The crash consistent snapshot frequency (in minutes). |
| [`multiVmSyncStatus`](#parameter-replicationpoliciesmultivmsyncstatus) | string | A value indicating whether multi-VM sync has to be enabled. |
| [`recoveryPointHistory`](#parameter-replicationpoliciesrecoverypointhistory) | int | The duration in minutes until which the recovery points need to be stored. |

### Parameter: `replicationPolicies.name`

The name of the replication policy.

- Required: Yes
- Type: string

### Parameter: `replicationPolicies.appConsistentFrequencyInMinutes`

The app consistent snapshot frequency (in minutes).

- Required: No
- Type: int

### Parameter: `replicationPolicies.crashConsistentFrequencyInMinutes`

The crash consistent snapshot frequency (in minutes).

- Required: No
- Type: int

### Parameter: `replicationPolicies.multiVmSyncStatus`

A value indicating whether multi-VM sync has to be enabled.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disable'
    'Enable'
  ]
  ```

### Parameter: `replicationPolicies.recoveryPointHistory`

The duration in minutes until which the recovery points need to be stored.

- Required: No
- Type: int

### Parameter: `restoreSettings`

The restore settings of the vault.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`crossSubscriptionRestoreSettings`](#parameter-restoresettingscrosssubscriptionrestoresettings) | object | The restore settings of the vault. |

### Parameter: `restoreSettings.crossSubscriptionRestoreSettings`

The restore settings of the vault.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`crossSubscriptionRestoreState`](#parameter-restoresettingscrosssubscriptionrestoresettingscrosssubscriptionrestorestate) | string | The restore settings of the vault. |

### Parameter: `restoreSettings.crossSubscriptionRestoreSettings.crossSubscriptionRestoreState`

The restore settings of the vault.

- Required: Yes
- Type: string

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Backup Contributor'`
  - `'Backup Operator'`
  - `'Backup Reader'`
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'Site Recovery Contributor'`
  - `'Site Recovery Operator'`
  - `'Site Recovery Reader'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `softDeleteSettings`

The soft delete related settings.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enhancedSecurityState`](#parameter-softdeletesettingsenhancedsecuritystate) | string | The enhanced security state. |
| [`softDeleteRetentionPeriodInDays`](#parameter-softdeletesettingssoftdeleteretentionperiodindays) | int | The soft delete retention period in days. |
| [`softDeleteState`](#parameter-softdeletesettingssoftdeletestate) | string | The soft delete state. |

### Parameter: `softDeleteSettings.enhancedSecurityState`

The enhanced security state.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AlwaysON'
    'Disabled'
    'Enabled'
    'Invalid'
  ]
  ```

### Parameter: `softDeleteSettings.softDeleteRetentionPeriodInDays`

The soft delete retention period in days.

- Required: Yes
- Type: int

### Parameter: `softDeleteSettings.softDeleteState`

The soft delete state.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AlwaysON'
    'Disabled'
    'Enabled'
    'Invalid'
  ]
  ```

### Parameter: `tags`

Tags of the Recovery Service Vault resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The Name of the recovery services vault. |
| `privateEndpoints` | array | The private endpoints of the recovery services vault. |
| `resourceGroupName` | string | The name of the resource group the recovery services vault was created in. |
| `resourceId` | string | The resource ID of the recovery services vault. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.11.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
