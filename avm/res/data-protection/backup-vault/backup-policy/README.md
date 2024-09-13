# Data Protection Backup Vault Backup Policies `[Microsoft.DataProtection/backupVaults/backupPolicies]`

This module deploys a Data Protection Backup Vault Backup Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)

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
