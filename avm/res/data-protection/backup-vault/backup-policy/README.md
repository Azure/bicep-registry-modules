# Data Protection Backup Vault Backup Policies `[Microsoft.DataProtection/backupVaults/backupPolicies]`

This module deploys a Data Protection Backup Vault Backup Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DataProtection/backupVaults/backupPolicies` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataProtection/backupVaults/backupPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupVaultName`](#parameter-backupvaultname) | string | The name of the backup vault. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the backup policy. |
| [`properties`](#parameter-properties) | object | The properties of the backup policy. |

### Parameter: `backupVaultName`

The name of the backup vault.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the backup policy.

- Required: No
- Type: string
- Default: `'DefaultPolicy'`

### Parameter: `properties`

The properties of the backup policy.

- Required: No
- Type: object
- Default: `{}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backup policy. |
| `resourceGroupName` | string | The name of the resource group the backup policy was created in. |
| `resourceId` | string | The resource ID of the backup policy. |

## Cross-referenced modules

_None_

## Notes

### Parameter Usage: `properties`

Create a backup policy.

<details>

<summary>Parameter JSON format</summary>

```json
 "properties": {
    "value": {
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
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
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
```

</details>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
