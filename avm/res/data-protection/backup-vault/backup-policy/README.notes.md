
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

