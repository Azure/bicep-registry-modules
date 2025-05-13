# Data Protection Backup Vaults `[Microsoft.DataProtection/backupVaults]`

This module deploys a Data Protection Backup Vault.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.DataProtection/backupVaults` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataProtection/2024-04-01/backupVaults) |
| `Microsoft.DataProtection/backupVaults/backupInstances` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataProtection/2024-04-01/backupVaults/backupInstances) |
| `Microsoft.DataProtection/backupVaults/backupPolicies` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataProtection/2024-04-01/backupVaults/backupPolicies) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/data-protection/backup-vault:<version>`.

- [Using Customer-Managed-Keys with User-Assigned identity](#example-1-using-customer-managed-keys-with-user-assigned-identity)
- [Using only defaults](#example-2-using-only-defaults)
- [Using large parameter set](#example-3-using-large-parameter-set)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Using Customer-Managed-Keys with User-Assigned identity_

This instance deploys the module using Customer-Managed-Keys using a User-Assigned Identity to access the Customer-Managed-Key secret. Please note that enabling CMK with User-Assigned Managed Identity in currently in preview.


<details>

<summary>via Bicep module</summary>

```bicep
module backupVault 'br/public:avm/res/data-protection/backup-vault:<version>' = {
  name: 'backupVaultDeployment'
  params: {
    // Required parameters
    name: 'dpbvcmk001'
    // Non-required parameters
    azureMonitorAlertSettingsAlertsForAllJobFailures: 'Disabled'
    backupPolicies: [
      {
        name: 'DefaultPolicy'
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
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    immutabilitySettingState: 'Locked'
    infrastructureEncryption: 'Enabled'
    location: '<location>'
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    softDeleteSettings: {
      retentionDurationInDays: 14
      state: 'On'
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
      "value": "dpbvcmk001"
    },
    // Non-required parameters
    "azureMonitorAlertSettingsAlertsForAllJobFailures": {
      "value": "Disabled"
    },
    "backupPolicies": {
      "value": [
        {
          "name": "DefaultPolicy",
          "properties": {
            "datasourceTypes": [
              "Microsoft.Compute/disks"
            ],
            "objectType": "BackupPolicy",
            "policyRules": [
              {
                "backupParameters": {
                  "backupType": "Incremental",
                  "objectType": "AzureBackupParams"
                },
                "dataStore": {
                  "dataStoreType": "OperationalStore",
                  "objectType": "DataStoreInfoBase"
                },
                "name": "BackupDaily",
                "objectType": "AzureBackupRule",
                "trigger": {
                  "objectType": "ScheduleBasedTriggerContext",
                  "schedule": {
                    "repeatingTimeIntervals": [
                      "R/2022-05-31T23:30:00+01:00/P1D"
                    ],
                    "timeZone": "W. Europe Standard Time"
                  },
                  "taggingCriteria": [
                    {
                      "isDefault": true,
                      "taggingPriority": 99,
                      "tagInfo": {
                        "id": "Default_",
                        "tagName": "Default"
                      }
                    }
                  ]
                }
              },
              {
                "isDefault": true,
                "lifecycles": [
                  {
                    "deleteAfter": {
                      "duration": "P7D",
                      "objectType": "AbsoluteDeleteOption"
                    },
                    "sourceDataStore": {
                      "dataStoreType": "OperationalStore",
                      "objectType": "DataStoreInfoBase"
                    },
                    "targetDataStoreCopySettings": []
                  }
                ],
                "name": "Default",
                "objectType": "AzureRetentionRule"
              }
            ]
          }
        }
      ]
    },
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
      }
    },
    "immutabilitySettingState": {
      "value": "Locked"
    },
    "infrastructureEncryption": {
      "value": "Enabled"
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "softDeleteSettings": {
      "value": {
        "retentionDurationInDays": 14,
        "state": "On"
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
using 'br/public:avm/res/data-protection/backup-vault:<version>'

// Required parameters
param name = 'dpbvcmk001'
// Non-required parameters
param azureMonitorAlertSettingsAlertsForAllJobFailures = 'Disabled'
param backupPolicies = [
  {
    name: 'DefaultPolicy'
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
param customerManagedKey = {
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
  userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
}
param immutabilitySettingState = 'Locked'
param infrastructureEncryption = 'Enabled'
param location = '<location>'
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param softDeleteSettings = {
  retentionDurationInDays: 14
  state: 'On'
}
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module backupVault 'br/public:avm/res/data-protection/backup-vault:<version>' = {
  name: 'backupVaultDeployment'
  params: {
    // Required parameters
    name: 'dpbvmin001'
    // Non-required parameters
    location: '<location>'
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
      "value": "dpbvmin001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/data-protection/backup-vault:<version>'

// Required parameters
param name = 'dpbvmin001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 3: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module backupVault 'br/public:avm/res/data-protection/backup-vault:<version>' = {
  name: 'backupVaultDeployment'
  params: {
    // Required parameters
    name: 'dpbvmax001'
    // Non-required parameters
    azureMonitorAlertSettingsAlertsForAllJobFailures: 'Disabled'
    backupInstances: [
      {
        dataSourceInfo: {
          datasourceType: 'Microsoft.Storage/storageAccounts/blobServices'
          resourceID: '<resourceID>'
          resourceLocation: '<resourceLocation>'
          resourceName: '<resourceName>'
          resourceType: 'Microsoft.Storage/storageAccounts'
          resourceUri: '<resourceUri>'
        }
        name: '<name>'
        policyInfo: {
          policyName: '<policyName>'
          policyParameters: {
            backupDatasourceParametersList: [
              {
                containersList: '<containersList>'
                objectType: 'BlobBackupDatasourceParameters'
              }
            ]
          }
        }
      }
      {
        dataSourceInfo: {
          datasourceType: 'Microsoft.Compute/disks'
          resourceID: '<resourceID>'
          resourceLocation: '<resourceLocation>'
          resourceName: '<resourceName>'
          resourceType: 'Microsoft.Compute/disks'
          resourceUri: '<resourceUri>'
        }
        name: '<name>'
        policyInfo: {
          policyName: '<policyName>'
          policyParameters: {
            dataStoreParametersList: [
              {
                dataStoreType: 'OperationalStore'
                objectType: 'AzureOperationalStoreParameters'
                resourceGroupId: '<resourceGroupId>'
              }
            ]
          }
        }
      }
      {
        dataSourceInfo: {
          datasourceType: 'Microsoft.Compute/disks'
          resourceID: '<resourceID>'
          resourceLocation: '<resourceLocation>'
          resourceName: '<resourceName>'
          resourceType: 'Microsoft.Compute/disks'
          resourceUri: '<resourceUri>'
        }
        name: '<name>'
        policyInfo: {
          policyName: '<policyName>'
          policyParameters: {
            dataStoreParametersList: [
              {
                dataStoreType: 'OperationalStore'
                objectType: 'AzureOperationalStoreParameters'
                resourceGroupId: '<resourceGroupId>'
              }
            ]
          }
        }
      }
    ]
    backupPolicies: [
      {
        name: '<name>'
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
                    'R/2025-03-31T00:00:00+04:00/P1D'
                  ]
                  timeZone: 'Arabian Standard Time'
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
      {
        name: '<name>'
        properties: {
          datasourceTypes: [
            'Microsoft.Storage/storageAccounts/blobServices'
          ]
          objectType: 'BackupPolicy'
          policyRules: [
            {
              isDefault: true
              lifecycles: [
                {
                  deleteAfter: {
                    duration: 'P30D'
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
            {
              isDefault: true
              lifecycles: [
                {
                  deleteAfter: {
                    duration: 'P90D'
                    objectType: 'AbsoluteDeleteOption'
                  }
                  sourceDataStore: {
                    dataStoreType: 'VaultStore'
                    objectType: 'DataStoreInfoBase'
                  }
                  targetDataStoreCopySettings: []
                }
              ]
              name: 'Default'
              objectType: 'AzureRetentionRule'
            }
            {
              backupParameters: {
                backupType: 'Discrete'
                objectType: 'AzureBackupParams'
              }
              dataStore: {
                dataStoreType: 'VaultStore'
                objectType: 'DataStoreInfoBase'
              }
              name: 'BackupDaily'
              objectType: 'AzureBackupRule'
              trigger: {
                objectType: 'ScheduleBasedTriggerContext'
                schedule: {
                  repeatingTimeIntervals: [
                    'R/2025-03-31T00:00:00+04:00/P1D'
                  ]
                  timeZone: 'Arabian Standard Time'
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
          ]
        }
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
    }
    roleAssignments: [
      {
        name: 'cbc3932a-1bee-4318-ae76-d70e1ba399c8'
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
      "value": "dpbvmax001"
    },
    // Non-required parameters
    "azureMonitorAlertSettingsAlertsForAllJobFailures": {
      "value": "Disabled"
    },
    "backupInstances": {
      "value": [
        {
          "dataSourceInfo": {
            "datasourceType": "Microsoft.Storage/storageAccounts/blobServices",
            "resourceID": "<resourceID>",
            "resourceLocation": "<resourceLocation>",
            "resourceName": "<resourceName>",
            "resourceType": "Microsoft.Storage/storageAccounts",
            "resourceUri": "<resourceUri>"
          },
          "name": "<name>",
          "policyInfo": {
            "policyName": "<policyName>",
            "policyParameters": {
              "backupDatasourceParametersList": [
                {
                  "containersList": "<containersList>",
                  "objectType": "BlobBackupDatasourceParameters"
                }
              ]
            }
          }
        },
        {
          "dataSourceInfo": {
            "datasourceType": "Microsoft.Compute/disks",
            "resourceID": "<resourceID>",
            "resourceLocation": "<resourceLocation>",
            "resourceName": "<resourceName>",
            "resourceType": "Microsoft.Compute/disks",
            "resourceUri": "<resourceUri>"
          },
          "name": "<name>",
          "policyInfo": {
            "policyName": "<policyName>",
            "policyParameters": {
              "dataStoreParametersList": [
                {
                  "dataStoreType": "OperationalStore",
                  "objectType": "AzureOperationalStoreParameters",
                  "resourceGroupId": "<resourceGroupId>"
                }
              ]
            }
          }
        },
        {
          "dataSourceInfo": {
            "datasourceType": "Microsoft.Compute/disks",
            "resourceID": "<resourceID>",
            "resourceLocation": "<resourceLocation>",
            "resourceName": "<resourceName>",
            "resourceType": "Microsoft.Compute/disks",
            "resourceUri": "<resourceUri>"
          },
          "name": "<name>",
          "policyInfo": {
            "policyName": "<policyName>",
            "policyParameters": {
              "dataStoreParametersList": [
                {
                  "dataStoreType": "OperationalStore",
                  "objectType": "AzureOperationalStoreParameters",
                  "resourceGroupId": "<resourceGroupId>"
                }
              ]
            }
          }
        }
      ]
    },
    "backupPolicies": {
      "value": [
        {
          "name": "<name>",
          "properties": {
            "datasourceTypes": [
              "Microsoft.Compute/disks"
            ],
            "objectType": "BackupPolicy",
            "policyRules": [
              {
                "backupParameters": {
                  "backupType": "Incremental",
                  "objectType": "AzureBackupParams"
                },
                "dataStore": {
                  "dataStoreType": "OperationalStore",
                  "objectType": "DataStoreInfoBase"
                },
                "name": "BackupDaily",
                "objectType": "AzureBackupRule",
                "trigger": {
                  "objectType": "ScheduleBasedTriggerContext",
                  "schedule": {
                    "repeatingTimeIntervals": [
                      "R/2025-03-31T00:00:00+04:00/P1D"
                    ],
                    "timeZone": "Arabian Standard Time"
                  },
                  "taggingCriteria": [
                    {
                      "isDefault": true,
                      "taggingPriority": 99,
                      "tagInfo": {
                        "id": "Default_",
                        "tagName": "Default"
                      }
                    }
                  ]
                }
              },
              {
                "isDefault": true,
                "lifecycles": [
                  {
                    "deleteAfter": {
                      "duration": "P7D",
                      "objectType": "AbsoluteDeleteOption"
                    },
                    "sourceDataStore": {
                      "dataStoreType": "OperationalStore",
                      "objectType": "DataStoreInfoBase"
                    },
                    "targetDataStoreCopySettings": []
                  }
                ],
                "name": "Default",
                "objectType": "AzureRetentionRule"
              }
            ]
          }
        },
        {
          "name": "<name>",
          "properties": {
            "datasourceTypes": [
              "Microsoft.Storage/storageAccounts/blobServices"
            ],
            "objectType": "BackupPolicy",
            "policyRules": [
              {
                "isDefault": true,
                "lifecycles": [
                  {
                    "deleteAfter": {
                      "duration": "P30D",
                      "objectType": "AbsoluteDeleteOption"
                    },
                    "sourceDataStore": {
                      "dataStoreType": "OperationalStore",
                      "objectType": "DataStoreInfoBase"
                    },
                    "targetDataStoreCopySettings": []
                  }
                ],
                "name": "Default",
                "objectType": "AzureRetentionRule"
              },
              {
                "isDefault": true,
                "lifecycles": [
                  {
                    "deleteAfter": {
                      "duration": "P90D",
                      "objectType": "AbsoluteDeleteOption"
                    },
                    "sourceDataStore": {
                      "dataStoreType": "VaultStore",
                      "objectType": "DataStoreInfoBase"
                    },
                    "targetDataStoreCopySettings": []
                  }
                ],
                "name": "Default",
                "objectType": "AzureRetentionRule"
              },
              {
                "backupParameters": {
                  "backupType": "Discrete",
                  "objectType": "AzureBackupParams"
                },
                "dataStore": {
                  "dataStoreType": "VaultStore",
                  "objectType": "DataStoreInfoBase"
                },
                "name": "BackupDaily",
                "objectType": "AzureBackupRule",
                "trigger": {
                  "objectType": "ScheduleBasedTriggerContext",
                  "schedule": {
                    "repeatingTimeIntervals": [
                      "R/2025-03-31T00:00:00+04:00/P1D"
                    ],
                    "timeZone": "Arabian Standard Time"
                  },
                  "taggingCriteria": [
                    {
                      "isDefault": true,
                      "taggingPriority": 99,
                      "tagInfo": {
                        "id": "Default_",
                        "tagName": "Default"
                      }
                    }
                  ]
                }
              }
            ]
          }
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
        "systemAssigned": true
      }
    },
    "roleAssignments": {
      "value": [
        {
          "name": "cbc3932a-1bee-4318-ae76-d70e1ba399c8",
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
using 'br/public:avm/res/data-protection/backup-vault:<version>'

// Required parameters
param name = 'dpbvmax001'
// Non-required parameters
param azureMonitorAlertSettingsAlertsForAllJobFailures = 'Disabled'
param backupInstances = [
  {
    dataSourceInfo: {
      datasourceType: 'Microsoft.Storage/storageAccounts/blobServices'
      resourceID: '<resourceID>'
      resourceLocation: '<resourceLocation>'
      resourceName: '<resourceName>'
      resourceType: 'Microsoft.Storage/storageAccounts'
      resourceUri: '<resourceUri>'
    }
    name: '<name>'
    policyInfo: {
      policyName: '<policyName>'
      policyParameters: {
        backupDatasourceParametersList: [
          {
            containersList: '<containersList>'
            objectType: 'BlobBackupDatasourceParameters'
          }
        ]
      }
    }
  }
  {
    dataSourceInfo: {
      datasourceType: 'Microsoft.Compute/disks'
      resourceID: '<resourceID>'
      resourceLocation: '<resourceLocation>'
      resourceName: '<resourceName>'
      resourceType: 'Microsoft.Compute/disks'
      resourceUri: '<resourceUri>'
    }
    name: '<name>'
    policyInfo: {
      policyName: '<policyName>'
      policyParameters: {
        dataStoreParametersList: [
          {
            dataStoreType: 'OperationalStore'
            objectType: 'AzureOperationalStoreParameters'
            resourceGroupId: '<resourceGroupId>'
          }
        ]
      }
    }
  }
  {
    dataSourceInfo: {
      datasourceType: 'Microsoft.Compute/disks'
      resourceID: '<resourceID>'
      resourceLocation: '<resourceLocation>'
      resourceName: '<resourceName>'
      resourceType: 'Microsoft.Compute/disks'
      resourceUri: '<resourceUri>'
    }
    name: '<name>'
    policyInfo: {
      policyName: '<policyName>'
      policyParameters: {
        dataStoreParametersList: [
          {
            dataStoreType: 'OperationalStore'
            objectType: 'AzureOperationalStoreParameters'
            resourceGroupId: '<resourceGroupId>'
          }
        ]
      }
    }
  }
]
param backupPolicies = [
  {
    name: '<name>'
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
                'R/2025-03-31T00:00:00+04:00/P1D'
              ]
              timeZone: 'Arabian Standard Time'
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
  {
    name: '<name>'
    properties: {
      datasourceTypes: [
        'Microsoft.Storage/storageAccounts/blobServices'
      ]
      objectType: 'BackupPolicy'
      policyRules: [
        {
          isDefault: true
          lifecycles: [
            {
              deleteAfter: {
                duration: 'P30D'
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
        {
          isDefault: true
          lifecycles: [
            {
              deleteAfter: {
                duration: 'P90D'
                objectType: 'AbsoluteDeleteOption'
              }
              sourceDataStore: {
                dataStoreType: 'VaultStore'
                objectType: 'DataStoreInfoBase'
              }
              targetDataStoreCopySettings: []
            }
          ]
          name: 'Default'
          objectType: 'AzureRetentionRule'
        }
        {
          backupParameters: {
            backupType: 'Discrete'
            objectType: 'AzureBackupParams'
          }
          dataStore: {
            dataStoreType: 'VaultStore'
            objectType: 'DataStoreInfoBase'
          }
          name: 'BackupDaily'
          objectType: 'AzureBackupRule'
          trigger: {
            objectType: 'ScheduleBasedTriggerContext'
            schedule: {
              repeatingTimeIntervals: [
                'R/2025-03-31T00:00:00+04:00/P1D'
              ]
              timeZone: 'Arabian Standard Time'
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
      ]
    }
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
}
param roleAssignments = [
  {
    name: 'cbc3932a-1bee-4318-ae76-d70e1ba399c8'
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
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module backupVault 'br/public:avm/res/data-protection/backup-vault:<version>' = {
  name: 'backupVaultDeployment'
  params: {
    // Required parameters
    name: 'dpbvwaf001'
    // Non-required parameters
    azureMonitorAlertSettingsAlertsForAllJobFailures: 'Disabled'
    backupPolicies: [
      {
        name: 'DefaultPolicy'
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
    immutabilitySettingState: 'Locked'
    location: '<location>'
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    softDeleteSettings: {
      retentionDurationInDays: 14
      state: 'On'
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
      "value": "dpbvwaf001"
    },
    // Non-required parameters
    "azureMonitorAlertSettingsAlertsForAllJobFailures": {
      "value": "Disabled"
    },
    "backupPolicies": {
      "value": [
        {
          "name": "DefaultPolicy",
          "properties": {
            "datasourceTypes": [
              "Microsoft.Compute/disks"
            ],
            "objectType": "BackupPolicy",
            "policyRules": [
              {
                "backupParameters": {
                  "backupType": "Incremental",
                  "objectType": "AzureBackupParams"
                },
                "dataStore": {
                  "dataStoreType": "OperationalStore",
                  "objectType": "DataStoreInfoBase"
                },
                "name": "BackupDaily",
                "objectType": "AzureBackupRule",
                "trigger": {
                  "objectType": "ScheduleBasedTriggerContext",
                  "schedule": {
                    "repeatingTimeIntervals": [
                      "R/2022-05-31T23:30:00+01:00/P1D"
                    ],
                    "timeZone": "W. Europe Standard Time"
                  },
                  "taggingCriteria": [
                    {
                      "isDefault": true,
                      "taggingPriority": 99,
                      "tagInfo": {
                        "id": "Default_",
                        "tagName": "Default"
                      }
                    }
                  ]
                }
              },
              {
                "isDefault": true,
                "lifecycles": [
                  {
                    "deleteAfter": {
                      "duration": "P7D",
                      "objectType": "AbsoluteDeleteOption"
                    },
                    "sourceDataStore": {
                      "dataStoreType": "OperationalStore",
                      "objectType": "DataStoreInfoBase"
                    },
                    "targetDataStoreCopySettings": []
                  }
                ],
                "name": "Default",
                "objectType": "AzureRetentionRule"
              }
            ]
          }
        }
      ]
    },
    "immutabilitySettingState": {
      "value": "Locked"
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "softDeleteSettings": {
      "value": {
        "retentionDurationInDays": 14,
        "state": "On"
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
using 'br/public:avm/res/data-protection/backup-vault:<version>'

// Required parameters
param name = 'dpbvwaf001'
// Non-required parameters
param azureMonitorAlertSettingsAlertsForAllJobFailures = 'Disabled'
param backupPolicies = [
  {
    name: 'DefaultPolicy'
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
param immutabilitySettingState = 'Locked'
param location = '<location>'
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param softDeleteSettings = {
  retentionDurationInDays: 14
  state: 'On'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Backup Vault. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureMonitorAlertSettingsAlertsForAllJobFailures`](#parameter-azuremonitoralertsettingsalertsforalljobfailures) | string | Settings for Azure Monitor based alerts for job failures. |
| [`backupInstances`](#parameter-backupinstances) | array | List of all backup instances. |
| [`backupPolicies`](#parameter-backuppolicies) | array | List of all backup policies. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key (CMK) definition. ENABLING CMK WITH USER ASSIGNED MANAGED IDENTITY IS A PREVIEW SERVICE/FEATURE, MICROSOFT MAY NOT PROVIDE SUPPORT FOR THIS, PLEASE CHECK THE [PRODUCT DOCS](https://learn.microsoft.com/en-us/azure/backup/encryption-at-rest-with-cmk-for-backup-vault) FOR CLARIFICATION. |
| [`dataStoreType`](#parameter-datastoretype) | string | The datastore type to use. ArchiveStore does not support ZoneRedundancy. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`featureSettings`](#parameter-featuresettings) | object | Feature settings for the backup vault. |
| [`immutabilitySettingState`](#parameter-immutabilitysettingstate) | string | The immmutability setting state of the backup vault resource. |
| [`infrastructureEncryption`](#parameter-infrastructureencryption) | string | Whether or not the service applies a secondary layer of encryption. For security reasons, it is recommended to set it to Enabled. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`softDeleteSettings`](#parameter-softdeletesettings) | object | The soft delete related settings. |
| [`tags`](#parameter-tags) | object | Tags of the backup vault resource. |
| [`type`](#parameter-type) | string | The vault redundancy level to use. |

### Parameter: `name`

Name of the Backup Vault.

- Required: Yes
- Type: string

### Parameter: `azureMonitorAlertSettingsAlertsForAllJobFailures`

Settings for Azure Monitor based alerts for job failures.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `backupInstances`

List of all backup instances.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataSourceInfo`](#parameter-backupinstancesdatasourceinfo) | object | The data source info for the backup instance. |
| [`name`](#parameter-backupinstancesname) | string | The name of the backup instance. |
| [`policyInfo`](#parameter-backupinstancespolicyinfo) | object | The policy info for the backup instance. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`friendlyName`](#parameter-backupinstancesfriendlyname) | string | The friendly name of the backup instance. |

### Parameter: `backupInstances.dataSourceInfo`

The data source info for the backup instance.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`datasourceType`](#parameter-backupinstancesdatasourceinfodatasourcetype) | string | The data source type of the resource. |
| [`resourceID`](#parameter-backupinstancesdatasourceinforesourceid) | string | The resource ID of the resource. |
| [`resourceLocation`](#parameter-backupinstancesdatasourceinforesourcelocation) | string | The location of the data source. |
| [`resourceName`](#parameter-backupinstancesdatasourceinforesourcename) | string | Unique identifier of the resource in the context of parent. |
| [`resourceType`](#parameter-backupinstancesdatasourceinforesourcetype) | string | The resource type of the data source. |
| [`resourceUri`](#parameter-backupinstancesdatasourceinforesourceuri) | string | The Uri of the resource. |

### Parameter: `backupInstances.dataSourceInfo.datasourceType`

The data source type of the resource.

- Required: Yes
- Type: string

### Parameter: `backupInstances.dataSourceInfo.resourceID`

The resource ID of the resource.

- Required: Yes
- Type: string

### Parameter: `backupInstances.dataSourceInfo.resourceLocation`

The location of the data source.

- Required: Yes
- Type: string

### Parameter: `backupInstances.dataSourceInfo.resourceName`

Unique identifier of the resource in the context of parent.

- Required: Yes
- Type: string

### Parameter: `backupInstances.dataSourceInfo.resourceType`

The resource type of the data source.

- Required: Yes
- Type: string

### Parameter: `backupInstances.dataSourceInfo.resourceUri`

The Uri of the resource.

- Required: Yes
- Type: string

### Parameter: `backupInstances.name`

The name of the backup instance.

- Required: Yes
- Type: string

### Parameter: `backupInstances.policyInfo`

The policy info for the backup instance.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`policyName`](#parameter-backupinstancespolicyinfopolicyname) | string | The name of the backup instance policy. |
| [`policyParameters`](#parameter-backupinstancespolicyinfopolicyparameters) | object | Policy parameters for the backup instance. |

### Parameter: `backupInstances.policyInfo.policyName`

The name of the backup instance policy.

- Required: Yes
- Type: string

### Parameter: `backupInstances.policyInfo.policyParameters`

Policy parameters for the backup instance.

- Required: Yes
- Type: object

### Parameter: `backupInstances.friendlyName`

The friendly name of the backup instance.

- Required: No
- Type: string

### Parameter: `backupPolicies`

List of all backup policies.

- Required: No
- Type: array

### Parameter: `customerManagedKey`

The customer managed key (CMK) definition. ENABLING CMK WITH USER ASSIGNED MANAGED IDENTITY IS A PREVIEW SERVICE/FEATURE, MICROSOFT MAY NOT PROVIDE SUPPORT FOR THIS, PLEASE CHECK THE [PRODUCT DOCS](https://learn.microsoft.com/en-us/azure/backup/encryption-at-rest-with-cmk-for-backup-vault) FOR CLARIFICATION.

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

### Parameter: `dataStoreType`

The datastore type to use. ArchiveStore does not support ZoneRedundancy.

- Required: No
- Type: string
- Default: `'VaultStore'`
- Allowed:
  ```Bicep
  [
    'ArchiveStore'
    'OperationalStore'
    'VaultStore'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `featureSettings`

Feature settings for the backup vault.

- Required: No
- Type: object

### Parameter: `immutabilitySettingState`

The immmutability setting state of the backup vault resource.

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

### Parameter: `infrastructureEncryption`

Whether or not the service applies a secondary layer of encryption. For security reasons, it is recommended to set it to Enabled.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
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
| [`retentionDurationInDays`](#parameter-softdeletesettingsretentiondurationindays) | int | The soft delete retention period in days. |
| [`state`](#parameter-softdeletesettingsstate) | string | The soft delete state. |

### Parameter: `softDeleteSettings.retentionDurationInDays`

The soft delete retention period in days.

- Required: Yes
- Type: int

### Parameter: `softDeleteSettings.state`

The soft delete state.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AlwaysON'
    'Off'
    'On'
  ]
  ```

### Parameter: `tags`

Tags of the backup vault resource.

- Required: No
- Type: object

### Parameter: `type`

The vault redundancy level to use.

- Required: No
- Type: string
- Default: `'GeoRedundant'`
- Allowed:
  ```Bicep
  [
    'GeoRedundant'
    'LocallyRedundant'
    'ZoneRedundant'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The Name of the backup vault. |
| `resourceGroupName` | string | The name of the resource group the recovery services vault was created in. |
| `resourceId` | string | The resource ID of the backup vault. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Notes

### Parameter Usage: `backupPolicies`

Create backup policies in the backupvault.

<details>

<summary>Parameter JSON format</summary>
```json
 "backupPolicies": {
    "value": [
        {
            "name": "DefaultPolicy",
            "properties": {
                "policyRules": [
                    {
                        "backupParameters": {
                            "backupType": "Incremental",
                            "objectType": "AzureBackupParams"
                        },
                        "trigger": {
                            "schedule": {
                                "repeatingTimeIntervals": [
                                    "R/2022-05-31T23:30:00+01:00/P1D"
                                ],
                                "timeZone": "W. Europe Standard Time"
                            },
                            "taggingCriteria": [
                                {
                                    "tagInfo": {
                                        "tagName": "Default",
                                        "id": "Default_"
                                    },
                                    "taggingPriority": 99,
                                    "isDefault": true
                                }
                            ],
                            "objectType": "ScheduleBasedTriggerContext"
                        },
                        "dataStore": {
                            "dataStoreType": "OperationalStore",
                            "objectType": "DataStoreInfoBase"
                        },
                        "name": "BackupDaily",
                        "objectType": "AzureBackupRule"
                    },
                    {
                        "lifecycles": [
                            {
                                "deleteAfter": {
                                    "objectType": "AbsoluteDeleteOption",
                                    "duration": "P7D"
                                },
                                "targetDataStoreCopySettings": [],
                                "sourceDataStore": {
                                    "dataStoreType": "OperationalStore",
                                    "objectType": "DataStoreInfoBase"
                                }
                            }
                        ],
                        "isDefault": true,
                        "name": "Default",
                        "objectType": "AzureRetentionRule"
                    }
                ],
                "datasourceTypes": [
                    "Microsoft.Compute/disks"
                ],
                "objectType": "BackupPolicy"
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
backupPolicies: [
    {
        name: 'DefaultPolicy'
        properties: {
            policyRules: [
                {
                    backupParameters: {
                        backupType: 'Incremental'
                        objectType: 'AzureBackupParams'
                    }
                    trigger: {
                        schedule: {
                            repeatingTimeIntervals: [
                                'R/2022-05-31T23:30:00+01:00/P1D'
                            ]
                            timeZone: 'W. Europe Standard Time'
                        }
                        taggingCriteria: [
                            {
                                tagInfo: {
                                    tagName: 'Default'
                                    id: 'Default_'
                                }
                                taggingPriority: 99
                                isDefault: true
                            }
                        ]
                        objectType: 'ScheduleBasedTriggerContext'
                    }
                    dataStore: {
                        dataStoreType: 'OperationalStore'
                        objectType: 'DataStoreInfoBase'
                    }
                    name: 'BackupDaily'
                    objectType: 'AzureBackupRule'
                }
                {
                    lifecycles: [
                        {
                            deleteAfter: {
                                objectType: 'AbsoluteDeleteOption'
                                duration: 'P7D'
                            }
                            targetDataStoreCopySettings: []
                            sourceDataStore: {
                                dataStoreType: 'OperationalStore'
                                objectType: 'DataStoreInfoBase'
                            }
                        }
                    ]
                    isDefault: true
                    name: 'Default'
                    objectType: 'AzureRetentionRule'
                }
            ]
            datasourceTypes: [
                'Microsoft.Compute/disks'
            ]
            objectType: 'BackupPolicy'
        }
    }
]
```

</details>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
